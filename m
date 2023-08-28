Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CB45C83F10
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Aug 2023 01:02:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbjH1BBc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Aug 2023 21:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjH1BBZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Aug 2023 21:01:25 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FF3116
        for <linux-xfs@vger.kernel.org>; Sun, 27 Aug 2023 18:01:18 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-1ba5cda3530so1994559fac.3
        for <linux-xfs@vger.kernel.org>; Sun, 27 Aug 2023 18:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1693184478; x=1693789278;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+ey3a3EQIL6KYkJlctVTmM6HP9fmVw4is9OF6/0zWHc=;
        b=rhG2shLM4bM2xVdjkrG0Tuv4sCUHXiYoayLjSIzqtyRI9ATKaJ+LjWZlnulNWI8zuo
         5gFzo2fVAoR3jpHzv/OKw0pGCDZudmARbDDWgSjrQhkXZbbSa1wJfgeV7eTVkjBgX15C
         tIWNA/zXDuIor4gGVq77kSP4+F+8MLYon0FwCKQuWZhu7N5g+PQu2hxl/CQCYwRd9nCx
         6EvqCD/UmIY/ViiMyN2YMKeQ2HSSdwzy3aqAYVXoN739chLYl2vnOenwyHQmGbUfcrB/
         DyX1B37KrQ8qlrWGgmXDt7ZfEgbBt+fg9vM2HKXxmUhXljGqYgJ204H9FgEizUbkK6qR
         kVmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693184478; x=1693789278;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ey3a3EQIL6KYkJlctVTmM6HP9fmVw4is9OF6/0zWHc=;
        b=drdiT65EFnglSTa5he+6b7CUtdDjnsCZDctErS0LAuk1EvSPRvVc+Pp0Sg+bhhlXK0
         UkWJA8xBNU5Zd9W+rjy+sYYCrAgvYx0yGD6beqZOgqOffBPO46PxTE9D0tzev/oqFqFo
         30d5+xB9sT0HOuImrEgV714ovbObIjz1LC5faMBBkkSwpHKoFvEUqjvQilXT0iCCcJzL
         Dy+Xkil9Txzf0quCbhACWs5Z/JGoRpk7qUZJATcPA9ptDI2LvWtq9/r6/w8/pr1mBong
         KkAe3rO61IRzUrGUk6TcsKA/TwvT6jbb+DV4WNeGpLe7SvXKsIfrI4weSDa0VG1tN/bo
         7ifg==
X-Gm-Message-State: AOJu0YxJDmiZgyX6TMQFcAOdiHNWvXwquYfSu+48yGfguVo8xXa1opVT
        xFLnb/PI9jZqUhkxdPSCpxVwX2hPNjcELN2E8WM=
X-Google-Smtp-Source: AGHT+IE1PjiyhK22hMwbt+FAlv7IpVaq9Ta4dwO6kDQa7XfD2trIEMHHoyW7BGu/rfE5KxAOMU95lw==
X-Received: by 2002:a05:6870:d252:b0:1c0:3110:12cc with SMTP id h18-20020a056870d25200b001c0311012ccmr11443295oac.55.1693184478067;
        Sun, 27 Aug 2023 18:01:18 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id w59-20020a17090a6bc100b00263154aab24sm6082626pjj.57.2023.08.27.18.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Aug 2023 18:01:16 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qaQcz-007QgG-2k;
        Mon, 28 Aug 2023 11:01:13 +1000
Date:   Mon, 28 Aug 2023 11:01:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Shawn <neutronsharc@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Do I have to fsync after aio_write finishes (with fallocate
 preallocation) ?
Message-ID: <ZOvx2Xg31EbJXPgr@dread.disaster.area>
References: <CAB-bdyQVJdTcaaDLWmm+rsW_U6FLF3qCTqLEKLkM6hOgk09uZQ@mail.gmail.com>
 <20221129213436.GG3600936@dread.disaster.area>
 <CAB-bdyQw7hRpRPn9JTnpyJt1sA9vPDTVsUTmrhke-EMmGfaHBA@mail.gmail.com>
 <ZOl2IHacyqSUFgfi@dread.disaster.area>
 <CAB-bdyRTKNQeukwjuB=fCT91BDO5uTJzA_Y7msOdEPBDAURbzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB-bdyRTKNQeukwjuB=fCT91BDO5uTJzA_Y7msOdEPBDAURbzg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 26, 2023 at 06:09:13PM -0700, Shawn wrote:
> xfs_io shows "extsize" as 0.   The data bsize is always 4096.  What's
> the implication of a 0 extsize?
> 
> $ sudo xfs_io -c 'stat' /mnt/S48BNW0K700192T/
> fd.path = "/mnt/S48BNW0K700192T/"
> fd.flags = non-sync,non-direct,read-write
> stat.ino = 64
> stat.type = directory
> stat.size = 81
> stat.blocks = 0
> fsxattr.xflags = 0x0 [--------------]
> fsxattr.projid = 0
> fsxattr.extsize = 0    <====  0
> fsxattr.nextents = 0
> fsxattr.naextents = 0
> dioattr.mem = 0x200
> dioattr.miniosz = 512
> dioattr.maxiosz = 2147483136

THere are no xflags set, meaning the XFS_DIFLAG_EXTSZINHERIT is not
set on the directory so nothing will inherit the extsize from the
directory at creation time. An extsize of zero is the default "don't
do any non-default extent size alignment" (i.e. align to stripe
parameters if the filesystem has them set, but nothing else.)

If this is the root directory of a mounted filesystem, it means the
extent size hint was not set by mkfs, and it hasn't been set
manually via xfs_io after mount, either.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
