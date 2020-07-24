Return-Path: <SRS0=Yx8G=BD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A00DC43617
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 18:25:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A1FF206F0
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 18:25:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="J/8zD0cl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgGXSYm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 14:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbgGXSYl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 14:24:41 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A12C0619E4
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 11:24:40 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id l64so2697549qkb.8
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 11:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3Ie5Y5jakC2TFYwvUbZ4AezHADKbOSAGoe2GqVmVxQg=;
        b=J/8zD0clhD+RVPBhfuu6n3aDk34xjG3G2KT7+4IkbmjawUxqIMUwBx65PcUOHaOIkX
         oI1Sdn0qS+Lt+BST2Qr0oP8vDDo4TBRPd220V/Lp+KF/xKk/jgtUiFtoxAskajrs77df
         TlMlSOIwv4m9vTr1I+1cgHOb4k/v9MYCvEIzbthmYw016OpXfwddDb8DC5D49xN2bxVA
         nC/HY1vs4dQJw8EWZqRv2W+xkqEJChNK7sKcx0BNNMihdz6PBw7bblcCv+R9Sp2Znk+j
         o/DQrrJ/RxALmlHx6mn6R1ogpPSFbfU9wjGjZI3cfV6adS97zSB8rOMD1tExxP1DHiav
         9mlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3Ie5Y5jakC2TFYwvUbZ4AezHADKbOSAGoe2GqVmVxQg=;
        b=bMB0eV7YxiBuUMEt7JD6w3FLHRW1Nbnex60sgSZtMZK9U1KbenHM8WQGHUj6jon+tH
         hgUUutO/hbBc+M8lPgq88bRchojIMgbh0vle2XMfBFhXFIYv2ZMMk+F1gCVYDoR6avW3
         DKpGKjM1vd245rNmpoxG1USowt+EmHmaTMWMIjFTTfZTAfkMAq/BP8on8DHKlMSZw0VK
         89tpoT3Es2DmZBEIDo/qaGoJnUMbXabTkoKUaRsucACY8/2eO/7Afu4hfcxYxzwDX8Fy
         rRidllAQBgCmtcgpYvXX0QJ0xLmGsJLCSl3rWNzpd2SG9fcKzy5S0mciAo+6L7lMfnD/
         ajZw==
X-Gm-Message-State: AOAM530qzg3RUcTK8n1spPKzJvmATWRiU0c11pzeAV7ZeR+RsRsksMzz
        X2J+L8NUXPB0J8YtBQ/fO2ZHNbNfy3VKvg==
X-Google-Smtp-Source: ABdhPJyOoDWvRTYYGd9EiZWjC7o3snsGBi2o0muewXUaL4FerT4fhL0bqh+y3QkRXVoIfrJA6+Slow==
X-Received: by 2002:a37:9205:: with SMTP id u5mr1958494qkd.327.1595615079736;
        Fri, 24 Jul 2020 11:24:39 -0700 (PDT)
