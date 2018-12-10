Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41874 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbeLJQzh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Dec 2018 11:55:37 -0500
Date: Mon, 10 Dec 2018 08:55:25 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Enlarging w/ xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed:
 Inappropriate ioctl for device
Message-ID: <20181210165525.GU24487@magnolia>
References: <20181210042842.GA16286@draconx.ca>
 <20181210143345.GB8356@bfoster>
 <CADyTPEw_RZCC2yodbJ6W0e9mwJgQW19UXCHhcw1-tF4b0=hMjg@mail.gmail.com>
 <20181210161121.GC8356@bfoster>
 <20181210165020.GT24487@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181210165020.GT24487@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Nick Bowler <nbowler@draconx.ca>, linux-xfs@vger.kernel.org

On Mon, Dec 10, 2018 at 08:50:20AM -0800, Darrick J. Wong wrote:
> On Mon, Dec 10, 2018 at 11:11:22AM -0500, Brian Foster wrote:
> > On Mon, Dec 10, 2018 at 10:39:14AM -0500, Nick Bowler wrote:
> > > Hi Brian,
> > > 
> > > On 12/10/18, Brian Foster <bfoster@redhat.com> wrote:
> > > > The only thing that comes to mind while poking through the code is
> > > > perhaps xfsprogs is sending the traditional XFS_IOC_GROWFSDATA command
> > > > into the compat_ioctl() path somehow or another (assuming
> > > > BROKEN_X86_ALIGNMENT is set).
> > > >
> > > > What arch is your kernel/xfsprogs?
> > > 
> > > This system is running an amd64 kernel with x32 userspace (including
> > > xfsprogs).
> > > 
> > 
> > Ok, so I think that means BROKEN_X86_ALIGNMENT should be set since XFS
> > defines it as:
> > 
> > #if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
> > #define BROKEN_X86_ALIGNMENT
> > ...
> > 
> > > > What does 'cat /sys/kernel/debug/trace/trace' show if you run
> > > > 'trace-cmd start -e xfs:xfs_file*ioctl*' and then attempt the growfs?
> > > 
> > > Looks like I don't have the required tracing enabled in my kernel
> > > configuration, but I can build a new one if needed.  Is CONFIG_FTRACE
> > > sufficient for this?
> > > 
> > 
> > Not sure. I think you need to have CONFIG_TRACING enabled, which may
> > require FTRACE and/or some other options. Hmm, perhaps you'd be covered
> > if you make sure you have CONFIG_DYNAMIC_FTRACE enabled.
> > 
> > From your strace output:
> > 
> > ioctl(3, _IOC(_IOC_WRITE, 0x58, 0x6e, 0x10), 0xffcc9a80) = -1 ENOTTY (Inappropriate ioctl for device)
> > 
> > 0x6e corresponds to the GROWFSDATA[_32] cmd and I think 0x10 is the
> > size, which is 16 bytes as opposed to the 12 bytes expected for
> > GROWFSDATA_32 for struct compat_xfs_growfs_data:
> > 
> > typedef struct compat_xfs_growfs_data {
> >         __u64           newblocks;      /* new data subvol size, fsblocks */
> >         __u32           imaxpct;        /* new inode space percentage limit */
> > } __attribute__((packed)) compat_xfs_growfs_data_t;
> > 
> > On a 64-bit kernel, that packed attribute is the difference between
> > expecting a padded 16 byte struct vs. a 12 byte version presumably from
> > a 32-bit application. So if you are calling into the ->compat_ioctl()
> > path I think the question is why is your xfsprogs sending the 16 byte
> > structure?
> 
> ...because the x32 ABI is weird in that pointers are 4 bytes like on
> x86, but the registers are 64 bits wide like on x64, and (except for
> pointers being 4 bytes wide) the structure alignment rules follow x64.
> 
> Normally xfs structures are explicitly padded to 8-byte boundaries and
> pointers forced into u64 fields to avoid all of this compatibility
> headache, but this wasn't done with struct xfs_growfs_data, so it needs
> a compatibility shim for every ABI supported by Linux.
> 
> As you can tell, we never really bothered to check in XFS.  The creators
> of the x32 ABI even call out XFS ioctl32.c[1] specifically on their list
> of things that needed fixing, but they never got around to it.
> 
> https://sites.google.com/site/x32abi/
> 
> $ cat b.c
> struct moo {
>         unsigned long long a;
>         unsigned int b;
> };
> 
> int bork(struct moo *m)
> {
>         return m->b;
> }
> $ gcc -Wall -g -m64 -c -o b.o b.c	# x86_64
> $ gdb b.o
> Reading symbols from b.o...done.
> (gdb) p sizeof(struct moo)
> $1 = 12

<sigh> paste error, that's supposed to be 16.

--D

> (gdb) quit
> $ gcc -Wall -g -m32 -c -o b.o b.c	# i386
> $ gdb b.o
> Reading symbols from b.o...done.
> (gdb) p sizeof(struct moo)
> $1 = 12
> (gdb) quit
> $ gcc -Wall -g -mx32 -c -o b.o b.c	# x32
> $ gdb b.o
> Reading symbols from b.o...done.
> (gdb) p sizeof(struct moo)
> $1 = 16
> 
> So I guess someone needs to fix the headers to detect x32 and point it
> at the x64 definitions ... or something.  Personally, I thought x32 was
> basically dead at this point, but clearly not. :/
> 
> --D
> 
> > Brian
> > 
> > > Thanks,
> > >   Nick
