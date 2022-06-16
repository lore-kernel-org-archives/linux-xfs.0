Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A00C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 16:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbiFPQa0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 12:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiFPQa0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 12:30:26 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7785F2ED6E
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 09:30:25 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q140so1708780pgq.6
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 09:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NGZra2EXAzLHhvW+Rx2ltiLUVuZcwe1XdYZcnOjkDHg=;
        b=NOwRne8XqcUUhyuKhlF+5HvgP3UvdzK8/fh9MFgoTFqiNh0P1LFPED1MPYxudrHJQD
         s0LNPDJGZYu3fewhvZ4e0qLKZFXlbMxc70IuVSyQ4FzetS2enU17cVKevqxx8+dSPuep
         hx3rhBWdNcqhVw8ur8q7WYdWttqTiZKhjIxi4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NGZra2EXAzLHhvW+Rx2ltiLUVuZcwe1XdYZcnOjkDHg=;
        b=Lom9YI7usPKj8C9y89q/oTNyAPN0p0s/9WEUk9p9VCldk+w0uBdg7XMCm6J7iAqHiv
         Uy2kHtCfEDMyWT2kq6brl9REw1U3wFNOBsK+KGDzMFnPFf6b6K2/9SIv0oQRuDqtoJVA
         QScXPwJP+OZDHNgruqGVRZ7AMt4FwddTKO+Jr8O7YJYpDjj6lDXfNPGEjXZ81GRHovKl
         iybKPWCIVZsXHzGMCAo9Hh+Z/rMb8s3iZ5gQFsID1pBmSLyWeRCEIQaSsdtDaqBxkaG1
         jclbfFoscqeMP/x/EnqlxX7J/W5lblws+r6FvJ9zI0pEJMOIyidrVwQM2IdUyFGjJAIl
         TDpQ==
X-Gm-Message-State: AJIora/oaJgV0nkp7ryQoZ9WNYMkAuq+JdFwKHToV6OBJPj3LnNLZByI
        70b3nyWF8U1Ar4Tgvtj3LOWcfA==
X-Google-Smtp-Source: AGRyM1uuN87FEV5uTWR0IbCKzPsRK7nTwh7zISxsaLIezfzPOdcOQ5ZoPRB0MV7eFCd74z9myE1g6g==
X-Received: by 2002:a63:f944:0:b0:3fd:4f29:67e9 with SMTP id q4-20020a63f944000000b003fd4f2967e9mr5033941pgk.593.1655397024977;
        Thu, 16 Jun 2022 09:30:24 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y5-20020a170902d64500b001641a68f1c7sm1831548plh.273.2022.06.16.09.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 09:30:24 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-hardening@vger.kernel.org, Jason@zx2c4.com,
        linux-xfs@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>, urezki@gmail.com,
        joe@perches.com, gregkh@linuxfoundation.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject: Re: [PATCH] usercopy: use unsigned long instead of uintptr_t
Date:   Thu, 16 Jun 2022 09:29:12 -0700
Message-Id: <165539694985.1107767.16603574353239972239.b4-ty@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220616143617.449094-1-Jason@zx2c4.com>
References: <20220616143617.449094-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 16 Jun 2022 16:36:17 +0200, Jason A. Donenfeld wrote:
> A recent commit factored out a series of annoying (unsigned long) casts
> into a single variable declaration, but made the pointer type a
> `uintptr_t` rather than the usual `unsigned long`. This patch changes it
> to be the integer type more typically used by the kernel to represent
> addresses.
> 
> 
> [...]

Given Linus's confirmation: applied to for-next/hardening, thanks! I
do note, however, that we have almost 1700 uses of uintptr_t in the
kernel. Perhaps we need to add a section to the CodingStyle doc?

[1/1] usercopy: use unsigned long instead of uintptr_t
      https://git.kernel.org/kees/c/e230d8275da4

-- 
Kees Cook

