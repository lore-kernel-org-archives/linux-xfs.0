Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD1EBC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 11:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243210AbiEPLgU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 May 2022 07:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243213AbiEPLfm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 May 2022 07:35:42 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31DA38DBC
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 04:35:09 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-e656032735so19680828fac.0
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 04:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=+4tDC2D0CMGWGTnhzvvFvlQy/8nHT19ELg+AEYRkeCk=;
        b=VPZb2cxkBcNMgPk+zySNuRMiscYBBKCD1qLsGrNYkI9wKeEiZuQi1qbcqNN58fJ5jR
         iDxcW5OC3kvHCnF01RNKOjlnnEm6Kn2JxV5SIBGToT3F1PF9sjxjtfeZDVw6vobranto
         2QhIMRrirzvVNdKsgTVMH08wWMdhrynv7onuh4JF0CfizoCi0xFRe8pB1sCAu6Dv/k5q
         8k9sP+72Jxb/9xkHueV3Yyo/bw+4Y2jSkVx68FqNiZcTZ15QvRzoyN/vPNso1itjFw8a
         hTbLHLeMItIADXCP5q1kgcnfpgojET3nWbDctYtY5UuATIb6kjzjJtxM/sjcQsBE64Ec
         0Z4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=+4tDC2D0CMGWGTnhzvvFvlQy/8nHT19ELg+AEYRkeCk=;
        b=X/z9eviND1dR12nYDecE3tYOKwATwVPY9wVfcMeagECia/HFOwMPD5DqWIFKuVYySX
         KYwzOIPxYYoPN/MYnE4zVeHcWix/wSvpqhE6lLCrhGpfbpKtHiI2eyV7Pr2cIjDG+rF2
         2n0BRIY1TknROtnj0X8RlIOCaOskr+2ozPsIaLguDe8tY+47suxjPOI6HaoIIPjCsABR
         E3uSAMGlhKpqurxngU9NSnATpxQDycN657qFLpwQxsuffh5Nz1cV8mrhAuSgvqv7eg6H
         8BePCsZAaTGeGu+WR2XNdXlBlRm+Hav7c3S3Bl15EsERds2CaA8i9oIAP82m9aOKByPy
         10ZQ==
X-Gm-Message-State: AOAM531zB9HCzb6ltK510cJbybscE4cEtCstwsc7DAnKz2a/3EdSxmgh
        uHICSPKyIcatuQT2Q4Nmgm0PlkplDunIwXrBEt9YIzQ7UgU=
X-Google-Smtp-Source: ABdhPJy94+a+m2kajFJW/PC6FpFbfquFnbtDk/hHTvyKrcxDd7oLGnshMTVV/O7kKlrNLKa0xjIGW9S7TFDtah0bxtM=
X-Received: by 2002:a05:6870:c8a5:b0:f1:65c3:b1e9 with SMTP id
 er37-20020a056870c8a500b000f165c3b1e9mr7083261oab.36.1652700908879; Mon, 16
 May 2022 04:35:08 -0700 (PDT)
MIME-Version: 1.0
From:   Raghav Sharma <raghavself28@gmail.com>
Date:   Mon, 16 May 2022 17:04:57 +0530
Message-ID: <CAGthhtKXimFugYicqrDEc_bjzPh8n=Ue96YO9VRJOQoD4A_ycA@mail.gmail.com>
Subject: [QUESTION] xfs version 5 new features
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello!

I am working with the Haiku organization for adding xfs support for HaikuOS.
We currently have xfs version 4 read support, I want to extend it to
xfs version 5.

What are new features introduced in xfs V5?

Does "xfs_filesystem_structure" pdf documentation contain all
necessary fields for V5?

I don't know if this mailing list is the right place to ask for help
on this topic, so do let me know about it.

Thanks
Raghav
