Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9224C7F37
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 04:18:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6DA06304053
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 02:18:00 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id BB18IzjE9ykv6lo8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 20 Jun 2013 02:17:57 -0700 (PDT)
Date: Thu, 20 Jun 2013 02:17:53 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/60] xfs: patch queue for 3.11
Message-ID: <20130620091753.GA13353@infradead.org>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<20130619091538.GA359@infradead.org>
	<20130619213417.GI29338@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130619213417.GI29338@dastard>
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

On Thu, Jun 20, 2013 at 07:34:17AM +1000, Dave Chinner wrote:
> I don't see any problem with doing that, though I would like to keep
> some of it separate - the dir2 stuff is complex enough that I would
> like to keep it separate, but stuff like all the log item format
> headers can be aggregated.
> 
> How about we end up with xfs_log_format.h for the log and log item
> formats, xfs_da_format.h for all the dir2/da/attr format definitions,
> and xfs_format.h for everything else?

Sounds reasonable.

> >  - any chance to reorder the inode.c split so that stuff doesn't get
> >    move around multiple times?
> 
> I was waiting for that question - I have been considering doing that
> but I've been putting it off because it is a fair bit of shuffling
> that I'd have to do from scratch. Sounds like another vote for :redo
> it"...

Maybe wait for the discussion about having the trans stuff and the
separate project quotas to go in before this, as it would mean another
big redo..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
