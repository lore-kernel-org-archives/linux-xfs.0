Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:34287 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752948AbdEMXcQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 13 May 2017 19:32:16 -0400
Received: by mail-oi0-f46.google.com with SMTP id b204so98969547oii.1
        for <linux-xfs@vger.kernel.org>; Sat, 13 May 2017 16:32:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201705132023.CEI64165.FtQJFOMFOHOSVL@I-love.SAKURA.ne.jp>
References: <201705132023.CEI64165.FtQJFOMFOHOSVL@I-love.SAKURA.ne.jp>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 13 May 2017 16:32:15 -0700
Message-ID: <CAPcyv4gc9Ab3TBTs-QULw=DRboe7+PjkrVMP5hvp=2gjYn3M0A@mail.gmail.com>
Subject: Re: [pre-linux-4.12-rc1] undefined reference to `put_dax' `dax_get_by_host'
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-xfs@vger.kernel.org

On Sat, May 13, 2017 at 4:23 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Hello.
>
> I got build failures as of commit 0fcc3ab23d7395f5 ("Merge branch 'libnvdimm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm").
>
> $ make
> fs/built-in.o: In function `xfs_file_iomap_end':
> xfs_iomap.c:(.text+0xe0ef9): undefined reference to `put_dax'
> fs/built-in.o: In function `xfs_file_iomap_begin':
> xfs_iomap.c:(.text+0xe1a7f): undefined reference to `dax_get_by_host'
> make: *** [vmlinux] Error 1
> $ grep DAX .config
> CONFIG_DAX=m
> # CONFIG_DEV_DAX is not set
> # CONFIG_FS_DAX is not set

Yes, sorry about that. I think we need fs_dax_get_by_host() that
always fails in the FS_DAX=n case so the compiler knows to throw away
that code.
