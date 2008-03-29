Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Mar 2008 21:56:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2T4tqVu011724
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2008 21:55:54 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB99F706781
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2008 21:56:27 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id vcMzI56tIuBehqYf for <xfs@oss.sgi.com>; Fri, 28 Mar 2008 21:56:27 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 0F65C1801C350
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2008 23:56:26 -0500 (CDT)
Message-ID: <47EDCBF9.4070102@sandeen.net>
Date: Fri, 28 Mar 2008 23:56:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH, RFC] fix attr fit checking for filesystems which have lost
 their attr2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Regarding the F8 corruption...  I have a pretty narrow testcase
now, and it turns out this was a bit of a perfect storm.

First, F8 shipped 2.6.23 which had the problem with sb_features2
padding out on 64-bit boxes, but this was ok because userspace
and kernelspace both did this, and it was properly mounting &
running as attr2.

However, hch came along in 2.6.24 and did some endian annotation 
for the superblock and in the process:
> A new helper xfs_sb_from_disk handles the other (read)
> direction and doesn't need the slightly hacky table-driven approach
> because we only ever read the full sb from disk.

However, this resulted in kernelspace behaving differently,
and now *missing* the attr2 flag in sb_features2, (actually
sb_bad_features2) so we mounted as if we had attr1.  Which 
is really supposed to be ok, IIRC, except in 
xfs_attr_shortform_bytesfit we return the default
fork offset value from the superblock, even if di_forkoff
is *already* set.  In the error case I had, di_forkoff was set
to 15 (from previously being attr2...) but we returned 14
(the mp default) and I think this is where things started
going wrong; I think this caused us to write an attr on top
of the extent data.

My understanding of this is that if di_forkoff is non-zero,
we should always be using it for space calculations, regardless
of whether we are mounted with attr2 or not...

and with that, how's this look, to be honest I haven't run it
through QA yet...

I'm not certain if xfs_bmap_compute_maxlevels() may lead
to similar problems....

------------------

always use di_forkoff for when checking for attr space

In the case where we mount a filesystem which was previously
using the attr2 format as attr1, returning the default
mp->m_attroffset instead of the per-inode di_forkoff for
inline attribute fit calculations may result in corruption,
if the existing "attr2" formatted attribute is already taking
more space than the default.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---


Index: linux-2.6-git/fs/xfs/xfs_attr_leaf.c
===================================================================
--- linux-2.6-git.orig/fs/xfs/xfs_attr_leaf.c
+++ linux-2.6-git/fs/xfs/xfs_attr_leaf.c
@@ -166,7 +166,7 @@ xfs_attr_shortform_bytesfit(xfs_inode_t 
 
 	if (!(mp->m_flags & XFS_MOUNT_ATTR2)) {
 		if (bytes <= XFS_IFORK_ASIZE(dp))
-			return mp->m_attroffset >> 3;
+			return dp->i_d.di_forkoff;
 		return 0;
 	}
