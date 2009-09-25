Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8PJfDOH185887 for <xfs@oss.sgi.com>; Fri, 25 Sep 2009 14:41:13 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC61C47FB8E
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2009 12:42:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id l8v084meaHOEK0NC for
	<xfs@oss.sgi.com>; Fri, 25 Sep 2009 12:42:31 -0700 (PDT)
Message-ID: <4ABD1D22.2030002@sandeen.net>
Date: Fri, 25 Sep 2009 14:42:26 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] fix readahead calculations in xfs_dir2_leaf_getdents()
References: <4ABA5192.80509@sandeen.net>
In-Reply-To: <4ABA5192.80509@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs mailing list <xfs@oss.sgi.com>
Cc: tobias@lists.yoper.com

This is for bug #850,
http://oss.sgi.com/bugzilla/show_bug.cgi?id=850
XFS file system segfaults , repeatedly and 100% reproducable in 2.6.30 , 2.6.31

The above only showed up on a CONFIG_XFS_DEBUG=y kernel, because
xfs_bmapi() ASSERTs that it has been asked for at least one map,

and it was getting 0.

The root cause is that our guesstimated "bufsize" from xfs_file_readdir
was fairly small, and the

		bufsize -= length;

in the loop was going negative - except bufsize is a size_t, so it 
was wrapping to a very large number.

Then when we did
		ra_want = howmany(bufsize + mp->m_dirblksize,
				  mp->m_sb.sb_blocksize) - 1;

with that very large number, the (int) ra_want was coming out
negative, and a subsequent compare:

		if (1 + ra_want > map_blocks ...

was coming out -true- (negative int compare w/ uint) and we went 
back to xfs_bmapi() for more, even though we did not need more,
and asked for 0 maps, and hit the ASSERT.

We have kind of a type mess here, but just keeping bufsize from 
going negative is probably sufficient to avoid the problem.


Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

V2: use min() as suggested by Jeff, it's tidier.

diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index fa913e4..4467d61 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -854,6 +854,7 @@ xfs_dir2_leaf_getdents(
 			 */
 			ra_want = howmany(bufsize + mp->m_dirblksize,
 					  mp->m_sb.sb_blocksize) - 1;
+			ASSERT(ra_want >= 0);
 
 			/*
 			 * If we don't have as many as we want, and we haven't
@@ -1088,7 +1089,8 @@ xfs_dir2_leaf_getdents(
 		 */
 		ptr += length;
 		curoff += length;
-		bufsize -= length;
+		/* bufsize may have just been a guess; don't go negative */
+		bufsize = min((bufsize - length), (size_t)0);
 	}
 
 	/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