Received: from lca.pw (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id c22sm7634469qke.2.2020.07.24.11.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 11:24:39 -0700 (PDT)
Date:   Fri, 24 Jul 2020 14:24:32 -0400
From:   Qian Cai <cai@lca.pw>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     darrick.wong@oracle.com, hch@infradead.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, khlebnikov@yandex-team.ru
Subject: Re: WARN_ON_ONCE(1) in iomap_dio_actor()
Message-ID: <20200724182431.GA4871@lca.pw>
References: <20200619211750.GA1027@lca.pw>
 <20200620001747.GC8681@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200620001747.GC8681@bombadil.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 19, 2020 at 05:17:47PM -0700, Matthew Wilcox wrote:
> On Fri, Jun 19, 2020 at 05:17:50PM -0400, Qian Cai wrote:
> > Running a syscall fuzzer by a normal user could trigger this,
> > 
> > [55649.329999][T515839] WARNING: CPU: 6 PID: 515839 at fs/iomap/direct-io.c:391 iomap_dio_actor+0x29c/0x420
> ...
> > 371 static loff_t
> > 372 iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
> > 373                 void *data, struct iomap *iomap, struct iomap *srcmap)
> > 374 {
> > 375         struct iomap_dio *dio = data;
> > 376
> > 377         switch (iomap->type) {
> > 378         case IOMAP_HOLE:
> > 379                 if (WARN_ON_ONCE(dio->flags & IOMAP_DIO_WRITE))
> > 380                         return -EIO;
> > 381                 return iomap_dio_hole_actor(length, dio);
> > 382         case IOMAP_UNWRITTEN:
> > 383                 if (!(dio->flags & IOMAP_DIO_WRITE))
> > 384                         return iomap_dio_hole_actor(length, dio);
> > 385                 return iomap_dio_bio_actor(inode, pos, length, dio, iomap);
> > 386         case IOMAP_MAPPED:
> > 387                 return iomap_dio_bio_actor(inode, pos, length, dio, iomap);
> > 388         case IOMAP_INLINE:
> > 389                 return iomap_dio_inline_actor(inode, pos, length, dio, iomap);
> > 390         default:
> > 391                 WARN_ON_ONCE(1);
> > 392                 return -EIO;
> > 393         }
> > 394 }
> > 
> > Could that be iomap->type == IOMAP_DELALLOC ? Looking throught the logs,
> > it contains a few pread64() calls until this happens,
> 
> It _shouldn't_ be able to happen.  XFS writes back ranges which exist
> in the page cache upon seeing an O_DIRECT I/O.  So it's not supposed to
> be possible for there to be an extent which is waiting for the contents
> of the page cache to be written back.

Okay, it is IOMAP_DELALLOC. We have,

[11746.454628][T431855] Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!
[11746.466345][T431855] File: /tmp/trinity-testfile2 (deleted) PID: 431855 Comm: trinity-c54
[11746.474608][T431855] iomap->type = 1, iomap->flags = 2, iomap->length = 2031616

I noticed the commit 5a9d929d6e13 ("iomap: report collisions between directio
and buffered writes to userspace") started to convert those WARN_ON_ONCE() to
dio_warn_stale_pagecache() indicating that those to be triggered by userspace
programs, so this looks like just another missing place to convert? Apparently,
we don't want non-root users to be able to trigger this warning and kernel
tainted. This?

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index ec7b78e6feca..7f49292df420 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -388,7 +388,7 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
        case IOMAP_INLINE:
                return iomap_dio_inline_actor(inode, pos, length, dio, iomap);
        default:
-               WARN_ON_ONCE(1);
+               dio_warn_stale_pagecache(dio->iocb->ki_filp);
                return -EIO;
        }
 }

