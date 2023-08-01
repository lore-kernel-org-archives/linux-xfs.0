Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9161AC00528
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Aug 2023 23:18:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbjHAXSB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Aug 2023 19:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbjHAXSA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Aug 2023 19:18:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BAB26AA
        for <linux-xfs@vger.kernel.org>; Tue,  1 Aug 2023 16:17:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 919746175E
        for <linux-xfs@vger.kernel.org>; Tue,  1 Aug 2023 23:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2BFC433C8;
        Tue,  1 Aug 2023 23:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690931871;
        bh=65Tp/9tJaUD3Fib6QC9NRUutewiMxa5DvWC56qPg+80=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=njms4SmUEH7HCKq24F+ry/NYlKM1jhAaE/AcCRywJYKcC7bcxz3rMBHlQj8Bg6oZS
         5Bu17jLigCOoGN0Yfx951mTve+ozk5cdlcmyErMHP2UjqcoEVOxDGGh1xvABxA3qQm
         OrxPTDJ8I9Cihp7uPT4ECD9u7oISF37FARyKr8kd2/JeVNHk/aR+zILV2NJ2wxkeii
         Fm0+3BBn2XQgXNfEL2JGR4wFgsFL4aQEfH6hWqXSGE2rcQ78ZWjzAvqpQrg4D/syQU
         kiw77FQapqXmWtHgWowP5+qizYznXJr2HsarqH7lnHqFW1JzzA+cMHGcPOmRXl2Ftb
         Ge0C1XQLn/gyA==
Date:   Tue, 1 Aug 2023 16:17:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-xfs@vger.kernel.org, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: Re: [PATCH 2/6] xfs: invert the realtime summary cache
Message-ID: <20230801231750.GO11352@frogsfrogsfrogs>
References: <cover.1687296675.git.osandov@osandov.com>
 <e3ae5bfc7cd4b640e83a25f001169d4ae50d797a.1687296675.git.osandov@osandov.com>
 <20230712224001.GV108251@frogsfrogsfrogs>
 <ZLWccEOHmPGyVh4I@telecaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZLWccEOHmPGyVh4I@telecaster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 17, 2023 at 12:54:24PM -0700, Omar Sandoval wrote:
> On Wed, Jul 12, 2023 at 03:40:01PM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 20, 2023 at 02:32:12PM -0700, Omar Sandoval wrote:
> > > From: Omar Sandoval <osandov@fb.com>
> > > 
> > > In commit 355e3532132b ("xfs: cache minimum realtime summary level"), I
> > > added a cache of the minimum level of the realtime summary that has any
> > > free extents. However, it turns out that the _maximum_ level is more
> > > useful for upcoming optimizations, and basically equivalent for the
> > > existing usage. So, let's change the meaning of the cache to be the
> > > maximum level + 1, or 0 if there are no free extents.
> > 
> > Hmm.  If I'm reading xfs_rtmodify_summary_int right, m_rsum_cache[b] now
> > tells us the maximum log2(length) of the free extents starting in
> > rtbitmap block b?
> > 
> > IOWs, let's say the cache contents are:
> > 
> > {2, 3, 2, 15, 8}
> > 
> > Someone asks for a 400rtx (realtime extent) allocation, so we want to
> > find a free space of at least magnitude floor(log2(400)) == 8.
> > 
> > The cache tells us that there aren't any free extents longer than 2^1
> > blocks in rtbitmap blocks 0 and 2; longer than 2^2 blocks in rtbmp block
> > 1; longer than 2^7 blocks in rtbmp block 4; nor longer than 2^14 blocks
> > in rtbmp block 3?
> 
> There's a potential for an off-by-one bug here, so just to make sure
> we're saying the same thing: the realtime summary for level n contains
> the number of free extents starting in a bitmap block such that
> floor(log2(size_in_realtime_extents)) == n. The maximum size of a free
> extent in level n is therefore 2^(n + 1) - 1 realtime extents.
> 
> So in your example, the cache is telling us that realtime bitmap blocks
> 0 and 2 don't have anything free in levels 2 or above, and therefore
> don't have any free extents longer than _or equal to_ 2^2.

D'oh.  I forgot that subtlety that the maximum size of a free
extent in level n is therefore 2^(n + 1) - 1 realtime extents.

> I'll try to reword the commit message and comments to make this
> unambiguous.

Ok, thanks.  A couple of quick examples (feel free to use mine) would be
helpful for descrambling my brain. :)

--D
