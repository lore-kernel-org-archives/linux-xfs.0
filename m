Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6RKk50p208557 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 15:46:06 -0500
Subject: Re: [RFC, PATCH 0/2] xfs: Fast zeroing of allocated space
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1280210129-10925-1-git-send-email-david@fromorbit.com>
References: <1280210129-10925-1-git-send-email-david@fromorbit.com>
Date: Tue, 27 Jul 2010 15:49:07 -0500
Message-ID: <1280263747.2002.200.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, 2010-07-27 at 15:55 +1000, Dave Chinner wrote:
> These two patches allow conversion of a written range of a file into
> back into unwritten state. The first patch converts page cache
> helper functions to use the correct range primitives as we need to
> be able to toss (invalidate) pages only within the range specified,
> not to to the end of the file as it currently uses.
> 
> The actual conversion also preallocates any holes in the range, so
> it turns the entire range requested into allocated, unwritten
> extents.
> 
> I also have a patch that adds this functionality to fallocate(). I
> haven't tested that at all, but if this is something we want to
> support, I'd suggest that we want fallocate to be able to do it...

Nice feature.  Kind of surprising to me how small the set
of changes it requires is.

I agree with Christoph's comments.  These two patches otherwise
look good to me as well.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