> 
> > [child21:124180] [17] pread64(fd=353, buf=0x0, count=0x59b5, pos=0xe0e0e0e) = -1 (Illegal seek)
> > [child21:124180] [339] pread64(fd=339, buf=0xffffbcc40000, count=0xbd71, pos=0xff26) = -1 (Illegal seek)
> > [child21:124627] [136] pread64(fd=69, buf=0xffffbd290000, count=0xee42, pos=2) = -1 (Illegal seek)
> > [child21:124627] [196] pread64(fd=83, buf=0x1, count=0x62f8, pos=0x15390000) = -1 (Illegal seek)
> > [child21:125127] [154] pread64(fd=345, buf=0xffffbcc40000, count=9332, pos=0xffbd) = 9332
> > [child21:125169] [188] pread64(fd=69, buf=0xffffbce90000, count=0x4d47, pos=0) = -1 (Illegal seek)
> > [child21:125169] [227] pread64(fd=345, buf=0x1, count=0xe469, pos=1046) = -1 (Bad address)
> > [child21:125569] [354] pread64(fd=87, buf=0xffffbcc50000, count=0x4294, pos=0x16161616) = -1 (Illegal seek)
> > [child21:125569] [655] pread64(fd=341, buf=0xffffbcc70000, count=2210, pos=0xffff) = -1 (Illegal seek)
> > [child21:125569] [826] pread64(fd=343, buf=0x8, count=0xeb22, pos=0xc090c202e598b) = 0
> > [child21:126233] [261] pread64(fd=338, buf=0xffffbcc40000, count=0xe8fe, pos=105) = -1 (Illegal seek)
> > [child21:126233] [275] pread64(fd=190, buf=0x8, count=0x9c24, pos=116) = -1 (Is a directory)
> > [child21:126882] [32] pread64(fd=86, buf=0xffffbcc40000, count=0x7fc2, pos=2) = -1 (Illegal seek)
> > [child21:127448] [14] pread64(fd=214, buf=0x4, count=11371, pos=0x9b26) = 0
> > [child21:127489] [70] pread64(fd=339, buf=0xffffbcc70000, count=0xb07a, pos=8192) = -1 (Illegal seek)
> > [child21:127489] [80] pread64(fd=339, buf=0x0, count=6527, pos=205) = -1 (Illegal seek)
> > [child21:127489] [245] pread64(fd=69, buf=0x8, count=0xbba2, pos=47) = -1 (Illegal seek)
> > [child21:128098] [334] pread64(fd=353, buf=0xffffbcc90000, count=0x4540, pos=168) = -1 (Illegal seek)
> > [child21:129079] [157] pread64(fd=422, buf=0x0, count=0x80df, pos=0xdfef6378b650aa) = 0
> > [child21:134700] [275] pread64(fd=397, buf=0xffffbcc50000, count=0xdee6, pos=0x887b1e74a2) = -1 (Illegal seek)
> > [child21:135042] [7] pread64(fd=80, buf=0x8, count=0xc494, pos=216) = -1 (Illegal seek)
> > [child21:135056] [188] pread64(fd=430, buf=0xffffbd090000, count=0xbe66, pos=0x3a3a3a3a) = -1 (Illegal seek)
> > [child21:135442] [143] pread64(fd=226, buf=0xffffbd390000, count=11558, pos=0x1000002d) = 0
> > [child21:135513] [275] pread64(fd=69, buf=0x4, count=4659, pos=0x486005206c2986) = -1 (Illegal seek)
> > [child21:135513] [335] pread64(fd=339, buf=0xffffbd090000, count=0x90fd, pos=253) = -1 (Illegal seek)
> > [child21:135513] [392] pread64(fd=76, buf=0xffffbcc40000, count=0xf324, pos=0x5d5d5d5d) = -1 (Illegal seek)
> > [child21:135665] [5] pread64(fd=431, buf=0xffffbcc70000, count=10545, pos=16384) = -1 (Illegal seek)
> > [child21:135665] [293] pread64(fd=349, buf=0x4, count=0xd2ad, pos=0x2000000) = -1 (Illegal seek)
> > [child21:135790] [99] pread64(fd=76, buf=0x8, count=0x70d7, pos=0x21000440) = -1 (Illegal seek)
> > [child21:135790] [149] pread64(fd=70, buf=0xffffbd5b0000, count=0x53f3, pos=255) = -1 (Illegal seek)
> > [child21:135790] [301] pread64(fd=348, buf=0x4, count=5713, pos=0x6c00401a) = -1 (Illegal seek)
> > [child21:136162] [570] pread64(fd=435, buf=0x1, count=11182, pos=248) = -1 (Illegal seek)
> > [child21:136162] [584] pread64(fd=78, buf=0xffffbcc40000, count=0xa401, pos=8192) = -1 (Illegal seek)
> > [child21:138090] [167] pread64(fd=339, buf=0x4, count=0x6aba, pos=256) = -1 (Illegal seek)
> > [child21:138090] [203] pread64(fd=348, buf=0xffffbcc90000, count=0x8625, pos=128) = -1 (Illegal seek)
> > [child21:138551] [174] pread64(fd=426, buf=0x0, count=0xd582, pos=0xd7e8674d0a86) = 0
> > [child21:138551] [179] pread64(fd=426, buf=0xffffbce90000, count=0x415a, pos=0x536e873600750b2d) = 0
> > [child21:138988] [306] pread64(fd=436, buf=0x8, count=0x62e6, pos=0x445c403204924c1) = -1 (Illegal seek)
> > [child21:138988] [353] pread64(fd=427, buf=0x4, count=0x993b, pos=176) = 0
