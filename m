Return-Path: <SRS0=JBSb=7N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7488EC433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 31 May 2020 15:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C7502076B
	for <linux-xfs@archiver.kernel.org>; Sun, 31 May 2020 15:05:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NxmI1Ppr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbgEaPFD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 May 2020 11:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgEaPFD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 May 2020 11:05:03 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303E3C061A0E
        for <linux-xfs@vger.kernel.org>; Sun, 31 May 2020 08:05:02 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id m81so4357851ioa.1
        for <linux-xfs@vger.kernel.org>; Sun, 31 May 2020 08:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o2Vin5OLVYrzwNedF93A91LHiIC7jv5BLWtOfA8PIDg=;
        b=NxmI1Pprlw5O6n+e9UsDxjhhiHhdzjxyfFzIo0e3WeX9ZXn9H/iA0TD46CLtsIJyyf
         zKBAIVJWZUBPxDr1/FQVfwS0dzNYlOdgQWwhb23s8ReDrPzJ1MOZ6tmQ9Ch+SPkv1wt1
         qCtEPmARopeb1h3Hb5+RSCstk97LVbXPUxcTpRsUlzd9ESvYDWvZWDgYZioDMs+47e5I
         vnfhd9TEuWbDJVvx+r+4j5rKG2rIOV8UrpsjMbHQ6PONZvjcX4lCD9TQGzOyZOyqz12i
         r/fdiyARLSStdT2R0QjEupZAumSOqqsyWA51duapY7gz79ue/xG0VSyZelDio5H4VKEE
         6p5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o2Vin5OLVYrzwNedF93A91LHiIC7jv5BLWtOfA8PIDg=;
        b=CE9Li2+PAzm4VuNgO6bN3+K+kRlITJpji0dQZQmkwWZaObsg9Z/0aasCbOeiRJT0Zg
         Mv5IEBAhCCDJmTc+QksCwbo6lbfXEz3iJ9O8pCX8utRdKVIJZoJKb+/HQQ1377IPWCJg
         iK7widd0QFRO9QRKrxMPZ7yQ1dz4Eq7VF8bpneMf9ytrG2pnHEx2XL1+Vq0eQzG+F37m
         C3/HxD/J2+UtfQJCJf2n/ePGKib/wDzNrJCta/KlxTHHOqCjKGkyFtDNjH6IPJjNz8/l
         017Jkba+K9GNqhZPtSa1kWWfGb6Vcvu3NnQf+mpSotTExF96KEPXxa6URZGf7By5QcWD
         PrPA==
X-Gm-Message-State: AOAM531DTpQqOYuaUauNczN4Hk7MiedsGm2Y6SUfxypwFGhGlx4HdM18
        MMXQeB1PBnDAdo8/3HzyOQGLYvdtRv16KnDSVEwAjw==
X-Google-Smtp-Source: ABdhPJzR84GDeuCnrLRW3yuhc2fzRixlWk/tAJ2vPEMjO0xUGXyIo5myj6UEQBWiTKDzftMtpzSPtcgki7+tvXpsWMw=
X-Received: by 2002:a5d:8c95:: with SMTP id g21mr15002882ion.72.1590937501625;
 Sun, 31 May 2020 08:05:01 -0700 (PDT)
MIME-Version: 1.0
References: <157784106066.1364230.569420432829402226.stgit@magnolia> <157784108755.1364230.10581541534925642174.stgit@magnolia>
In-Reply-To: <157784108755.1364230.10581541534925642174.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 31 May 2020 18:04:50 +0300
Message-ID: <CAOQ4uxjKH4zJo4P8AU=fVBd6HG9wRTmc=Uiy7Q4A30deAeXq=g@mail.gmail.com>
Subject: Re: [PATCH 04/14] xfs: fix quota timer inactivation
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 1, 2020 at 3:14 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> We need to take the inactivated inodes' resource usage into account when
> we decide if we're actually over quota.
>

Does this patch belong in this series?
Anyway, fine by me.

Thanks,
Amir.
