Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Nov 2006 20:03:17 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAL439aG007613
	for <xfs@oss.sgi.com>; Mon, 20 Nov 2006 20:03:10 -0800
Message-ID: <45627A4D.3020502@sandeen.net>
Date: Mon, 20 Nov 2006 22:02:21 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
References: <455CB54F.8080901@sandeen.net> <455CE1E3.7020703@sandeen.net> <45612621.5010404@sandeen.net>
In-Reply-To: <45612621.5010404@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:

> Eric Sandeen wrote:
>   
>> ugh.  it's broken on x86 too, so it's not just the alignment/padding,
>>     
>> although that should be fixed for cross-arch mounts.
>>     
>> -Eric
>>     
>>     
> here's a testcase to corrupt it FWIW.
>   
>   
Ok, with expert collaboration from Russell, Barry, Tim, 
Nathan, David, et al, how about this:

For btree dirs, we need a different calculation for the space
used in di_u, to set the minimum threshold for the fork offset...

This fixes my testcase, but as Tim points out -now- we need to compact
the btree ptrs, if we return (and use) an offset < current forkoff...

whee....

-Eric


Index: linux-2.6.18/fs/xfs.orig/xfs_attr_leaf.c
===================================================================
--- linux-2.6.18.orig/fs/xfs.orig/xfs_attr_leaf.c
+++ linux-2.6.18/fs/xfs.orig/xfs_attr_leaf.c
@@ -116,6 +116,7 @@ xfs_attr_shortform_bytesfit(xfs_inode_t 
 	int minforkoff;	/* lower limit on valid forkoff locations */
 	int maxforkoff;	/* upper limit on valid forkoff locations */
 	xfs_mount_t *mp = dp->i_mount;
+	int dsize = 0;
 
 	offset = (XFS_LITINO(mp) - bytes) >> 3; /* rounded down */
 
@@ -134,8 +135,21 @@ xfs_attr_shortform_bytesfit(xfs_inode_t 
 		return 0;
 	}
 
+	switch (dp->i_d.di_format) {
+	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_EXTENTS:
+		dsize = dp->i_df.if_bytes;
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		dsize = XFS_BMDR_SPACE_CALC(
+			XFS_BMAP_BROOT_NUMRECS(dp->i_df.if_broot));
+		break;
+	default:
+		/* should bail, unknown format, .... */
+	}
+
 	/* data fork btree root can have at least this many key/ptr pairs */
-	minforkoff = MAX(dp->i_df.if_bytes, XFS_BMDR_SPACE_CALC(MINDBTPTRS));
+	minforkoff = MAX(dsize, XFS_BMDR_SPACE_CALC(MINDBTPTRS));
 	minforkoff = roundup(minforkoff, 8) >> 3;
 
 	/* attr fork btree root can have at least this many key/ptr pairs */
