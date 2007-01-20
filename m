Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 19 Jan 2007 20:35:41 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0K4ZWqw000461
	for <xfs@oss.sgi.com>; Fri, 19 Jan 2007 20:35:34 -0800
Message-ID: <45B19BDD.2050808@sandeen.net>
Date: Fri, 19 Jan 2007 22:34:37 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: EXTENT BOUNDARIES
References: <45B137CA.3020206@ampex.com>
In-Reply-To: <45B137CA.3020206@ampex.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Les Oxley <les@ampex.com>
Cc: xfs@oss.sgi.com

Les Oxley wrote:
> 
> Hello,
> 
> We are looking into running XFS on a 3TB FLASH MEMORY MODULE.  We have a 
> question  regarding the extent boundaries.
> See the attached PowerPoint drawing, xfs.ppt We are running Linux.
> Our  media is 3 million contiguous 4KB blocks. We would like to define 
> an extent size of 1MB and this tracks the erasure block size
> of the flash memory, and that greatly improves perfomance. We are trying 
> to understand where XFS places the extent boundaries with reference to 
> the contiguous block sequence.
> Is this deterministic as indicated in the drawing ? That is, are the 
> extent boundaries on 256 block boundaries.
> 
> Any help would be greatly appreciated.
> 
> Les Oxley
> Ampex Corporation
> Redwood City
> California.

extents by definition land on filesystem block boundaries, and can in 
general be any number of filesystem blocks, starting & ending most 
anywhere on the block device.

If you wish to always allocate in 1m chunks, you might consider using 
the xfs realtime subvolume, see the extsize description in the mkfs.xfs 
man page.  I'm not sure how much buffered IO to the realtime subvol has 
been tested; pretty sure it works at this point, though the sgi guys 
will correct me if I'm wrong... it's not exactly the normal mode of 
operation.

Using the realtime subvol, however, all your file -metadata- will still 
be allocated on the main data volume, in much smaller pieces.

-Eric
