Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Mar 2008 17:24:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2J0O8JE006845
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 17:24:09 -0700
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 42A07FCC313
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 17:24:40 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id svQHBH6lKsYFcw3w for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 17:24:40 -0700 (PDT)
Date: Tue, 18 Mar 2008 20:23:07 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
Message-ID: <20080319002307.GA11349@josefsipek.net>
References: <b1b17e290803181649w507322e7mf1410b30a2621506@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1b17e290803181649w507322e7mf1410b30a2621506@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andre Draszik <xfs@andred.net>
Cc: xfs@oss.sgi.com

On Tue, Mar 18, 2008 at 11:49:11PM +0000, Andre Draszik wrote:
> Hi,
> 
> (I just subscribed, so I can't reply correctly :-(
> 
> In fact,, the last two evenings I spent making XFS work on arm eabi,
> where things are much better than with the old API, but still XFS
> won't work out of the box.
> 
> So, Eric, if you go for the #if defined(__arm__) &&
> !defined(__ARM_EABI__) approach, arm eabi will still be broken.

Ouch.

> EABI basically behaves like other 'normal' arches/abis, but sometimes
> structures get padded to have a size of a multiple of 8, i.e. padding
> is added at the end of the struct, which as far as I can see for now
> affects 5 structs: xfs_dir2_data_entry_t, xfs_dinode_t, xfs_sb_t,
> xfs_dsb_t, and xlog_rec_header_t
> 
> I must say, I like Jeff's approach of explicitly telling gcc about
> alignment much better :-) It makes it a) much easier to find structs
> that are in fact representations of on-disk data and thus might need
> tweaking, and b) as somebody already said you fix such problems once
> and forever.

Hopefully, there won't be any need for additional tweaking.

> E.g. for me as an absolute outsider, it was quite time consuming
> finding out which structs are actually on-disk.
 
Hey, I feel your pain. I just grepped the entire source tree for 'struct'
and went through them one by one.
 
> That said, Jeff, you mentioned that your changes don't work yet
> completely - could this be because (at least from the comments) struct
> xfs_sb needs to match struct xfs_dsb and you only change xfs_dsb?
 
As far as I know the patch I sent later last night does work. BUT, and I
mean *BUT*, I did not test it on anything other than x86. And even then, I
wouldn't trust it with my data just yet :)  It is very possible that some
arches are still broken - it was a "request for comment", not a "please
apply".

I talked about it a bit in the IRC channel, and the SGI folks want (1) proof
that adding these attributes does not create any regressions on any of the
supported architectures (and fixes the one that's currently broken - arm),
and (2) need to make sure that the ~700 instructions (~0.3% increase) that
get added to ia64 do not cause a regression in performance. Both points are
valid, and it'll all happen sometime (hopefully) soon.

Thanks for the heads up wrt ARM EABI.

Josef 'Jeff' Sipek.

-- 
You measure democracy by the freedom it gives its dissidents, not the
freedom it gives its assimilated conformists.
		- Abbie Hoffman
