Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Apr 2007 07:18:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3JEIZfB007662
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2007 07:18:38 -0700
Date: Fri, 20 Apr 2007 00:18:27 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20070419141827.GF32602149@melbourne.sgi.com>
References: <735C1873E656C24699818814048F8FB0054C43B4@icex1.ic.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <735C1873E656C24699818814048F8FB0054C43B4@icex1.ic.ac.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Burbidge, Simon A" <s.burbidge@imperial.ac.uk>
Cc: xfs@oss.sgi.com

On Thu, Apr 19, 2007 at 02:28:24PM +0100, Burbidge, Simon A wrote:
> 
> Hi,
> 
> We've had a couple of occurrnces of xfs shutdowns on one of our
> fileservers.
> The latest had the message:
> 
> Apr 19 10:35:00 fs3 kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO
> at line 1745 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffff8819bc7c
> Apr 19 10:35:00 fs3 kernel:
> Apr 19 10:35:00 fs3 kernel: Call
> Trace:<ffffffff8819a399>{:xfs:xfs_free_ag_extent+1449}
> <ffffffff8819bc7c>{:xfs:xfs_free_extent+188}

So you've got a corrupted freespace btree. What is the filesystem
hosted on - a normal block device, iscsi, nbd? What kernel?

Are there any I/O errors in the log?

What we you running at the time of the shutdowns? Anything
common between the occurrences?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
