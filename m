Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84268C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5963D207DA
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:43:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TK9s/cdW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgHROnJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 10:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgHROnI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 10:43:08 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3314DC061389
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:43:08 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id 77so17792631ilc.5
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z2NmcLZqtetwvj22On8rg3QaB/7lEuJsqsNFNcCq9A4=;
        b=TK9s/cdWhfbhwwtaYQmrOj0/6HWI3zdaA3STsFIPm37YLAmSjXUyd7/pu3CkQ6K00A
         JFDHujGu/Mq/+o6FqbgzeUsqsOz1CFC8AB0kE8gaS0+6AU8tJ1nxz6iH8TDCePJPUjy6
         fPbaJBVCC98D9WQjCCcGgN5CHb/occCiNkxoWaiea4K0ggkmL6yneQzLlI4kqznt5ztP
         CxALNP9jz97Ic74NbH/kDtYex4gjMqTdshiaAcUwb94EjTMyG54MaBypEHRMi7rxmYsD
         5jMh57+f/0nbmRCqqkZqE8E4VUCZTkWPrefcgfcCZvZ7dpDBCwOy5jADZO/B98wNkxFN
         QLNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z2NmcLZqtetwvj22On8rg3QaB/7lEuJsqsNFNcCq9A4=;
        b=V70JGhZnJSNDRRf0qGcm7mwUGhW//Ob50Yf6mhJJusK7Gn6Ha75QrAILwbvxNvHR0e
         sjV13jxUvijIZiMrfxAOkSXBd0J6zMOeaieZjnds0xrtEEnvw5SyyU0TfzR+Cb1ZC/Ez
         Cs6juwS+9YbKf+bWN/eDqPX+XjAelkgcs+6vxwO5x8p3riGtVroG8hZQODgUm4DBIJgL
         juOiTDBp6SMbAsL4UkLL4uz/48qJ4paMF0eIvsvroKyUBOqxychOupwNDkUQuY1jdzGV
         tCipd5lvu2C017jve30uAYGcNR9KTquTTNSGPBF0mLgQ/RNMxTzK280z+KF80TJIKt5F
         L2BA==
X-Gm-Message-State: AOAM533IBvY2bcPpzrDlKHpAoLfjdJx7Nka2EpE5yAePNBrUWYErm9tu
        RyT4uKbPX2TPqpWkiG38SLjRcbJlObZDUmMzykA=
X-Google-Smtp-Source: ABdhPJz/b135+AYsnFVv5DNj2Qy2FUL7dRNvAAp6pq16JKownrkRSZCGn6/sXyTyeJLoyY5Kx7sGaUWiZlK9pgfPIKk=
X-Received: by 2002:a92:5209:: with SMTP id g9mr18823775ilb.72.1597761787652;
 Tue, 18 Aug 2020 07:43:07 -0700 (PDT)
MIME-Version: 1.0
References: <159770513155.3958786.16108819726679724438.stgit@magnolia> <159770521602.3958786.7715509326251625669.stgit@magnolia>
In-Reply-To: <159770521602.3958786.7715509326251625669.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 17:42:56 +0300
Message-ID: <CAOQ4uxitV-eDDCB=rqdGpNpYCJhdC2x2jFcfPAgeJdCDTE8H9w@mail.gmail.com>
Subject: Re: [PATCH 13/18] xfs: enable big timestamps
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
> Enable the big timestamp feature.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>


Reviewed-by: Amir Goldstein <amir73il@gmail.com>
