Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D41C47F59
	for <xfs@oss.sgi.com>; Mon,  9 Sep 2013 10:35:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A8C848F8066
	for <xfs@oss.sgi.com>; Mon,  9 Sep 2013 08:35:52 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	pZDsLE5esDIZy9I4 for <xfs@oss.sgi.com>;
	Mon, 09 Sep 2013 08:35:51 -0700 (PDT)
Date: Tue, 10 Sep 2013 01:35:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] xfs: increase inode cluster size for v5 filesystems
Message-ID: <20130909153546.GT12779@dastard>
References: <1378715664-19969-1-git-send-email-david@fromorbit.com>
	<20130909133254.GA14778@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130909133254.GA14778@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Sep 09, 2013 at 06:32:54AM -0700, Christoph Hellwig wrote:
> I can't see anything v5 format specific here, as 512 byte inodes can be
> created with v4 filesystems as well.

It's an RFC, and so i've just done the minimum I need to do to
verify it is working corectly. Indeed, I'm not sure it is all there
yet, as I haven't tested increased inode alignments on older
kernels. So I'm not sure whether it will need a feature bit or
not yet.

The test matrix of having to test everything on v4 and v5 is just
nasty, especially if we are talking about prototyping code. I'd much
prefer to bring things to v5 filesytsems where we have much lower
exposure and risk of corruption problems, and then when we know it's
solid because of the QA we've done on it, then we can expose the
majority of the XFS userbase to it by bringing it back to v4
filesystems.

As i've said before - if someone wants to bring new features to v4
filesystems sooner than I do, then they need to step up and do the
work themselves, because I don't have the time and resources to
fully verify new features on v4 filesystem formats...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
