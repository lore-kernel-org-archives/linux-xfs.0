Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 03 Oct 2007 17:39:52 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l940diOS014885
	for <linux-xfs@oss.sgi.com>; Wed, 3 Oct 2007 17:39:46 -0700
Date: Thu, 4 Oct 2007 10:39:35 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: 2.6.23-rc9-git1 hang with XFS
Message-ID: <20071004003935.GC23367404@sgi.com>
References: <fe1032$3mi$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe1032$3mi$1@sea.gmane.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alessandro Bono <alessandro.bono@gmail.com>
Cc: linux-xfs@oss.sgi.com

On Wed, Oct 03, 2007 at 11:03:29PM +0200, Alessandro Bono wrote:
> Hi all
> 
> I'm testing 2.6.23-rc9-git1 on my old home server
> Trying to reorganizer my xfs filesystem with xfs_fsr cause a sort of system
> hang

xfs_fsr is waiting for a direct I/O to complete.
Other processes are waiting for the superblock I/O to compete
(which is why writes are hanging), an dothers are waiting
for iclog space to be freed up. I think something is holding
off I/O completion, and this:

> possible SYN flooding on port 4664. Sending cookies.
> possible SYN flooding on port 4664. Sending cookies.
> possible SYN flooding on port 4664. Sending cookies.
> possible SYN flooding on port 4664. Sending cookies.
> possible SYN flooding on port 4664. Sending cookies.

indicates someone trying a DOS on your box. Perhaps it's
succeeding by denying interrupt service to you disks?

If you pull the network cable, does the system start to respond
properly again?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
