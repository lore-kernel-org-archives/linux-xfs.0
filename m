Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF33C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 22:41:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D63A60FC3
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 22:41:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238325AbhHLWmB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 18:42:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232611AbhHLWl7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Aug 2021 18:41:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D440060FC3;
        Thu, 12 Aug 2021 22:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628808093;
        bh=tfvD1WMWrk4Ku6cO/aWuhV4K5NVrgFbO1EJkI5FvSRQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UIv/X3W6+wWFRS5INMofLagCtWiUP66NPz8uvsDVQWNPYd0yYZWtbBXB8x9t1Ag+c
         9YGh9YOA6wCDCidPgsHdO61mNX95gf5CSs6+k6dC8hRz8PV/HCDQC6IooXeQF+j4Xc
         ohElqqiYEPmBsRqQEZdrQhFCKfdqOKx79EY9Bw6d2HUpbCAHzlV7fdzFRfsmu5vnrq
         HGCagPLGDXUEx6iVcqNUMoprm8lNIbqw0SB9GyXTowWLs8tB9eQXyzcaxZUXQwMZyK
         tnLMvseO2cuVCZc9iLT4LqDmuVdSnOkXzaNHPyI/IbEjYNvHdCGo6J7xjXmS5/Dd5/
         gSqqJw04ljTVg==
Date:   Thu, 12 Aug 2021 15:41:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [bug report] xfs: pass the goal of the incore inode walk to
 xfs_inode_walk()
Message-ID: <20210812224133.GY3601466@magnolia>
References: <20210812064222.GA20009@kili>
 <20210812214048.GE3657114@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812214048.GE3657114@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 13, 2021 at 07:40:48AM +1000, Dave Chinner wrote:
> On Thu, Aug 12, 2021 at 09:42:22AM +0300, Dan Carpenter wrote:
> > Hello Darrick J. Wong,
> > 
> > The patch c809d7e948a1: "xfs: pass the goal of the incore inode walk
> > to xfs_inode_walk()" from Jun 1, 2021, leads to the following
> > Smatch static checker warning:
> > 
> > 	fs/xfs/xfs_icache.c:52 xfs_icwalk_tag()
> > 	warn: unsigned 'goal' is never less than zero.
> > 
> > fs/xfs/xfs_icache.c
> >     49 static inline unsigned int
> >     50 xfs_icwalk_tag(enum xfs_icwalk_goal goal)
> >     51 {
> > --> 52 	return goal < 0 ? XFS_ICWALK_NULL_TAG : goal;
> > 
> > This enum will be unsigned in GCC, so "goal" can't be negative.
> 
> I think this is incorrect. The original C standard defines enums as
> signed integers, not unsigned. And according to the GCC manual
> (section 4.9 Structures, Unions, Enumerations, and Bit-Fields)
> indicates that C90 first defines the enum type to be compatible with
> the declared values. IOWs, for a build using C89 like the kernel
> does, enums should always be signed.
> 
> This enum is defined as:
> 
> enum xfs_icwalk_goal {
>         /* Goals that are not related to tags; these must be < 0. */
>         XFS_ICWALK_DQRELE       = -1,
> 
>         /* Goals directly associated with tagged inodes. */
>         XFS_ICWALK_BLOCKGC      = XFS_ICI_BLOCKGC_TAG,
>         XFS_ICWALK_RECLAIM      = XFS_ICI_RECLAIM_TAG,
> };
> 
> i.e. the enum is defined to clearly contain negative values and so
> GCC should be defining it as a signed integer regardless of the
> version of C being used...
> 
> > Plus
> > we only pass 0-1 for goal (as far as Smatch can tell).
> 
> Yup, smatch has definitely got that one wrong:
> 
> xfs_dqrele_all_inodes()
>   xfs_icwalk(mp, XFS_ICWALK_DQRELE, &icw);
>     xfs_icwalk_get_perag(.... XFS_ICWALK_DQRELE)
>       xfs_icwalk_tag(... XFS_ICWALK_DQRELE, ...)
> 
> So this warning looks like an issue with smatch, not a bug in the
> code...

...unless Dan is running smatch against for-next, which removes
XFS_ICWALK_DQRELE and thus allows for an unsigned type to back the enum?

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
