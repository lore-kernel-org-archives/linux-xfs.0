Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CC83A7F67
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 07:25:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 673F2AC001
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 05:25:18 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Q2NNQRaQhrBJ1SYV for <xfs@oss.sgi.com>;
	Fri, 07 Jun 2013 05:25:17 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Ukvj6-0005Sv-Gw
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 22:25:04 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Ukvj6-000318-Ce
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 22:25:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/12] xfs: remote attribute lookups require the value length
Date: Fri,  7 Jun 2013 22:24:53 +1000
Message-Id: <1370607901-11538-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1370607901-11538-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-1-git-send-email-david@fromorbit.com>
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
 libxfs/xfs_attr_leaf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 881f417..d9f5ec5 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -2122,9 +2122,10 @@ xfs_attr3_leaf_lookup_int(
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
