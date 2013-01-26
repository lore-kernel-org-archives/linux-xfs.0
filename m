Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CFCC77F50
	for <xfs@oss.sgi.com>; Sat, 26 Jan 2013 16:40:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7240EAC004
	for <xfs@oss.sgi.com>; Sat, 26 Jan 2013 14:40:35 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id VRPRehyFJczNTSaO for <xfs@oss.sgi.com>;
	Sat, 26 Jan 2013 14:40:34 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 4/8] xfs_repair: Fix free of uninit ptr in xfs_acl_valid()
	error path
Date: Sat, 26 Jan 2013 16:40:28 -0600
Message-Id: <1359240032-11576-5-git-send-email-sandeen@redhat.com>
In-Reply-To: <1359240032-11576-1-git-send-email-sandeen@redhat.com>
References: <1359240032-11576-1-git-send-email-sandeen@redhat.com>
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
Cc: Eric Sandeen <sandeen@redhat.com>

This error path:

xfs_acl_valid(xfs_acl_disk_t *daclp)
{
	xfs_acl_t	*aclp;
...
	if (daclp == NULL)
		goto acl_invalid;
...
acl_invalid:
	free(aclp);

attempts to free garbage; set it to NULL on init to make
it safe.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 repair/attr_repair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index bab65b1..ec7f4a3 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -1004,7 +1004,7 @@ process_attributes(
 static int
 xfs_acl_valid(xfs_acl_disk_t *daclp)
 {
-	xfs_acl_t	*aclp;
+	xfs_acl_t	*aclp = NULL;
 	xfs_acl_entry_t *entry, *e;
 	int user = 0, group = 0, other = 0, mask = 0, mask_required = 0;
 	int i, j;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
