Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CA8467F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 13:26:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ABDDE304051
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 11:26:47 -0800 (PST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com
	[74.125.82.50]) by cuda.sgi.com with ESMTP id q3pbKkcuFFQaUJRI
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2015 11:26:45 -0800 (PST)
Received: by wmww144 with SMTP id w144so27381570wmw.0
	for <xfs@oss.sgi.com>; Tue, 01 Dec 2015 11:26:44 -0800 (PST)
Subject: Re: sleeps and waits during io_submit
References: <20151130161438.GD24765@bfoster.bfoster>
	<565D639F.8070403@scylladb.com>
	<20151201131114.GA26129@bfoster.bfoster>
	<565DA784.5080003@scylladb.com>
	<20151201145631.GD26129@bfoster.bfoster>
	<565DBB3E.2010308@scylladb.com>
	<20151201160133.GE26129@bfoster.bfoster>
	<565DC613.4090608@scylladb.com>
	<20151201162958.GF26129@bfoster.bfoster>
	<565DD449.5090101@scylladb.com>
	<20151201185113.GG26129@bfoster.bfoster>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <565DF472.8080101@scylladb.com>
Date: Tue, 1 Dec 2015 21:26:42 +0200
MIME-Version: 1.0
In-Reply-To: <20151201185113.GG26129@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Glauber Costa <glauber@scylladb.com>, xfs@oss.sgi.com

