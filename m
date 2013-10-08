Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BAC277F69
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 09:21:12 -0500 (CDT)
Message-ID: <525414D9.10308@sgi.com>
Date: Tue, 8 Oct 2013 09:21:13 -0500
From: Rich Johnston <rjohnston@sgi.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 10/07/2013 07:57 PM, Eric Sandeen wrote:
> On 10/7/13 7:53 PM, Dave Chinner wrote:
>> Two tests, please. move all the common parts into common/dump, and
>> write them as two separate tests. That way we can easily track what
>> test is failing just by looking at what harness test is failing...
>
> I'm not quite convinced that it's 2 separate tests, TBH.
>
> It's the same root cause; I guess there is a slightly different
> outcome because if you hit the same root cause enough times,
> you'll segfault.


Multiple DMF offline files are successfully restored but the attrs are 
lost. I wanted to show/test that case.

I agree with Eric that it is the same  root cause but because can occur 
with successful dumps and does not segfault,  Thats why the 2 tests.

> That's the only difference in test #2.
> (and the segfault isn't fixed AFAIK).

Agreed and I will note that in the test description.

>
> -Eric
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
