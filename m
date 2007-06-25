Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Jun 2007 16:28:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5PNSPtL004343
	for <linux-xfs@oss.sgi.com>; Mon, 25 Jun 2007 16:28:27 -0700
Date: Tue, 26 Jun 2007 09:28:17 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Wrong Data Pointer-XFS File system
Message-ID: <20070625232817.GC31489@sgi.com>
References: <11246839.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11246839.post@talk.nabble.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sandy1 <sundeep.saini@rediffmail.com>
Cc: linux-xfs@oss.sgi.com

On Thu, Jun 21, 2007 at 11:23:35PM -0700, Sandy1 wrote:
> 
> Hi,
> I am Using SuSe 10.0 with Xfs file system. I am working on a File system
> based project. During the initial research in On disk layout of File system
> , i found data pointer problem. I was not able to get the data location as
> per pointed by "absolute block no." in "xfs_bmbt_rec" extent pointers.

The xfs_bmbt_rec holds the address in FSB format, not DADDR format.

> When i create any file in 0th (zero`th) AG in that case i am able to reach
> on proper location by using "absolute block no." pointer.
> 
> But when i create any file in 1st or in 2nd AG and so on. I never got the
> file data at the location pointed by "absolute block no.". I always found
> the file data before the the pointed address.

FSB notation is sparse representation.

> I am not getting any value in Superblock that tells me about difference in
> pointer location with actual data.
> 
> This value always becomes multiple of the AG number.
> 
> Please help to get out from this problem.
> 
> Is there any other calculation for finding the data locations.

man xfs_db. Search for "convert".

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
