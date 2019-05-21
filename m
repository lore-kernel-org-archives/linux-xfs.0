Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot1-f45.google.com ([209.85.210.45]:41814 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbfEUCKU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 22:10:20 -0400
Received: by mail-ot1-f45.google.com with SMTP id l25so6533281otp.8
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2019 19:10:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAHgs-5XkA5xFgxgSaX9m70gduuO1beq6fiY7UEGv1ad6bd19Hw@mail.gmail.com>
 <20190513140943.GC61135@bfoster> <683a9b7b-ad5c-5e91-893e-daaa68a853c9@sandeen.net>
 <CAHgs-5Vybp+diCoecfEWbHLRScNnsHKW7-4rwhXH3H+hfcfoLg@mail.gmail.com> <20190521014336.GG29573@dread.disaster.area>
In-Reply-To: <20190521014336.GG29573@dread.disaster.area>
From: Tim Smith <tim.smith@vaultcloud.com.au>
Date: Tue, 21 May 2019 12:10:09 +1000
Message-ID: <CAHgs-5V1v976so3BF7OhbSk0KypqSVwE5b4c0jWgRBCRvuaSPA@mail.gmail.com>
Subject: Re: xfs filesystem reports negative usage - reoccurring problem
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Tue, May 21, 2019 at 11:43 AM Dave Chinner <david@fromorbit.com> wrote:
> 8756a5af1819 ("libxfs: add more bounds checking to sb sanity checks")
> 2e9e6481e2a7 ("xfs: detect and fix bad summary counts at mount")
>
> were both merged in 4.19. Well, that would explain why you aren't
> seeing warnings or having it fixed automatically on detection.
>
> IOWs, whatever the cause of your single bit error is, I don't know,
> but it would seem that recent kernels will detect the condition and
> automatically fix themselves at mount time.

This kit is in a legacy environment to be (eventually) decommissioned,
so I'll patch the kernel to work around the issue until we can put the
hardware to bed.

Absolute legend! Thank you for all your help!
