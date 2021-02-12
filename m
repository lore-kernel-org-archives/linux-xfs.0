Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_05,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB7FAC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 20:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9E7064DEC
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 20:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhBLUvz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Feb 2021 15:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhBLUvz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Feb 2021 15:51:55 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90D3C061756
        for <linux-xfs@vger.kernel.org>; Fri, 12 Feb 2021 12:51:14 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id c25so421176qvb.4
        for <linux-xfs@vger.kernel.org>; Fri, 12 Feb 2021 12:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=KlMVcEJLdA8GQL8dZxVDh6xooa/ZcjBtTJiELV1ZweM=;
        b=LQaOsVxBXTzUPhpJuUGYwV/DgleIdYTtqjjfx1z6c8qI0yKe138SboDMQIFWfZtMSb
         E1O32VvrsD71f9gTD6AEkep8bJO4z+7rjgGlXUeNJU4BxbQ4ItI/R3iqTJG2DBd8uR/P
         eAj1T1Gqc6oIghHzvUoH1m5PgjpEC5fjMc1EA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=KlMVcEJLdA8GQL8dZxVDh6xooa/ZcjBtTJiELV1ZweM=;
        b=sGvrZT42Oya4wodlsxy8QHseqFllnvhBoPBATg2KI6Agfp30QkAA2N4mA+UvSqbNm9
         8SvdnesQgkS8DQBdYJNGiGErdQx+LdQu2iXCMuLCXSuLyt7Y3HSBBfCCN/sTx99CJjak
         rcoZ2mySqmm0tjV1cUhllJzLLklQ1NNgI4WI1kuee7p9NSTyjEN4/EjTVL5rbdkFpuoC
         orAJ2hp52zpCQxOdWhqXxFLmxVLHF53WNU2pnFMnm+WIAGFNnaY4xkWKY0yfSpXJUFJr
         LMfTyzX1OG2MwMFgZdy4oLmw3Y3iQwWUo0srBrN0C0EL5v5xoF8BCjNpZbdIxhVPhrRr
         9Xvg==
X-Gm-Message-State: AOAM533/ufNXRHdr1fFmpzDWtILck28vyxW2lR9ybMMUFlMPbw+52tng
        WKILHGvKSHSpxkbD6l5mAQlLbvylEcPgE/C3+J2F9Xii6uhv7v4Q
X-Google-Smtp-Source: ABdhPJyNZi5Y+D72EFjsAn3lPyK3jKq2qa+U5fI0qwHictOEPwzvByVuyEIthQ0gXIEE4eksj5qK7Jj4q+3ejnGipVY=
X-Received: by 2002:a05:6214:1ca:: with SMTP id c10mr4208595qvt.44.1613163073662;
 Fri, 12 Feb 2021 12:51:13 -0800 (PST)
MIME-Version: 1.0
References: <20210212204849.1556406-1-mmayer@broadcom.com>
In-Reply-To: <20210212204849.1556406-1-mmayer@broadcom.com>
From:   Markus Mayer <mmayer@broadcom.com>
Date:   Fri, 12 Feb 2021 12:51:02 -0800
Message-ID: <CAGt4E5tbyHpDEPtEGK8SYoB4w4srAfHpiBADkR+PpkQyguiLPg@mail.gmail.com>
Subject: Re: [PATCH] include/buildrules: substitute ".o" for ".lo" only at the
 very end
To:     Linux XFS <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> To prevent issues when the ".o" extension appears in a directory path,
> ensure that the ".o" -> ".lo" substitution is only performed for the
> final file extension.

If the subject should be "[PATCH] xfsprogs: ...", please let me know.

Regards,
-Markus
