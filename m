Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35794 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbeKBWSd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Nov 2018 18:18:33 -0400
Received: by mail-wr1-f68.google.com with SMTP id z16-v6so1959103wrv.2
        for <linux-xfs@vger.kernel.org>; Fri, 02 Nov 2018 06:11:25 -0700 (PDT)
Date: Fri, 2 Nov 2018 14:11:20 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs_io: prevents the usage in FIFO files
Message-ID: <20181102131120.jpflu5jhxxvpoucz@odin.usersys.redhat.com>
References: <20181016094343.21102-1-cmaiolino@redhat.com>
 <fa4344fc-31b1-8381-981c-d9c83daa981f@sandeen.net>
 <20181101163209.GQ4135@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181101163209.GQ4135@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

Hi guys.

On Thu, Nov 01, 2018 at 09:32:09AM -0700, Darrick J. Wong wrote:
> On Thu, Nov 01, 2018 at 10:41:42AM -0500, Eric Sandeen wrote:
> > On 10/16/18 4:43 AM, Carlos Maiolino wrote:
> > 
> > This seems a little too heavy-handed.  Operating on pipes is probably
> > rare, but xfs_io is supposed to be a generic I/O tool.
> 
> Agreed.  Suppose I want to try reflinking a pipe in an xfstest? ;)
> 
> > Today I can do for example:
> > 
> > # mkfifo pipe
> > 
> > # xfs_io -c stat pipe
> > fd.path = "pipe"
> > fd.flags = non-sync,non-direct,read-write
> > stat.ino = 102077957
> > stat.type = fifo
> > stat.size = 0
> > stat.blocks = 0
> > 
> > What xfs_io command was stuck in particular?  These all seem to be handled uh, at least without a hang, if not correctly:
> > 
> > # xfs_io -c "pread 0 4096" pipe
> > pread: Illegal seek
> > # xfs_io -c "pwrite 0 4096" pipe
> > pwrite: Illegal seek
> > # xfs_io -c "bmap" pipe
> > foreign file active, bmap command is for XFS filesystems only
> > 

I just did a quick look at the FIFO code in kernel to better understand what's
going on and what can we do about it.

What happens is if the pipe is opened for Write only or read only, it will block
waiting for the other side of the pipe (if NONBLOCK isn't used). While, if the
file is opened as O_RDWR, the same is not true, as the following snippet taken
from fifo_open():

===============================

	switch (filp->f_mode) {
		case FMODE_READ:
		...
		if (!is_pipe && !pipe->writers) {
			if (wait_for_partner(pipe, &pipe->w_counter))
		...

		case FMODE_WRITE:
...
			if (!is_pipe && !pipe->readers) {
				if (wait_for_partner(pipe, &pipe->r_counter))
...
.
.
	case FMODE_READ | FMODE_WRITE:
	/*
	 *  O_RDWR
	 *  POSIX.1 leaves this case "undefined" when O_NONBLOCK is set.
	 *  This implementation will NEVER block on a O_RDWR open, since
	 *  the process can at least talk to itself.
	 */

		pipe->readers++;
		pipe->writers++;
		pipe->r_counter++;
		pipe->w_counter++;

		if (pipe->readers == 1 || pipe->writers == 1)
			wake_up_partner(pipe);
		break;

================================

So, I was wondering if maybe, we should only deny the usage of pipes when
`xfs_io -r` is used? Or should we keep the granularity of each command having
its own decision if it's allowed over pipes or not.
Or even a new argument allowing the usage of pipes or not (I'm not a fan of new
arguments, but this is still a feasible option).

Cheers


> > (?!)
> > 
> > Oh, this one is interesting ;)
> > 
> > # xfs_io -c "fiemap" pipe
> > pipe:
> > xfs_io: ioctl(FS_IOC_FIEMAP) ["pipe"]: Structure needs cleaning
> > 
> > ...
> > 
> > [149881.306316] XFS (dm-0): Internal error xfs_bmapi_read at line 3817 of file fs/xfs/libxfs/xfs_bmap.c.  Caller xfs_file_iomap_begin+0x16c/0x9f0 [xfs]
> > 
> > 
> > (eek?)
> 
> /me suspects we should change the vfs ioctl_fiemap() to return zero
> records (or EOPNOTSUPP?) for non-file, non-dir fds...
> 
> --D
> 

-- 
Carlos
