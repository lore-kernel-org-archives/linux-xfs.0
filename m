Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o04NqMbF157379 for <xfs@oss.sgi.com>; Mon, 4 Jan 2010 17:52:22 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 73F081C2A854
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2010 15:53:12 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	xhPUCbdmH4pg2gf0 for <xfs@oss.sgi.com>;
	Mon, 04 Jan 2010 15:53:12 -0800 (PST)
Date: Tue, 5 Jan 2010 10:53:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] XFS: Sort delayed write buffers before dispatch
Message-ID: <20100104235309.GO13802@discord.disaster>
References: <1262401416-19546-1-git-send-email-david@fromorbit.com>
	<1262401416-19546-4-git-send-email-david@fromorbit.com>
	<20100104154331.GA7924@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100104154331.GA7924@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Jan 04, 2010 at 10:43:31AM -0500, Christoph Hellwig wrote:
> On Sat, Jan 02, 2010 at 02:03:36PM +1100, Dave Chinner wrote:
> > Ideally this should use a list sort rather than requiring an
> > external buffer to sort the buffers in, but for simplicity
> > just do it via sort function. Followup patches are needed to
> > take the list sort functions from the DRM and UBIFS code and
> > make it a common function and to utilise it. That will allow
> > sorting the entire delwri queue to be written in one go.
> 
> 
> Maybe getting the common list sort in ASAP might be a good idea.  That
> way we could have it ready by the time this patchset is merged.  If not
> adding a new list sort to XFS temporarily might be a better idea than
> artifically flattening the list.

I'm about to post that and an updated patch series to use it. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
