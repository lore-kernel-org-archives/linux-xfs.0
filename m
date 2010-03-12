Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2CBtGJW249386 for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 05:55:17 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 05D281D2F811
	for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 03:56:48 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	sTPYDaE3BRqDmHSW for <xfs@oss.sgi.com>;
	Fri, 12 Mar 2010 03:56:48 -0800 (PST)
Date: Fri, 12 Mar 2010 22:56:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hang during xfs_fsr run
Message-ID: <20100312115645.GD4732@dastard>
References: <4B8FC1B7.3070505@dermichi.com>
	<20100304222611.GK14317@discord.disaster>
	<4B92C71C.5010003@dermichi.com>
	<20100308000601.GF28189@discord.disaster>
	<4B94EADD.2080108@dermichi.com> <4B953D3F.3090002@sandeen.net>
	<4B975C5C.5090806@dermichi.com> <20100311233934.GB4732@dastard>
	<4B9A0D2F.30506@dermichi.com>
	<20100312100019.GA13230@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100312100019.GA13230@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Michael Weissenbacher <mw@dermichi.com>, xfs@oss.sgi.com

On Fri, Mar 12, 2010 at 05:00:19AM -0500, Christoph Hellwig wrote:
> On Fri, Mar 12, 2010 at 10:45:19AM +0100, Michael Weissenbacher wrote:
> > Hi Dave!
> >> Hi Michael - have you got any idea what the files are that are
> >> hitting this? This failure is implying that the inode is still dirty
> >> after syncing all the data. Is something trying to modify it while
> >> XFS is trying to map it?
> > Yes, as far as i can tell it's always a file that some process is  
> > currently modifying. It happens ofter with some file unter /var/log  
> > which syslog is currently modifying. I tried setting the "no-defrag"  
> > flag via xfs_io's chattr on all log files but that didn't seem to help.  
> > It seems that cyrus imapd is triggering this problem far more likely  
> > than any other program. Some examples of files where it usually hangs:
> > /var/spool/imap/x/user/xxxx/cyrus.cache (lsof -> cyrus)
> > /var/imap/db/log.xxxxxxx (lsof -> cyrus)
> > /var/log/xxx.log (lsof -> syslog)
> 
> So what's interesting is that cyrus uses mmapp access to files, which
> might be an indicator that we have problems with excluding fsr on mmaped
> files.

Ah, yeah.

->page_mkwrite executes without the inode iolock held, so we can't
lock it out from creating new delalloc pages by holding the iolock
like the bmap code does.

I don't think we're allowed to take the iolock in ->page_mkwrite, so
effectively that leaves us with the situation where we can't do an
atomic flush and map in the bmap code.

Christoph, I guess that means we need to make the bmap code
handle/ignore delalloc extents rather than assume they never occur
after the flush.  What do you think?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
