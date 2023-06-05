Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C65FC7EE24
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 15:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbjFEPVz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 11:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbjFEPVx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 11:21:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13120102;
        Mon,  5 Jun 2023 08:21:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96875626C2;
        Mon,  5 Jun 2023 15:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF04C433EF;
        Mon,  5 Jun 2023 15:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685978496;
        bh=FhcxfDybfxe5XDtQY5JWUXZWFTARBoxmiOfbGEHKbU4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=js22gT2ZEdeJwl3HxF1/bkkpAd2zI7tuax2BPvIhgyZtf2ue5eRJZZZ8dqgIXZ+Rm
         QD6HwViSMq3LrcnBZxW7GEDDP85L7YPnLIGzBxQxX7k36RJ44RpGtq2Vlqu+ByV+P2
         1nnBlsABKaA8pCfwubay6e8e/z+e7FBbcQDitKg43LKBUVKD7VCmWTREt1m/lFIaZr
         f+EiEbTNHlkHbRU4wzcUTuYK6zcM613xQhA63H0OSOSBv1hwJYlKVrD4xTNlbdrFyV
         mHnQ0KGa7ej7c6vxhW3TzCOTh+r6zF020Nnv8M0CkGu9hIJMF+OjceZ9gUKjQGd6QD
         J0oHHdjX7JKaA==
Date:   Mon, 5 Jun 2023 08:21:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Wang Yugui <wangyugui@e16-tech.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 5/7] filemap: Allow __filemap_get_folio to allocate
 large folios
Message-ID: <20230605152135.GK72241@frogsfrogsfrogs>
References: <20230602222445.2284892-1-willy@infradead.org>
 <20230602222445.2284892-6-willy@infradead.org>
 <20230604180925.GF72241@frogsfrogsfrogs>
 <ZH0GvxAdw1RO2Shr@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZH0GvxAdw1RO2Shr@casper.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 04, 2023 at 10:48:47PM +0100, Matthew Wilcox wrote:
> On Sun, Jun 04, 2023 at 11:09:25AM -0700, Darrick J. Wong wrote:
> > On Fri, Jun 02, 2023 at 11:24:42PM +0100, Matthew Wilcox (Oracle) wrote:
> > > +		do {
> > > +			err = -ENOMEM;
> > > +			if (order == 1)
> > > +				order = 0;
> > 
> > Doesn't this interrupt the scale-down progression 2M -> 1M -> 512K ->
> > 256K -> 128K -> 64K -> 32K -> 16K -> 4k?  What if I want 8k folios?
> 
> You can't have order-1 file/anon folios.  We have deferred_list in the
> third page, so we have to have at least three pages in every large folio.
> I forget exactly what it's used for; maybe there's a way to do without
> it, but for now that's the rule.

Ahahaha, ok.  I hadn't realized/remembered that.

/me wonders if that ought to be captured in a header as some static
inline clamping function instead of opencoded, but afaict there's only
four places around the kernel that do/need this.

Really it's a pity we can't do

	for order in 9 8 7 6 5 4 3 2 0; do

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D
