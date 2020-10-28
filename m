Return-Path: <SRS0=iKFT=ED=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5871FC56202
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 23:21:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07C0620790
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 23:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbgJ1XVB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 19:21:01 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:39264 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388359AbgJ1XVA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 19:21:00 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 975113AAF94;
        Thu, 29 Oct 2020 10:20:57 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kXukS-005NHW-S2; Thu, 29 Oct 2020 10:20:56 +1100
Date:   Thu, 29 Oct 2020 10:20:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_db: add an ls command
Message-ID: <20201028232056.GB7391@dread.disaster.area>
References: <160375514873.880118.10145241423813965771.stgit@magnolia>
 <160375516100.880118.14555322605178437533.stgit@magnolia>
 <20201028012703.GA7391@dread.disaster.area>
 <20201028225046.GF1061252@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028225046.GF1061252@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=afefHYAZSVUA:10 a=7-415B0cAAAA:8
        a=ReSjPbbON82tr1zQDEEA:9 a=xETcClYN22e5MA3q:21 a=_Fr2YpWc3ZORegXp:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 28, 2020 at 03:50:46PM -0700, Darrick J. Wong wrote:
> On Wed, Oct 28, 2020 at 12:27:03PM +1100, Dave Chinner wrote:
> > On Mon, Oct 26, 2020 at 04:32:41PM -0700, Darrick J. Wong wrote:
> > > +	hash = libxfs_dir2_hashname(mp, &xname);
> > > +
> > > +	dbprintf("%-18llu %-14s 0x%08llx %3d %s", ino, dstr, hash, xname.len,
> > > +			display_name);
> > > +	if (!good)
> > > +		dbprintf(_(" (corrupt)"));
> > > +	dbprintf("\n");
> > 
> > Can we get this to emit the directory offset of the entry as well?
> 
> Er... I think so.  Do you want to report the u32 value that gets loaded
> in ctx->pos?  Or the actual byte offset within the directory?

I'd suggest that it should be the same as the telldir cookie that is
returned by the kernel for the given entry.

> > > +	} else if (direct || !S_ISDIR(VFS_I(dp)->i_mode)) {
> > > +		/* List the directory entry associated with a single file. */
> > > +		char		inum[32];
> > > +
> > > +		if (!tag) {
> > > +			snprintf(inum, sizeof(inum), "<%llu>",
> > > +					(unsigned long long)iocur_top->ino);
> > > +			tag = inum;
> > > +		} else {
> > > +			char	*p = strrchr(tag, '/');
> > > +
> > > +			if (p)
> > > +				tag = p + 1;
> > > +		}
> > > +
> > > +		dir_emit(mp, tag, -1, iocur_top->ino,
> > > +				libxfs_mode_to_ftype(VFS_I(dp)->i_mode));
> > 
> > I'm not sure what this is supposed to do - we turn the current inode
> > if it's not a directory into a -directory entry- without actually
> > know it's name? And we can pass in an inode that isn't a directory
> > and do the same? This doesn't make a huge amount of sense to me - it
> > tries to display the inode number as a dirent?
> 
> I added this (somewhat confusing) ability so that fstests could resolve
> a path to an inode number without having to dig any farther into the
> disk format.
> 
> IOWs, you can do:
> 
> ino=$(_scratch_xfs_db -c 'ls -d /usr/bin/bash')
>
> to get the inode number directly.  Without this, you'd have to do
> something horrible like this...

You mean:

$ ls -i /bin/bash | cut -f 1 -d " "
175492
$

i.e. if you want to provide the inode number rather than just the
path, then let's use the same names as a real ls  implementation :)

> To map a path to an inode number.  I thought it made a lot more sense to
> do that in C (even if it makes the xfs_db CLI a little weird) than
> implement a bunch of string parsing after the fact.

I also suspect it would be simpler to separate it out into two
functions rather than the way it is implemented now....

> Maybe I should just simplify it to "display the inode number of whatever
> the path resolves to" instead of constructing an artificial directory
> entry.

*nod*

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
