Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 09 Jan 2007 02:36:17 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l09AaAqw014667
	for <xfs@oss.sgi.com>; Tue, 9 Jan 2007 02:36:11 -0800
Date: Tue, 9 Jan 2007 10:04:20 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: bd_mount_mutex -> bd_mount_sem (was Re: xfs_file_ioctl / xfs_freeze: BUG: warning at kernel/mutex-debug.c:80/debug_mutex_unlock())
Message-ID: <20070109100420.GB14713@infradead.org>
References: <20070104001420.GA32440@m.safari.iki.fi> <20070107213734.GS44411608@melbourne.sgi.com> <20070108110323.GA3803@m.safari.iki.fi> <45A27416.8030600@sandeen.net> <20070108234728.GC33919298@melbourne.sgi.com> <20070108161917.73a4c2c6.akpm@osdl.org> <45A30828.6000508@sandeen.net> <20070108191800.9d83ff5e.akpm@osdl.org> <45A30E1D.4030401@sandeen.net> <20070108195127.67fe86b8.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070108195127.67fe86b8.akpm@osdl.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@osdl.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, David Chinner <dgc@sgi.com>, linux-kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Jan 08, 2007 at 07:51:27PM -0800, Andrew Morton wrote:
> I don't even know what code we're talking about here...
> 
> I'm under the impression that XFS will return to userspace with a
> filesystem lock held, under the expectation (ie: requirement) that
> userspace will later come in and release that lock.
> 
> If that's not true, then what _is_ happening in there?
> 
> If that _is_ true then, well, that sucks a bit.

It's not a filesystem lock.  It's a per-blockdevice lock that prevents
multiple people from freezing the filesystem at the same time, aswell
as providing exclusion between a frozen filesystem an mount-related
activity.  It's a traditional text-box example for a semaphore.
