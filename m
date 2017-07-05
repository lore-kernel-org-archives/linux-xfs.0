Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30912 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752253AbdGETUD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jul 2017 15:20:03 -0400
Date: Wed, 5 Jul 2017 12:19:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] fs: ext4: inode->i_generation not assigned 0.
Message-ID: <20170705191933.GA6297@magnolia>
References: <c9f7090b2a58364998ad4a49cfdac379b905c7e9.1498687302.git.kkc6196@fb.com>
 <20A40B3C-E179-432B-B56F-BDAAF0CD2E1F@dilger.ca>
 <7CD38230-D961-428F-B2E9-2C0E28CAF442@fb.com>
 <20170629045940.GB5865@birch.djwong.org>
 <20170629143551.GB1651@fieldses.org>
 <20170629172528.GA5869@birch.djwong.org>
 <20170629183053.GA4178@fieldses.org>
 <20170629185022.GB4178@fieldses.org>
 <20170704040446.GB4704@birch.djwong.org>
 <20170705011534.GC1420@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170705011534.GC1420@fieldses.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: William Koh <kkc6196@fb.com>, Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>, linux-ext4 <linux-ext4@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, xfs <linux-xfs@vger.kernel.org>

On Tue, Jul 04, 2017 at 09:15:34PM -0400, J. Bruce Fields wrote:
> On Mon, Jul 03, 2017 at 09:04:46PM -0700, Darrick J. Wong wrote:
> > On Thu, Jun 29, 2017 at 02:50:22PM -0400, J. Bruce Fields wrote:
> > > On Thu, Jun 29, 2017 at 02:30:53PM -0400, J. Bruce Fields wrote:
> > > > On Thu, Jun 29, 2017 at 10:25:28AM -0700, Darrick J. Wong wrote:
> > > > > Was there ever a version of NFS (or more generally callers of the
> > > > > exportfs code) that couldn't deal with i_generation in the file handle,
> > > > > and therefore we invented this generation hack to work around the loss
> > > > > of the generation information?
> > > > > 
> > > > > There's a comment in xfs_fs_encode_fh about not supporting 64bit inodes
> > > > > with subtree_check (which seems to require one ino/gen pair for the file
> > > > > and a second pair for the file's parent) on NFSv2 because v2 doesn't
> > > > > provide enough space for all the file handle information, but that's the
> > > > > furthest I got with lazy-mining the git history. :)
> > > > 
> > > > There's a comment in fs/ext4/super.c:ext4_nfs_get_inode
> > > > 
> > > > 	* Currently we don't know the generation for parent directory, so
> > > > 	* a generation of 0 means "accept any"
> > > > 
> > > > But I don't see that used.
> > > > 
> > > > It was used once upon a time; I see it actually used in old 2.5 code in
> > > > nfsd_get_dentry.  Hm.
> > > 
> > > Oh, maybe it's here in fs/libfs.c:generic_fh_to_parent:
> > > 
> > > 	switch (fh_type) {
> > > 	case FILEID_INO32_GEN_PARENT:
> > > 		inode = get_inode(sb, fid->i32.parent_ino,
> > >         			  (fh_len > 3 ? fid->i32.parent_gen : 0));
> > > 		break;
> > > 	}
> > > 
> > > I'm not sure under what conditions that filehandle encoding is used.
> > 
> > The best guess I can come up with is the old nfs_fhbase_old style handles,
> > which (afaict) do not carry parent i_generation?
> 
> Yeah, I just couldn't tell in the time I looked whether they could still
> be handed out.
> 
> If not, then the only way they'd still be used is if a client had a
> server continually mounted while the server was upgraded from a kernel
> that still handed out the old filehandle.
> 
> So if they haven't been given out for long enough it's possible nobody
> would notice if we dropped support.
> 
> But, I didn't get far enough to figure that out.

Hmm, so looking back through prehistory, Linux prior to 2.3.51 (11 March
2000) gave out the old dentry style fhandles.  After that, the kernel
only gave out the new style handles that we still use today.  In 2.4.6
(4 July 2001) the behavior was modified again to chain handle types,
i.e. if the client passed in an old style handle then it would get
another old style handle back.  The changelog for -pre9 says that this
was done for compatibility reasons.

So, what's the probability that there are clients out there that started
talking to a 2.2-based knfsd and will now want to talk to a modern 4.13
kernel seventeen years later?  (Do nfs handles persist across client
restarts/remounts?)

--D

> 
> --b.
