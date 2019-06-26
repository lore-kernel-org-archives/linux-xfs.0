Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f46.google.com ([209.85.221.46]:44593 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfFZVEU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 17:04:20 -0400
Received: by mail-wr1-f46.google.com with SMTP id r16so4305510wrl.11
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 14:04:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAFVd4NsBRm_pbySuSc4U=a=G4wiowZ3gFBooLEQZGZJe9V748g@mail.gmail.com>
In-Reply-To: <CAFVd4NsBRm_pbySuSc4U=a=G4wiowZ3gFBooLEQZGZJe9V748g@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 26 Jun 2019 15:04:06 -0600
Message-ID: <CAJCQCtRD2g1c5uyDurLbt7tedPM8g6f1-74ECAW9cA1Do1yNBQ@mail.gmail.com>
Subject: Re: XFS Repair Error
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs list <linux-xfs@vger.kernel.org>
Cc: Rich Otero <rotero@editshare.com>

On Wed, Jun 26, 2019 at 2:32 PM Rich Otero <rotero@editshare.com> wrote:
>
> I have an XFS filesystem of approximately 56 TB on a RAID that has
> been experiencing some disk failures. The disk problems seem to have
> led to filesystem corruption, so I attempted to repair the filesystem

This applies
http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Also, are the disk failures fixed? Is the RAID happy? I'm very
skeptical of writing anything, including repairs, let alone rw
mounting, a file system that's one a busted or questionably working
storage stack. The storage stack needs to be in working order first.
Is it?

> with `xfs_repair -L <device>`. Xfs_repair finished with a message
> stating that an error occurred and to report the bug.

OK why -L ? Was there a previous mount attempt and if so when kernel
errors? Was there a previous repair attempt without -L? -L is a heavy
hammer that shouldn't be needed unless the log is damaged and if the
log is damaged or otherwise can't be replayed, you should get a kernel
message about that.


-- 
Chris Murphy
