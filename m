Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C22C05027
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Nov 2023 18:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbjKJSAY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Nov 2023 13:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235341AbjKJR7c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Nov 2023 12:59:32 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3589A7280
        for <linux-xfs@vger.kernel.org>; Thu,  9 Nov 2023 22:27:34 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id DBFB267373; Fri, 10 Nov 2023 06:08:46 +0100 (CET)
Date:   Fri, 10 Nov 2023 06:08:46 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH, RFC] libxfs: check the size of on-disk data structures
Message-ID: <20231110050846.GA24953@lst.de>
References: <20231108163316.493089-1-hch@lst.de> <20231109195233.GH1205143@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231109195233.GH1205143@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 09, 2023 at 11:52:33AM -0800, Darrick J. Wong wrote:
> > +#ifndef BUILD_BUG_ON_MSG
> > +#define BUILD_BUG_ON_MSG(a, b)	BUILD_BUG_ON(a)
> 
> How difficult would it be to port the complex kernel macros that
> actually result in the message being emitted in the gcc error output?
> 
> It's helpful that when the kernel build breaks, the robots will report
> exactly which field/struct/whatever tripped, which makes it easier to
> start figuring out where things went wrong on some weird architecture.

I did try to pull the entire compile time assert machinery from
the kernels compiler_types.h in, especially as atomic.h already uses
a differnet part of it.  After it pulled in two more depdendencies
I gave up, but in principle it should be entirely doable.

> Otherwise I'm all for porting xfs_ondisk.h to xfsprogs.  IIRC I tried
> that a long time ago and Dave or someone said xfs/122 was the answer.

I'd much prefer to do it in C code and inside the libxfs we build.
If we can agree on that and on killing off xfs/122 I'll look into
porting the more complex compile time assert.

The other option would be to switch to using static_assert from C11,
which doesn't allow a custom message, but at least the default message
isn't confusing as hell.

