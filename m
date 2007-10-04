Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Oct 2007 13:06:35 -0700 (PDT)
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.170])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l94K6U8k031571
	for <linux-xfs@oss.sgi.com>; Thu, 4 Oct 2007 13:06:32 -0700
Received: by ug-out-1314.google.com with SMTP id m3so470515ugc
        for <linux-xfs@oss.sgi.com>; Thu, 04 Oct 2007 13:06:30 -0700 (PDT)
From: Alessandro Bono <alessandro.bono@gmail.com>
Subject: Re: 2.6.23-rc9-git1 hang with XFS
Date: Thu, 4 Oct 2007 21:38:36 +0200
References: <fe1032$3mi$1@sea.gmane.org> <20071004003935.GC23367404@sgi.com>
In-Reply-To: <20071004003935.GC23367404@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710042138.36920.alessandro.bono@gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-xfs@oss.sgi.com

On Thursday 04 October 2007, David Chinner wrote:
> On Wed, Oct 03, 2007 at 11:03:29PM +0200, Alessandro Bono wrote:
> > Hi all
> >
> > I'm testing 2.6.23-rc9-git1 on my old home server
> > Trying to reorganizer my xfs filesystem with xfs_fsr cause a sort of
> > system hang
>
> xfs_fsr is waiting for a direct I/O to complete.
> Other processes are waiting for the superblock I/O to compete
> (which is why writes are hanging), an dothers are waiting
> for iclog space to be freed up. I think something is holding
>
> off I/O completion, and this:
> > possible SYN flooding on port 4664. Sending cookies.
> > possible SYN flooding on port 4664. Sending cookies.
> > possible SYN flooding on port 4664. Sending cookies.
> > possible SYN flooding on port 4664. Sending cookies.
> > possible SYN flooding on port 4664. Sending cookies.
>
> indicates someone trying a DOS on your box. Perhaps it's
> succeeding by denying interrupt service to you disks?
>
> If you pull the network cable, does the system start to respond
> properly again?

There is no difference with and without  network cable plugged in
Other partitions on the same lvm2 volume with ext3 works without any problem
so disks and sw raid seems to work 

how can I debug this problem? If needed I can recompile kernel to collect 
other info

>
> Cheers,
>
> Dave.



-- 
Cordiali saluti

Alessandro Bono
