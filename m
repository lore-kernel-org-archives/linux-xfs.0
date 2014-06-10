Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 465997F50
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2014 09:09:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 230F48F8054
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2014 07:09:13 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id TR5l5tQth9VzR5rE for <xfs@oss.sgi.com>;
	Tue, 10 Jun 2014 07:09:08 -0700 (PDT)
Message-ID: <53971184.50008@sandeen.net>
Date: Tue, 10 Jun 2014 09:09:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [DISCUSS] Planning for new dev cycle (3.17)
References: <20140609223320.GE9508@dastard> <20140610060944.GG9508@dastard>
In-Reply-To: <20140610060944.GG9508@dastard>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 6/10/14, 1:09 AM, Dave Chinner wrote:

> There is a new version of this work (Eric's patches and the base
> libxfs restructure) here:
> 
> 	git://oss.sgi.com/xfs/xfs.git xfs-libxfs-restructure
> 
> It's based on 3.15 with the current for-next branch merged into it
> and then the changes done over the top, so it's about as up-to-date
> as it can be. Comments welcome...

Comment 1: doesn't build ;)


make[1]: *** No rule to make target `fs/xfs/xfs_dir2_readdir.o', needed by `fs/xfs/xfs.o'.  Stop.
make[1]: *** Waiting for unfinished jobs....
  CC [M]  fs/xfs/xfs_buf.o
make: *** [_module_fs/xfs] Error 2

problems w/ xfs_rtbitmap.o as well, patch follows.

Comment 2: Coverity thinks this adds about 25 defects, I'll have to go
look at why...

-Eric

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index a22a6b8..0b7b3b3 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -43,6 +43,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_dir2_data.o \
 				   xfs_dir2_leaf.o \
 				   xfs_dir2_node.o \
+				   xfs_dir2_readdir.o \
 				   xfs_dir2_sf.o \
 				   xfs_dquot_buf.o \
 				   xfs_ialloc.o \
@@ -55,6 +56,9 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_trans_resv.o \
 				   )
 
+xfs-$(CONFIG_XFS_RT)		+= $(addprefix libxfs/, \
+				   xfs_rtbitmap.o \
+				   )
 # highlevel code
 xfs-y				+= xfs_aops.o \
 				   xfs_attr_inactive.o \
@@ -62,7 +66,6 @@ xfs-y				+= xfs_aops.o \
 				   xfs_bit.o \
 				   xfs_bmap_util.o \
 				   xfs_buf.o \
-				   xfs_dir2_readdir.o \
 				   xfs_discard.o \
 				   xfs_error.o \
 				   xfs_export.o \
@@ -110,8 +113,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
 				   xfs_quotaops.o
 
 # xfs_rtbitmap is shared with libxfs
-xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o \
-				   xfs_rtbitmap.o
+xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o
 
 xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
 xfs-$(CONFIG_PROC_FS)		+= xfs_stats.o




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
