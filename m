Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A01B3C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jun 2022 19:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346213AbiFMTBf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jun 2022 15:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346426AbiFMTAx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jun 2022 15:00:53 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DCC895DFE
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jun 2022 09:26:02 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id l4so4904506pgh.13
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jun 2022 09:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wkb+MwOrUuF+HNd2u2CzHWqIJJzZwh4CpbRv5BFIGG8=;
        b=gKsruLw56RKY2FaeJAdSucX4UKrG/JulROQ/Lt1+qZSrG2XQGf0wzVUyvCtcoFligh
         qJmOkyGGmy/7pK9UO5EU/+sICRYUzDHUkudPv1xc+EN2bjAzDFf+UImJ1vRALiT8KoYL
         ZyaoQzhghBob9lWBHE2yo35TAYUbprZwEYaZQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wkb+MwOrUuF+HNd2u2CzHWqIJJzZwh4CpbRv5BFIGG8=;
        b=LsBfG4V69eZXJmryPXnw6rqrxvuE+yEPfaMoFCQS8hOrqmz0hAEFNaeru9N+ZF5nhY
         BTtS1GwPTi1krNGRDgnqmcVGT4uIW8SAlfrLFkwftguYn03SaBG7K3RHim+dy6vDMTXQ
         4PP/q6HqdC0GFRUC8gU2k6SMfHS2GyIhZ/xqKH/pM4Qn+BFol2Qfmh7CZYL0uU+JtOKX
         3wrCEb/w4SRAr5wWicejd8FVymKB+thUNbMH1SahYydbZqRyq9t8LDjHHUT2uzEcl5Yq
         ydEE6oV/XMWBr66tTJwhLwsSTBhDzG8WCiITx009WNizFwQztB84mglA0fAr3ty1ppcD
         G/wQ==
X-Gm-Message-State: AOAM531PdF8kQBc8ZcCJeH+7oD2YJ4+By+4r6wya6ElUw1sXS8s2U9g7
        3XhXwUcO7LGEgrp8hGRw3Lldag==
X-Google-Smtp-Source: ABdhPJxyTNae2p+FANYseTK5qabNBuM278c8Nc3c4pWqu8t/rD+fUEmy0SY3R0WtqX1gZiJQB6MOtQ==
X-Received: by 2002:a05:6a00:4211:b0:51c:45e:532b with SMTP id cd17-20020a056a00421100b0051c045e532bmr61401pfb.10.1655137561925;
        Mon, 13 Jun 2022 09:26:01 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id cx9-20020a17090afd8900b001e0d4169365sm7600090pjb.17.2022.06.13.09.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 09:26:01 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     willy@infradead.org
Cc:     Kees Cook <keescook@chromium.org>, linux-mm@kvack.org,
        urezki@gmail.com, linux-xfs@vger.kernel.org,
        linux-hardening@vger.kernel.org, zlang@redhat.com
Subject: Re: [PATCH 0/3] Fixes for usercopy
Date:   Mon, 13 Jun 2022 09:25:50 -0700
Message-Id: <165513754627.2848924.5682845219293339630.b4-ty@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220612213227.3881769-1-willy@infradead.org>
References: <20220612213227.3881769-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, 12 Jun 2022 22:32:24 +0100, Matthew Wilcox (Oracle) wrote:
> Kees, I'm hoping you'll take these through your tree.  I think they're
> all reasonable fixes to go into 5.19.  The first one is essential;
> it fixes two different bugs that people have hit.
> 
> Matthew Wilcox (Oracle) (3):
>   usercopy: Handle vm_map_ram() areas
>   usercopy: Cast pointer to an integer once
>   usercopy: Make usercopy resilient against ridiculously large copies
> 
> [...]

Applied to for-next/hardening, thanks!

[1/3] usercopy: Handle vm_map_ram() areas
      https://git.kernel.org/kees/c/751ad8bdde7f
[2/3] usercopy: Cast pointer to an integer once
      https://git.kernel.org/kees/c/de2ae8f5331a
[3/3] usercopy: Make usercopy resilient against ridiculously large copies
      https://git.kernel.org/kees/c/630b2014e60e

-- 
Kees Cook

