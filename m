Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B692929DFC
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 12:41:57 -0500 (CDT)
Message-ID: <5241CEE2.5040607@sgi.com>
Date: Tue, 24 Sep 2013 12:41:54 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] [RFC] xfs: lookaside cache for xfs_buf_find
References: <1378690396-15792-1-git-send-email-david@fromorbit.com>
	<52404D7F.1080308@sgi.com> <20130924004803.GZ9901@dastard>
In-Reply-To: <20130924004803.GZ9901@dastard>
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
Cc: xfs@oss.sgi.com

On 09/23/13 19:48, Dave Chinner wrote:
> On Mon, Sep 23, 2013 at 09:17:35AM -0500, Mark Tinguely wrote:
>> On 09/08/13 20:33, Dave Chinner wrote:
>>> From: Dave Chinner<dchinner@redhat.com>
>>>
>>> CPU overhead of buffer lookups dominate most metadata intensive
>>> workloads. The thing is, most such workloads are hitting a
>>> relatively small number of buffers repeatedly, and so caching
>>> recently hit buffers is a good idea.
>>>
>> ...
>>
>> I think this needs more testing.
>
> Yes, that's what an "RFC" implies. It's an idea, it's not
> fully baked and it's not ready for inclusion - it's a proof of
> concept that needs further work, and I't being posted for discussion
> to determine if it's worth pursuing further.
>
> Indeed, I haven't proposed it for inclusion yet because I'm
> still finding problems caused by the patch - it's still just a
> prototype at this point.
>
>> I got the same panic running xfstest 319 with the patch at:
>>     http://oss.sgi.com/archives/xfs/2013-09/msg00578.html
>> once it hung on a xfs_buf lock before the panic.
>>
>> And these are the only tests that I threw at this patch.
>
> Sure. The version I have in my stack at the moment has some more
> ixes in it, like handling of length mismatches due to stale buffers
> on lookaside lookups, and other such things.
>
> i.e. early feedback on prototype code is exactly what [RFC] patches
> are for...

And early feedback is that it has potential but needs more work.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
