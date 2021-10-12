Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD08C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D51960EB4
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:22:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbhJLXY6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:24:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229588AbhJLXY6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Oct 2021 19:24:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC82E60E0C;
        Tue, 12 Oct 2021 23:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634080976;
        bh=19NERmz1OqKhIhpjNbFrKpQAyB+6CWRvPQ5u6HEy1lg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eZQXhhZqPtEhDAbDT69+mDQw8CryvBAxGrDUcNYq+M5YfmJkgPp51lyCcAzgMtZEt
         7TbOEw0t0kMIbkf3Z5bSlywAm9JONFZB5KB1TNf7yLezBFhHrV1fc6vdPbRteHtvJi
         nnhMhvvvMPaaBKjRWb37CLwCxyOnj0GYxS30cro3ff2RuT64lKd5aEzH6Yd+up3OaH
         HQVGdst1F0TFZ9vO5MpC4Th1gmnarMLVmZ3qzDvsAammTQomu51Lm/h8YoIxo6gwi0
         Xzo8Gn/yQ1XN4VSJ7a3hFIVcM2lEAqgwGj/+siE20Dz8VVFusSRxHmWdVH/pXc+ZrH
         5kNamSSFyjrFQ==
Date:   Tue, 12 Oct 2021 16:22:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     David Rientjes <rientjes@google.com>,
        Rustam Kovhaev <rkovhaev@gmail.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        cl@linux.com, penberg@kernel.org, iamjoonsoo.kim@lge.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, gregkh@linuxfoundation.org,
        Al Viro <viro@zeniv.linux.org.uk>, dvyukov@google.com
Subject: Re: [PATCH] xfs: use kmem_cache_free() for kmem_cache objects
Message-ID: <20211012232255.GS24307@magnolia>
References: <20210929212347.1139666-1-rkovhaev@gmail.com>
 <20210930044202.GP2361455@dread.disaster.area>
 <17f537b3-e2eb-5d0a-1465-20f3d3c960e2@suse.cz>
 <YVYGcLbu/aDKXkag@nuc10>
 <a9b3cd91-8ee6-a654-b2a8-00c3efb69559@suse.cz>
 <YVZXF3mbaW+Pe+Ji@nuc10>
 <1e0df91-556e-cee5-76f7-285d28fe31@google.com>
 <20211012204320.GP24307@magnolia>
 <20211012204345.GQ24307@magnolia>
 <9db5d16a-2999-07a4-c49d-7417601f834f@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9db5d16a-2999-07a4-c49d-7417601f834f@suse.cz>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 12, 2021 at 11:32:25PM +0200, Vlastimil Babka wrote:
> On 10/12/2021 10:43 PM, Darrick J. Wong wrote:
> > On Tue, Oct 12, 2021 at 01:43:20PM -0700, Darrick J. Wong wrote:
> >> On Sun, Oct 03, 2021 at 06:07:20PM -0700, David Rientjes wrote:
> >>> On Thu, 30 Sep 2021, Rustam Kovhaev wrote:
> >>>
> >>>>>>> I think it's fair if something like XFS (not meant for tiny systems AFAIK?)
> >>>>>>> excludes SLOB (meant for tiny systems). Clearly nobody tried to use these
> >>>>>>> two together last 5 years anyway.
> >>>>>>
> >>>>>> +1 for adding Kconfig option, it seems like some things are not meant to
> >>>>>> be together.
> >>>>>
> >>>>> But if we patch SLOB, we won't need it.
> >>>>
> >>>> OK, so we consider XFS on SLOB a supported configuration that might be
> >>>> used and should be tested.
> >>>> I'll look into maybe adding a config with CONFIG_SLOB and CONFIG_XFS_FS
> >>>> to syzbot.
> >>>>
> >>>> It seems that we need to patch SLOB anyway, because any other code can
> >>>> hit the very same issue.
> >>>>
> >>>
> >>> It's probably best to introduce both (SLOB fix and Kconfig change for 
> >>> XFS), at least in the interim because the combo of XFS and SLOB could be 
> >>> broken in other ways.  If syzbot doesn't complain with a patched kernel to 
> >>> allow SLOB to be used with XFS, then we could potentially allow them to be 
> >>> used together.
> >>>
> >>> (I'm not sure that this freeing issue is the *only* thing that is broken, 
> >>> nor that we have sufficient information to make that determination right 
> >>> now..)
> >>
> >> I audited the entire xfs (kernel) codebase and didn't find any other
> >> usage errors.  Thanks for the patch; I'll apply it to for-next.
> 
> Which patch, the one that started this thread and uses kmem_cache_free() instead
> of kfree()? I thought we said it's not the best way?

It's probably better to fix slob to be able to tell that a kmem_free'd
object actually belongs to a cache and should get freed that way, just
like its larger sl[ua]b cousins.

However, even if that does come to pass, anybody /else/ who wants to
start(?) using XFS on a SLOB system will need this patch to fix the
minor papercut.  Now that I've checked the rest of the codebase, I don't
find it reasonable to make XFS mutually exclusive with SLOB over two
instances of slab cache misuse.  Hence the RVB. :)

--D

> > Also, the obligatory
> > 
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > 
> > --D
> > 
> >>
> >> --D
> 
