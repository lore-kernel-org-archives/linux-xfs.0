Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D1BC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Oct 2021 00:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1138C610EA
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Oct 2021 00:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234708AbhJOA7k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 20:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234745AbhJOA7f (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 20:59:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6E8461040;
        Fri, 15 Oct 2021 00:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634259449;
        bh=WFqaaGetsrU0F1LXNipYaIrryMD5ZYTRfecIsz8rLq8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=snUtZ9excOZNnlFFMRUeJVIxjWJFru1Xvrjr8xypife31DULY3UMsHv/mzQYLm0MG
         c9DxNx3iz2b741uRBsnAMYRZ+n1uDj8mCPhiw5S4bGh+diRuhvtguhDaKgMyzVNPZJ
         JMqzlqoOm0y4OKUSb6bYHxmoZL/bAftajHT41L60WYI5G2r0aIP/0RT10ferHe+p3u
         fFaj0Te7y9rhfifV+KsydswLpAWBKsvPSTk4yFR929qVA6SrgPJ06LFpK9R2i6QtXE
         39BAhklqvLUNInES41D5KZmnAg0pRVkCWRpIrusVtvG31ZOFmiyzB57FODAtapjC4w
         k1qCMqgGYq9Tg==
Date:   Thu, 14 Oct 2021 17:57:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Rustam Kovhaev <rkovhaev@gmail.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        cl@linux.com, penberg@kernel.org, iamjoonsoo.kim@lge.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, gregkh@linuxfoundation.org,
        Al Viro <viro@zeniv.linux.org.uk>, dvyukov@google.com
Subject: Re: [PATCH] xfs: use kmem_cache_free() for kmem_cache objects
Message-ID: <20211015005729.GD24333@magnolia>
References: <YVYGcLbu/aDKXkag@nuc10>
 <a9b3cd91-8ee6-a654-b2a8-00c3efb69559@suse.cz>
 <YVZXF3mbaW+Pe+Ji@nuc10>
 <1e0df91-556e-cee5-76f7-285d28fe31@google.com>
 <20211012204320.GP24307@magnolia>
 <20211012204345.GQ24307@magnolia>
 <9db5d16a-2999-07a4-c49d-7417601f834f@suse.cz>
 <20211012232255.GS24307@magnolia>
 <3928ef69-eaac-241c-eb32-d2dd2eab9384@suse.cz>
 <YWcPyYk0Rlyvl9a9@nuc10>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWcPyYk0Rlyvl9a9@nuc10>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 13, 2021 at 09:56:41AM -0700, Rustam Kovhaev wrote:
> On Wed, Oct 13, 2021 at 09:38:31AM +0200, Vlastimil Babka wrote:
> > On 10/13/21 01:22, Darrick J. Wong wrote:
> > > On Tue, Oct 12, 2021 at 11:32:25PM +0200, Vlastimil Babka wrote:
> > >> On 10/12/2021 10:43 PM, Darrick J. Wong wrote:
> > >> > On Tue, Oct 12, 2021 at 01:43:20PM -0700, Darrick J. Wong wrote:
> > >> >> On Sun, Oct 03, 2021 at 06:07:20PM -0700, David Rientjes wrote:
> > >> >>
> > >> >> I audited the entire xfs (kernel) codebase and didn't find any other
> > >> >> usage errors.  Thanks for the patch; I'll apply it to for-next.
> > >> 
> > >> Which patch, the one that started this thread and uses kmem_cache_free() instead
> > >> of kfree()? I thought we said it's not the best way?
> > > 
> > > It's probably better to fix slob to be able to tell that a kmem_free'd
> > > object actually belongs to a cache and should get freed that way, just
> > > like its larger sl[ua]b cousins.
> > 
> > Agreed. Rustam, do you still plan to do that?
> 
> Yes, I do, thank you.

Note that I left out the parts of the patch that changed mm/slob.c
because I didn't think that was appropriate for a patch titled 'xfs:'.

> 
> > 
> > > However, even if that does come to pass, anybody /else/ who wants to
> > > start(?) using XFS on a SLOB system will need this patch to fix the
> > > minor papercut.  Now that I've checked the rest of the codebase, I don't
> > > find it reasonable to make XFS mutually exclusive with SLOB over two
> > > instances of slab cache misuse.  Hence the RVB. :)
> > 
> > Ok. I was just wondering because Dave's first reply was that actually you'll
> > need to expand the use of kfree() instead of kmem_cache_free().

I look forward to doing this, but since XFS is a downstream consumer of
the kmem apis, we'll have to wait until the slob changes land to do
that.

--D
