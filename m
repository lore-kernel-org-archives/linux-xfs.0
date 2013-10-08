Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 55F7E7F58
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 19:57:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E5678AC002
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 17:57:12 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id sQWYcSNXfuODKgdy for <xfs@oss.sgi.com>;
	Mon, 07 Oct 2013 17:57:09 -0700 (PDT)
Message-ID: <52535864.8020503@sandeen.net>
Date: Mon, 07 Oct 2013 19:57:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests XFS: verify extended attributes after
	multi-stream xfsdump/xfsrestore
References: <524AF8AE.5030300@sgi.com> <20131007193912.256265551@sgi.com>
	<20131008005317.GU4446@dastard>
In-Reply-To: <20131008005317.GU4446@dastard>
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
Cc: rjohnston@sgi.com, xfs@oss.sgi.com

On 10/7/13 7:53 PM, Dave Chinner wrote:
> Two tests, please. move all the common parts into common/dump, and
> write them as two separate tests. That way we can easily track what
> test is failing just by looking at what harness test is failing...

I'm not quite convinced that it's 2 separate tests, TBH.

It's the same root cause; I guess there is a slightly different
outcome because if you hit the same root cause enough times,
you'll segfault.  That's the only difference in test #2.
(and the segfault isn't fixed AFAIK).

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
