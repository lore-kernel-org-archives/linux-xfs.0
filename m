Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A80B8C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E3FD20786
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:24:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZAhIKabP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgHROYG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 10:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbgHROXi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 10:23:38 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED29C061342
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:23:37 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id s1so8215960iot.10
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yLzEhITF6ENtVa3T1AcaDK8oV4FYiAzjg3HPKP6rJ5E=;
        b=ZAhIKabPZFmSLBGe9BGIW54aW86c4NOvM98Fkc02wUH4TvQGNjekKzgCK1xTsVTW6Y
         7yV8/fmOdTS0d3KpwaVjBKq8ATCapxjPG5BdYzNxhVPtr0yY2aE0Qm47xdJKpNWCAJ13
         PLNE4S8dtKtWx/LOqZ35gK9OUQ6BEDk+NFOOYuCYVgnLjA/EzPOCFhxEWr9Z6ZghFtxn
         6FHiIK9N5EKNhmLjWVwhyDE+jHvz+wLP0a/x+ya3sK9MUoDkGsrTVSp0thbRP+XUnhM0
         bkYPMzIzd9/lIOwBzZj02qlGzbciF71SMvY78dLgeFj5VgXpFTsV2LwpbT05ZcjQqf9a
         JU1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yLzEhITF6ENtVa3T1AcaDK8oV4FYiAzjg3HPKP6rJ5E=;
        b=shqZl2L4fKwdLmoMa0hl2KWQjBS9i6bKw40Nx2nYK5UfUCGWzAV8890hEQTlwrNqS2
         Fv5+qy2qw63SRH5KMwq2jcsK64u60Rx0Kl2Wy8vN+T5xKVfmWxftPA3ERSzEFGKa/p/3
         vD5IgcMIpm1mshl5r20AzAQDslfnSuLF3M523dwdn/I2i0dk3bvBK6rodPi5IgP+Poif
         ktwJ8DvJIQ8183iX8PTTKrzgNZCnYWq+tY1w4Y7BKWI+IM5l1RSpIlrqjzDL3O37/CdL
         wIew4u+Oa8ibqK6lC/vdSDoLJoNcH7dnh08SDO0Ywp87XFl4vfnetQw3fvwJvIZTbmX0
         KzjA==
X-Gm-Message-State: AOAM531MYttTjAB/E4zUd4XkgPUIDSkWyEaFhAyJoOBhAEJA4681Cihh
        Y+UEyn90H68pAacCrg68CQhCIiFrY05TYqfEm9/LQEjhIwU=
X-Google-Smtp-Source: ABdhPJyilT9tQjrzgV8Oi0mN3zOiGafVE9W33gv7lGptsZqGaEC6rwNrYUF8HVy8RIh4nrBYdOjwCZWm+TyqH/qUDhg=
X-Received: by 2002:a02:82c3:: with SMTP id u3mr19411120jag.81.1597760616953;
 Tue, 18 Aug 2020 07:23:36 -0700 (PDT)
MIME-Version: 1.0
References: <159770513155.3958786.16108819726679724438.stgit@magnolia> <159770515944.3958786.9980493388979059788.stgit@magnolia>
In-Reply-To: <159770515944.3958786.9980493388979059788.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 17:23:26 +0300
Message-ID: <CAOQ4uxiWK83i_BOBNMThmJ5E_bWS0QvwzSzoWsubq5Q3spQ_mw@mail.gmail.com>
Subject: Re: [PATCH 04/18] xfs: refactor default quota grace period setting code
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
> Refactor the code that sets the default quota grace period into a helper
> function so that we can override the ondisk behavior later.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Same here. no refactoring, but fine.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
