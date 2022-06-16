Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC3A9C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 14:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbiFPOvV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 10:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbiFPOvV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 10:51:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2493F43EF1;
        Thu, 16 Jun 2022 07:51:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39CE5B823E0;
        Thu, 16 Jun 2022 14:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2779DC341C5;
        Thu, 16 Jun 2022 14:51:14 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="PkGsblFi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1655391073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/Ps2YC2wCwycvBi10ctMxDm81xYyrKyFftv5PAXfyRM=;
        b=PkGsblFifbNC4pQDmVpsVWLuHGpuZK31ARFnApYM49FnnXRVq9LhfwtjV2KELKgjZ0HAy3
        M9mMzbYDNJJArBQb2UHqq4q6PIdPu0t+uiW0GfO5dHvZdp/bYb1iEoOh2+tK9dNrLrope/
        YBW28VC6mFClNsSvLLZ6x/d/E6ZTDF4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c527be78 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 16 Jun 2022 14:51:12 +0000 (UTC)
Date:   Thu, 16 Jun 2022 16:51:08 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        Uladzislau Rezki <urezki@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] usercopy: use unsigned long instead of uintptr_t
Message-ID: <YqtDXPWdFQ/fqgDo@zx2c4.com>
References: <20220616143617.449094-1-Jason@zx2c4.com>
 <YqtAShjjo1zC6EgO@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YqtAShjjo1zC6EgO@casper.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Matthew,

On Thu, Jun 16, 2022 at 03:38:02PM +0100, Matthew Wilcox wrote:
> On Thu, Jun 16, 2022 at 04:36:17PM +0200, Jason A. Donenfeld wrote:
> > A recent commit factored out a series of annoying (unsigned long) casts
> > into a single variable declaration, but made the pointer type a
> > `uintptr_t` rather than the usual `unsigned long`. This patch changes it
> > to be the integer type more typically used by the kernel to represent
> > addresses.
> 
> No.  I did this on purpose.  uintptr_t is the correct type to represent
> a pointer that's being used as an integer.  This dinosaur approach of
> using unsigned long has to stop.

For better or for worse, I've always assumed that the kernel had its
reasons -- legitimate reasons, even -- for preferring `unsigned long` to
a userspace type like `uintptr_t`, so I've always tried to code that
way.

If that's a "dinosaur approach" that "has to stop", it'd certainly be
news to me (and I'm guessing others on the list too). I've never really
seen anybody question the kernel's `unsigned long` usage before.

So hopefully some outcome of this discussion will make it clear, and
then either this patch will go in, or I'll get to work on carefully
adjusting my code that uses `unsigned long` at the moment.

Jason
