Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 01 Aug 2007 07:10:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l71E9qbm000998
	for <linux-xfs@oss.sgi.com>; Wed, 1 Aug 2007 07:09:57 -0700
Date: Thu, 2 Aug 2007 00:09:44 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Proper method of snapshotting XFS with external log using LVM2
Message-ID: <20070801140944.GA31489@sgi.com>
References: <1185737538.12064.44.camel@server.ak.quickcircuit.co.nz> <20070801121713.GY31489@sgi.com> <1185971009.13401.146.camel@server.ak.quickcircuit.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185971009.13401.146.camel@server.ak.quickcircuit.co.nz>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mario Becroft <mb@gem.win.co.nz>
Cc: David Chinner <dgc@sgi.com>, linux-xfs@oss.sgi.com

On Thu, Aug 02, 2007 at 12:23:29AM +1200, Mario Becroft wrote:
> Hi David,
> 
> Thanks very much for your clear explanation of how to snapshot XFS
> filesystems with external log. It is good to know that I am doing it
> right.
> 
> I found that in the latest Linux kernel version 2.6.22.1, you cannot use
> the method I have been using, and which you confirmed is ok. The problem
> is that if you xfs_freeze the filesystem, then the LVM snapshot command
> hangs forever.

Ah, yes, I wondered if that still happened. The dm snapshot code is
a little naive - it just assumes that it is the only thing that can
freeze a device.

> (Back in kernel version 2.6.16 this did not happen.) I
> guess the snapshot command is also attempting to freeze the filesystem,
> or something, which doesn't work when it is already frozen.

It hangs on a lock that is held across the xfs_freeze -f ;
xfs_freeze -u sequence.

> I suppose
> how to fix this is a question for the linux-lvm mailing list.

IIRC from the last time this came, they'll tell you not to use
xfs_freeze.

As it is, the freeze_bdev() interface that both xfs_freeze and
dm-snapshot use is a complete pile of crud that we need to fix.
One of these days I'll get some time to fix it....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
