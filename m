Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Aug 2006 14:02:29 -0700 (PDT)
Received: from orca.ele.uri.edu (orca.ele.uri.edu [131.128.51.63])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7OL2MDW016781
	for <linux-xfs@oss.sgi.com>; Thu, 24 Aug 2006 14:02:22 -0700
Subject: Re: how to understand allocsp
From: Ming Zhang <mingz@ele.uri.edu>
Reply-To: mingz@ele.uri.edu
In-Reply-To: <44EE11B0.7010208@sandeen.net>
References: <1156450310.2700.85.camel@localhost.localdomain>
	 <44EE11B0.7010208@sandeen.net>
Content-Type: text/plain
Date: Thu, 24 Aug 2006 17:01:49 -0400
Message-Id: <1156453309.2700.94.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@oss.sgi.com

see the code for this XFS_IOC_ALLOCSP

                if (startoffset > fsize) {
                        error = xfs_alloc_file_space(ip, fsize,
                                        startoffset - fsize, 0,
attr_flags);
                        if (error)
                                break;
                }

                va.va_mask = XFS_AT_SIZE;
                va.va_size = startoffset;

                error = xfs_setattr(bdp, &va, attr_flags, credp);

                if (error)
                        return error;

                clrprealloc = 1;
                break;


so if offset is larger than current file size, it will allocate the
space and fill with zero. this is exactly what i met with "allocsp
1048576 0".

i would say this this pretty misleading. since "allocsp 0 1048576" can
be easily thought as "allocate 1048576 space start from 0" but now seems
only an ATTR is set.


Ming



On Thu, 2006-08-24 at 15:53 -0500, Eric Sandeen wrote:
> Ming Zhang wrote:
> > Hi All
> > 
> > Play with xfs_io and feel confused about this allocsp.
> > 
> > Starting with a empty file.
> > 
> 
> I honestly never keep this all straight without going back to the code, 
> but I'd start by looking at the comments for, and code in, 
> xfs_change_file_space and xfs_alloc_file_space.
> 
>          /*
>           * XFS_IOC_RESVSP and XFS_IOC_UNRESVSP will reserve or unreserve
>           * file space.
>           * These calls do NOT zero the data space allocated to the file,
>           * nor do they change the file size.
>           *
>           * XFS_IOC_ALLOCSP and XFS_IOC_FREESP will allocate and free file
>           * space.
>           * These calls cause the new file data to be zeroed and the file
>           * size to be changed.
>           */
> 
> The semantics of all this could be clearer, IMHO.
> 
> -Eric
