Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 03DCC7F3F
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 17:58:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CC22D8F818B
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 15:58:54 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	KG1KhuJddlul02sr for <xfs@oss.sgi.com>;
	Mon, 12 May 2014 15:58:49 -0700 (PDT)
Date: Tue, 13 May 2014 08:58:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfstests PATCH 0/4] locktest: cleanup, bugfixes, and add new
	locking test
Message-ID: <20140512225845.GN26353@dastard>
References: <1399907193-23857-1-git-send-email-jlayton@poochiereds.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1399907193-23857-1-git-send-email-jlayton@poochiereds.net>
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
To: Jeff Layton <jlayton@poochiereds.net>
Cc: xfs@oss.sgi.com

On Mon, May 12, 2014 at 11:06:29AM -0400, Jeff Layton wrote:
> This patchset does some general cleanup of the locktest binary, adds
> some infrastructure to allow testing F_GETLK requests, and adds a new
> F_GETLK test to the pile.
> 
> The main impetus here is a regression that I caused in F_GETLK handling
> for v3.15. The patch is making its way to Linus now, but I want to be
> sure that it doesn't regress in the future.

So do these changes cause locktest to fail on older kernels? i.e.
does changing the test cause the locktest tests to fail where
previously they passed? If so, we're going to have to make this a
little more complex...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
