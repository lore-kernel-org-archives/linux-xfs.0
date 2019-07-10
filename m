Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38847 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfGJOau (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 10:30:50 -0400
Received: by mail-wr1-f66.google.com with SMTP id g17so2719771wrr.5
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 07:30:49 -0700 (PDT)
MIME-Version: 1.0
References: <958316946.20190710124710@a-j.ru>
In-Reply-To: <958316946.20190710124710@a-j.ru>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 10 Jul 2019 08:30:37 -0600
Message-ID: <CAJCQCtTpdGxB4r04wPNE+PRV5Jx_m95kShwvLJ5zxdmfw2fnEw@mail.gmail.com>
Subject: Re: Need help to recover root filesystem after a power supply issue
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrey Zhunev <a-j@a-j.ru>
Cc: xfs list <linux-xfs@vger.kernel.org>

On Wed, Jul 10, 2019 at 3:52 AM Andrey Zhunev <a-j@a-j.ru> wrote:
>
> [root@tftp ~]# xfs_repair /dev/centos/root
> Phase 1 - find and verify superblock...
> superblock read failed, offset 53057945600, size 131072, ag 2, rval -1
>
> fatal error -- Input/output error
> [root@tftp ~]#

# smartctl -l scterc /dev/

Point it to the physical device. If it's a consumer drive, it might
support a configurable SCT ERC. Also need to see the kernel messages
at the time of the i/o error. There's some chance if a deep recover
read is possible, it'll recover the data. But I don't see how this is
related to power supply failure.


-- 
Chris Murphy
