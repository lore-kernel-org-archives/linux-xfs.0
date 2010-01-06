Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o06923FM050775 for <xfs@oss.sgi.com>; Wed, 6 Jan 2010 03:02:04 -0600
Received: from bob.dscon.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D158143F7F
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2010 01:02:54 -0800 (PST)
Received: from bob.dscon.sk (bob.dscon.sk [88.86.113.10]) by cuda.sgi.com with
	ESMTP id LjTLs4chjxghFfP2 for <xfs@oss.sgi.com>;
	Wed, 06 Jan 2010 01:02:54 -0800 (PST)
Date: Wed, 6 Jan 2010 10:02:53 +0100
From: DS <xfs@bob.dscon.sk>
Subject: Re: xfs 2.6.31.9 error - possibly SOLVED
Message-ID: <20100106090253.GA19339@bob.dscon.sk>
References: <20091228151048.GA24031@bob.dscon.sk>
	<20091228232204.GB7613@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091228232204.GB7613@discord.disaster>
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
To: xfs@oss.sgi.com

There was something wrong with the old FS and the kernel 2.6.31.9 (unable to replay log) has not been of much help.
All works fine with kernel 2.6.27.42 and new clear FS  for a few days .

Thanks.

Dusan




On Tue, Dec 29, 2009 at 10:22:04AM +1100, Dave Chinner wrote:
> On Mon, Dec 28, 2009 at 04:10:48PM +0100, DS wrote:
> > Hello,
> > 
> > after upgrade from Debian etch -> Debian lenny with custom kernel
> > 2.6.31.9 (before 2.6.28.1) I see this error and server is
> > resetting sometimes..
> > 
> > Filesystem was creating far far away (about 4years ago).
> > 
> > XFS internal error XFS_WANT_CORRUPTED_RETURN at line 366 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffff81169ae3
> 
> Any errors in the log before this (e.g. IO errors)?
> 
> > Pid: 4022, comm: procmail Not tainted 2.6.31.9 #3
> > Call Trace:
> >  [<ffffffff8118edfe>] xfs_error_report+0x3e/0x40
> >  [<ffffffff811680fa>] xfs_alloc_fixup_trees+0x2ba/0x340
> >  [<ffffffff81167de9>] ? xfs_alloc_get_rec+0x29/0x60
> >  [<ffffffff81169ae3>] xfs_alloc_ag_vextent_near+0x3f3/0x940
> >  [<ffffffff8116a105>] xfs_alloc_ag_vextent+0xd5/0x130
> >  [<ffffffff8116aa68>] xfs_alloc_vextent+0x3a8/0x4f0
> .....
> 
> Looks like a corrupted free space tree - that could have happened a
> long time ago and only now are you tripping over it. I'd run
> xfs_repair on the filesystem to fix up the problem. If it happens
> again then we'll have to look deeper.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
