Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Jan 2007 15:48:43 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l08NmZqw026489
	for <xfs@oss.sgi.com>; Mon, 8 Jan 2007 15:48:37 -0800
Date: Tue, 9 Jan 2007 10:47:28 +1100
From: David Chinner <dgc@sgi.com>
Subject: bd_mount_mutex -> bd_mount_sem (was Re: xfs_file_ioctl / xfs_freeze: BUG: warning at kernel/mutex-debug.c:80/debug_mutex_unlock())
Message-ID: <20070108234728.GC33919298@melbourne.sgi.com>
References: <20070104001420.GA32440@m.safari.iki.fi> <20070107213734.GS44411608@melbourne.sgi.com> <20070108110323.GA3803@m.safari.iki.fi> <45A27416.8030600@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45A27416.8030600@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, akpm@osdl.org

On Mon, Jan 08, 2007 at 10:40:54AM -0600, Eric Sandeen wrote:
> Sami Farin wrote:
> > On Mon, Jan 08, 2007 at 08:37:34 +1100, David Chinner wrote:
> > ...
> >>> fstab was there just fine after -u.
> >> Oh, that still hasn't been fixed?
> > 
> > Looked like it =)
> 
> Hm, it was proposed upstream a while ago:
> 
> http://lkml.org/lkml/2006/9/27/137
> 
> I guess it got lost?

Seems like it. Andrew, did this ever get queued for merge?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
