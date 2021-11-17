Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB588C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 17:44:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD39561154
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 17:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239579AbhKQRri (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Nov 2021 12:47:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbhKQRrh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Nov 2021 12:47:37 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312FBC061570
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 09:44:39 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id x5so3412713pfr.0
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 09:44:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+uFdsysPKBJg8+GUKCjjrR+fu42d0RKVIlJ5p5O3Gqw=;
        b=AhgC+2wjkr5d9yDLbCved4jaDjwAVOHHegPWWTmEA1k+UoMOMYjm4jdejJ0FNzHR6s
         c5CZZTpF5RcDbQWqOsFLQ+5n3WzHTDlujVf/JCPu7XZBET18Z8qLE0BanPT0rnfK5Zu9
         KyIvCY0B/udnAqmbfZZUOtpDWwYOaZvFxMVOaWJLK5nqRMnfBvKrqK4xPQYQJSiLOVa8
         0rlfBALzCZrz1lMqwQv6qq3GRi5Jd7hsx8WgDG14wOcf8TDRiDnZ6oCTTfiQ53aT4YRB
         Vf3FTTZZnWUbXVIHLEPwTQXniddBnZWJsqT6SgaoHFJDwC1BLNE6VpCGlp3JGhptmlcC
         V9cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+uFdsysPKBJg8+GUKCjjrR+fu42d0RKVIlJ5p5O3Gqw=;
        b=okTtOixtxFSYYbrG+dDOH8fyklemgauMaZRoPpK0qxaNjsr+/npKLG+rj5q+ysLQF3
         dGW9Z7dgfITdLJYbZlIr+0PJPocuntzrVk6ZkwnztK5pM4FF1PrGfb4wWnhrb1N38zTI
         C1GMiBhiv8r+BNhZM15q4iEDfgqvlCrb9CiyI7au/3qLUaTfN3/I07t5e/AeZLXOtu5a
         f/WS/Hg+JyTzcDpR6Uti9UlZj2NrwXCxfkZ1zUWDk6iCybwE0ORCWI2yBO6Szg0s2VLO
         7kBDVsYH2Aah4r2Ddn2tU1+6Qs7ldaVDC+hrefsq2abIRU2pZ8XdWV+chY9Lt4rlv+cA
         jJBQ==
X-Gm-Message-State: AOAM532W9SFewl8G50EAdDYk697TmC5ua2CFrYs53ObvxaeXlLSTh/EX
        Rx8e7SHnmZqUlhJBzAMsKaA3oNH2dIaX5Jk0U72Zga+AgCc=
X-Google-Smtp-Source: ABdhPJxiiB8Ak1RjXFinVMdC+8Tb3rrtEkfJ8k6NlxRhm42dcgWCdDR0kkUYUFwrF8G9DBBrfo1Xmvo4+uUGPt+QmE4=
X-Received: by 2002:aa7:8d0a:0:b0:4a2:82d7:1695 with SMTP id
 j10-20020aa78d0a000000b004a282d71695mr37260918pfe.86.1637171078758; Wed, 17
 Nov 2021 09:44:38 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-2-hch@lst.de>
In-Reply-To: <20211109083309.584081-2-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 17 Nov 2021 09:44:25 -0800
Message-ID: <CAPcyv4ijKTcABMs2tZEuPWo1WDOux+4XWN=DNF5v8SrQRSbfDg@mail.gmail.com>
Subject: Re: [PATCH 01/29] nvdimm/pmem: move dax_attribute_group from dax to pmem
To:     Christoph Hellwig <hch@lst.de>
Cc:     Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-s390 <linux-s390@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-erofs@lists.ozlabs.org,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 9, 2021 at 12:33 AM Christoph Hellwig <hch@lst.de> wrote:
>
> dax_attribute_group is only used by the pmem driver, and can avoid the
> completely pointless lookup by the disk name if moved there.  This
> leaves just a single caller of dax_get_by_host, so move dax_get_by_host
> into the same ifdef block as that caller.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Link: https://lore.kernel.org/r/20210922173431.2454024-3-hch@lst.de
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

This one already made v5.16-rc1.
