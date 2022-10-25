Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 498A8C38A2D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 22:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbiJYWas (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 18:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbiJYWar (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 18:30:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B28E43E5F
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 15:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6104E61BB6
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 22:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFDFC433D6;
        Tue, 25 Oct 2022 22:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666737018;
        bh=zxBH4708yQt8iacwO75MOaaO6C4X1oFYufgeP/P3ooI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IfY7/lUa5URXVGZx90t2AnDdh6wY9KQF7o+M3Y+CvOXVgWH2QlyVduljtD8fssHlI
         Jt3unaZDOQEmn4plxcxSK217tLUm9A+8cs0RvZjuFxwIQvAUotSE6yQ2jZIf9Z0O5F
         jQE+k+0REimA3eWG6/FpbXTnE68RMofSP5cqcw/QFkV1j/SkCG9w4VpJsjP8CwCJxI
         hnnTfFInbAOIvQ7xKbUhilUO8wslMghRniB9FjYA4jj7IFpgY8/elkXAlnqevbK7oW
         LcImLGWq1EuYMijNONWt3fvYU860D0r/AWmCrQ9445YuEW59jJ7DFJbEm25tuYi+0d
         WruGGtDCuV5Kw==
Date:   Tue, 25 Oct 2022 15:30:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH] xfs: fix incorrect return type for fsdax fault handlers
Message-ID: <Y1hjehfVft6oUO6c@magnolia>
References: <Y1cEYs4TK/kED/52@magnolia>
 <Y1cKIEmT2R9INlDT@casper.infradead.org>
 <Y1crWdYUGatxJn+T@magnolia>
 <Y1gkzZzAl1QilpVe@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1gkzZzAl1QilpVe@casper.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 25, 2022 at 07:02:53PM +0100, Matthew Wilcox wrote:
> On Mon, Oct 24, 2022 at 05:18:33PM -0700, Darrick J. Wong wrote:
> > On Mon, Oct 24, 2022 at 10:56:48PM +0100, Matthew Wilcox wrote:
> > > On Mon, Oct 24, 2022 at 02:32:18PM -0700, Darrick J. Wong wrote:
> > > > Fix the incorrect return type for these two functions, and make the
> > > > !fsdax version return SIGBUS since there is no vm_fault_t that maps to
> > > > zero.
> > > 
> > > Hmm?  You should be able to return 0 without sparse complaining.
> > 
> > Yes I know, but is that the correct return value for "someone is calling
> > the wrong function, everything is fubar, please stop the world now"?
> 
> No, it's "success, but I didn't bother to lock the page myself, please
> do it for me", which doesn't really make any sense.  I think in this
> case, having not initialised vmf->page, we'd probably take a NULL
> ptr dereference in lock_page().

Yes, that's why I don't want to leave the !fsdax stub returning zero.

--D

> From your changelog, it seemed like you were trying to come up with the
> vm_fault_t equivalent of 0, rather than trying to change the semantics
> of the !fsdax version.
