Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D51F67F73
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2014 11:42:49 -0500 (CDT)
Message-ID: <53399B06.5010400@sgi.com>
Date: Mon, 31 Mar 2014 11:42:46 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix bad hash ordering
References: <20140328173430.622616177@sgi.com> <20140331001055.GD16336@dastard>
In-Reply-To: <20140331001055.GD16336@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On 03/30/14 19:10, Dave Chinner wrote:
> On Fri, Mar 28, 2014 at 12:33:34PM -0500, Mark Tinguely wrote:
>> Fix the fix directory "bad hash ordering" bug introduced in
>> commit f5ea1100.
>

...

>
>> ---
>> A C program that generates this problem can be found at:
>>   http://oss.sgi.com/archives/xfs/2014-03/msg00373.html
>>
>> A xfstest for this bug is coming from Hannes Frederic Sowa.
>
> Can you convert this program to an xfstest yourself so that I can
> commit the regression test at the same time I commit an updated
> fix?

We narrowed the iterations down to make it a quick test.
I have every confidence that Hannes can generate the test in a timely
manner and I will help in any way possible.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
