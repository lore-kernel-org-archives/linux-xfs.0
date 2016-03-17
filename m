Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 37E197CB1
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 09:30:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E78B18F8059
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 07:30:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ktdWUa0r1w4iH6ah (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 17 Mar 2016 07:30:40 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 7/9] dm thin: add method to provision space
Date: Thu, 17 Mar 2016 10:30:35 -0400
Message-Id: <1458225037-24155-8-git-send-email-bfoster@redhat.com>
In-Reply-To: <1458225037-24155-1-git-send-email-bfoster@redhat.com>
References: <1458225037-24155-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com

This is a hacky interface added to support the filesystem experiment for
reserving blocks out of thin pools. The XFS POC uses this method
provision space in the pool when blocks are allocated. The number of
actual blocks allocated is returned, which is used to update the
filesystem accounting.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 drivers/md/dm-thin.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index ac770d89..00b7322 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -4389,6 +4389,52 @@ static int thin_get_reserved_space(struct dm_target *ti, sector_t *nr_sects)
 	return 0;
 }
 
+static int thin_provision_space(struct dm_target *ti, sector_t offset, sector_t len)
+{
+	struct thin_c *tc = ti->private;
+	struct pool *pool = tc->pool;
+	sector_t end;
+	dm_block_t pblock;
+	dm_block_t vblock;
+	int error;
+	struct dm_thin_lookup_result lookup;
+	sector_t count;
+
+	if (!is_factor(offset, pool->sectors_per_block))
+		return -EINVAL;
+
+	if (!len || !is_factor(len, pool->sectors_per_block))
+		return -EINVAL;
+
+	end = offset + len;
+
+	count = 0;
+	while (offset < end) {
+		vblock = offset / pool->sectors_per_block;
+
+		error = dm_thin_find_block(tc->td, vblock, true, &lookup);
+		if (error == 0)
+			goto next;
+		if (error != -ENODATA)
+			return error;
+
+		error = alloc_data_block(tc, &pblock);
+		if (error)
+			return error;
+
+		error = dm_thin_insert_block(tc->td, vblock, pblock);
+		if (error)
+			return error;
+
+		count += pool->sectors_per_block;
+next:
+		offset += pool->sectors_per_block;
+	}
+
+	/* XXX: int -> sector_t ! */
+	return count;
+}
+
 static struct target_type thin_target = {
 	.name = "thin",
 	.version = {1, 18, 0},
@@ -4405,6 +4451,7 @@ static struct target_type thin_target = {
 	.io_hints = thin_io_hints,
 	.reserve_space = thin_reserve_space,
 	.get_reserved_space = thin_get_reserved_space,
+	.provision_space = thin_provision_space,
 };
 
 /*----------------------------------------------------------------*/
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
