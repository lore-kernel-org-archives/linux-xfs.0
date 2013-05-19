Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F027529E06
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 18:51:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D044E8F8033
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 16:51:45 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	szJIk5AW2vhAVnC0 for <xfs@oss.sgi.com>;
	Sun, 19 May 2013 16:51:44 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UeDO2-00069t-RA
	for xfs@oss.sgi.com; Mon, 20 May 2013 09:51:34 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UeDO2-0003yu-OV
	for xfs@oss.sgi.com; Mon, 20 May 2013 09:51:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/14] xfs: remote attribute lookups require the value length
Date: Mon, 20 May 2013 09:51:16 +1000
Message-Id: <1369007481-15185-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1369007481-15185-1-git-send-email-david@fromorbit.com>
References: <1369007481-15185-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

When reading a remote attribute, to correctly calculate the length
of the data buffer for CRC enable filesystems, we need to know the
length of the attribute data. We get this information when we look
up the attribute, but we don't store it in the args structure along
with the other remote attr information we get from the lookup. Add
this information to the args structure so we can use it
appropriately.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr_leaf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 8eeb88f..0bce1b3 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -2332,9 +2332,10 @@ xfs_attr3_leaf_lookup_int(
 			if (!xfs_attr_namesp_match(args->flags, entry->flags))
 				continue;
 			args->index = probe;
+			args->valuelen = be32_to_cpu(name_rmt->valuelen);
 			args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
 			args->rmtblkcnt = XFS_B_TO_FSB(args->dp->i_mount,
-						   be32_to_cpu(name_rmt->valuelen));
+						       args->valuelen);
 			return XFS_ERROR(EEXIST);
 		}
 	}
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
