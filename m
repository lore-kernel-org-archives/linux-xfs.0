Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAMMte2s176754 for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 16:55:40 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B4BD21D2A5E5
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 14:55:39 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	yDWgNka07LdfIWY9 for <xfs@oss.sgi.com>;
	Tue, 22 Nov 2011 14:55:39 -0800 (PST)
Date: Tue, 22 Nov 2011 17:55:37 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: EFSCORRUPTED on mount?
Message-ID: <20111122225537.GA25530@infradead.org>
References: <CAF3hT9B8-ou-4RhfCkfFWTwwB_tb7nWSP-5pgP3G6oTE+1gAvA@mail.gmail.com>
	<CAF3hT9AurrVi7xosauVmhQcsbqJgLsxkNYm6dWDNCpB+GR69=w@mail.gmail.com>
	<20111122014114.GJ2386@dastard>
	<CAF3hT9Cu+56WJqzHVu+fMgquddwoMsfW-WC8CvRRBtC4PA3uHw@mail.gmail.com>
	<4ECBEF83.5020607@sandeen.net>
	<CAF3hT9CA23aDfYTF__mVEM7jRq=ZEgqhfX49hK9kcBqM_+h0CQ@mail.gmail.com>
	<4ECC19C3.5070905@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4ECC19C3.5070905@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Gregory Farnum <gregory.farnum@dreamhost.com>, xfs@oss.sgi.com

On Tue, Nov 22, 2011 at 03:53:07PM -0600, Eric Sandeen wrote:
> > Ending recovery (logdev: internal)
> > ...
> 
> All that recovery a result of the icky shutdown procedure I guess....
> 
> > Nov 17 16:01:01 cephstore6358 kernel: [  214.214688] XFS: Internal
> > error XFS_WANT_CORRUPTED_GOTO at line 1664 of file fs/xfs/xfs_alloc.c.
> >  Caller 0xffffffff811d6b71
> 
> And this was the first indication of trouble.

allocation btree corruption - we try to free a block, which had already
been inserted into the by-size allocation btree.  This very much looks
like a cache failure to me.

> > Nov 17 16:01:01 cephstore6358 kernel: [  214.302172]
> > [<ffffffff810d2b11>] ? sys_truncate+0x171/0x173
> > Nov 17 16:01:01 cephstore6358 kernel: [  214.307846]
> > [<ffffffff8166c07b>] ? system_call_fastpath+0x16/0x1b
> > Nov 17 16:01:01 cephstore6358 kernel: [  214.314031] XFS (sdg1):
> > xfs_do_force_shutdown(0x8) called from line 3864 of file
> > fs/xfs/xfs_bmap.c.  Return address = 0xffffffff811e2046
> 
> by here it had shut down, and you were just riding along when
> it went kablooey.  Any non-xfs error just before this point?

And this was the caller of xfs_free_extent, now shuting the fs down
because of the above error.

> > Nov 17 16:01:01 cephstore6358 kernel: [  214.340451] XFS (sdg1):
> > Corruption of in-memory data detected.  Shutting down filesystem
> > Nov 17 16:01:01 cephstore6358 kernel: [  214.348518] XFS (sdg1):
> > Please umount the filesystem and rectify the problem(s)
> > Nov 17 16:01:01 cephstore6358 kernel: [  227.789285] XFS (sdg1):
> > xfs_log_force: error 5 returned.
> > Nov 17 16:01:01 cephstore6358 kernel: [  229.820255] XFS (sdg1):
> > xfs_log_force: error 5 returned.
> 
> To be honest I'm not sure offhand if this error 5 (EIO) is a
> result of the shutdown, or the cause of it.

It is.  One the filesystem has been shut down xfs_log_force will
always return EIO.  The printk for is rather useless, though.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
