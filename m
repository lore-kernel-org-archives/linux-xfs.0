Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8BB277F3F
	for <xfs@oss.sgi.com>; Mon, 16 Dec 2013 09:19:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 79C708F8052
	for <xfs@oss.sgi.com>; Mon, 16 Dec 2013 07:19:05 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 29h5syess4GexYWK (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Dec 2013 07:19:01 -0800 (PST)
Date: Mon, 16 Dec 2013 07:19:00 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xattr atomicy
Message-ID: <20131216151900.GA12360@infradead.org>
References: <20131213115644.GA28551@infradead.org>
	<20131213215117.GV10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131213215117.GV10988@dastard>
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

On Sat, Dec 14, 2013 at 08:51:17AM +1100, Dave Chinner wrote:
> Yes, but they are still atomic from a user and crash recovery
> point of view....

I can't see how we can guarantee an atomic update for them, both
in the case of an I/O error and an actual system crash.

> Well, I think it's a bit different to the directory block case - the
> directory blocks are filesystem metadata, while xattrs contain user
> data. Hence if we log user xattrs a user can consume all of the log
> bandwidth writing xattrs and degrade the metadata modification
> performance of the rest of the filesystem.

We're getting close to do that with namespace modifications with
all your scalability work :)

I think that's a point to consider, but not really black and white.  It
just makes it a bit easier to consume log bandwith, and increases the
need to have some form of per-user quotas for this sort of operations.

> So, IMO, the first question we need to answer is whether the current
> behaviour is actually a problem for anyone....

I've not heard of real life problems, but an interfaces that has very
nice behavior for the common case, but a much less optimal for a corner
cases is bound to cause trouble.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
