Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 03C1E7CAE
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2016 17:47:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AAC798F8037
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2016 15:47:31 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 56LJt1hbO1OjAMdA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 28 Mar 2016 15:47:28 -0700 (PDT)
Date: Mon, 28 Mar 2016 15:47:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Build regressions/improvements in v4.6-rc1
Message-ID: <20160328224710.GC5822@birch.djwong.org>
References: <CAMuHMdXx80zs5VoA_aYc_wMn37O=fa6oXk-ovteHq0hGQYUUzg@mail.gmail.com>
	<CAMuHMdW3dfhZVT0e4tiqsbEPjYYA_hGUXQer1bQDeF2Gbs4WJg@mail.gmail.com>
	<20160328215923.GG11812@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160328215923.GG11812@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Rich Felker <dalias@libc.org>, Cris <linux-cris-kernel@axis.com>, Linux-sh list <linux-sh@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Geert Uytterhoeven <geert@linux-m68k.org>

On Tue, Mar 29, 2016 at 08:59:23AM +1100, Dave Chinner wrote:
> On Sun, Mar 27, 2016 at 02:43:24PM +0200, Geert Uytterhoeven wrote:
> > On Sun, Mar 27, 2016 at 2:39 PM, Geert Uytterhoeven
> > <geert@linux-m68k.org> wrote:
> > > Below is the list of build error/warning regressions/improvements in
> > > v4.6-rc1[1] compared to v4.5[2].
> > >
> > > Summarized:
> > >   - build errors: +9/-6
> > 
> > > [1] http://kisskb.ellerman.id.au/kisskb/head/10114/ (all 262 configs)
> > > [2] http://kisskb.ellerman.id.au/kisskb/head/10047/ (all 262 configs)
> > 
> > > 9 error regressions:
> > >   + /home/kisskb/slave/src/fs/xfs/xfs_ondisk.h: error: call to
> > > '__compiletime_assert_79' declared with attribute error: XFS:
> > > sizeof(xfs_attr_shortform_t) is wrong, expected 8:  => 79:2
> > 
> > cris-allyesconfig, cris-allmodconfig
> 
> Yup, cris is the only platform that throws this error on this
> structure. It's an on-disk structure and relying on the gcc
> optimiser to do the same thing from release to release has become
> such a crap-shoot these days. Hence as a stop-gap measure we added
> build time checking of what they compiler is doing with those
> structures, and to refuse to build XFS if the compiler/platform is
> doing something obviously different.
> 
> Modernising the on-disk structure definitions is on the list of
> things to do, but it's nowhere near the top of my list at the
> moment...

I have a test patch that (for now) changes the ondisk format checks for the
variable-length structures to look at the offsets of the non-variable-length
fields.  Can you give it a try?

(No idea if it fixes fixes cris, but it passes the six arches that I can
actually test on (x86/power/arm)).  The downside is that it does nothing about
troubling implication that there could be computers writing out a disk format
that's incompatible with x86 XFSes...)

--D
-----------
From: Darrick J. Wong <darrick.wong@oracle.com>
Subject: [PATCH] xfs: check offsets of variable length structures

Some of the directory/attr structures contain variable-length objects,
so the enclosing structure doesn't have a meaningful fixed size at
compile time.  We can check the offsets of the members before the
variable-length member, so do those.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ondisk.h |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 960648b..3742216 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -22,6 +22,11 @@
 	BUILD_BUG_ON_MSG(sizeof(structname) != (size), "XFS: sizeof(" \
 		#structname ") is wrong, expected " #size)
 
+#define XFS_CHECK_OFFSET(structname, member, off) \
+	BUILD_BUG_ON_MSG(offsetof(structname, member) != (off), \
+		"XFS: offsetof(" #structname ", " #member ") is wrong, " \
+		"expected " #off)
+
 static inline void __init
 xfs_check_ondisk_structs(void)
 {
@@ -81,15 +86,28 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_name_remote_t,	12);
 	 */
 
+	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, valuelen,	0);
+	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, namelen,	2);
+	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, nameval,	3);
+	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, valueblk,	0);
+	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, valuelen,	4);
+	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, namelen,	8);
+	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, name,	9);
 	XFS_CHECK_STRUCT_SIZE(xfs_attr_leafblock_t,		40);
-	XFS_CHECK_STRUCT_SIZE(xfs_attr_shortform_t,		8);
+	XFS_CHECK_OFFSET(xfs_attr_shortform_t, hdr.totsize,	0);
+	XFS_CHECK_OFFSET(xfs_attr_shortform_t, hdr.count,	2);
+	XFS_CHECK_OFFSET(xfs_attr_shortform_t, list[0].namelen,	4);
+	XFS_CHECK_OFFSET(xfs_attr_shortform_t, list[0].valuelen, 5);
+	XFS_CHECK_OFFSET(xfs_attr_shortform_t, list[0].flags,	6);
+	XFS_CHECK_OFFSET(xfs_attr_shortform_t, list[0].nameval,	7);
 	XFS_CHECK_STRUCT_SIZE(xfs_da_blkinfo_t,			12);
 	XFS_CHECK_STRUCT_SIZE(xfs_da_intnode_t,			16);
 	XFS_CHECK_STRUCT_SIZE(xfs_da_node_entry_t,		8);
 	XFS_CHECK_STRUCT_SIZE(xfs_da_node_hdr_t,		16);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_data_free_t,		4);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_data_hdr_t,		16);
-	XFS_CHECK_STRUCT_SIZE(xfs_dir2_data_unused_t,		6);
+	XFS_CHECK_OFFSET(xfs_dir2_data_unused_t, freetag,	0);
+	XFS_CHECK_OFFSET(xfs_dir2_data_unused_t, length,	2);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_free_hdr_t,		16);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_free_t,			16);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_ino4_t,			4);
@@ -100,6 +118,9 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_t,			16);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_tail_t,		4);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_entry_t,		3);
+	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, namelen,		0);
+	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, offset,		1);
+	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, name,		3);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_hdr_t,		10);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_off_t,		2);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
