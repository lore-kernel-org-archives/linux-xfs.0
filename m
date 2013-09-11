Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D31D47F51
	for <xfs@oss.sgi.com>; Wed, 11 Sep 2013 11:22:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B26218F8033
	for <xfs@oss.sgi.com>; Wed, 11 Sep 2013 09:22:03 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id BnDOvy5m5jZZicwx (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Sep 2013 09:21:59 -0700 (PDT)
Date: Wed, 11 Sep 2013 09:21:59 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [RFC] xfs: increase inode cluster size for v5 filesystems
Message-ID: <20130911162159.GA29319@infradead.org>
References: <1378715664-19969-1-git-send-email-david@fromorbit.com>
	<20130909133254.GA14778@infradead.org>
	<20130909153546.GT12779@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130909153546.GT12779@dastard>
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

On Tue, Sep 10, 2013 at 01:35:47AM +1000, Dave Chinner wrote:
> The test matrix of having to test everything on v4 and v5 is just
> nasty, especially if we are talking about prototyping code. I'd much
> prefer to bring things to v5 filesytsems where we have much lower
> exposure and risk of corruption problems, and then when we know it's
> solid because of the QA we've done on it, then we can expose the
> majority of the XFS userbase to it by bringing it back to v4
> filesystems.

I think the test matrix is a reason for not enabling this only on v5
filesystems.  Large inodes are an old and supported use case, although
probably not as heavily tested as it should.  By introducing two
different large inode cases we don't really help increasing test
coverage for a code path that is the same for v4 and v5.

That being said as long as you're still prototyping I'm not going to
interfere.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
