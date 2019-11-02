Return-Path: <SRS0=21/y=Y2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94878CA9EC7
	for <linux-xfs@archiver.kernel.org>; Sat,  2 Nov 2019 04:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B8962084D
	for <linux-xfs@archiver.kernel.org>; Sat,  2 Nov 2019 04:25:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="SHWv2jkO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfKBEZ1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 2 Nov 2019 00:25:27 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:44315 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfKBEZ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Nov 2019 00:25:27 -0400
Received: by mail-ot1-f65.google.com with SMTP id n48so10073713ota.11
        for <linux-xfs@vger.kernel.org>; Fri, 01 Nov 2019 21:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WVKY0SioYELJ6ImI8v503Lskf+dAkDXW4DKFTghrrvY=;
        b=SHWv2jkO49HDcZocXLDXy78sL6G9/hjS58JuJUxYvtdb3mk1EEucfKJPlTLckUhr/J
         YuA1vjvu+ra/1CvOsajcC5oiZ6IrRNsgwZQ4CefAkjgyaaVbYonwj6WcPQSTMaSlkFno
         To/RTYODLOo8jttLyd+bE/2HvuMZRYa8SdNFzoCAjPx3wr+fSElVFlgBs/kxYnMgxq1A
         +WiE9CcIUveR6MOhQHaTHl/UlIlugi9OMXaOxEkmYhIt32I/kYLnkgVpnYAroc7txWnC
         HHR7UqKp5Bkie3I1vmlt0T6AJ9ifxAINOBUt4n04sEG4cVQfzRSP5Dyq0Q7T2CGrGfA1
         OSmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WVKY0SioYELJ6ImI8v503Lskf+dAkDXW4DKFTghrrvY=;
        b=fQ922Xsx94GQnoCQMeyuxQ8xRKop1+rkWTqQY6aWIgh/vmYaW6XO3bp/pLzDLVYqP1
         uaOVEmpnXcvQMX3mMs+xbARsM8S13hul/hwVvYe5k7KilAYd6U3sP/8JUOJr2UnZR0XW
         rwKd5y6Ifoe9kwv1UZpAUFyQCYrurktiels7xzq57gz5Dev+HPfTJmhKhQernSabbF3U
         FFpT1zgcmkQLWTjW/l+m4QmafCrm86qKjTLxYL/NGvDC1o9lohvCV4uM+TspxsBZgxc0
         yCATZgwOv2JvJaZRvP4Hh75T9T0p+QQs58U7I2iVrzsoU5H52gMess4p0STONe46wh+O
         phJw==
X-Gm-Message-State: APjAAAWfNm95mRSLf7ww4kSTKpDYjVdrGZreDAb+qjVKSflEf8Zn/Eku
        h1NBuioK+La1Oie4b6JcB32G5I9naz9wGFyR1dMHAg==
X-Google-Smtp-Source: APXvYqzuhvuy068R2WZlsZs6OALu7q7vZmg+l5pCz59QbwFS6qu8b/RiiqHO1Swr/2p2mNuDWmNLcgvs2qICNDvAVow=
X-Received: by 2002:a9d:2d89:: with SMTP id g9mr11067444otb.126.1572668726439;
 Fri, 01 Nov 2019 21:25:26 -0700 (PDT)
MIME-Version: 1.0
References: <20191023221332.GE2044@dread.disaster.area> <efffc9e7-8948-a117-dc7f-e394e50606ab@plexistor.com>
 <20191024073446.GA4614@dread.disaster.area> <fb4f8be7-bca6-733a-7f16-ced6557f7108@plexistor.com>
 <20191024213508.GB4614@dread.disaster.area> <ab101f90-6ec1-7527-1859-5f6309640cfa@plexistor.com>
 <20191025003603.GE4614@dread.disaster.area> <20191025204926.GA26184@iweiny-DESK2.sc.intel.com>
 <20191027221039.GL4614@dread.disaster.area> <20191031161757.GA14771@iweiny-DESK2.sc.intel.com>
 <20191101224715.GY4614@dread.disaster.area>
In-Reply-To: <20191101224715.GY4614@dread.disaster.area>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 1 Nov 2019 21:25:15 -0700
Message-ID: <CAPcyv4juj9E1qKSXzOVfugmd=rBLZAvfbDdZT6ut0LdWwza=xA@mail.gmail.com>
Subject: Re: [PATCH 0/5] Enable per-file/directory DAX operations
To:     Dave Chinner <david@fromorbit.com>
Cc:     Ira Weiny <ira.weiny@intel.com>, Boaz Harrosh <boaz@plexistor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 1, 2019 at 3:47 PM Dave Chinner <david@fromorbit.com> wrote:
[..]
> No, the flag does not get turned on until we've solved the problems
> that resulted in us turning it off. We've gone over this mutliple
> times, and nobody has solved the issues that need solving - everyone
> seems to just hack around the issues rather than solving it
> properly. If we thought taking some kind of shortcut full of
> compromises and gotchas was the right solution, we would have never
> turned the flag off in the first place.

My fault. I thought the effective vs physical distinction was worth
taking an incremental step forward. Ira was continuing to look at the
a_ops issue in the meantime.
