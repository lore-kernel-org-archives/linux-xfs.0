Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 423F4C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 14:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbiFPOiN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 10:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377637AbiFPOiM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 10:38:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEDE44A03;
        Thu, 16 Jun 2022 07:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WRQ7IP4husqBZexrV10wcSx741ile1sfqnxtlMk8LfI=; b=A87rmSe6QbsZno/A5ZYtyjjhnj
        Ko8DHShg3DcPEPNdwiW0zc3tR8hJRcDLSHpYY+IgmZ4VibI+YoOYVUnjNxeLdwVvfcQa9KEUaK4Ti
        XlmgxiyEsjcNcu+o7+alJ+j+qkwQ4RJhQqJ0aqE3248Kh9sDhbGB8OUNd5kWOkIVSQGlFUtl5Dp9S
        wvcKS8ub7+BRs1hocxGghx1+FgCNHsPexKhyob+ioZm8fuJVd8nDMoFCesS2PvHuaeTcgZ0NstoGr
        /AWiudfYtZu3/59CEMzYjxglzGNZde1mE05tF9SHEE7X/nWEWD4xySG7qjSbH65ZUjNE2ugrDKQA1
        KMqtP93A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1qdG-00210p-DG; Thu, 16 Jun 2022 14:38:02 +0000
Date:   Thu, 16 Jun 2022 15:38:02 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        Uladzislau Rezki <urezki@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] usercopy: use unsigned long instead of uintptr_t
Message-ID: <YqtAShjjo1zC6EgO@casper.infradead.org>
References: <20220616143617.449094-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616143617.449094-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 16, 2022 at 04:36:17PM +0200, Jason A. Donenfeld wrote:
> A recent commit factored out a series of annoying (unsigned long) casts
> into a single variable declaration, but made the pointer type a
> `uintptr_t` rather than the usual `unsigned long`. This patch changes it
> to be the integer type more typically used by the kernel to represent
> addresses.

No.  I did this on purpose.  uintptr_t is the correct type to represent
a pointer that's being used as an integer.  This dinosaur approach of
using unsigned long has to stop.
