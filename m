Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2B8CA7CA2
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 14:57:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F1B4E30404E
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 12:57:41 -0700 (PDT)
Received: from mail1.bemta8.messagelabs.com (mail1.bemta8.messagelabs.com
	[216.82.243.206]) by cuda.sgi.com with ESMTP id
	EwGoRCJWqeKL4HY2 for <xfs@oss.sgi.com>;
	Thu, 16 Jun 2016 12:57:39 -0700 (PDT)
From: Benjamin Wirth <Benjamin.Wirth@winmagic.com>
Subject: RE: development APIs for used/free blocks information
Date: Thu, 16 Jun 2016 19:57:36 +0000
Message-ID: <97A4F433DEE099488FE21C1718A641D213A030CE@wmsexchsvr02.winmagic.local>
References: <97A4F433DEE099488FE21C1718A641D2139E86F5@wmsexchsvr01.winmagic.local>
	<20160426222129.GD26977@dastard>
	<97A4F433DEE099488FE21C1718A641D2139E972E@wmsexchsvr01.winmagic.local>
	<20160427234108.GK26977@dastard>
In-Reply-To: <20160427234108.GK26977@dastard>
Content-Language: en-US
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi David,

I proceeded to parse the on-disk free blocks BTree for finding the free blocks information. Is there a way I could force a flush of BTree information to disk, so that in an online filesystem that is being changed I can also handle the changes in the BTree?

I was looking at XFS_FSOP_GOING_FLAGS_LOGFLUSH flag but it might do more then I need to do and actually shutdown the filesystem. Any other options? I don't mind about performance degradation so interested in any option.

Thanks,
Ben

-----Original Message-----
From: Dave Chinner [mailto:david@fromorbit.com] 
Sent: Wednesday, April 27, 2016 7:41 PM
To: Benjamin Wirth
Cc: xfs@oss.sgi.com
Subject: Re: development APIs for used/free blocks information

On Wed, Apr 27, 2016 at 12:54:24PM +0000, Benjamin Wirth wrote:
> Hello Dave,
> 
> Thanks for your response.
> 
> And I apologize, reading back my email I wasn't clear about what I was 
> looking for.
> 
> I want to be able to query which blocks are free or used, not just the 
> counts. In EXT I was able to use ext2fs_test_block_bitmap() for that. 
> XFS has a BTree with the free extents ordered by block number which I 
> was hoping to be able to access from user-space, but couldn't find any 
> APIs for it (or the headers containing the structure definitions) in 
> the xfsprogs-devel package. Am I trying to do something impossible 
> here?

There are prototypes that need a bit of polishing to complete:

http://oss.sgi.com/archives/xfs/2016-04/msg00633.html

Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
