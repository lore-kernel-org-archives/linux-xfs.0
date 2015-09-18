Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EF0697F4E
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2015 21:08:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B0D258F8049
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2015 19:08:13 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	HCJGEDxVCcGvvuxl for <xfs@oss.sgi.com>;
	Thu, 17 Sep 2015 19:08:07 -0700 (PDT)
Date: Fri, 18 Sep 2015 12:03:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsxyncd in 'D' state
Message-ID: <20150918020351.GS3902@dastard>
References: <2CC86DBF85FEEC41A2DFE1647B40613D5DAF2CA0@NCB-SV-117.DUCOM.edu>
	<2CC86DBF85FEEC41A2DFE1647B40613D5DAF2DB8@NCB-SV-117.DUCOM.edu>
	<20150917192102.GA5342@bfoster.bfoster>
	<2CC86DBF85FEEC41A2DFE1647B40613D5DAF2DFC@NCB-SV-117.DUCOM.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2CC86DBF85FEEC41A2DFE1647B40613D5DAF2DFC@NCB-SV-117.DUCOM.edu>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Earl, Joshua P" <Joshua.Earl@DrexelMed.edu>
Cc: Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Sep 17, 2015 at 09:37:09PM +0000, Earl, Joshua P wrote:
> Hi Brian,
> 
> Sorry about the top posting thing... I'm not sure how to control
> that, is my replying somehow messing with that?

when everthing is backwards
to read the thread
it makes it hard

And please wrap your text at 72 columns.

> With good news, I seem to have figured out what was going on.  I
> had a cron job which would run every 15 minutes which changed the
> permissions in a directory: 
> chmod -R g+rwx /data/shared/homes/bjanto/*
> chmod -R g+rwx /data/shared/homes/lanastor/*
> chgrp -hR ilmn /data/nextseq/*
> chgrp -hR lab /data/shared/homes/*

So you are modifying a large amount of metadata every 15 minutes,
and then you have a problem with your 22-disk wide RAID6 array when
the metadata gets written back. metadata writeback is, by the nature
of metadata in a filesystem, done in small, isolated IOs that cause
large RAID5/6 arrays to do an stripe-wide RMW cycle on every IO.

> > Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> > sda               0.29     3.61    5.78    3.58     0.10     0.03    28.27     0.05    5.19   2.39   2.24
> > sdb               1.02     8.66   31.50    3.91     0.33     0.12    26.14     5.94  167.54  27.47  97.25
> > 
> > Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> > sda               0.00     1.60    0.00    2.00     0.00     0.01    14.40     0.01    4.30   4.30   0.86
> > sdb               0.00     0.00    0.00    0.80     0.00     0.03    64.00     6.46 6332.75 1250.00 100.00

That's pretty clear that your hardware raid array is taking over a
second per IO that requires a RMW cycle. So not a filesystem
problem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
