Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Apr 2007 07:37:06 -0700 (PDT)
Received: from mr4.cc.ic.ac.uk (mr4.cc.ic.ac.uk [155.198.5.114])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3JEb1fB012213
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2007 07:37:03 -0700
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: XFS internal error XFS_WANT_CORRUPTED_GOTO
Date: Thu, 19 Apr 2007 15:36:58 +0100
Message-ID: <735C1873E656C24699818814048F8FB0054C43B8@icex1.ic.ac.uk>
In-Reply-To: <20070419141827.GF32602149@melbourne.sgi.com>
From: "Burbidge, Simon A" <s.burbidge@imperial.ac.uk>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

Hi Dave,
Thanks for the response.
No I/O errors reported in the message log or on the RAID box.

It's an Infortrend SATA RAID5 array, with a fibre channel connection to
the server.
The filesystem is build on an LVM volume.
Kernel is  2.6.13-15-smp running on an x86_64 dual CPU Xeon server with
hyper-threading enabled.
The most significant feature of the load is that it is part of an HPC
cluster, and has a large number of  nodes NFS mounting the filesystem
across Gigabit ethernet.

I did notice that in the first incident, a user had a directory with
700000 files in it, and xfs_repair found fault with that directory. The
user has revised their workflow since and removed the files.
Very difficult to spot common traits in the workload between the 2
incidents.

Cheers,
Simon


> -----Original Message-----
> From: David Chinner [mailto:dgc@sgi.com] 
> Sent: 19 April 2007 15:18
> To: Burbidge, Simon A
> Cc: xfs@oss.sgi.com
> Subject: Re: XFS internal error XFS_WANT_CORRUPTED_GOTO
> 
> On Thu, Apr 19, 2007 at 02:28:24PM +0100, Burbidge, Simon A wrote:
> > 
> > Hi,
> > 
> > We've had a couple of occurrnces of xfs shutdowns on one of our
> > fileservers.
> > The latest had the message:
> > 
> > Apr 19 10:35:00 fs3 kernel: XFS internal error 
> XFS_WANT_CORRUPTED_GOTO
> > at line 1745 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffff8819bc7c
> > Apr 19 10:35:00 fs3 kernel:
> > Apr 19 10:35:00 fs3 kernel: Call
> > Trace:<ffffffff8819a399>{:xfs:xfs_free_ag_extent+1449}
> > <ffffffff8819bc7c>{:xfs:xfs_free_extent+188}
> 
> So you've got a corrupted freespace btree. What is the filesystem
> hosted on - a normal block device, iscsi, nbd? What kernel?
> 
> Are there any I/O errors in the log?
> 
> What we you running at the time of the shutdowns? Anything
> common between the occurrences?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
> 
