Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4CFr14A081964 for <xfs@oss.sgi.com>; Tue, 12 May 2009 10:53:01 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2352B1D292E3
	for <xfs@oss.sgi.com>; Tue, 12 May 2009 08:53:08 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id E9FSCXTjALiE6b0S for
	<xfs@oss.sgi.com>; Tue, 12 May 2009 08:53:08 -0700 (PDT)
Date: Tue, 12 May 2009 11:53:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: mmap vs mtime in 2.6.26 and up
Message-ID: <20090512155301.GA23160@infradead.org>
References: <874ovws94s.fsf@tac.ki.iif.hu> <87ljp2v6vt.fsf@tac.ki.iif.hu>
	<2c0942db0905120837g702b457bm52a412293925021a@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2c0942db0905120837g702b457bm52a412293925021a@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ray Lee <ray-lk@madrabbit.org>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Anton Salikhmetov <salikhmetov@gmail.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Ferenc Wagner <wferi@niif.hu>

On Tue, May 12, 2009 at 08:37:43AM -0700, Ray Lee wrote:
> > I've noticed that the last modification times of our RRD files got
> > stuck after upgrading from 2.6.24 to 2.6.26 (Debian Etch -> Lenny; I
> > also tested with 2.6.30-rc5, they are still stuck). ??It has some
> > literature, most notably kernel bug #2645, but that's closed long ago
> > and the resulting patch http://lkml.org/lkml/2008/1/22/370 is present
> > in my kernels. ??Still, the test program (version 3 from the bug report)
> > gives failures:

The problem is pretty simple.  do_wp_page and __do_fault use
file_update_time to update ctime and mtime.  But this function is only
a helper for simply filesystems that have a binary inode dirty/non dirty
state and keep the m/ctime purely in the Linux inode.  It must not be
called from generic code as more complex filesystems need a notification
through ->setattr to update the timestamps.  This will also affect other
filesystems like ubifs.  I'm not entirely sure why it ever worked
before, we must have picked up those c/mtime updates by accident
somehow.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
