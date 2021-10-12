Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2063C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 20:43:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0AB060E90
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 20:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbhJLUpX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 16:45:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232986AbhJLUpW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Oct 2021 16:45:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9896C6023F;
        Tue, 12 Oct 2021 20:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634071400;
        bh=qSRTLhh6AyfiudCxLkFvL8P1dGGMhRf6B1OWORkwoKw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ue6l9ezEMMCy87G2pv2zr0SUcuCQdpYH3vzmAShXxdWr7o6PhZf6/t1z9Q8rv9veP
         E+eeWK7xSBxZLAvOe4Su1hDkaooEsB3KF5H+aNo/9uDt72d6kpGJGQ+uyRW09PIgSD
         JD6B5Y5LgJn4RezDwDLiHszdqgbkAy3AjZjXMSTOk9ed8kLtO6bqTlyDn/687zyDZf
         GjrBk5WBUd/fpVS8qYmuaakUtZEGPGqDbWfktM6H+5fylI0f42ucPbxvRnkBp4s9q4
         1iLFDJcOP1Tng5cTpv0FjuTVJdkj0b0BJju5oFAbR6Hi3oiXziUVBtwa3I/aA54iEn
         J6kO2sgaqJ/9g==
Date:   Tue, 12 Oct 2021 13:43:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     David Rientjes <rientjes@google.com>
Cc:     Rustam Kovhaev <rkovhaev@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        cl@linux.com, penberg@kernel.org, iamjoonsoo.kim@lge.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, gregkh@linuxfoundation.org,
        Al Viro <viro@zeniv.linux.org.uk>, dvyukov@google.com
Subject: Re: [PATCH] xfs: use kmem_cache_free() for kmem_cache objects
Message-ID: <20211012204320.GP24307@magnolia>
References: <20210929212347.1139666-1-rkovhaev@gmail.com>
 <20210930044202.GP2361455@dread.disaster.area>
 <17f537b3-e2eb-5d0a-1465-20f3d3c960e2@suse.cz>
 <YVYGcLbu/aDKXkag@nuc10>
 <a9b3cd91-8ee6-a654-b2a8-00c3efb69559@suse.cz>
 <YVZXF3mbaW+Pe+Ji@nuc10>
 <1e0df91-556e-cee5-76f7-285d28fe31@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e0df91-556e-cee5-76f7-285d28fe31@google.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 03, 2021 at 06:07:20PM -0700, David Rientjes wrote:
> On Thu, 30 Sep 2021, Rustam Kovhaev wrote:
> 
> > > >> I think it's fair if something like XFS (not meant for tiny systems AFAIK?)
> > > >> excludes SLOB (meant for tiny systems). Clearly nobody tried to use these
> > > >> two together last 5 years anyway.
> > > > 
> > > > +1 for adding Kconfig option, it seems like some things are not meant to
> > > > be together.
> > > 
> > > But if we patch SLOB, we won't need it.
> > 
> > OK, so we consider XFS on SLOB a supported configuration that might be
> > used and should be tested.
> > I'll look into maybe adding a config with CONFIG_SLOB and CONFIG_XFS_FS
> > to syzbot.
> > 
> > It seems that we need to patch SLOB anyway, because any other code can
> > hit the very same issue.
> > 
> 
> It's probably best to introduce both (SLOB fix and Kconfig change for 
> XFS), at least in the interim because the combo of XFS and SLOB could be 
> broken in other ways.  If syzbot doesn't complain with a patched kernel to 
> allow SLOB to be used with XFS, then we could potentially allow them to be 
> used together.
> 
> (I'm not sure that this freeing issue is the *only* thing that is broken, 
> nor that we have sufficient information to make that determination right 
> now..)

I audited the entire xfs (kernel) codebase and didn't find any other
usage errors.  Thanks for the patch; I'll apply it to for-next.

--D
