Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A480D7F3F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 02:03:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 92EB48F8070
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 00:03:38 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id FFGgjLoBJwO3uBd1 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Oct 2013 00:03:34 -0700 (PDT)
Date: Wed, 16 Oct 2013 00:03:33 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] xfs: fold xfs_change_file_space into xfs_ioc_space
Message-ID: <20131016070333.GA18721@infradead.org>
References: <20131012075503.370510641@bombadil.infradead.org>
	<20131012075640.637625757@bombadil.infradead.org>
	<20131014050807.GJ4446@dastard>
	<20131015153143.GA1612@infradead.org>
	<20131015214733.GW4446@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131015214733.GW4446@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Oct 16, 2013 at 08:47:33AM +1100, Dave Chinner wrote:
> I'll put a significant quantity of beer on the table if anyone other
> than xfstests is actually using these ioctls. In all my years of
> working with XFS, I've never seen a single user of them, even on
> Irix.
> 
> The one person I know who was considering using XFS_IOC_ALLOCSP
> convinced me (quite easily) to implement XFS_IOC_ZERO_RANGE for them
> because writing all those zeros to re-initialise pre-allocated VM
> images was going to be prohibitively expensive...
> 
> Anyway, it was just a thought.

Send a patch to warn on their usage, and you might be the lucky owner of
a beer or two a few years down the road :)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
