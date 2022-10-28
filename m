Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A33DCC38A02
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 22:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiJ1WMZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Oct 2022 18:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiJ1WLx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Oct 2022 18:11:53 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FA722B787
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 15:11:52 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id m15so1494653ilq.2
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 15:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GFIrL5iVp0BfqJWCd3uXH6X4ZHXGsiWFTpJr0Fzu0p4=;
        b=e4r60sCcZBzK0owy9MYeuVEQ0Qxb1TSV8MONmzo7ONeHEBdrGIF65LVc3iDos6YE1q
         cQ58AHfslwq4AOjVKLixj5t7l1IPIXqfcyHAnt5O7DPPEI2m73hCq82IqO7SbvTYzq37
         VW28ktRt4lbauDI03HlbbInFOyJInKxos+pOjSxE0j0egY2rCxzrS8m4c3pR3utf5lzA
         IOSNCs9TL314iU4PowEA8hNjeR3InXNNMQQcy1ZR3muX9J91CnsQWgZx65kgfbm1TeuN
         izbFfwkWSOGO0lyi9qQIYLSpcP9tx5g4OoXd8fHw1DzQKGc/ajAuXiY3tCu7ry6lCXRP
         b2rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GFIrL5iVp0BfqJWCd3uXH6X4ZHXGsiWFTpJr0Fzu0p4=;
        b=iNUL43fVapSleyB257PdRCy+lHIHHGMki9EZDEgefK6kez43ESZJP1zuIuBsFpgHM8
         roT+R3EUgHOgk8umdmNbRJdDgWJZo4imTxvskNjUO/74LzbCDxvz8PCvya/o1FTQ2/K9
         0HF3OR+ioWXCOjtj+YYNfdSD1FWxOLqRxBTJjr2Rfpu9yDs4rTWkOtnncyDuwPhzQ3Qa
         JVs7zTKCmPrDK3isGpf4eOergZahsGgFPGuKMvGyHBgF1efQiOXx9WXxD3dIX2eYhUZX
         muq2rxvuiCP7Xc6cuU11QT2dAHfSjt0wsCYHSCax0wnP5807etlZl7fYiLO2jibdXAgZ
         9TGQ==
X-Gm-Message-State: ACrzQf1xTLedvLqTN1asS6c3CecSAKEAy87TNDXwu+Dmy/HGi6uZE8/4
        dRZ2vb+NoDxr9mBQsZ/Myo0SqmK+vkHEx8fZW6jvWUnf
X-Google-Smtp-Source: AMsMyM6xQCi9QyEbAW8pLGBI6CE6lfvIhhyswPVorPHDsxJac+Qt0xZfBT79QNpILwJMNDTHqH/Dp8joFlHJGSPHshw=
X-Received: by 2002:a05:6e02:1a8d:b0:2ff:1ffa:a53d with SMTP id
 k13-20020a056e021a8d00b002ff1ffaa53dmr748668ilv.175.1666995111373; Fri, 28
 Oct 2022 15:11:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAB-bdyRWCJLDde4izM_H-Bh9wPg-Enas+D4VvTROWEpVy0ZgZg@mail.gmail.com>
In-Reply-To: <CAB-bdyRWCJLDde4izM_H-Bh9wPg-Enas+D4VvTROWEpVy0ZgZg@mail.gmail.com>
From:   Neutron Sharc <neutronsharc@gmail.com>
Date:   Fri, 28 Oct 2022 15:11:15 -0700
Message-ID: <CAB-bdyTJjM7ju-ku6w1Tib06r70FbZ8r0y8mfBaKu4XQDuMeUw@mail.gmail.com>
Subject: Fwd: does xfs support aio_fsync?
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello all,
I have a workload that benefits the most if I can issue async fsync
after many async writes are completed. I was under the impression that
xfs/ext4 both support async fsync so I can use libaio to submit fsync.
When I tested with io_submit(fsync),  it always returned EINVAL.  So I
browsed the linux source (both kernel 3.10,  4.14)  and I found
xfs/xfs_file.c doesn't implement "aio_fsync", nor does ext4/file.c.

I found an old post which said aio_fsync was already included in xfs
(https://www.spinics.net/lists/xfs/msg28408.html)

What xfs or kernel version should I use to get aio_fsync working?  Thanks all.


Shawn
