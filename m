Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B8BC54EE9
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Sep 2022 02:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiIUCxY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 22:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiIUCwv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 22:52:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A671B7DF52;
        Tue, 20 Sep 2022 19:52:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69154B82E0B;
        Wed, 21 Sep 2022 02:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B9EC43470;
        Wed, 21 Sep 2022 02:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663728768;
        bh=RhR8GLW+bPD7kNiLxNd2NSfrl+/O4Gc3C+CqOGphGe0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S/VEg7DyTP1VVx7Z8n0SiPDexYG0hCuDf3LV3vbKAeu9Z/IuKDX2xxP2BsW7yxzit
         NBtFWPRfxO5oI6ETLwJP8VlkZmqzuOmLLwUjI/aLykhcTzbkDXClIutCpHT3Ru6FIH
         swlx0ohfXTbyj4AqvsTMA1JfhP3+mW6P3ndcZpFieWk8CTnbstjMx2q2yHkHCFbpOU
         RUpCA1rWMFZmqYrrMa1ht/kCItWuSNSJqr2lKdltshybvP9LRjP4P7mqmL8bwNDec8
         bfWEHQvunElibTf3PBnWshdDAg3TyLSbOzwpOcF41duGvPwDEdCC6jNzUTv5zO3PzY
         pt6Hw66QW5yrg==
Date:   Tue, 20 Sep 2022 19:52:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Rob Landley <rob@landley.net>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: fs/xfs/Kconfig points at oss.sgi.com which is toast.
Message-ID: <Yyp8f9hUbGpS1R9Q@magnolia>
References: <4d69c27b-d0a0-997e-6609-eccd0939d156@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d69c27b-d0a0-997e-6609-eccd0939d156@landley.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 17, 2022 at 04:09:55PM -0500, Rob Landley wrote:
> Is there a replacement URL for the xfs documentation?

None that I know of.  Some of it went to xfs.org but then we lost
control of it.  I tried to push other pieces went to xfs.wiki.kernel.org
but then we lost control of that too.  Some of it is slowly migrating to
the kernel source code, but most of the old stuff is probably not
movable because people are afraid of mixing GPL and CC licensed data in
the same git repo/git server.

(And please always cc linux-xfs)

--D

> Rob
