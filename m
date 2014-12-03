Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8AE4F7F4E
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2014 13:54:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5CB478F8049
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2014 11:54:49 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	1UKJrZLEA9Hdn2NX for <xfs@oss.sgi.com>;
	Wed, 03 Dec 2014 11:54:47 -0800 (PST)
Date: Thu, 4 Dec 2014 06:54:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: lobotomise xfs_trans_read_buf_map()
Message-ID: <20141203195433.GI18131@dastard>
References: <1417473290-17544-1-git-send-email-david@fromorbit.com>
	<20141202165930.GA28571@infradead.org>
	<20141202224518.GG18131@dastard>
	<20141203105122.GA3727@infradead.org> <547F19AE.6050808@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <547F19AE.6050808@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Dec 03, 2014 at 08:09:50AM -0600, Mark Tinguely wrote:
> On 12/03/14 04:51, Christoph Hellwig wrote:
> >On Wed, Dec 03, 2014 at 09:45:18AM +1100, Dave Chinner wrote:
> >>>Can you fix the inconsistent return for the trylock case in a follow on
> >>>patch?  This difference doesn't look intentional to me, and I would
> >>>be surprised if it's correctly handled in the callers.
> >>
> >>Ok, I'll do an audit and make this common in a follow up patch. Just
> >>to confirm:
> >>
> >>		if (!(flags & XBF_TRYLOCK))
> >>			return -ENOMEM;
> >>		return -EAGAIN;
> >>
> >>is what you want to see, right?
> >
> >Yes.
> 
> Even ENOMEM / EAGAIN could be wrong if _xfs_buf_find() was given an
> illegal block number - then it would be EFSCORRUPT.

Well, in theory.  Yes, the comment I wrote in xfs_buf_find() at the
time of adding the first check says we should return EFSCORRUPTED,
but that's only indicative of the fact that we've been handed
something that is bad. The code won't do anything different if it
is handed ENOMEM or EFSCORRUPTED - the same error handling will
occur, and the only difference will be a warning in the log.

> I think we need to push the error message from _xfs_buf_find(). I
> played with it once and seemed to have lost it and can do it again
> if no one else has the time.

The check in _xfs_buf_find() is a loud warning because it
indicates we failed to validate a block number at a higher layer.
IOWs, if you see that warning fire in _xfs_buf_find(), we need to
track down where that bad block number came from and why it wasn't
correctly validated before we tried to actually use it. Those are
the bugs we need to fix; reworking the buffer cache API so that
_xfs_buf_find() can return an error won't fix those bugs, nor change
the error handling behaviour of the callers of xfs_trans*buf[_map].

Hence I don't think we need to change _Xfs_buf_find() or the way it
reports errors at all. Put the work into fixing the block number
validation bugs it exposes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
