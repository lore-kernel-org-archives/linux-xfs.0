Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B29C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 10:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C7D720789
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 10:50:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vYKeUD+h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgHRKug (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 06:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgHRKu1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 06:50:27 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB4EC061389
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 03:50:26 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id f12so9596973ils.6
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 03:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fca19t8nG9fNG1KZYKtrfptj1834oZNNUjXfnKYObQc=;
        b=vYKeUD+h6AyuP4rsjpFrDH35jaLgk6q1Fc3Z4ox1SRJ+V+9A6uKN4WW8Xy6ulYjy3J
         S9sAuVE0XHo1CK+s9PiZeEtgm4eVQiBoWMFWAwISktgvNH3azdT9fOcqOMTbZkdFBSpF
         B/Du3klJXdedxg0Mkxs6FfzvH4N37Wcsq2LuRmr1w1yvev+S0rwsbLSKibHqPBVmpvSt
         7Og3XBBkYO3VAhXDvj/mq9Klh5HtgdbZqU0vpc/qSUhFVhvJZlXWk5mS3Q0xN+AwOXCA
         Nh9Ln8Y28Q5NnxkFEVBzRaXhJ1azY9BhOlTa5c4vVjgFZs1COwFPGVr19FPMLa0lU6XW
         GKmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fca19t8nG9fNG1KZYKtrfptj1834oZNNUjXfnKYObQc=;
        b=Kqx5JlG8pZUtYtjyGRI88lxEDrezr7oFjziynYbEsSACfIiFfX0BlYoPw96ZvsBl3W
         qX7m8EUn1YIyW8Wo3v7yKLGoe6tRv/F0wz+HjkbEP2A1/LPwQOoxNvUSHq+LBBtUDtnL
         IQa+lJ6c+Cwm1AAcI3QjWF0+4ox3clusRyJs2271ewRHNMceFYLKfc7nZeuXS5eDXLwV
         I7h/ulki7uG0afWjqnuV0CAhigAXNr29ZJIqtx3k1N/1jvfL6BVcrU5qg2izH17DdTd8
         kl3we2b7jbgt4+HdyeFPRDVwz0rYgJZmHrxzckm4i0y802GnGXWivIFnOPSHv3U/Lw5n
         qkQw==
X-Gm-Message-State: AOAM530HDbAc4zG+p2BIcTBT//uA9QoA9miLr+BKqvmatTGiG0p20JFg
        71VZiTSR15f5x7rbj8PW9PzvKtIxiEkzkjsLUN6RrO8F0x8=
X-Google-Smtp-Source: ABdhPJy/quDiOjtejkN6+Gyo+z/MLKbjboS+w5/o971NUhTXTyzuSZtjmUo7XPKALy54EU60+trFWPD8oZt9QrQnpF0=
X-Received: by 2002:a92:1fd9:: with SMTP id f86mr17875588ilf.250.1597747825761;
 Tue, 18 Aug 2020 03:50:25 -0700 (PDT)
MIME-Version: 1.0
References: <159770500809.3956827.8869892960975362931.stgit@magnolia> <159770503323.3956827.10474268235979771814.stgit@magnolia>
In-Reply-To: <159770503323.3956827.10474268235979771814.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 13:50:14 +0300
Message-ID: <CAOQ4uxgamUqoac0a+Nr6RJDwZJsBZ+Kbu6DbR5dKUAtFskNwsw@mail.gmail.com>
Subject: Re: [PATCH 04/11] xfs: remove xfs_timestamp_t
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 1:57 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Kill this old typedef.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Fine.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
