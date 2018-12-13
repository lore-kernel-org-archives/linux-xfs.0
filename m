Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37865 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbeLMGpe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Dec 2018 01:45:34 -0500
Received: by mail-lj1-f195.google.com with SMTP id e5-v6so781851lja.4
        for <linux-xfs@vger.kernel.org>; Wed, 12 Dec 2018 22:45:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20181213013000.15716-1-nbowler@draconx.ca>
References: <20181213013000.15716-1-nbowler@draconx.ca>
From: Nick Bowler <nbowler@draconx.ca>
Date: Thu, 13 Dec 2018 01:45:30 -0500
Message-ID: <CADyTPEw0MVi_JQ3io7uX3+AeGTr3QR+HtUMZ_1ZwAw4wrYr0gg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] Fixing xfs ioctls on x32
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

On 12/12/18, Nick Bowler <nbowler@draconx.ca> wrote:
[...]
> All the remaining failures on x32 appear to be aio related, or are
> also failing on the i686 tests.  I have no experience with aio but
> I'm going to assume those problems have nothing to do with ioctl.
[...]
> After (x32):
>
>   Failures: generic/112 generic/113 generic/114 generic/198 generic/207
>             generic/210 generic/240 generic/252 generic/427 generic/451
>             generic/465 generic/484 xfs/191-input-validation xfs/269
>             xfs/495
>   Failed 15 of 656 tests

In support of my assumption that the "generic" failures above are
unrelated to xfs ioctl implementation, I've confirmed that all the
"generic" tests listed as failing above also fail on ext4...

Cheers,
  Nick
