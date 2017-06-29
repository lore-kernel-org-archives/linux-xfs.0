Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50638 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751893AbdF2RZo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2017 13:25:44 -0400
Date: Thu, 29 Jun 2017 10:25:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] fs: ext4: inode->i_generation not assigned 0.
Message-ID: <20170629172528.GA5869@birch.djwong.org>
References: <c9f7090b2a58364998ad4a49cfdac379b905c7e9.1498687302.git.kkc6196@fb.com>
 <20A40B3C-E179-432B-B56F-BDAAF0CD2E1F@dilger.ca>
 <7CD38230-D961-428F-B2E9-2C0E28CAF442@fb.com>
 <20170629045940.GB5865@birch.djwong.org>
 <20170629143551.GB1651@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170629143551.GB1651@fieldses.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: William Koh <kkc6196@fb.com>, Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>, linux-ext4 <linux-ext4@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, xfs <linux-xfs@vger.kernel.org>

On Thu, Jun 29, 2017 at 10:35:51AM -0400, J. Bruce Fields wrote:
> On Wed, Jun 28, 2017 at 09:59:40PM -0700, Darrick J. Wong wrote:
> > AFAICT, i_generation == 0 in XFS and btrfs is just as valid as any other
> > number.  There is no special casing of zero in either filesystem.
> > 
> > So now, my curiosity intrigued, I surveyed all the Linux filesystems
> > that can export to NFS.  I see that there are actually quite a few fs
> > (ext[2-4], exofs, efs, fat, jfs, f2fs, isofs, nilfs2, reiserfs, udf,
> > ufs) that treat zero as a special value meaning "ignore generation
> > check"; others (xfs, btrfs, fuse, ntfs, ocfs2) that don't consider zero
> > special and always require a match; and still others (affs, befs, ceph,
> > gfs2, jffs2, squashfs) that don't check at all.
> > 
> > That to mean strongly suggests that more research is necessary to figure
> > out why some of the filesystems that support i_generation reserve zero
> > as a special value to disable generation checks and why others always
> > require an exact match.  Until we can recapture why things are they way
> > they are, it doesn't make much sense to have a helper that only applies
> > to half the filesystems.
> 
> From a quick look at ext2; correct me if I got anything wrong:
> 
> 	- it looks like this is *only* used by NFS fh->inode lookups,
> 	  there's not some other internal use for this special case.
> 	- filehandles are never encoded with i_generation 0, so will
> 	  never be returned to clients.
> 
> So, this could only ever be used by an NFS client.  But the only NFS
> client that could ever use it would be a non-standard client that knew
> this special feature of these particular filesystems.
> 
> Sounds like at most a slightly useful tool for malicious clients
> attempting filehandle-guessing attacks.
> 
> I'm probably missing something.

Was there ever a version of NFS (or more generally callers of the
exportfs code) that couldn't deal with i_generation in the file handle,
and therefore we invented this generation hack to work around the loss
of the generation information?

There's a comment in xfs_fs_encode_fh about not supporting 64bit inodes
with subtree_check (which seems to require one ino/gen pair for the file
and a second pair for the file's parent) on NFSv2 because v2 doesn't
provide enough space for all the file handle information, but that's the
furthest I got with lazy-mining the git history. :)

--D

> 
> --b.
