Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E614C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4582F206D5
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:01:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mMdbCxAW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbgEVMBl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 08:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728544AbgEVMBl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 08:01:41 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB70C061A0E
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 05:01:41 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id d5so1555241ios.9
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 05:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9kfDyeRgXwcRKAWrO1OF4PmjRLDKlvTyyEANMi71FpY=;
        b=mMdbCxAWmOiuD3/jU/Yqf6Tmxb3DgG3yldd+y5NJlrcv8OZPxh1mT8Zst3kiPKT42V
         o1QX2zYeMwf3d7RshmQKrdA3u5zyafq1DFXjGlUbrqbFuZzxJI68xSEM543ZUCqKjPP1
         G59/S4RrQz+cuPfosHefEiu1Wejb9GofjjNI9qH2InnwsgOKvrxh3iSzjbWGAHbKhwqo
         PuMGzK5Fn7TKP+ckInCDSx5YnSv1FS8f/KcdZJizhewh6Bkc04PtMFdD2CgLeBY8U+O2
         AGsq0zyVkDFY0DeP57t3M72n25/Ww8KCthoG+I3EZ4Wsb4uRpJ5BxPLd7avxAKoDC0GH
         Pafg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9kfDyeRgXwcRKAWrO1OF4PmjRLDKlvTyyEANMi71FpY=;
        b=U9UBtWgL3HWePk31fxcIGRCaNJx2EaMN5hfixvk3R3jhoB7k4ZH+7iKOzJ6wLP+mmQ
         eO19N6MSh8k4id9LYVApzY6Ci+skh05bivyhX5vDFMcfZrXLew9yLG+pUEahyJbuhAWk
         7QUiRrSxLlAcLCn9uHFk0KK8EOvW+ySx0DqjXCelcYcYUe00MqnqsXZxO8htHy5eosav
         7fjZIyhgjl2foBnO4EYDr3Apvk7Xc3nan//+l1ueUO6ueqcSengwtWYMcO/T4NVG8Eek
         1mhV2wqDnVlUSEjRz+wdRitwmOrZ3oeKs5Tm4AkHG/CknVKP2sO3MsgTxQRMJIeadMfN
         ZY+w==
X-Gm-Message-State: AOAM530BvohrJIXOVHkNJ1gmDN1VwavJ80Jz8MEt9NhJjmb4lYWtRR5t
        dJanZg56GtpoGhFdlwfvjri8OAwF02kncNBXdvw=
X-Google-Smtp-Source: ABdhPJzUaKr4c+D5hJkkleNBNzL1iOfXbE8Z5tVHrtxQj9FpFdQK450tsESKj8KyK3Lr+zk8bytg47i3Swt/a3KjE+g=
X-Received: by 2002:a05:6602:4a:: with SMTP id z10mr2761914ioz.186.1590148900727;
 Fri, 22 May 2020 05:01:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200522035029.3022405-1-david@fromorbit.com> <CAOQ4uxhcwUV6056FejN+1XyEugSLp4qPF1KTp9+qpZeE0S8KKg@mail.gmail.com>
In-Reply-To: <CAOQ4uxhcwUV6056FejN+1XyEugSLp4qPF1KTp9+qpZeE0S8KKg@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 22 May 2020 15:01:29 +0300
Message-ID: <CAOQ4uxiUnS1X4aSOyrUVwNYS4UAQ6-4n5Hs8sVqpSrJsU7DTqA@mail.gmail.com>
Subject: Re: [PATCH 00/24] xfs: rework inode flushing to make inode reclaim
 fully asynchronous
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>
> Since this is a "long standing issue" I am sure you have tests.
> Can you please share the tests you used (simoop?) with some
> encouraging performance numbers - flattening the stall curve ;-).
>

Found the numbers and OOM story in patch 13.

Thanks,
Amir.
