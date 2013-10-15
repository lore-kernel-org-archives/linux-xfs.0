Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9E61C7F3F
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 10:31:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6DCBE8F8059
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 08:31:45 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ZHKcVAuq7eluAdC7 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Oct 2013 08:31:44 -0700 (PDT)
Date: Tue, 15 Oct 2013 08:31:43 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] xfs: fold xfs_change_file_space into xfs_ioc_space
Message-ID: <20131015153143.GA1612@infradead.org>
References: <20131012075503.370510641@bombadil.infradead.org>
	<20131012075640.637625757@bombadil.infradead.org>
	<20131014050807.GJ4446@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131014050807.GJ4446@dastard>
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

On Mon, Oct 14, 2013 at 04:08:07PM +1100, Dave Chinner wrote:
> One question, though:
> 
> > +	case XFS_IOC_ALLOCSP:
> > +	case XFS_IOC_ALLOCSP64:
> > +	case XFS_IOC_FREESP:
> > +	case XFS_IOC_FREESP64:
> 
> Should we, at this point, mark these ioctls as deprecated and
> schedule then for removal given that we've recommended against using
> them for the past 10 years and we have fallocate() now?

I don't see any reason to remove them given that it's only about 15
extra lines of code.  But if you care enough to get rid of them we
probably need multiple years of actuall warnings emmited when used
before actually removing them.  I would be very surprised if there
aren't same users that wouldn't argue very vocally against their
removal.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
