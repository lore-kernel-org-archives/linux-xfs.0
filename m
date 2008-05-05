Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 May 2008 16:17:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m45NHIgq005930
	for <xfs@oss.sgi.com>; Mon, 5 May 2008 16:17:20 -0700
Date: Tue, 6 May 2008 09:17:54 +1000
From: David Chinner <dgc@sgi.com>
Subject: XFS shutdown in xfs_iunlink_remove() (was Re: 2.6.25: swapper: page allocation failure. order:3, mode:0x4020)
Message-ID: <20080505231754.GL155679365@sgi.com>
References: <BAY103-DAV7CF38DF784B82EC3F2CFAB2D70@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY103-DAV7CF38DF784B82EC3F2CFAB2D70@phx.gbl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Marco Berizzi <pupilla@hotmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

[Please cc the XFS list (xfs@oss.sgi.com) on bug reports or put "XFS" in the
subject line so ppl know to pay attention to your report.]

On Mon, May 05, 2008 at 03:41:29PM +0200, Marco Berizzi wrote:
> Hi.
> Just few minutes ago an xfs filesystem
> was shutdown with these errors:
> 
> May  5 14:31:38 Pleiadi kernel: xfs_inotobp: xfs_imap()  returned an
> error 22 on hda8.  Returning error.
> May  5 14:31:38 Pleiadi kernel: xfs_iunlink_remove: xfs_inotobp()
> returned an error 22 on hda8.  Returning error.
> May  5 14:31:38 Pleiadi kernel: xfs_inactive:^Ixfs_ifree() returned an
> error = 22 on hda8
> May  5 14:31:38 Pleiadi kernel: xfs_force_shutdown(hda8,0x1) called from
> line 1737 of file fs/xfs/xfs_vnodeops.c.  Return address = 0xc01e6fde
> May  5 14:31:38 Pleiadi kernel: Filesystem "hda8": I/O Error Detected.
> Shutting down filesystem: hda8
> May  5 14:31:38 Pleiadi kernel: Please umount the filesystem, and
> rectify the problem(s)
> May  5 14:36:43 Pleiadi kernel: xfs_force_shutdown(hda8,0x1) called from
> line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xc01eaf21

Is it reproducable? What were you doing at the time the problem occurred?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
