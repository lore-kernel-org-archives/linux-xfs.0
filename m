Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6A8847CA2
	for <xfs@oss.sgi.com>; Sat, 13 Feb 2016 11:09:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 17528AC003
	for <xfs@oss.sgi.com>; Sat, 13 Feb 2016 09:09:23 -0800 (PST)
Received: from mail-lf0-f48.google.com (mail-lf0-f48.google.com
	[209.85.215.48]) by cuda.sgi.com with ESMTP id bP75vMWQsdExCk0P
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 13 Feb 2016 09:09:19 -0800 (PST)
Received: by mail-lf0-f48.google.com with SMTP id m1so68534316lfg.0
	for <xfs@oss.sgi.com>; Sat, 13 Feb 2016 09:09:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160126141733.GA48264@bfoster.bfoster>
References: <1453177919-17849-1-git-send-email-david@fromorbit.com>
	<20160120015853.GU6033@dastard>
	<20160126141733.GA48264@bfoster.bfoster>
Date: Sat, 13 Feb 2016 18:09:17 +0100
Message-ID: <CADr68Wa9vG=ZOn4gbHezEyOeM+tCo69s3WVqcVXnZrn+=DdoVA@mail.gmail.com>
Subject: Re: [PATCH v2] [RFC] xfs: allocate log vector buffers outside CIL
	context lock
From: Jens Rosenboom <j.rosenboom@x-ion.de>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

2016-01-26 15:17 GMT+01:00 Brian Foster <bfoster@redhat.com>:
> On Wed, Jan 20, 2016 at 12:58:53PM +1100, Dave Chinner wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> One of the problems we currently have with delayed logging is that
>> under serious memory pressure we can deadlock memory reclaim. THis
>> occurs when memory reclaim (such as run by kswapd) is reclaiming XFS
>> inodes and issues a log force to unpin inodes that are dirty in the
>> CIL.
>>
>> The CIL is pushed, but this will only occur once it gets the CIL
>> context lock to ensure that all committing transactions are complete
>> and no new transactions start being committed to the CIL while the
>> push switches to a new context.
>>
>> The deadlock occurs when the CIL context lock is held by a
>> committing process that is doing memory allocation for log vector
>> buffers, and that allocation is then blocked on memory reclaim
>> making progress. Memory reclaim, however, is blocked waiting for
>> a log force to make progress, and so we effectively deadlock at this
>> point.
>>
>> To solve this problem, we have to move the CIL log vector buffer
>> allocation outside of the context lock so that memory reclaim can
>> always make progress when it needs to force the log. The problem
>> with doing this is that a CIL push can take place while we are
>> determining if we need to allocate a new log vector buffer for
>> an item and hence the current log vector may go away without
>> warning. That means we canot rely on the existing log vector being
>> present when we finally grab the context lock and so we must have a
>> replacement buffer ready to go at all times.
>>
>> To ensure this, introduce a "shadow log vector" buffer that is
>> always guaranteed to be present when we gain the CIL context lock
>> and format the item. This shadow buffer may or may not be used
>> during the formatting, but if the log item does not have an existing
>> log vector buffer or that buffer is too small for the new
>> modifications, we swap it for the new shadow buffer and format
>> the modifications into that new log vector buffer.
>>
>> The result of this is that for any object we modify more than once
>> in a given CIL checkpoint, we double the memory required
>> to track dirty regions in the log. For single modifications then
>> we consume the shadow log vectorwe allocate on commit, and that gets
>> consumed by the checkpoint. However, if we make multiple
>> modifications, then the second transaction commit will allocate a
>> shadow log vector and hence we will end up with double the memory
>> usage as only one of the log vectors is consumed by the CIL
>> checkpoint. The remaining shadow vector will be freed when th elog
>> item is freed.
>>
>> This can probably be optimised - access to the shadow log vector is
>> serialised by the object lock (as opposited to the active log
>> vector, which is controlled by the CIL context lock) and so we can
>> probably free shadow log vector from some objects when the log item
>> is marked clean on removal from the AIL.
>>
>> The patch survives smoke testing and some load testing. I haven't
>> done any real performance testing, but I have done some load and low
>> memory testing and it hasn't exploded (perf did - it failed several
>> order 2 memory allocations, which XFS continued along just fine).
>>
>> That said, I don't have a reliable deadlock reproducer in the first
>> place, so I'm interested i hearing what people think about this
>> approach to solve the problem and ways to test and improve it.
>>
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> ---
>
> This seems reasonable to me in principle. It would be nice to have some
> kind of feedback in terms of effectiveness resolving the original
> deadlock report. I can't think of a good way of testing short of
> actually instrumenting the deadlock one way or another, unfortunately.
> Was there a user that might be willing to test or had a detailed enough
> description of the workload/environment?

We have seen this issue on our production Ceph cluster sporadically
and have tried a long time to reproduce it in a lab environment.

Now I finally seem to have found a way to reproduce it at least twice
in a row. My test cluster is composed of 8 small nodes with 2 SSDs
each, so 16 OSDs. One of the nodes runs as rgw and I use cosbench to
write objects into the cluster. Running with 32 workers writing
16k-size objects into 100 buckets, I start seeing messages like this
after a couple of hours (at this point there are about 10M objects in
the cluster):

Feb 13 10:51:53 storage-node35 kernel: [10558.479309] XFS:
ceph-osd(10078) possible memory allocation deadlock size 32856 in
kmem_alloc (mode:0x2408240)
Feb 13 10:51:55 storage-node35 kernel: [10560.289810] XFS:
ceph-osd(10078) possible memory allocation deadlock size 32856 in
kmem_alloc (mode:0x2408240)
Feb 13 10:51:55 storage-node35 kernel: [10560.613984] XFS:
ceph-osd(10078) possible memory allocation deadlock size 32856 in
kmem_alloc (mode:0x2408240)
Feb 13 10:51:57 storage-node35 kernel: [10562.614089] XFS:
ceph-osd(10078) possible memory allocation deadlock size 32856 in
kmem_alloc (mode:0x2408240)

Soon after this, operations get so slow that the OSDs die because of
their suicide timeouts.

Then I installed onto 3 servers this patch (applied onto kernel
v4.4.1). The bad news is that I am still getting the kernel messages
on these machines. The good news, though, is that they appear at a
much lower frequency and also the impact on performance seems to be
lower, so the OSD processes on these three nodes did not get killed.

I'm going to rerun the test with the patched kernel on all nodes next
week, I could also run debug stuff if you have some idea for that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
