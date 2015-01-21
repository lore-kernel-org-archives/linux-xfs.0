Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3366D7F3F
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 20:35:59 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 04B5B304032
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 18:35:55 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Tasx9hqAwICT0vfA for <xfs@oss.sgi.com>;
	Tue, 20 Jan 2015 18:35:50 -0800 (PST)
Date: Wed, 21 Jan 2015 13:34:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/3] xfs: set superblock buffer type correctly
Message-ID: <20150121023444.GI16552@dastard>
References: <1421800780-26008-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1421800780-26008-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: jack@suse.cz

From: Dave Chinner <dchinner@redhat.com>

When the superblock is modified in a transaction, the commonly
modified fields are not actually copied to the superblock buffer to
avoid the buffer lock becoming a serialisation point. However, there
are some other operations that modify the superblock fields within
the transaction that don't directly log to the superblock but rely
on the changes to be applied during the transaction commit (to
minimise the buffer lock hold time).

When we do this, we fail to mark the buffer log item as being a
superblock buffer and that can lead to the buffer not being marked
with the corect type in the log and hence causing recovery issues.
Fix it by setting the type correctly, similar to xfs_mod_sb()...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index fa3135b..eb90cd5 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -472,6 +472,7 @@ xfs_trans_apply_sb_deltas(
 		whole = 1;
 	}
 
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
 	if (whole)
 		/*
 		 * Log the whole thing, the fields are noncontiguous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
