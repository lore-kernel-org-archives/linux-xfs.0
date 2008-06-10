Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 09 Jun 2008 20:50:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5A3oSBe018960
	for <xfs@oss.sgi.com>; Mon, 9 Jun 2008 20:50:30 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 70B1D20A6EC
	for <xfs@oss.sgi.com>; Mon,  9 Jun 2008 20:51:23 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id 8SjssLJ1o3WLvZ1w for <xfs@oss.sgi.com>; Mon, 09 Jun 2008 20:51:23 -0700 (PDT)
Date: Tue, 10 Jun 2008 13:51:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS and block-level snapshots
Message-ID: <20080610035119.GY10720@disturbed>
References: <FCF761C7-435E-4AA5-9055-9DA0033B7ACC@zymeworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FCF761C7-435E-4AA5-9055-9DA0033B7ACC@zymeworks.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Kamil Kisiel <kamil@zymeworks.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 06, 2008 at 11:33:17AM -0700, Kamil Kisiel wrote:
> Hello,
>
> I had a question about XFS integrity and performing block-level  
> snapshots.
>
> We currently have a 2TB (but growing soon..) volume mounted by a Linux  
> host with kernel 2.6.23 over iSCSI from our SAN. Our SAN unit has the  
> capability to perform block-level snapshots, which is done at regular  
> intervals.
>
> I know that it is recommended to perform an xfs_freeze before performing 
> a snapshot. However, the control of the snapshots is independent from the 
> OS, which currently has no knowledge of their occurrence. I'm curious as 
> to the repercussions of this. I understand that in all likelyhood, the 
> integrity of files which are currently being written will not be 
> preserved. However, even with an xfs_freeze this is not guaranteed, as an 
> application may require additional disk transactions to maintain the file 
> in a valid state (it is not necessarily atomic, depending on the 
> application).

That's from an application POV, not a filesystem POV. When you
freeze the filesystem all the data and metadata is guaranteed to be
consistent on disk. If your application requires further guarantees
of atomicity, then it needs to call xfs_freeze at a time that the
application can guarantee that it'sstate in the filesystem is
consistent.  i.e. not a filesystem problem.

> As far as metadata transactions are concerned, the journal should
> make  these atomic, so there should not be any problem there?

Sure, asssuming that at the time the snapshot is taken that the sum
of the journal contents, the filesystem metadata on disk and the
data on disk = a consistent filesystem image. Which, of course, will
never happen when you randomly snapshot a busy filesystem as it's a
constantly moving target.

e.g. say that while the log is being snapshotted by the block device
it wraps (i.e. the head moves from the end to the start) and
metadata I/O completes so the tail moves forward. now you have a
snapshot with the old tail in it and you've lost the transactions at
the head of the log. i.e. the journal is no longer consistent with
what is on disk in the snapshot. This can happen for data vs
metadata, metadata vs metadata and metadata vs log. IOWs, if you
don't freeze before you snapshot, your snapshot if full of nasty
little inconsistencies just waiting to trip you over....

> Basically, I'd like to know what is the worst that could happen, and why 
> an xfs_freeze is necessary in this scenario.

Worst case? Silent data corruption in the snapshot. Metadata
corruption in the snapshot leading to filesystem shutdowns and
system panics. Choose your poison - they're all bad.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
