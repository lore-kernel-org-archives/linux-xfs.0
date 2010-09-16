Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8GGll8W003794 for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 11:47:50 -0500
Date: Thu, 16 Sep 2010 12:48:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 2.6.35.4: Fixed simple warning (array subscript is above
	array bounds)
Message-ID: <20100916164835.GA19511@infradead.org>
References: <388312.90213.qm@web45811.mail.sp1.yahoo.com>
	<1284655322.2153.22.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1284655322.2153.22.camel@doink>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: Poyo VL <poyo_vl@yahoo.com>, xfs@oss.sgi.com

On Thu, Sep 16, 2010 at 11:42:02AM -0500, Alex Elder wrote:
> Additionally, the alignment of the overall structure
> will be 64 bits because of hte inumber field.  Expanding
> the name field by another byte will not change that.
> 
> So I think this change is OK.  Can anyone else
> back me up?

We do sizeof requests on a few of these structures, not sure if it
includes this one.  I have a patchset to dust off that gets rid of
all the structures that aren't actually physically on disk.  I'll
try to dust if off and submit it - this was a preparation for the
CRC enablement of the directory structures.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
