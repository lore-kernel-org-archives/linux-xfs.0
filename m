Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2BNc6Vg200262 for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 17:38:06 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B7DB141FC3C
	for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 15:39:37 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	3IMDfzihSv105hfh for <xfs@oss.sgi.com>;
	Thu, 11 Mar 2010 15:39:37 -0800 (PST)
Date: Fri, 12 Mar 2010 10:39:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hang during xfs_fsr run
Message-ID: <20100311233934.GB4732@dastard>
References: <4B8FA2CD.6010904@dermichi.com>
	<20100304131511.GH14317@discord.disaster>
	<20100304134641.GA26871@infradead.org>
	<4B8FC1B7.3070505@dermichi.com>
	<20100304222611.GK14317@discord.disaster>
	<4B92C71C.5010003@dermichi.com>
	<20100308000601.GF28189@discord.disaster>
	<4B94EADD.2080108@dermichi.com> <4B953D3F.3090002@sandeen.net>
	<4B975C5C.5090806@dermichi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B975C5C.5090806@dermichi.com>
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
To: Michael Weissenbacher <mw@dermichi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, Mar 10, 2010 at 09:46:20AM +0100, Michael Weissenbacher wrote:
> >Odds are you'll still oops, just earlier.  Send anything interesting
> >you see in the dmesg if/when it happens...
> >
> Those are the assertion failures i saw during yesterday's run. The
> process xfs_fsr hung on inode 536898141 and i couldn't kill it, even
> with "kill -9". I had to reboot to get everything back to normal.

> Mar  9 22:32:43 email kernel: [57269.991906] Assertion failed: ip->i_delayed_blks == 0, file: fs/xfs/xfs_bmap.c, line: 5657

Hi Michael - have you got any idea what the files are that are
hitting this? This failure is implying that the inode is still dirty
after syncing all the data. Is something trying to modify it while
XFS is trying to map it?

We've seen this occasionally in the past, but we've never been able
to reproduce it with any reliability.  Hence any information you can
extract would certainly help us here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
