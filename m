Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B8BA07D21
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2016 07:54:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8F103304039
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2016 05:54:30 -0700 (PDT)
Received: from mail1.bemta8.messagelabs.com (mail1.bemta8.messagelabs.com
	[216.82.243.197]) by cuda.sgi.com with ESMTP id
	od3NQ4ExYRGAm5ER for <xfs@oss.sgi.com>;
	Wed, 27 Apr 2016 05:54:28 -0700 (PDT)
From: Benjamin Wirth <Benjamin.Wirth@winmagic.com>
Subject: RE: development APIs for used/free blocks information
Date: Wed, 27 Apr 2016 12:54:24 +0000
Message-ID: <97A4F433DEE099488FE21C1718A641D2139E972E@wmsexchsvr01.winmagic.local>
References: <97A4F433DEE099488FE21C1718A641D2139E86F5@wmsexchsvr01.winmagic.local>
	<20160426222129.GD26977@dastard>
In-Reply-To: <20160426222129.GD26977@dastard>
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

Hello Dave,

Thanks for your response.

And I apologize, reading back my email I wasn't clear about what I was looking for.

I want to be able to query which blocks are free or used, not just the counts. In EXT I was able to use ext2fs_test_block_bitmap() for that. XFS has a BTree with the free extents ordered by block number which I was hoping to be able to access from user-space, but couldn't find any APIs for it (or the headers containing the structure definitions) in the xfsprogs-devel package. Am I trying to do something impossible here?

Thanks,
Ben

-----Original Message-----
From: Dave Chinner [mailto:david@fromorbit.com] 
Sent: Tuesday, April 26, 2016 6:21 PM
To: Benjamin Wirth
Cc: xfs@oss.sgi.com
Subject: Re: development APIs for used/free blocks information

On Tue, Apr 26, 2016 at 08:51:10PM +0000, Benjamin Wirth wrote:
> Hello,
> 
> I was looking for development APIs for XFS. The contents of 
> xfsprogs-devel seem to only contain a few IOCTL commands, mostly 
> file/inode based operations.
> 
> I need to query free/used blocks of an entire XFS filesystem and was 
> hoping to find some user-space APIs for this.

$ man 2 statvfs

Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
