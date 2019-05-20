Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot1-f49.google.com ([209.85.210.49]:36836 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfETXlX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:41:23 -0400
Received: by mail-ot1-f49.google.com with SMTP id c3so14678182otr.3
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2019 16:41:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAHgs-5XkA5xFgxgSaX9m70gduuO1beq6fiY7UEGv1ad6bd19Hw@mail.gmail.com>
 <20190513211947.GR29573@dread.disaster.area>
In-Reply-To: <20190513211947.GR29573@dread.disaster.area>
From: Tim Smith <tim.smith@vaultcloud.com.au>
Date: Tue, 21 May 2019 09:41:12 +1000
Message-ID: <CAHgs-5Ufzv7NrtL-0pQzGhC3vvDmFVOyeXOW4kRKLsX7xzXf_Q@mail.gmail.com>
Subject: Re: xfs filesystem reports negative usage - reoccurring problem
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, May 14, 2019 at 7:19 AM Dave Chinner <david@fromorbit.com> wrote:
>   decimal        hex
>  459388955       1b61b7cb
> 4733263928      11a1fdfe8
>                 ^
>                 Single bit is wrong in the free block count.
>
> IOWs, I'd say there's single bit errors happening somewhere in your
> system. Whether it be memory corruption, machines being rowhammered,
> uncorrected storage media errors, etc I have no idea. But it seems
> suspicious that the free block count is almost exactly 0x100000000
> out....

This issue is happening on more than one host, so I'm guessing that it
might not be a RAM issue... however, all the incorrect fdblocks values
do start with a 1:

server2 /dev/sdm
fdblocks = 4674169069 (0x1169A28ED)
server3 /dev/sdad
fdblocks = 4722598181 (0x1197D2125)
server4 /dev/sdad
fdblocks = 4708207408 (0x118A18B30)
