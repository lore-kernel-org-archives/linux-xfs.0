Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1435FC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E078F20786
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:30:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TB7VK92u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgHROaG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 10:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726660AbgHROaD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 10:30:03 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D3FC061389
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:30:03 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id g19so21337532ioh.8
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z8kVJyxcQUEJb5izenLRSOu8hedwtBMCnHslO/0M2OI=;
        b=TB7VK92uWdkw8nrTBbV+wk2nOQWryd2eoH17dCLjrJaFdtW85Mgt97ZLtGiuR14iab
         mDOpUQMWAQjeh92GgzzOF1MFhJys0OwFzWCIc4ZUOmXKwaUX1AlqTrQJJK93Rl31xMLp
         gRuHwEc3Aaecr2znxm2PxgEx2Rx2AViy6hix8TKTPj0Z+joaIqIQzC9SZatQkm0wHfAz
         Gie7m/hnfuMp+DA2oyqQVtq9sbdo5kKHJ0NkoJ3ye6U0SqQQJmBAFUmbtFYiG3XMkzof
         3Bj8e2QhizkigwozLV9EbWMyi6IzsRwl7usUHE+yYYD8oFnkIAqZdueZ21B42vCIkgTq
         PJzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z8kVJyxcQUEJb5izenLRSOu8hedwtBMCnHslO/0M2OI=;
        b=OY4C4wtu6PzJy+KiS+PUbkhUQVYEQny2oWIKJo9B4t8oN25ZdqpmY9Pp2xMBXHVeAP
         feIx28HSnrIR+VLMNlJKPg+D7sIQy+TGSRRP9qbSbIhPS3cDmB1B38y+Lg/0wBFMIn/Y
         dN/Tst81AGDc4p1nEW45QfyCvu9/sBDBAS94IfOVgurumJvpVJEL8eqkwYMwjMpV/Dva
         7CAl0QF9ZJ1ZY4+/UNA+TOyNWqUEJLu9R2gw0b+LsPgR1uSJ3cku4eNiWKioiQw67N4v
         yg7B2yc3LkqlBmcALDj8+VPUjIx1ff8UmIo6aMzVqFDmFzz42iLKN91mXJeb+EmvRzmx
         NRaA==
X-Gm-Message-State: AOAM531T5VHgdsuEj8AkU5rJuOVozlLVGjtKP7f8F5E+aUb5U8UGD1OC
        QDofBcXI0yK75rVByI7F3QhAbwIbbeHDhQ4lqMvuXYPBJKU=
X-Google-Smtp-Source: ABdhPJxSvVoJn1WziBtYYF6pjcTDj3tg/A4B2AKlLhoyiFxCXsjGb2vaNQphQh0tF1C2geyq4ISAn4b8X8fetFgRJP4=
X-Received: by 2002:a6b:5d0a:: with SMTP id r10mr16543741iob.186.1597761002785;
 Tue, 18 Aug 2020 07:30:02 -0700 (PDT)
MIME-Version: 1.0
References: <159770513155.3958786.16108819726679724438.stgit@magnolia> <159770518396.3958786.953688801201393844.stgit@magnolia>
In-Reply-To: <159770518396.3958786.953688801201393844.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 17:29:51 +0300
Message-ID: <CAOQ4uxgPU41Uggv4oJmMnD5bT3JZNOw_GO+zN4DLio+oaiOC0g@mail.gmail.com>
Subject: Re: [PATCH 08/18] xfs: convert struct xfs_timestamp to union
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 2:23 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Convert the xfs_timestamp struct to a union so that we can overload it
> in the next patch.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

ok.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
