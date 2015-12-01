Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D40ED7F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 15:24:19 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 98E05304067
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 13:24:19 -0800 (PST)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com
	[74.125.82.44]) by cuda.sgi.com with ESMTP id GU7HAkm0MDe6eSDa
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2015 13:24:17 -0800 (PST)
Received: by wmuu63 with SMTP id u63so190561951wmu.0
	for <xfs@oss.sgi.com>; Tue, 01 Dec 2015 13:24:16 -0800 (PST)
Subject: Re: sleeps and waits during io_submit
References: <CAD-J=zZh1dtJsfrW_Gwxjg+qvkZMu7ED-QOXrMMO6B-G0HY2-A@mail.gmail.com>
	<20151130141000.GC24765@bfoster.bfoster>
	<565C5D39.8080300@scylladb.com>
	<20151130161438.GD24765@bfoster.bfoster>
	<565D639F.8070403@scylladb.com>
	<20151201131114.GA26129@bfoster.bfoster>
	<565DA784.5080003@scylladb.com>
	<20151201145631.GD26129@bfoster.bfoster>
	<565DBB3E.2010308@scylladb.com> <20151201210417.GY19199@dastard>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <565E0FFD.70507@scylladb.com>
Date: Tue, 1 Dec 2015 23:24:13 +0200
MIME-Version: 1.0
In-Reply-To: <20151201210417.GY19199@dastard>
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
Cc: Brian Foster <bfoster@redhat.com>, Glauber Costa <glauber@scylladb.com>, xfs@oss.sgi.com

On 12/01/2015 11:04 PM, Dave Chinner wrote:
> On Tue, Dec 01, 2015 at 05:22:38PM +0200, Avi Kivity wrote:
>> On 12/01/2015 04:56 PM, Brian Foster wrote:
>>> On Tue, Dec 01, 2015 at 03:58:28PM +0200, Avi Kivity wrote:
>>>>>   io_submit() can probably block in a variety of
>>>>> places afaict... it might have to read in the inode extent map, allocate
>>>>> blocks, take inode/ag locks, reserve log space for transactions, etc.
>>>> Any chance of changing all that to be asynchronous?  Doesn't sound too hard,
>>>> if somebody else has to do it.
>>>>
>>> I'm not following... if the fs needs to read in the inode extent map to
>>> prepare for an allocation, what else can the thread do but wait? Are you
>>> suggesting the request kick off whatever the blocking action happens to
>>> be asynchronously and return with an error such that the request can be
>>> retried later?
>> Not quite, it should be invisible to the caller.
> I have a pony I can sell you.

You already sold me a pony.

>> That is, the code called by io_submit()
>> (file_operations::write_iter, it seems to be called today) can kick
>> off this operation and have it continue from where it left off.
> This is a problem that people have tried to solve in the past (e.g.
> syslets, etc) where the thread executes until it has to block, and
> then it's handled off to a worker thread/syslet to block and the
> main process returns with EIOCBQUEUED.

Yes, I remember that.

> Basically, you're asking for a real AIO infrastructure to
> beintroduced into the kernel, and I think that's beyond what us XFS
> guys can do...

Sure you can, Dave.  In fact you feel an irresistible urge to do it.

But I don't think the EIOCBQUEUED thing need be repeated.  We can have a 
simpler implementation:

  - Add a task flag TIF_AIO, which causes any new I/O to fail with 
EAIOWOULDBLOCK.

  - have __blockdev_direct_IO() do its block-mapping operations with 
TIF_AIO set (but remove it just before issuing the bio).

  - sys_aio_submit() catches EAIOWOULDBLOCK and resubmits the aio in a 
work item, this time without TIF_AIO games.

The effect would be similar to EIOCBQUEUED, but simpler, as instead of 
issuing any metadata I/O you abort the operation and restart it from 
scratch.

>
>>>>>   Reducing the frequency of block allocation/frees might also be
>>>>> another help (e.g., preallocate and reuse files,
>>>> Isn't that discouraged for SSDs?
>>>>
>>> Perhaps, if you're referring to the fact that the blocks are never freed
>>> and thus never discarded..? Are you running fstrim?
>> mount -o discard.  And yes, overwrites are supposedly more expensive
>> than trim old data + allocate new data, but maybe if you compare it
>> with the work XFS has to do, perhaps the tradeoff is bad.
> Oh, you do realise that using "-o discard" causes significant delays
> in journal commit processing? i.e. the journal commit completion
> blocks until all the discards have been submitted and waited on
> *synchronously*. This is a problem with the linux block layer in
> that blkdev_issue_discard() is a synchronous operation.....

I do now. What's the unicode for a crying face?

> Hence if you are seeing delays in transactions (e.g. timestamp updates)
> it's entirely possible that things will get much better if you
> remove the discard mount option. It's much better from a performance
> perspective to use the fstrim command every so often - fstrim issues
> discard operations in the context of the fstrim process - it does
> not interact with the transaction subsystem at all.
>
>

All right.  On the other hand we have to know when to issue it. That 
would be when nn% of the disk area have been rewritten.  Is there some 
counter I can poll every minute or so for this?  Not doing the fstrim in 
time would cause the disk performance to tank.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
