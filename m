Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Apr 2007 15:11:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3JMBDfB016311
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2007 15:11:17 -0700
Date: Fri, 20 Apr 2007 08:10:59 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20070419221059.GI32602149@melbourne.sgi.com>
References: <20070419141827.GF32602149@melbourne.sgi.com> <735C1873E656C24699818814048F8FB0054C43B8@icex1.ic.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <735C1873E656C24699818814048F8FB0054C43B8@icex1.ic.ac.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Burbidge, Simon A" <s.burbidge@imperial.ac.uk>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Thu, Apr 19, 2007 at 03:36:58PM +0100, Burbidge, Simon A wrote:
> Hi Dave,
> Thanks for the response.
> No I/O errors reported in the message log or on the RAID box.

OK.

> It's an Infortrend SATA RAID5 array, with a fibre channel connection to
> the server.
> The filesystem is build on an LVM volume.
> Kernel is  2.6.13-15-smp running on an x86_64 dual CPU Xeon server with
> hyper-threading enabled.

That's a relatively old kernel. It's possible that what you are seeing
has been fixed since that kernel was released.

> The most significant feature of the load is that it is part of an HPC
> cluster, and has a large number of  nodes NFS mounting the filesystem
> across Gigabit ethernet.

Not uncommon - we do that all the time ;)

> I did notice that in the first incident, a user had a directory with
> 700000 files in it, and xfs_repair found fault with that directory. The
> user has revised their workflow since and removed the files.
> Very difficult to spot common traits in the workload between the 2
> incidents.

Ok, so that makes it kind of hard to start tracking this down. If it
keeps occurring and you can't isolate the workload that is causing
the problem, you might want to upgrade to a more recent kernel and
see if that helps.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
