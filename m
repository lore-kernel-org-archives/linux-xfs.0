Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4VEfIfr049788
	for <linux-xfs@oss.sgi.com>; Tue, 31 May 2011 09:41:18 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 64883490BB0
	for <linux-xfs@oss.sgi.com>; Tue, 31 May 2011 07:41:16 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id sQXix0nTwwMzSPcu for <linux-xfs@oss.sgi.com>;
	Tue, 31 May 2011 07:41:16 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1QRQ8A-0007oM-1t
	for linux-xfs@oss.sgi.com; Tue, 31 May 2011 16:41:14 +0200
Received: from host2.kattenlaw.com ([host2.kattenlaw.com])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 31 May 2011 16:41:14 +0200
Received: from brianmduncan by host2.kattenlaw.com with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 31 May 2011 16:41:14 +0200
From: Brian Duncan <brianmduncan@gmail.com>
Subject: Re: xfssyncd and disk spin down
Date: Tue, 31 May 2011 14:40:57 +0000 (UTC)
Message-ID: <loom.20110531T163459-953@post.gmane.org>
References: <20101223165532.GA23813@peter.simplex.ro>
	<20101227021904.GA24828@dastard>
	<20101227061629.GA2275@pandora.simplex.ro>
	<20101227140750.GB24828@dastard>
	<20101227171939.GA7759@pandora.simplex.ro>
	<20101231001323.GD15179@dastard>
	<20110120100143.GA2007@peter.simplex.ro>
	<20110120234310.GV16267@dastard>
	<20110210204254.GA10451@peter.simplex.ro>
	<20110210221851.GG2559@dastard>
	<loom.20110214T185310-606@post.gmane.org>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

> Dave Chinner <david <at> fromorbit.com> writes:
> > 
> > I know what the problem is, but I haven't had time to work out of
> > code a fix. Been spending my time trying to work out the cause bugs
> > that are triggering hangs, crashes or corruptions here...
> > 
> > Cheers,
> > 
> > Dave.
> 
> 


Can anyone please comment if this bug was ever fixed?

I have searched and see no further talk about this.

echo 720000 > /proc/sys/fs/xfs/xfssyncd_centisecs allows a drive to sleep more
often, but still is impacted by this. 

Thanks!


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
