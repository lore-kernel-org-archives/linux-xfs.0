Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D062AFC6194
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 00:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E173217F5
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 00:13:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="i4I8aaI9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfKGANN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 19:13:13 -0500
Received: from mail-wm1-f45.google.com ([209.85.128.45]:52830 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbfKGANN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 19:13:13 -0500
Received: by mail-wm1-f45.google.com with SMTP id c17so303530wmk.2
        for <linux-xfs@vger.kernel.org>; Wed, 06 Nov 2019 16:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HDtLubeVdq4OJO0RZYCc6bmc0KXv4LHBoOzOeyTmWOc=;
        b=i4I8aaI9PzUbT3nTXI0NojiPs62V3D212s3stavUhWId0K3IT1chBP7Y6+Wg+ESHnM
         HK71nDrsD8xtnk+CPUQD5RmjHeB83NDQbgRRNs+WmtogxAKeRF7j6GElIlCGK3ydrA3X
         iduf313+D7RZYCC2hi5HoUdX24Jmm1y+mcZMTF93JGDDfrEJL/IPoJQgin4JX73wIFO4
         XdW6UZog6HJggtEjWWLnPsUtbepI72lfjlfjI1KPaVVtUjtmyUyr3yCSeXiCqm18L14v
         oC3/enfW8obGAC3stRlEdspDGjQQZRqyQfjScNDmy/w4QdvYSEPMaPrPm9iShu51AXDb
         4uCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HDtLubeVdq4OJO0RZYCc6bmc0KXv4LHBoOzOeyTmWOc=;
        b=YIAkjGZiMtRWombjNKgQ2n/tm7uOXFwYQWjPL7wTW73ltIBUOjp1IbQ3uy+3MSgSbv
         cW426yyAzniKIIwb58b6HTx1dkYiI6/EgiawjCKeWBkPzsnE3iYnv9+imej16NZowRym
         GWIlgMPmTwyf8lmOmhuikqpLQZwHWdCW/QU9zKJfBhzBENlCL3NNGyJAUOeGYw+rHdvk
         RwgI/BzN9u9gRSCzsL5ZzLbt7nFEJmNJ/+FIJ4O/aiT6m62jKDxL6oKhbv8sN/XHCK/m
         DSllB3CYFYIVEYuHMI0Aks+utvdaJ/aI81t4XkpbY0Zb6l4uzJe+FIeSKPUYc88eu7mG
         8gIg==
X-Gm-Message-State: APjAAAXq3gJLu6Ppa4egJ0zFigx1dMRV8Pf6dpVQbL+2gN4R+j/R1tzJ
        dl3sLIboe7P/eziCtbkjrQWux3VAvsQEDps1spCpwQ==
X-Google-Smtp-Source: APXvYqyc77XqRkK6jrPCslCOUXy2dnIOu1dps/7uHOv6oYNhc62pcOQbV+wDMJkvvaZLPBYf813Ch+ARTh4Nz0ri7Oc=
X-Received: by 2002:a7b:cb4a:: with SMTP id v10mr210424wmj.106.1573085590658;
 Wed, 06 Nov 2019 16:13:10 -0800 (PST)
MIME-Version: 1.0
References: <CALjAwxiuTYAVvGGUXLx6Bo-zNuW5+WXL=A8DqR5oD6D5tsKwng@mail.gmail.com>
 <20191105085446.abx27ahchg2k7d2w@orion> <CALjAwxiNExFd_eeMAFNLrMU8EKn0FNWrRrgeMWj-CCT4s7DRjA@mail.gmail.com>
 <20191105103652.n5zwf6ty3wvhti5f@orion> <CALjAwxiMqjfBX3tZJv3MqMQ776v1aNcwme0B-AuhmEgMNUqgMw@mail.gmail.com>
In-Reply-To: <CALjAwxiMqjfBX3tZJv3MqMQ776v1aNcwme0B-AuhmEgMNUqgMw@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 7 Nov 2019 00:12:40 +0000
Message-ID: <CAJCQCtQyVNCe7_A4Z743_esvSkbn9LVxUmFV_hAv2rk8s5dkfg@mail.gmail.com>
Subject: Re: Tasks blocking forever with XFS stack traces
To:     Sitsofe Wheeler <sitsofe@gmail.com>
Cc:     Carlos Maiolino <cmaiolino@redhat.com>,
        xfs list <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 5, 2019 at 2:13 PM Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>
> My understanding is that the md "chunk size" is 64k so basically
> you're saying the sectsz should have been manually set to be as big as
> possible at mkfs time? I never realised this never happened by default
> (I see the sunit seems to be correct given the block size of 4096 but
> I'm unsure about swidth)...

Check with
# mdadm -E /dev/sdXY

Chunk size depends on the version of mdadm at the time of creation.
It's been a while since 512KiB was the default, leading to rather
large full stripe write size, and a lot of RMW if a significant number
of writes aren't full stripe writes.



-- 
Chris Murphy
