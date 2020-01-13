Return-Path: <SRS0=9ni0=3C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D1FBC33CA9
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 16:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 626432080D
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 16:14:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="0fT73zLr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbgAMQOc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jan 2020 11:14:32 -0500
Received: from mail-wr1-f47.google.com ([209.85.221.47]:42322 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbgAMQOc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jan 2020 11:14:32 -0500
Received: by mail-wr1-f47.google.com with SMTP id q6so9150107wro.9
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2020 08:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZvpsfGYATLEf/xvhrnHhDR6lj2j7KgzJ3z76Gl4IuN0=;
        b=0fT73zLrgz1trSU7IZqQRFLN1Pk3v23PG0e+2L53zu3Sakc8sX1/mJrgQqlwnHtnrI
         mETYUiMHAzaWpr1imfd79dan/R5Uge/gyQYfsX9hEM9uOiuSPaa+YwizCxxA9gqET3XG
         uuaHwvqsnXpCntar0BHOS0kmuX2OAsAoyeCw+tlmtbxzLYgCdTO7+teNxpLoOv68SztO
         6zHCuuX0zLj6EOW7WocNvMve4KZyq5b5wSP9V5zPsg2E2gLuzFJjweahwg3qUhru8fXi
         mhe/1QPec3lxE9AqdHClMvZXwIwRfdTDy4w2jfuqEbX3GTZJU1n9TcyZDctrHq7so+5q
         zJMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZvpsfGYATLEf/xvhrnHhDR6lj2j7KgzJ3z76Gl4IuN0=;
        b=HxPDsLGr53du3FjlaIL+4fjMMWS/+7zTXE4wWOziHvnVcX9AOddZ05qlAnY6yRXuL7
         sJEU2VhYmlCawlGHS2sEsO7A8F4l/gT29TipdYcQI5e8HH/zT0zpbk88llUyDoe9FN6x
         b5OcZn0nnRshs5Y/ta7Ds2Znc8PjAqYqIAH7V+5/j5ucY5gvVK00WniAHl07F5xK7kLK
         i4qQY9n316qF6aH0OpuOuFsgQy6WCUgywNuqPvkSmF+Ywmgw4obutdxBcUf4ZTiyP1ff
         sXTn/XEW0sDEnxgJIq3Y5defgsMQ50oDYbvqe03/0Po9X5GQRIF8HrBXbFJc6M4OLR7q
         bpXQ==
X-Gm-Message-State: APjAAAWvH7PtPWwrzS4amyR8dEvmYhO8Ngf9iSu/ZkRkSDsSZONIriss
        VuUNAK7o+xi9EwULHH+PkCit7ldKSqMqehMOaz7GxRihDqg=
X-Google-Smtp-Source: APXvYqwiOTRb9+UR+kdDsc9JRzhSgiGSpL8lr6cmzEYrYFaKc6L3f6hn6JuBUKmbgS0uouhOOd6IhGuuUlEIM+QPbtw=
X-Received: by 2002:adf:82f3:: with SMTP id 106mr19966956wrc.69.1578932070712;
 Mon, 13 Jan 2020 08:14:30 -0800 (PST)
MIME-Version: 1.0
References: <fe697fb6-cef6-2e06-de77-3530700852da@assyoma.it>
In-Reply-To: <fe697fb6-cef6-2e06-de77-3530700852da@assyoma.it>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 13 Jan 2020 09:14:14 -0700
Message-ID: <CAJCQCtShw=TTqfnxWpEROXfUgs2TtAOnLzPdi4LpOo9aYsN-gg@mail.gmail.com>
Subject: Re: XFS reflink vs ThinLVM
To:     xfs list <linux-xfs@vger.kernel.org>
Cc:     Gionatan Danti <g.danti@assyoma.it>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 13, 2020 at 3:28 AM Gionatan Danti <g.danti@assyoma.it> wrote:
>
> Still, in at least one use case they are quite similar: single-volume
> storage of virtual machine files, with vdisk-level snapshot. So lets say
> I have a single big volume for storing virtual disk image file, and
> using XFS reflink to take atomic, per file snapshot via a simple "cp
> --reflink vdisk.img vdisk_snap.img".

Is --reflink on XFS atomic? In particular for a VM file that's being
used, that's possibly quite a lot of metadata on disk and in-flight in
the host and in the guest.

I ask because I'm not certain --reflink copies on Btrfs are atomic,
I'll have to ask over there too. Whereas btrfs subvolume snapshots are
considered atomic.



-- 
Chris Murphy
