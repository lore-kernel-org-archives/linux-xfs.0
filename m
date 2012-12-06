Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB6LoITS159516 for <xfs@oss.sgi.com>; Thu, 6 Dec 2012 15:50:18 -0600
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id mxVgxUrLUpSlDufR for <xfs@oss.sgi.com>;
	Thu, 06 Dec 2012 13:52:43 -0800 (PST)
Message-ID: <50C113B6.20105@sandeen.net>
Date: Thu, 06 Dec 2012 15:52:54 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V3] mkfs.xfs: go into multidisk mode when geometry is on
	cmdline
References: <50ABB115.9070905@sandeen.net>
	<20121121095636.GC23339@infradead.org>
	<50C10FA5.9090909@sandeen.net>
In-Reply-To: <50C10FA5.9090909@sandeen.net>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Ben England <bengland@redhat.com>, xfs-oss <xfs@oss.sgi.com>

In the course of some other investigations, I found that 
calc_default_ag_geometry() doesn't go into "multidisk" mode
unless stripe geometry is *detected* (i.e. by the blkid routines).

Specifying a geometry on the cmdline is *not* sufficient, because
we test (ft.dsunit | ft.dswidth) which are not set by the cmdline
options.

If we move the AG calculations to after we have set dsunit & dswdith,
then we'll pick up either cmdline-specified or blkid-detected
geometry, and go into "multidisk" mode for AG size/count
calculations in both cases.

So now for a ~5T fs, for example, we'd make several more
AGs:

# truncate --size=5t fsfile
# mkfs.xfs -N -d su=128k,sw=8 fsfile | grep agcount
meta-data=fsfile                 isize=256    agcount=5, agsize=268435424 blks
# mkfs/mkfs.xfs -N -d su=128k,sw=8 fsfile | grep agcount
meta-data=fsfile                 isize=256    agcount=32, agsize=41943008 blks

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Add braces to last else clause per hch's request
V3: Add another brace so it compiles, ugh.

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index be931e3..577880b 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2090,25 +2090,6 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		nbmblocks = 0;
 	}
 
-	if (dasize) {		/* User-specified AG size */
-		/*
-		 * Check specified agsize is a multiple of blocksize.
-		 */
-		if (agsize % blocksize) {
-			fprintf(stderr,
-		_("agsize (%lld) not a multiple of fs blk size (%d)\n"),
-				(long long)agsize, blocksize);
-			usage();
-		}
-		agsize /= blocksize;
-		agcount = dblocks / agsize + (dblocks % agsize != 0);
-
-	} else if (daflag)	/* User-specified AG count */
-		agsize = dblocks / agcount + (dblocks % agcount != 0);
-	else
-		calc_default_ag_geometry(blocklog, dblocks,
-				ft.dsunit | ft.dswidth, &agsize, &agcount);
-
 	if (!nodsflag) {
 		if (dsunit) {
 			if (ft.dsunit && ft.dsunit != dsunit) {
@@ -2132,6 +2113,26 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		}
 	} /* else dsunit & dswidth can't be set if nodsflag is set */
 
+	if (dasize) {		/* User-specified AG size */
+		/*
+		 * Check specified agsize is a multiple of blocksize.
+		 */
+		if (agsize % blocksize) {
+			fprintf(stderr,
+		_("agsize (%lld) not a multiple of fs blk size (%d)\n"),
+				(long long)agsize, blocksize);
+			usage();
+		}
+		agsize /= blocksize;
+		agcount = dblocks / agsize + (dblocks % agsize != 0);
+
+	} else if (daflag) {	/* User-specified AG count */
+		agsize = dblocks / agcount + (dblocks % agcount != 0);
+	} else {
+		calc_default_ag_geometry(blocklog, dblocks,
+				dsunit | dswidth, &agsize, &agcount);
+	}
+
 	/*
 	 * If dsunit is a multiple of fs blocksize, then check that is a
 	 * multiple of the agsize too


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
