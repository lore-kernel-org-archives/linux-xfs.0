Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C89C64ED8
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Feb 2023 01:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjBYB6Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Feb 2023 20:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBYB6P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Feb 2023 20:58:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182E911171
        for <linux-xfs@vger.kernel.org>; Fri, 24 Feb 2023 17:58:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9731461820
        for <linux-xfs@vger.kernel.org>; Sat, 25 Feb 2023 01:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A49C433EF;
        Sat, 25 Feb 2023 01:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677290293;
        bh=TTJpKHrWp1GxnJ657+zHTEAPPvwv2SHWZo9VHfm7doA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qs7mioPZPNbGg04ZQ5sa63pARyfpcVTom+WOr8pDKGZFLFqhLqNIlqQSRYGyX7Upf
         gdbjYpdiMPAWX5TktHqj4PHnddSL6P3U9rEgO9rM6Z31mHwX0sg0KyOIJWJia3Gmth
         i9i1mmNAM6xr4+h7nXL3eFLnQAIpFkcZ2ltaBoW90YrgX18h2lsu/nTlrTIc9xUSvW
         NcuiGVRzWOY2r4QTO0aQzYXoLeJm4ByFAbLcK8dOiaSAsSBYwtmPXjd7Rr4H+4b5N/
         yTXOH+eerg/i0eVKOaZUw+Yt1uwFSpoAKTV0rnCbMT3bgMq7yjPfTWX3paKmstacPy
         tiWwL7WgXc7GQ==
Date:   Fri, 24 Feb 2023 17:58:12 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [RFC DELUGE v9r2d1] xfs: Parent Pointers
Message-ID: <Y/lrNIkBZsSjjkCm@magnolia>
References: <Y+6MxEgswrJMUNOI@magnolia>
 <8a65fba38b8a8f9167f27f2a2d6151c8d84bfa61.camel@oracle.com>
 <Y/gmTwva2hW0ydCb@magnolia>
 <CAOQ4uxi9FQebjznZbTcBa36pbChz+A94+BeykovCDx0S6Ygoxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi9FQebjznZbTcBa36pbChz+A94+BeykovCDx0S6Ygoxw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 24, 2023 at 09:24:48AM +0200, Amir Goldstein wrote:
