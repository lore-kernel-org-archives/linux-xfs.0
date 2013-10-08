Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DD5E97F58
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 19:58:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B6879304039
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 17:58:51 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id lVY8vlEnGrTVfsHJ for <xfs@oss.sgi.com>;
	Mon, 07 Oct 2013 17:58:50 -0700 (PDT)
Message-ID: <525358C8.1040805@sandeen.net>
Date: Mon, 07 Oct 2013 19:58:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests XFS: verify extended attributes after
	multi-stream xfsdump/xfsrestore
References: <524AF8AE.5030300@sgi.com> <20131007193912.256265551@sgi.com>
	<20131008005317.GU4446@dastard> <52535864.8020503@sandeen.net>
In-Reply-To: <52535864.8020503@sandeen.net>
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

On 10/7/13 7:57 PM, Eric Sandeen wrote:
> On 10/7/13 7:53 PM, Dave Chinner wrote:
>> Two tests, please. move all the common parts into common/dump, and
>> write them as two separate tests. That way we can easily track what
>> test is failing just by looking at what harness test is failing...
> 
> I'm not quite convinced that it's 2 separate tests, TBH.
> 
> It's the same root cause; I guess there is a slightly different
> outcome because if you hit the same root cause enough times,
> you'll segfault.  That's the only difference in test #2.
> (and the segfault isn't fixed AFAIK).

Or to be clearer - I'm not sure that test1 is testing anything
fundamentally different from test2.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
