Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38C59FA3743
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 21:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237309AbiJ0VM2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 17:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237316AbiJ0VLc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 17:11:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B1B1AF12
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 14:10:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62A396248B
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 21:10:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12DFC433D6;
        Thu, 27 Oct 2022 21:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666905003;
        bh=1w+D1W88FFlAGKTexcmLNNKZYsrQgCc5QXHMvOloxjA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f5qu4+6xfC2l5EubFXkTrn/b7620bZsVMnoUr5vsyzxEOPQ4MqCQqLMxpEggsFJzS
         LmzwBLgFtXrEUXJ++YNqs+TdxS8EjJPqwlsjqZzfzO5yreWwOKZp241jg9iqq0X6gp
         /sPsLdOKv4AUTG4809PxEMsBYCnZQGr9xHtPtbhZB/3wC4Yr96S9aKLU06BykCAW43
         KI7yqjFBDMcD6E5C8B5ecrP6AFoawQhP6RgfTIUn0WYXk3+W03zmrnxjyrtwhsTG1Q
         VFDS4OgycXaWbAlr4fBIMwZNi7khJJjZw1LbHljBG/eAePHReLopYmjFh62X8VAXVa
         WHlqWBmOfkjQw==
Date:   Thu, 27 Oct 2022 14:10:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/12] xfs: track cow/shared record domains explicitly in
 xfs_refcount_irec
Message-ID: <Y1rzq59IoQY6/0Rz@magnolia>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
 <166689087143.3788582.13267485725187767138.stgit@magnolia>
 <20221027210307.GS3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027210307.GS3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 28, 2022 at 08:03:07AM +1100, Dave Chinner wrote:
> On Thu, Oct 27, 2022 at 10:14:31AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Just prior to committing the reflink code into upstream, the xfs
> > maintainer at the time requested that I find a way to shard the refcount
> > records into two domains -- one for records tracking shared extents, and
> > a second for tracking CoW staging extents.  The idea here was to
> > minimize mount time CoW reclamation by pushing all the CoW records to
> > the right edge of the keyspace, and it was accomplished by setting the
> > upper bit in rc_startblock.  We don't allow AGs to have more than 2^31
> > blocks, so the bit was free.
> > 
> > Unfortunately, this was a very late addition to the codebase, so most of
> > the refcount record processing code still treats rc_startblock as a u32
> > and pays no attention to whether or not the upper bit (the cow flag) is
> > set.  This is a weakness is theoretically exploitable, since we're not
> > fully validating the incoming metadata records.
> > 
> > Fuzzing demonstrates practical exploits of this weakness.  If the cow
> > flag of a node block key record is corrupted, a lookup operation can go
> > to the wrong record block and start returning records from the wrong
> > cow/shared domain.  This causes the math to go all wrong (since cow
> > domain is still implicit in the upper bit of rc_startblock) and we can
> > crash the kernel by tricking xfs into jumping into a nonexistent AG and
> > tripping over xfs_perag_get(mp, <nonexistent AG>) returning NULL.
> > 
> > To fix this, start tracking the domain as an explicit part of struct
> > xfs_refcount_irec, adjust all refcount functions to check the domain
> > of a returned record, and alter the function definitions to accept them
> > where necessary.
> > 
> > Found by fuzzing keys[2].cowflag = add in xfs/464.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> Couple of minor things.
> 
> > @@ -169,12 +183,17 @@ xfs_refcount_update(
> >  	struct xfs_refcount_irec	*irec)
> >  {
> >  	union xfs_btree_rec	rec;
> > +	__u32			start;
> >  	int			error;
> 
> Why __u32 and not, say, u32 or uint32_t? u32 is used 10x more often
> than __u32 in the kernel code, and in XFS only seem to use the __
> variants in UAPI structures.

Force of habit, I guess.  I'll rework it as uint32_t.

> > @@ -364,6 +388,7 @@ xfs_refcount_split_extent(
> >  		error = -EFSCORRUPTED;
> >  		goto out_error;
> >  	}
> > +
> >  	if (rcext.rc_startblock == agbno || xfs_refc_next(&rcext) <= agbno)
> >  		return 0;
> >  
> 
> Random new whitespace?

Oops.  I overlooked that when I was slicing and dicing yesterday.

> Other than that it looks good.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thanks!

--D

> -- 
> Dave Chinner
> david@fromorbit.com
