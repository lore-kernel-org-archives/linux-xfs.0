Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1FEA87F9B
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 03:11:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1431C304043
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 01:11:09 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id b2zIgiKo4V4PMLb0 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Jul 2014 01:11:08 -0700 (PDT)
Date: Wed, 16 Jul 2014 01:11:05 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] logprint: Fix printing of AGF buffers
Message-ID: <20140716081105.GB29924@infradead.org>
References: <1405349100-19734-1-git-send-email-jack@suse.cz>
	<20140715101931.GC30363@infradead.org>
	<20140715140938.GA1733@quack.suse.cz>
	<20140715153922.GB5369@infradead.org>
	<20140716003851.GO22339@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140716003851.GO22339@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Wed, Jul 16, 2014 at 10:38:51AM +1000, Dave Chinner wrote:
> I added this:
> 
> 	/*
> 	 * The addition of spare space and the non-logged CRC format
> 	 * fields to the AGF mean that the size that is logged is almost
> 	 * always going to be smaller than the structure itself. Hence
> 	 * we need to make sure that the buffer contains all the data we
> 	 * want to print rather than just check against the structure
> 	 * size.
> 	 */
> 
> Cheers,

I'd prefer to mention v4 filesystems as well:

	/*
	 * v4 filesystems only contain the fields before the uuid, and
	 * even v5 filesystems don't usually log any field beneath it.
	 */

note that the AGI case also needs the same treatment.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
