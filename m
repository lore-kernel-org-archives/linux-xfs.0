Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37343C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 19:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235107AbiFPTTX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 15:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbiFPTTV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 15:19:21 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC8355379
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 12:19:17 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id y19so4545146ejq.6
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 12:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xpcGuEMSHNtJO6AL8yUFZTbd1w1Zp8LDaZt4zG7HQg8=;
        b=egGfdeT+mpO40XdFqHUt/mNRkwROuAaGPwmvBbc9V8CKQtgzMIeJ5dydpj2F6YqAWD
         jWaLyXMYcKZAUkbCHTdiuA4JkddfCRJMKfg3Rr2z7QYsJo+0kuIs2gL8w23PGhI7/UU1
         zp0PY/UWDuWBbGaf5HZQqxyladpYTQRU+gj7E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xpcGuEMSHNtJO6AL8yUFZTbd1w1Zp8LDaZt4zG7HQg8=;
        b=P7Tp53YUXfvt+qUFgt4uYm8dSowawJnd/wqs9ZeN3ymL9nt+MQrV4OVGI11lplGs31
         jDo+9PA69ZiQyesgzJi4mNu4CCudxxdaLmfM5jSoeEHFbE6j0N4Ph4NIapvTea3QJlYY
         Cx235ueUCravmPURQG88qbf4zBlimHs+Ry/q3Thf3X/2DGQBD3udGH200deH54oAUhOE
         pTIEScpGbWLvbssixTAQ1IFou7bE8uRDVoDePnsuDl8yFMb5re2BNhnf2nDNezeK6xSV
         IK5TcLw6I2a+Q7ggqrT+o59gnuGyGpIEENAsINDzJJYuWTjdEZdMsB9WA9+oHPzi8OwI
         sR6g==
X-Gm-Message-State: AJIora9VmybLei60WekPW8+KBNPVzwhQg5BkVeSn4JVjpIxlvVyHfDot
        6G5WbyuWzIXem9caf/G/obXI9PAk0x8NL8IH
X-Google-Smtp-Source: AGRyM1u/kzynD2UHmCwVBsEIm0pj4JZ2GrDLG+Z2BCLDOCYcYXKmCXlv262I4LKfhFFZDDsZ3u2kCQ==
X-Received: by 2002:a17:906:5197:b0:712:2223:d3d0 with SMTP id y23-20020a170906519700b007122223d3d0mr6006066ejk.74.1655407155851;
        Thu, 16 Jun 2022 12:19:15 -0700 (PDT)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com. [209.85.221.44])
        by smtp.gmail.com with ESMTPSA id bw1-20020a170906c1c100b0070e238ff66fsm1097431ejb.96.2022.06.16.12.19.14
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jun 2022 12:19:14 -0700 (PDT)
Received: by mail-wr1-f44.google.com with SMTP id o8so3076923wro.3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 12:19:14 -0700 (PDT)
X-Received: by 2002:a5d:47aa:0:b0:218:5ac8:f3a8 with SMTP id
 10-20020a5d47aa000000b002185ac8f3a8mr6159072wrb.442.1655407153820; Thu, 16
 Jun 2022 12:19:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220616143617.449094-1-Jason@zx2c4.com> <YqtAShjjo1zC6EgO@casper.infradead.org>
 <YqtDXPWdFQ/fqgDo@zx2c4.com> <YqtKjAZRPBVjlE8S@casper.infradead.org>
 <CAHk-=wj2OHy-5e+srG1fy+ZU00TmZ1NFp6kFLbVLMXHe7A1d-g@mail.gmail.com>
 <Yqtd6hTS52mbb9+q@casper.infradead.org> <CAHk-=wj_K2MnhC6N_LyY6ezmQyWzqBnfobXC354HJuKdqMePzA@mail.gmail.com>
 <CAHk-=whS3xhJ=quD5bzDb6JsAhKd0vem4K-U=DhUGf-tDJUMHg@mail.gmail.com>
In-Reply-To: <CAHk-=whS3xhJ=quD5bzDb6JsAhKd0vem4K-U=DhUGf-tDJUMHg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 16 Jun 2022 12:18:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi28vwsG-JNJEz_kc=qwPkYtYfh_14eHOUZsaGESDBDBA@mail.gmail.com>
Message-ID: <CAHk-=wi28vwsG-JNJEz_kc=qwPkYtYfh_14eHOUZsaGESDBDBA@mail.gmail.com>
Subject: Re: [PATCH] usercopy: use unsigned long instead of uintptr_t
To:     Matthew Wilcox <willy@infradead.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linux-MM <linux-mm@kvack.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-hardening@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 16, 2022 at 12:14 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> In that situation, we'd probably just see "long long" being 128-bit
> ("I32LP64LL128").

Looking around, it looks like people prefer "long long long" (or in
the kernel, just "u128") for this, because so many have already gotten
used to "long long" being 64-bit, and 32-bit architectures (where
"long" is 32-bit and "long long" is 64-bit) are still relevant enough
that people want to keep that.

             Linus
