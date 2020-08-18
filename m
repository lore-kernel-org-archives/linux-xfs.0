Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3669BC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:22:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E0382080C
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:22:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oQhno6o8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgHROWN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 10:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgHROWM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 10:22:12 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C723C061389
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:22:12 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t4so17756032iln.1
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tRAruK/VfHdjcyqsa4aNz18wZr8siWSaqYZv4Ds2718=;
        b=oQhno6o814jWr1IRrsF6LM3fA1s5LRSh4WuuvWeIEiDSnS8pHykLAMBlsphAuXkeZi
         Szf0LfBdksegf+0X9m88ZoqGD++cJsHhx6euXklviv/1w59QKBq1oT1vydFetm12pJjC
         Ic30XSjmqaP30P/R4XqPzzeGPlm4VS31b8VN/TZu0wjFoe5YJ6duLq776P7jNMicCVJs
         Us8Dz6IhdLxKyCQcb0zDWG+OpEXlL2qvyLxgbGQ+Oz9mJAVhqwBcHuN/Ut4XgO9D/2Fo
         vdPQ+E/pg2453S0rAfP65Zu9+T1N/a5+wdX9KsmjAjOyqzUnh9gGeJwL4b7+WAm3sd7I
         UNew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tRAruK/VfHdjcyqsa4aNz18wZr8siWSaqYZv4Ds2718=;
        b=Sa37Uz8BwnFRCaNWHPiiyH12u30axzxPfoHykJ2H1TL16c5Rj6GB4qi77WRiTCOz/L
         8iYtQVDzzNxKQtNjTchKhqHiddN0pJ/wQ9rmSiv4d1LDW7nIfXeneqrzPE2jL8wKv6uy
         DHeJjA7bg3inSGKXCfN7Rweuv+uQJLKgCSbZS4VqSiCuRVHd6s+P9TILwkSVkUtgwiQQ
         8YsaKTMhz6XOQSpvxNipFcskoLiIK0dNSxcGYsaBCgGZKfADvH4tx6gtngH9avMRbnJc
         pr/VZ8lJyBOMBiOcEDO2Wrc21mkp2iwEpcph5LggoMmMCX8pAkv3DsyG+FuEn6HRJ+zP
         faCg==
X-Gm-Message-State: AOAM530ulbd/P351oKQzoCp1PIb0u6bemjioKheY/D1imP6Zr6wlLtpL
        FjIi/wcZXiogSxGEMWR9QLaMsZhOTqgertoO9G4=
X-Google-Smtp-Source: ABdhPJx8gdQCMYDWubXvjObJBtMJRXAnWeCZEKRpyqF78EdRXCNaOaPspxyy6ouv+xwgpj0AN88AQcSxO0k5jxpIZAM=
X-Received: by 2002:a92:5209:: with SMTP id g9mr18749242ilb.72.1597760531533;
 Tue, 18 Aug 2020 07:22:11 -0700 (PDT)
MIME-Version: 1.0
References: <159770513155.3958786.16108819726679724438.stgit@magnolia> <159770515211.3958786.7094290347539609121.stgit@magnolia>
In-Reply-To: <159770515211.3958786.7094290347539609121.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 17:21:59 +0300
Message-ID: <CAOQ4uxjKta9UgtJ6rWE4Wy9hxGGGJOOxu+LuLY0Mf5i1kR69Ew@mail.gmail.com>
Subject: Re: [PATCH 03/18] xfs: refactor quota expiration timer modification
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 2:24 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Define explicit limits on the range of quota grace period expiration
> timeouts and refactor the code that modifies the timeouts into helpers
> that clamp the values appropriately.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

There is no refactoring here, but I suppose you want to keep the commit
names aligned with kernel commits, so

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
