Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD51C67871
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 00:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiJYAsD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 20:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiJYAru (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 20:47:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B61E1B76E3
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 16:22:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CC6D614D4
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 23:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A877C433B5;
        Mon, 24 Oct 2022 23:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666653774;
        bh=FwAE6oKpyntTkSzv1E3KQuVNYUeqmWq1Gpucgi/lq70=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C2rqczwfPcMBbfjB0dsagHifmvhSIx/eJsGs8w1RTgDcEm39rDFdFKfuhKOf1HJ2d
         +zk8l7VfNdUVICTq4HRQDbPu5UETZCsS4AoLgIPmJ8Tzu7llzwnB28I2krH457Gnsk
         PBwq1XUGMhZNLOkYoHzBKVH6KhCTUM3cSFRAO3BLsE2R4WGdQp308lsFhEVKWRpObv
         OuKBmCU6adguZTjaekp839K36KR+bJ1hWuIcJBGKsYCJLCiYku8NYvk0f2k+UzMCih
         03Bctq6RxgZfu40XlW1dp4dosO5HxFSWOmeMuDSpOCPPEFapb7UlLD4Zo/NbgsBlS1
         j0PBLGmmjG3yw==
Date:   Mon, 24 Oct 2022 16:22:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH] xfs: fix incorrect return type for fsdax fault handlers
Message-ID: <Y1ceTY4clIYOsRqA@magnolia>
References: <Y1cEYs4TK/kED/52@magnolia>
 <Y1cKIEmT2R9INlDT@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1cKIEmT2R9INlDT@casper.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 10:56:48PM +0100, Matthew Wilcox wrote:
> On Mon, Oct 24, 2022 at 02:32:18PM -0700, Darrick J. Wong wrote:
> > Fix the incorrect return type for these two functions, and make the
> > !fsdax version return SIGBUS since there is no vm_fault_t that maps to
> > zero.
> 
> Hmm?  You should be able to return 0 without sparse complaining.

What does (vm_fault_t)0 do?  And why wouldn't we want to induce a
segfault if someone calls the fsdax fault function when fsdax isn't
supported?

--D