On 12/01/2015 08:51 PM, Brian Foster wrote:
> On Tue, Dec 01, 2015 at 07:09:29PM +0200, Avi Kivity wrote:
>>
>> On 12/01/2015 06:29 PM, Brian Foster wrote:
>>> On Tue, Dec 01, 2015 at 06:08:51PM +0200, Avi Kivity wrote:
>>>> On 12/01/2015 06:01 PM, Brian Foster wrote:
>>>>> On Tue, Dec 01, 2015 at 05:22:38PM +0200, Avi Kivity wrote:
>>>>>> On 12/01/2015 04:56 PM, Brian Foster wrote:
>>>>>>> On Tue, Dec 01, 2015 at 03:58:28PM +0200, Avi Kivity wrote:
>>>>>>>> On 12/01/2015 03:11 PM, Brian Foster wrote:
>>>>>>>>> On Tue, Dec 01, 2015 at 11:08:47AM +0200, Avi Kivity wrote:
>>>>>>>>>> On 11/30/2015 06:14 PM, Brian Foster wrote:
>>>>>>>>>>> On Mon, Nov 30, 2015 at 04:29:13PM +0200, Avi Kivity wrote:
>>>>>>>>>>>> On 11/30/2015 04:10 PM, Brian Foster wrote:
>>>>>>>>> ...
> ...
>>>>>>>> Won't io_submit() also trigger metadata I/O?  Or is that all deferred to
>>>>>>>> async tasks?  I don't mind them blocking each other as long as they let my
>>>>>>>> io_submit alone.
>>>>>>>>
>>>>>>> Yeah, it can trigger metadata reads, force the log (the stale buffer
>>>>>>> example) or push the AIL (wait on log space). Metadata changes made
>>>>>>> directly via your I/O request are logged/committed via transactions,
>>>>>>> which are generally processed asynchronously from that point on.
>>>>>>>
>>>>>>>>>   io_submit() can probably block in a variety of
>>>>>>>>> places afaict... it might have to read in the inode extent map, allocate
>>>>>>>>> blocks, take inode/ag locks, reserve log space for transactions, etc.
>>>>>>>> Any chance of changing all that to be asynchronous?  Doesn't sound too hard,
>>>>>>>> if somebody else has to do it.
>>>>>>>>
>>>>>>> I'm not following... if the fs needs to read in the inode extent map to
>>>>>>> prepare for an allocation, what else can the thread do but wait? Are you
>>>>>>> suggesting the request kick off whatever the blocking action happens to
>>>>>>> be asynchronously and return with an error such that the request can be
>>>>>>> retried later?
>>>>>> Not quite, it should be invisible to the caller.
>>>>>>
>>>>>> That is, the code called by io_submit() (file_operations::write_iter, it
>>>>>> seems to be called today) can kick off this operation and have it continue
>>>>> >from where it left off.
>>>>> Isn't that generally what happens today?
>>>> You tell me.  According to $subject, apparently not enough.  Maybe we're
>>>> triggering it more often, or we suffer more when it does trigger (the latter
>>>> probably more likely).
>>>>
>>> The original mail describes looking at the sched:sched_switch tracepoint
>>> which on a quick look, appears to fire whenever a cpu context switch
>>> occurs. This likely triggers any time we wait on an I/O or a contended
>>> lock (among other situations I'm sure), and it signifies that something
>>> else is going to execute in our place until this thread can make
>>> progress.
>> For us, nothing else can execute in our place, we usually have exactly one
>> thread per logical core.  So we are heavily dependent on io_submit not
>> sleeping.
>>
> Yes, this "coroutine model" makes more sense to me from the application
> perspective. I'm just trying to understand what you're after from the
> kernel perspective.

It's basically the same thing.  To to this, we'd have get_block either 
return the block's address (if it was in some metadata cache), or, if it 
was not, issue an I/O that fills (part of) that cache, and as its 
completion function, a continuation that reruns __blockdev_direct_IO 
from the point it was stopped so it can submit the data I/O (if the 
metadata cache was completely updated) or issue the next I/O aiming to 
fill that metadata cache, if it was not.

Without that (and the more complicated code for the write path) 
io_submit is basically unusable. Yes parts of it are asynchronous, but 
if other parts of it are still synchronous, we end up requiring 
thread_count > cpu_count and now we have to context switch constantly.

>
>> The case of a contended lock is, to me, less worrying.  It can be reduced by
>> using more allocation groups, which is apparently the shared resource under
>> contention.
>>
> Yep.
>
>> The case of waiting for I/O is much more worrying, because I/O latency are
>> much higher.  But it seems like most of the DIO path does not trigger
>> locking around I/O (and we are careful to avoid the ones that do, like
>> writing beyond eof).
>>
>> (sorry for repeating myself, I have the feeling we are talking past each
>> other and want to be on the same page)
>>
> Yeah, my point is just that just because the thread blocked on I/O,
> doesn't mean the cpu can't carry on with some useful work for another
> task.

In our case, there is no other task.  We run one thread per logical 
core, so if that thread gets blocked, the cpu idles.

The whole point of io_submit() is to issue an I/O and let the caller 
continue processing immediately.  It is the equivalent of O_NONBLOCK for 
networking code.  If O_NONBLOCK did block from time to time, practically 
all modern network applications would see a huge performance drop.

>
>>>>>   We submit an I/O which is
>>>>> asynchronous in nature and wait on a completion, which causes the cpu to
>>>>> schedule and execute another task until the completion is set by I/O
>>>>> completion (via an async callback). At that point, the issuing thread
>>>>> continues where it left off. I suspect I'm missing something... can you
>>>>> elaborate on what you'd do differently here (and how it helps)?
>>>> Just apply the same technique everywhere: convert locks to trylock +
>>>> schedule a continuation on failure.
>>>>
>>> I'm certainly not an expert on the kernel scheduling, locking and
>>> serialization mechanisms, but my understanding is that most things
>>> outside of spin locks are reschedule points. For example, the
>>> wait_for_completion() calls XFS uses to wait on I/O boil down to
>>> schedule_timeout() calls. Buffer locks are implemented as semaphores and
>>> down() can end up in the same place.
>> But, for the most part, XFS seems to be able to avoid sleeping.  The call to
>> __blockdev_direct_IO only launches the I/O, so any locking is only around
>> cpu operations and, unless there is contention, won't cause us to sleep in
>> io_submit().
>>
>> Trying to follow the code, it looks like xfs_get_blocks_direct (and
>> __blockdev_direct_IO's get_block parameter in general) is synchronous, so
>> we're just lucky to have everything in cache.  If it isn't, we block right
>> there.  I really hope I'm misreading this and some other magic is happening
>> elsewhere instead of this.
>>
> Nope, it's synchronous from a code perspective. The
> xfs_bmapi_read()->xfs_iread_extents() path could have to read in the
> inode bmap metadata if it hasn't been done already. Note that this
> should only happen once as everything is stored in-core, so in most
> cases this is skipped. It's also possible extents are read in via some
> other path/operation on the inode before an async I/O happens to be
> submitted (e.g., see some of the other xfs_bmapi_read() callers).

Is there (could we add) some ioctl to prime this cache?  We could call 
it from a worker thread where we don't mind blocking during open.

What is the eviction policy for this cache?   Is it simply the block 
device's page cache?

What about the write path, will we see the same problems there?  I would 
guess the problem is less severe there if the metadata is written with 
writeback policy.

>
> Either way, the extents have to be read in at some point and I'd expect
> that cpu to schedule onto some other task while that thread waits on I/O
> to complete (read-ahead could also be a factor here, but I haven't
> really dug into how that is triggered for buffers).

To provide an example, our application, which is a database, faces this 
problem exact at a higher level.  Data is stored in data files, and data 
items' locations are stored in index files. When we read a bit of data, 
we issue an index read, and pass it a continuation to be executed when 
the read completes.  This latter continuation parses the data and passes 
it to the code that prepares it for merging with data from other data 
files, and an eventual return to the user.

Having written code for over a year in this style, I've come to expect 
it to be used everywhere asynchronous I/O is used, but I realize it is 
fairly hard without good support from a framework that allows 
continuations to be composed in a natural way.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