> On Fri, Feb 24, 2023 at 5:09 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Fri, Feb 17, 2023 at 08:02:29PM +0000, Allison Henderson wrote:
> > > On Thu, 2023-02-16 at 12:06 -0800, Darrick J. Wong wrote:
> > > > Hi everyone,
> > > >
> > > > This deluge contains all of the additions to the parent pointers
> > > > patchset that I've been working on for the past month.  The kernel
> > > > and
> > > > xfsprogs patchsets are based on Allison's v9r2 tag from last week;
> > > > the fstests patches are merely a part of my development tree.  To
> > > > recap
> >
> > <snip>
> >
> > > Ermergersh, thats a lot!  Thanks for all the hard work.  I feel like if
> > > we don't come up with a plan for review though, people may not know
> > > where to start for these deluges!  Lets see... if we had to break this
> > > down, I think would divide it up between the existing parent pointers
> > > and the new pptr propositions for ofsck.
> >
> > That's a good place to cleave.
> >
> > > Then further divide it among
> > > kernel space, user space and test case.  If I had to pick only one of
> > > these to focus attention on, probably it should be new ofsck changes in
> > > the kernel space, since the rest of the deluge is really contingent on
> > > it.
> >
> > Yup.  Though you ought to read through the offline fsck patches too.
> > Those take a very different approach to resolving parent pointers.  So
> > much of repair is based on nuking directories that I don't know there's
> > a good way to rebuild them from parent pointers.
> >
> > A thought I had was that when we decide to zap a directory due to
> > problems in the directory blocks themselves, we could them initiate a
> > scan of the parent pointers to try to find all the dirents we can.  I
> > ran into problems with that approach because libxfs_iget allocates fresh
> > xfs_inode objects (instead of caching and sharing them like the kernel
> > does) and that made it really hard to scan things in a coherent manner.
> >
> > > So now we've narrowed this down to a few subsets:
> > >
> > > [PATCHSET v9r2d1 0/3] xfs: bug fixes for parent pointers
> > > [PATCHSET v9r2d1 0/4] xfs: rework the GETPARENTS ioctl,
> >
> > If you read through these two patchsets and think they're ok, then
> > either fold the fixes into the main series or tack them on the end,
> > whichever is easier.  If you tack them on the end, please add your
> > own SOB tags.
> >
> > > [PATCHSET v9r2d1 00/23] xfs: online fsck support patches
> > > [PATCHSET v9r2d1 0/7] xfs: online repair of directories
> > > [PATCHSET v9r2d1 0/2] xfs: online checking of parent pointers
> > > [PATCHSET v9r2d1 0/3] xfs: online checking of parent pointers
> > > [PATCHSET v9r2d1 0/2] xfs: online checking of directories
> >
> > The fsck functionality exists to prove the point that directory repair
> > is /very/ awkward if we have to update p_diroffset.  As such, they
> > focused on getting the main parts right ... but with the obvious
> > problem of making pptrs dependent on online fsck part 1 getting merged.
> >
> > Speaking of which -- can we merge online fsck for 6.4?  Please? :)
> >
> > > [PATCHSET v9r2d1 0/5] xfs: encode parent pointer name in xattr key
> >
> > Resolving the questions presented by this series is critical to nailing
> > down the ondisk format and merging the feature.  But we'll get to that
> > below.
> >
> > > [PATCHSET v9r2d1 0/3] xfs: use flex arrays for XFS_IOC_GETPARENTS,
> >
> > I'd like to know what you think about converting the ioctl definition to
> > flex arrays instead of the fixed size structs.  I'm not sure where to
> > put this series, though.  If you decide that you want 'em, then ideally
> > they'd be in xfs_fs.h from the introduction of XFS_IOC_GETPARENTS, but
> > I don't see any point in backporting them around "xfs: rework the
> > GETPARENTS ioctl".
> >
> > (I would be ok if you rolled all of it into patch 25 from the original
> > v9 set.)
> >
> > > Of those, I think "xfs: encode parent pointer name in xattr key" is the
> > > only one that might impact other features since it's changeing the
> > > ondisk format from when we first started the effort years ago.  So
> > > probably that might be the best place for people to start since if this
> > > needs to change it might impact some of the other subsets in the
> > > deluge, or even features they are working on if they've based anything
> > > on the existing pptr set.
> >
> > Bingo!
> >
> > The biggest question about the format change is (IMHO) whether we're ok
> > with using a hash function for parent pointer names that don't fit in
> > the attr key space, and which hash?
> >
> > The sha2 family was designed to be collision resistant, but I don't
> > anticipate that will last forever.  The hash is computed from (the full
> > name and the child generation number) when the dirent name is longer
> > than 243 bytes.  The first 179 bytes of the dirent name are still
> > written in the parent pointer attr name.  An attacker would have to find
> > a collision that only changes the last 76 bytes of the dirent name, and
> > they'd have to know the generation number at runtime.
> >
> > (Note: dirent names shorter than 243 bytes are written directly into the
> > parent pointer xattr name, no hashing required.)
> >
> > I /think/ that's good enough, but I'm no cryptanalyst.  The alternative
> > would be to change the xattr format so that the namelen field in the
> > leaf structure to encode *only* the name component of the parent
> > pointer.  This would lead to a lot of special cased xattr code and
> > probably a lot of bugs and other stupid problems, which is why I didn't
> > take that route.
> >
> > Thoughts?
> 
> Is there an intention to allow enabling parent pointers on existing systems
> and run online repair to add the pptr xattrs?

That's going to be difficult because we don't know how much space the
parent pointers are going to need ahead of time.  I'd guess probably
not.

> If not, then you could avoid the entire complexity with
> statp->f_namelen = XFS_MAX_PPTR_NAMELEN;
> for pptr formatted fs.
> 
> Are those 12 bytes of namelen really going to be missed?

I dislike having to lower MAXNAMELEN; that seems like it would result in
user complaints.

> This limitation does not need to last forever.
> It can be lifted later by special casing pptr namelen as you suggested
> after a separate risk vs. benefit discussion.

Deferring the discussion in that manner will require us to burn another
incompat feature bit to prevent older kernels that don't understand the
hashing from mounting a filesystem where the hashes are in use.

--D

> Thanks,
> Amir.
