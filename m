Return-Path: <SRS0=TFM3=YL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD929CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Oct 2019 16:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADE34222C2
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Oct 2019 16:10:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="HN9o7AmI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405669AbfJRQKs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Oct 2019 12:10:48 -0400
Received: from mail-oi1-f172.google.com ([209.85.167.172]:40635 "EHLO
        mail-oi1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406212AbfJRQKr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Oct 2019 12:10:47 -0400
Received: by mail-oi1-f172.google.com with SMTP id k9so5652816oib.7
        for <linux-xfs@vger.kernel.org>; Fri, 18 Oct 2019 09:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=8l1eMQUdRu4q+gSH2YPTqZRanDumXJ8fPer53Anbvq4=;
        b=HN9o7AmIRBrr9cPXm5DeU5eM9K19s5UBI8ozZRkcQJmHWh7w3HwPudfSYH98394y0t
         skl6fjmajxMVndhFxJVJfO6a595+2HmE7/Hya7avUpNTLS2Wb+KTnTDlIKNmksXo8KwK
         JmhOJy8MMKWxIQ62yhP5vXhrf4f6PKn161bJWqfqq5O570XyklYiOaT5A/+8kB/9vVub
         N+7poTFqrJ5HBHJj2+GV21VVQWjvZtuLrwr9kMWqOeU2kwv37pLda5q0HaXNYy76priz
         T0S9Xc++bsIrYUKb+LuRdGULLD0bqjgDOF2uREf3TRT11sCd0OvEXGOamxBXp78Lx0CE
         jsqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=8l1eMQUdRu4q+gSH2YPTqZRanDumXJ8fPer53Anbvq4=;
        b=qKMZbzCN4NKtJogtPjKm4TrQ6zGvwVRKHVS3lJegVDk8X63UjWbYl7k67wGN56KH1s
         d2UDUaRgzX3rZPsvBJdVIaeXWar0lH+XNaX84mzA+1opIpiSjQiDn+c3TlbTOz/1noq8
         jGNrgzelmQZpxraDnbEZl67zgDblAJryy6zCz+7cKJ3gikHad1aX1ABt+3oOZgDq9sc9
         rkOpiwmk/u/0+tjaGcYvs+a5nGobJrVhqf2X5mAY1nZXgzAKcHeS3l7kI47obe0p5jMB
         uLSMQFO3HWgiR4jIlCprx1BXa61l1IMEKyy889Ca/eFlyjvizbgUOICAOYDkbFeLWeDb
         WLLg==
X-Gm-Message-State: APjAAAWXiPPzx4jFQmk1Dw1zbSVxsIHXBbD+G8KplcfY6dECzjgyk93Y
        zruGne8XW2XWmYfdrRDRPCE6tWcz0+XvBEWHBws26bHiIKY=
X-Google-Smtp-Source: APXvYqxZbhYP3Nucct1M7hbHghgOqJl2bl+EeKJgUUxok1r9pgW6QtT4mv/YHqjrZVXRLyLl7HYJr2SYlDE85W5LhFg=
X-Received: by 2002:aca:5dd5:: with SMTP id r204mr8386785oib.73.1571415046493;
 Fri, 18 Oct 2019 09:10:46 -0700 (PDT)
MIME-Version: 1.0
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 18 Oct 2019 09:10:34 -0700
Message-ID: <CAPcyv4jZTM6m7=UdoMrC=QpS4X8W4_6X_t_wM8ZjoYDCc_Z4=A@mail.gmail.com>
Subject: filesystem-dax huge page test fails due to misaligned extents
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Eric Sandeen <esandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

In the course of tracking down a v5.3 regression with filesystem-dax
unable to generate huge page faults on any filesystem, I found that I
can't generate huge faults on v5.2 with xfs, but ext4 works. That
result indicates that the block device is properly physically aligned,
but the allocator is generating misaligned extents.

The test fallocates a 1GB file and then looks for a 2MB aligned
extent. However, fiemap reports:

        for (i = 0; i < map->fm_mapped_extents; i++) {
                ext = &map->fm_extents[i];
                fprintf(stderr, "[%ld]: l: %llx p: %llx len: %llx flags: %x\n",
                                i, ext->fe_logical, ext->fe_physical,
                                ext->fe_length, ext->fe_flags);
        }

[0]: l: 0 p: 208000 len: 1fdf8000 flags: 800
[1]: l: 1fdf8000 p: c000 len: 170000 flags: 800
[2]: l: 1ff68000 p: 2000c000 len: 1ff70000 flags: 800
[3]: l: 3fed8000 p: 4000c000 len: 128000 flags: 801

...where l == ->fe_logical and p == ->fe_physical.

I'm still searching for the kernel where this behavior changed, but in
the meantime wanted to report this in case its something
straightforward in the allocator. The mkfs.xfs invocation in this case
was:

    mkfs.xfs -f -d su=2m,sw=1 -m reflink=0 /dev/pmem0
