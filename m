Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f177.google.com ([209.85.208.177]:41313 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727313AbeLJPjS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Dec 2018 10:39:18 -0500
Received: by mail-lj1-f177.google.com with SMTP id k15-v6so10026185ljc.8
        for <linux-xfs@vger.kernel.org>; Mon, 10 Dec 2018 07:39:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20181210143345.GB8356@bfoster>
References: <20181210042842.GA16286@draconx.ca> <20181210143345.GB8356@bfoster>
From: Nick Bowler <nbowler@draconx.ca>
Date: Mon, 10 Dec 2018 10:39:14 -0500
Message-ID: <CADyTPEw_RZCC2yodbJ6W0e9mwJgQW19UXCHhcw1-tF4b0=hMjg@mail.gmail.com>
Subject: Re: Enlarging w/ xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed:
 Inappropriate ioctl for device
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

Hi Brian,

On 12/10/18, Brian Foster <bfoster@redhat.com> wrote:
> The only thing that comes to mind while poking through the code is
> perhaps xfsprogs is sending the traditional XFS_IOC_GROWFSDATA command
> into the compat_ioctl() path somehow or another (assuming
> BROKEN_X86_ALIGNMENT is set).
>
> What arch is your kernel/xfsprogs?

This system is running an amd64 kernel with x32 userspace (including
xfsprogs).

> What does 'cat /sys/kernel/debug/trace/trace' show if you run
> 'trace-cmd start -e xfs:xfs_file*ioctl*' and then attempt the growfs?

Looks like I don't have the required tracing enabled in my kernel
configuration, but I can build a new one if needed.  Is CONFIG_FTRACE
sufficient for this?

Thanks,
  Nick
