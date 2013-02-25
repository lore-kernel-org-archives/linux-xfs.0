Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6D0957F8C
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 09:50:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E4173AC005
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 07:50:13 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id EKUh6a5LpPyyv0Qs for <xfs@oss.sgi.com>;
	Mon, 25 Feb 2013 07:50:12 -0800 (PST)
Message-ID: <512B8834.30805@sandeen.net>
Date: Mon, 25 Feb 2013 09:50:12 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [RFC] [PATCH 0/18] xfstests: move tests out of top level
References: <1343294892-20991-1-git-send-email-david@fromorbit.com>
	<5032ABBD.80504@sgi.com> <20120820224306.GF19235@dastard>
	<20120821163337.GC29979@sgi.com> <20120821220926.GP19235@dastard>
	<20120822191642.GF29979@sgi.com> <20120822234219.GR19235@dastard>
	<20120823170025.GG29979@sgi.com>
In-Reply-To: <20120823170025.GG29979@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Theodore Tso <tytso@mit.edu>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On 8/23/12 12:00 PM, Ben Myers wrote:
> Dave,
> 
> On Thu, Aug 23, 2012 at 09:42:19AM +1000, Dave Chinner wrote:
>> On Wed, Aug 22, 2012 at 02:16:42PM -0500, Ben Myers wrote:
>>> On Wed, Aug 22, 2012 at 08:09:26AM +1000, Dave Chinner wrote:
>>>> On Tue, Aug 21, 2012 at 11:33:37AM -0500, Ben Myers wrote:
>>>>> On Tue, Aug 21, 2012 at 08:43:06AM +1000, Dave Chinner wrote:
>>>>>> On Mon, Aug 20, 2012 at 04:27:25PM -0500, Mark Tinguely wrote:
>>>>>>> On 07/26/12 04:27, Dave Chinner wrote:
>>>>>>>> Alt-Subject: Games with Sed, Grep and Awk.
>>>>>>>>
>>>>>>>> This series is based on top of the large filesystem test series.
>>>>>>>>
>>>>>>>> This moves all the tests into a ./tests subdirectory, and sorts them into
>>>>>>>> classes of related tests. Those are:
>>>>>>>>
>>>>>>>> 	tests/generic:	valid for all filesystems
>>>>>>>> 	tests/shared:	valid for a limited number of filesystems
>>>>>>>> 	tests/xfs:	xfs specific tests
>>>>>>>> 	tests/btrfs	btrfs specific tests
>>>>>>>> 	tests/ext4	ext4 specific tests
>>>>>>>> 	tests/udf	udf specific tests
>>>>>>>
>>>>>>> The SGI XFS group talked about your proposed changes to xfstests and
>>>>>>> the response is very positive.
>>>>>>>
>>>>>>> The couple concerns are:
>>>>>>>
>>>>>>> 1) There is a consensus in the group that the benchmark framework
>>>>>>>    should remain until there is a common benchmark available.
>>>>>>>
>>>>>>>    Could the benchmark infrastructure be placed into its own directory
>>>>>>>    until a new common benchmark framework has been adopted?
>>>>>>
>>>>>> Keeping it just complicates things. The benchmark infrastructure
>>>>>> is bitrotted and was largely just a hack tacked on to the side of
>>>>>> the regression test suite.
>>>>>>
>>>>>> For it to be useful in an automated test environment, it would need
>>>>>> to be re-implemented from scratch with reliable recording of results
>>>>>> and the ability to determine if a result is unusual or not. None of
>>>>>> this exists - it's just a framework to run a couple of benchmarks
>>>>>> and dump some output to stdout using the xfstests machine config
>>>>>> files....
>>>>>>
>>>>>> I have tried integrating other benchmarks into xfstests a while back
>>>>>> (e.g. compile bench, fsmark, etc) and using the results for some
>>>>>> kind of meaningful performance regression test. I rapidly came to
>>>>>> the conclusion that the infrastructure was not up to scratch and
>>>>>> that my simple handwritten standalone test scripts to iterate
>>>>>> through benchmarks and capture results was much easier to use and
>>>>>> modify than to jump through the weird bench infrastructure hoops.
>>>>>>
>>>>>> So, no, I don't think it's worth keeping at all.
>>>>>
>>>>> You've already made it clear that you feel the current bench implementation is
>>>>> not worth keeping.  Once a suitable replacement for the bench infrastructure
>>>>> has been implemented we can remove the old one.  Until then we prefer to keep
>>>>> what we have in the tree.
>>>>
>>>> That's not how the process works 
>>>
>>> That is exactly how the process works.  You posted an RFC and Mark and the XFS
>>> team at SGI walked through your patch set.  Mark subsequently posted the
>>> commentary in reply to your RFC.  Cruft or not, the removal of a feature goes
>>> through the same review process as everything else.
>>
>> Sure, but you need to justify your arguments for keeping something
>> with evidence and logic - handwaving about wanting something is, and
>> always has been, insufficient justification. That's the part of the
>> process I'm talking about - that statements of need require
>> evidence, especially when you agreed to the removal at LSF in San
>> Fransisco a few months ago. My arguments at the time were:
>>
>> 	a) nobody is actually using it,
>> 	b) it has effectively been unmaintained since 2003
>> 	c) it has no regression analysis or detection capability
>> 	d) it shares *very little* of xfstests
>> 	e) it gets in the way of cleaning up xfstests
>> 	f) there are far better workload generators that are being
>> 	actively maintained.
>>
>> And AFAIA, nothing has changed in the past few months.
> 
> "In this case, SGI would like to keep the benchmark capability in xfstests in
> order have a better chance of catching performance regressions."  There has
> been a been performance regression in the past few months (and there will be
> more in the future), we have had performance regressions internally too, and
> this has brought the value of having benchmarks in xfstests into sharp focus.

"xfs has had performance regressions; xfstests contains bitrotted perf code"

But that's not a justification for keeping bitrotted code.

I think you finally answered the basic question Dave asked, and we learned
that SGI is not using the code which he proposes removing.

<snip>

> I understand that bench is bitrotted, but it still has some value even today.

Not if nobody uses it.  If it really had value it would be in use.

> Phil has agreed to take this on as a project so the bitrot will be addressed.

How's that been going in the 6 months since this patchset stalled?

Can we get it moving again?  Ext4 folks would like to see these changes
proceed as well.  What issues remain, if any?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
