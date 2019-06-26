Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f172.google.com ([209.85.219.172]:35094 "EHLO
        mail-yb1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbfFZWTG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 18:19:06 -0400
Received: by mail-yb1-f172.google.com with SMTP id i203so283618ybg.2
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 15:19:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAFVd4NsBRm_pbySuSc4U=a=G4wiowZ3gFBooLEQZGZJe9V748g@mail.gmail.com>
 <CAJCQCtRD2g1c5uyDurLbt7tedPM8g6f1-74ECAW9cA1Do1yNBQ@mail.gmail.com>
 <CAFVd4NszdvQ0P4KPo9pRqtRRJxebhtMBqGVAZTmGAPBWe25nFg@mail.gmail.com> <660f9958-b10a-3bf4-6910-87a811b2a7c3@sandeen.net>
In-Reply-To: <660f9958-b10a-3bf4-6910-87a811b2a7c3@sandeen.net>
From: Rich Otero <rotero@editshare.com>
Date: Wed, 26 Jun 2019 18:18:54 -0400
Message-ID: <CAFVd4Nuv9H4AAR9DPDhhdZtKV=QXFiC8AHZz9jb46EibuO568A@mail.gmail.com>
Subject: Re: XFS Repair Error
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Chris Murphy <lists@colorremedies.com>, xfs list <linux-xfs@vger.kernel.org>, Steve Alves <steve.alves@editshare.com>

> the filesystem seems to be a disaster, probably due to bad disks - xfs_repair can't repair bad hardware, of course.
>
> current xfs_repair completes for me without error, after spitting out over 450,000 lines of detected corruption issues.
>
> so my suggestions going forward would be:
>
> 1) fix storage
> 2) get newer admin tools for next time
>
> I appreciate the report, but not much to do w/ such an old version (and it seems already fixed in any case).

Since I knew that there were issues with the hardware, that's pretty
much what I expected to hear. It's good to know that the current
version could repair this sort of problem. Thanks for the reply.

Regards,
Rich Otero
EditShare
rotero@editshare.com
617-782-0479

On Wed, Jun 26, 2019 at 6:10 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 6/26/19 4:30 PM, Rich Otero wrote:
> >> This applies
> >> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> >
> > kernel version: 3.12.17
>
> ~6 years old :(
>
> > xfsprogs version: 3.1.7
>
> 8 years old :(  So, bug reports are not really useful here ;)
>
> the filesystem seems to be a disaster, probably due to bad disks - xfs_repair can't repair bad hardware, of course.
>
> current xfs_repair completes for me without error, after spitting out over 450,000 lines of detected corruption issues.
>
> so my suggestions going forward would be:
>
> 1) fix storage
> 2) get newer admin tools for next time
>
> I appreciate the report, but not much to do w/ such an old version (and it seems already fixed in any case).
>
> -Eric
