Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Jan 2007 22:00:22 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0960Gqw029476
	for <xfs@oss.sgi.com>; Mon, 8 Jan 2007 22:00:17 -0800
Subject: Re: [**BULK SPAM**]  Re: bd_mount_mutex -> bd_mount_sem (was Re:
	xfs_file_ioctl / xfs_freeze: BUG: warning at
	kernel/mutex-debug.c:80/debug_mutex_unlock())
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20070109044907.GH33919298@melbourne.sgi.com>
References: <20070107213734.GS44411608@melbourne.sgi.com>
	 <20070108110323.GA3803@m.safari.iki.fi> <45A27416.8030600@sandeen.net>
	 <20070108234728.GC33919298@melbourne.sgi.com>
	 <20070108161917.73a4c2c6.akpm@osdl.org> <45A30828.6000508@sandeen.net>
	 <20070108191800.9d83ff5e.akpm@osdl.org> <45A30E1D.4030401@sandeen.net>
	 <20070108195127.67fe86b8.akpm@osdl.org> <1168316223.32113.83.camel@edge>
	 <20070109044907.GH33919298@melbourne.sgi.com>
Content-Type: text/plain
Date: Tue, 09 Jan 2007 17:02:53 +1100
Message-Id: <1168322573.32113.86.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Andrew Morton <akpm@osdl.org>, Eric Sandeen <sandeen@sandeen.net>, linux-kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Tue, 2007-01-09 at 15:49 +1100, David Chinner wrote:
> On Tue, Jan 09, 2007 at 03:17:03PM +1100, Nathan Scott wrote:
> > On Mon, 2007-01-08 at 19:51 -0800, Andrew Morton wrote:
> > > If that's not true, then what _is_ happening in there?
> > 
> > This particular case was a device mapper stack trace, hence the
> > confusion, I think.  Both XFS and DM are making the same generic
> > block layer call here though (freeze_bdev).
> 
> Yup. it's the freeze_bdev/thaw_bdev use of the bd_mount_mutex()
> that's the problem. I fail to see _why_ we need to hold a lock
> across the freeze/thaw - the only reason i can think of is to
> hold out new calls to sget() (via get_sb_bdev()) while the
> filesystem is frozen though I'm not sure why you'd need to
> do that. Can someone explain why we are holding the lock from
> freeze to thaw?

Not me.  If it's really not needed, then...

> > > If that _is_ true then, well, that sucks a bit.
> > 
> > Indeed, its a fairly ordinary interface, but thats too late to go
> > fix now I guess (since its exposed to userspace already). 
> 
> Userspace knows nothing about that lock, so we can change that without
> changing the the userspace API.

...that would be true, AFAICS.

cheers.

-- 
Nathan
