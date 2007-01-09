Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 09 Jan 2007 02:36:19 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l09AaDqw014683
	for <xfs@oss.sgi.com>; Tue, 9 Jan 2007 02:36:14 -0800
Date: Tue, 9 Jan 2007 10:02:52 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: bd_mount_mutex -> bd_mount_sem (was Re: xfs_file_ioctl / xfs_freeze: BUG: warning at kernel/mutex-debug.c:80/debug_mutex_unlock())
Message-ID: <20070109100252.GA14713@infradead.org>
References: <20070104001420.GA32440@m.safari.iki.fi> <20070107213734.GS44411608@melbourne.sgi.com> <20070108110323.GA3803@m.safari.iki.fi> <45A27416.8030600@sandeen.net> <20070108234728.GC33919298@melbourne.sgi.com> <20070108161917.73a4c2c6.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070108161917.73a4c2c6.akpm@osdl.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@osdl.org>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, linux-kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Jan 08, 2007 at 04:19:17PM -0800, Andrew Morton wrote:
> Seems not.  I think people were hoping that various nasties in there
> would go away.  We return to userspace with a kernel lock held??

Well, there might be nicer solutions, but for now we should revert the
broken commit to change the lock type.
