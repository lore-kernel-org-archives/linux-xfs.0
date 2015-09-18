Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AB94B7F3F
	for <xfs@oss.sgi.com>; Fri, 18 Sep 2015 18:52:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6F8018F804B
	for <xfs@oss.sgi.com>; Fri, 18 Sep 2015 16:52:01 -0700 (PDT)
Received: from pp-mta2.drexelmed.edu ([198.17.30.173]) by cuda.sgi.com with
	ESMTP id ggCVF2NqotbLZ8Nd (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 18 Sep 2015 16:51:59 -0700 (PDT)
From: "Earl, Joshua P" <Joshua.Earl@DrexelMed.edu>
Subject: RE: xfsxyncd in 'D' state
Date: Fri, 18 Sep 2015 23:51:53 +0000
Message-ID: <2CC86DBF85FEEC41A2DFE1647B40613D6B6217BD@NCB-SV-117.DUCOM.edu>
References: <2CC86DBF85FEEC41A2DFE1647B40613D5DAF2CA0@NCB-SV-117.DUCOM.edu>
	<2CC86DBF85FEEC41A2DFE1647B40613D5DAF2DB8@NCB-SV-117.DUCOM.edu>
	<20150917192102.GA5342@bfoster.bfoster>
	<2CC86DBF85FEEC41A2DFE1647B40613D5DAF2DFC@NCB-SV-117.DUCOM.edu>,
	<20150918020351.GS3902@dastard>
In-Reply-To: <20150918020351.GS3902@dastard>
Content-Language: en-US
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
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

Thanks, sorry for my ignorance! I didn't understand the nomenclature
(first time posting)

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

I appreciate your insight, I honestly had no idea.
It is unintuitive to me when you make a change to a file
that the file has an additional 'metadata' write
which takes a lot longer.

I guess in the future if I make changes to the
owner/group of files there is just going to be some
lag associated with it on a raid 5/6 with many disks


Thanks!

~josh


Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com
________________________________

This email and any accompanying attachments are confidential. The information is intended solely for the use of the individual to whom it is addressed. Any review, disclosure, copying, distribution, or use of this email communication by others is strictly prohibited. If you are not the intended recipient, please notify the sender immediately and delete all copies. Thank you for your cooperation.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
