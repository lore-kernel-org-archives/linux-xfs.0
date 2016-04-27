Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 337287D37
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2016 18:41:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9C874AC001
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2016 16:41:14 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	6UsgTnhaVRva4gBo for <xfs@oss.sgi.com>;
	Wed, 27 Apr 2016 16:41:10 -0700 (PDT)
Date: Thu, 28 Apr 2016 09:41:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: development APIs for used/free blocks information
Message-ID: <20160427234108.GK26977@dastard>
References: <97A4F433DEE099488FE21C1718A641D2139E86F5@wmsexchsvr01.winmagic.local>
	<20160426222129.GD26977@dastard>
	<97A4F433DEE099488FE21C1718A641D2139E972E@wmsexchsvr01.winmagic.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <97A4F433DEE099488FE21C1718A641D2139E972E@wmsexchsvr01.winmagic.local>
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
To: Benjamin Wirth <Benjamin.Wirth@winmagic.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Apr 27, 2016 at 12:54:24PM +0000, Benjamin Wirth wrote:
> Hello Dave,
> 
> Thanks for your response.
> 
> And I apologize, reading back my email I wasn't clear about what I
> was looking for.
> 
> I want to be able to query which blocks are free or used, not just
> the counts. In EXT I was able to use ext2fs_test_block_bitmap()
> for that. XFS has a BTree with the free extents ordered by block
> number which I was hoping to be able to access from user-space,
> but couldn't find any APIs for it (or the headers containing the
> structure definitions) in the xfsprogs-devel package. Am I trying
> to do something impossible here?

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
