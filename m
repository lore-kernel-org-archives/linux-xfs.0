Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 16:10:52 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2FNAj6p018535
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 16:10:47 -0700
Date: Fri, 16 Mar 2007 10:10:31 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Should xfs_repair take this long?
Message-ID: <20070315231031.GP6095633@melbourne.sgi.com>
References: <45F92D8C.3090708@stsci.edu> <20070315150422.7bc5d178@harpe.intellique.com> <45F952F2.6000008@stsci.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F952F2.6000008@stsci.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Thomas Walker <walker@stsci.edu>
Cc: Emmanuel Florac <eflorac@intellique.com>, xfs@oss.sgi.com

On Thu, Mar 15, 2007 at 10:06:42AM -0400, Thomas Walker wrote:
> 
>     The terminal shows a lot of "." dots running across the screen 
> quickly, and every few hours it says this;
> 
> 
> .....................................................found candidate 
> secondary superblock...
> unable to verify superblock, continuing...
> found candidate secondary superblock...
> unable to verify superblock, continuing...

The primary superblock is not good, and it's trying to find a valid
secondary superblock. Doesn't sound promising so far - reapir can't
start until a valid superblok is found....

Can you dump the first sector of the device the fielsystem is
on:

# dd if=/dev/mapper/vg0-hladata3 bs=512 count=1 iflag=direct 2> /dev/null | od -Ax -x

So we can see if that really holds a primary XFS superblock?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
