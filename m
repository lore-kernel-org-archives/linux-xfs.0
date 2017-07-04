Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23623 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753085AbdGDEFE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jul 2017 00:05:04 -0400
Date: Mon, 3 Jul 2017 21:04:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] fs: ext4: inode->i_generation not assigned 0.
Message-ID: <20170704040446.GB4704@birch.djwong.org>
References: <c9f7090b2a58364998ad4a49cfdac379b905c7e9.1498687302.git.kkc6196@fb.com>
 <20A40B3C-E179-432B-B56F-BDAAF0CD2E1F@dilger.ca>
 <7CD38230-D961-428F-B2E9-2C0E28CAF442@fb.com>
 <20170629045940.GB5865@birch.djwong.org>
 <20170629143551.GB1651@fieldses.org>
 <20170629172528.GA5869@birch.djwong.org>
 <20170629183053.GA4178@fieldses.org>
 <20170629185022.GB4178@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170629185022.GB4178@fieldses.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: William Koh <kkc6196@fb.com>, Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>, linux-ext4 <linux-ext4@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, xfs <linux-xfs@vger.kernel.org>

On Thu, Jun 29, 2017 at 02:50:22PM -0400, J. Bruce Fields wrote:
> On Thu, Jun 29, 2017 at 02:30:53PM -0400, J. Bruce Fields wrote:
> > On Thu, Jun 29, 2017 at 10:25:28AM -0700, Darrick J. Wong wrote:
> > > Was there ever a version of NFS (or more generally callers of the
> > > exportfs code) that couldn't deal with i_generation in the file handle,
> > > and therefore we invented this generation hack to work around the loss
> > > of the generation information?
> > > 
> > > There's a comment in xfs_fs_encode_fh about not supporting 64bit inodes
> > > with subtree_check (which seems to require one ino/gen pair for the file
> > > and a second pair for the file's parent) on NFSv2 because v2 doesn't
> > > provide enough space for all the file handle information, but that's the
> > > furthest I got with lazy-mining the git history. :)
> > 
> > There's a comment in fs/ext4/super.c:ext4_nfs_get_inode
> > 
> > 	* Currently we don't know the generation for parent directory, so
> > 	* a generation of 0 means "accept any"
> > 
> > But I don't see that used.
> > 
> > It was used once upon a time; I see it actually used in old 2.5 code in
> > nfsd_get_dentry.  Hm.
> 
> Oh, maybe it's here in fs/libfs.c:generic_fh_to_parent:
> 
> 	switch (fh_type) {
> 	case FILEID_INO32_GEN_PARENT:
> 		inode = get_inode(sb, fid->i32.parent_ino,
>         			  (fh_len > 3 ? fid->i32.parent_gen : 0));
> 		break;
> 	}
> 
> I'm not sure under what conditions that filehandle encoding is used.

The best guess I can come up with is the old nfs_fhbase_old style handles,
which (afaict) do not carry parent i_generation?

--D

> 
> --b.
