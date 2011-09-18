Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IN2shp209832 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 18:02:54 -0500
Date: Mon, 19 Sep 2011 09:02:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs deadlock in stable kernel 3.0.4
Message-ID: <20110918230245.GF15688@dastard>
References: <1D2B34A7-7BB9-4E4E-9CA2-382C210E125F@profihost.ag>
	<20110912152133.GA8345@infradead.org>
	<C6515E45-5724-43DD-95A8-1F89AFE29601@profihost.ag>
	<20110912200543.GA22409@infradead.org>
	<4E6EF274.7050007@profihost.ag>
	<20110913205018.GA8543@infradead.org> <4E70571A.80108@profihost.ag>
	<4E705C42.6020909@profihost.ag>
	<20110914143005.GA28496@infradead.org>
	<4E75B660.1030502@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E75B660.1030502@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, aelder@sgi.com

On Sun, Sep 18, 2011 at 11:14:08AM +0200, Stefan Priebe - Profihost AG wrote:
> Hi,
> 
> at least i'm now able to reproduce the issue. I hope this will help
> to investigate the issue and hopefully you can reproduce it as well.
> 
> I'm using vanilla 3.0.4 kernel + xfs as root filesystem and had
> detect hanging taks with 120s set. You'll then see that the bonnie++
> command get's stuck in xlog_grant_log_space while creating or
> deleting files. I was using a SSD or a fast Raid 10 (24x SAS Disks)
> - i was not able to reproduce it on normal SATA disks even a 20x
> SATA Raid 10 didn't work.
> 
> I used bonnie++ (V 1.96) to reproduce it. Mostly in the 1st run the
> bug is triggered - sometimes I needed two runs.
> 
> bonnie++ -u root -s 0 -n 1024:32768:0:1024:4096 -d /
> 
> I hope that helps - as i now have a testing machine and can trigger
> the bug pretty fast (10-30min instead of hours). I can also add
> debug code if you want or have one.

If it is a log space accounting issue, then the output of 'xfs_info
<mtpt>' is really necessary to set the filesystem up the same way
(e.g. same log size, number of AGs, etc) so that it behaves the same
way on different test machines....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
