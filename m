Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1563 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727304AbeLJQLY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Dec 2018 11:11:24 -0500
Date: Mon, 10 Dec 2018 11:11:22 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Enlarging w/ xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed:
 Inappropriate ioctl for device
Message-ID: <20181210161121.GC8356@bfoster>
References: <20181210042842.GA16286@draconx.ca>
 <20181210143345.GB8356@bfoster>
 <CADyTPEw_RZCC2yodbJ6W0e9mwJgQW19UXCHhcw1-tF4b0=hMjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADyTPEw_RZCC2yodbJ6W0e9mwJgQW19UXCHhcw1-tF4b0=hMjg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nick Bowler <nbowler@draconx.ca>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 10, 2018 at 10:39:14AM -0500, Nick Bowler wrote:
> Hi Brian,
> 
> On 12/10/18, Brian Foster <bfoster@redhat.com> wrote:
> > The only thing that comes to mind while poking through the code is
> > perhaps xfsprogs is sending the traditional XFS_IOC_GROWFSDATA command
> > into the compat_ioctl() path somehow or another (assuming
> > BROKEN_X86_ALIGNMENT is set).
> >
> > What arch is your kernel/xfsprogs?
> 
> This system is running an amd64 kernel with x32 userspace (including
> xfsprogs).
> 

Ok, so I think that means BROKEN_X86_ALIGNMENT should be set since XFS
defines it as:

#if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
#define BROKEN_X86_ALIGNMENT
...

> > What does 'cat /sys/kernel/debug/trace/trace' show if you run
> > 'trace-cmd start -e xfs:xfs_file*ioctl*' and then attempt the growfs?
> 
> Looks like I don't have the required tracing enabled in my kernel
> configuration, but I can build a new one if needed.  Is CONFIG_FTRACE
> sufficient for this?
> 

Not sure. I think you need to have CONFIG_TRACING enabled, which may
require FTRACE and/or some other options. Hmm, perhaps you'd be covered
if you make sure you have CONFIG_DYNAMIC_FTRACE enabled.

>From your strace output:

ioctl(3, _IOC(_IOC_WRITE, 0x58, 0x6e, 0x10), 0xffcc9a80) = -1 ENOTTY (Inappropriate ioctl for device)

0x6e corresponds to the GROWFSDATA[_32] cmd and I think 0x10 is the
size, which is 16 bytes as opposed to the 12 bytes expected for
GROWFSDATA_32 for struct compat_xfs_growfs_data:

typedef struct compat_xfs_growfs_data {
        __u64           newblocks;      /* new data subvol size, fsblocks */
        __u32           imaxpct;        /* new inode space percentage limit */
} __attribute__((packed)) compat_xfs_growfs_data_t;

On a 64-bit kernel, that packed attribute is the difference between
expecting a padded 16 byte struct vs. a 12 byte version presumably from
a 32-bit application. So if you are calling into the ->compat_ioctl()
path I think the question is why is your xfsprogs sending the 16 byte
structure?

Brian

> Thanks,
>   Nick
