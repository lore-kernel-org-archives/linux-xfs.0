Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2D5F07F59
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 08:01:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1A0E0304053
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 06:01:20 -0800 (PST)
Received: from mail-lf0-f52.google.com (mail-lf0-f52.google.com
	[209.85.215.52]) by cuda.sgi.com with ESMTP id 0dPS3jLWy48jmkbv
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2015 06:01:14 -0800 (PST)
Received: by lfdl133 with SMTP id l133so9162956lfd.2
	for <xfs@oss.sgi.com>; Tue, 01 Dec 2015 06:01:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <565DA784.5080003@scylladb.com>
References: <CAD-J=zZh1dtJsfrW_Gwxjg+qvkZMu7ED-QOXrMMO6B-G0HY2-A@mail.gmail.com>
	<20151130141000.GC24765@bfoster.bfoster>
	<565C5D39.8080300@scylladb.com>
	<20151130161438.GD24765@bfoster.bfoster>
	<565D639F.8070403@scylladb.com>
	<20151201131114.GA26129@bfoster.bfoster>
	<565DA784.5080003@scylladb.com>
Date: Tue, 1 Dec 2015 09:01:13 -0500
Message-ID: <CAD-J=zY=A8MQLzykox276cHiH7ddXHFVp0w0B4XRBskv6YK_WQ@mail.gmail.com>
Subject: Re: sleeps and waits during io_submit
From: Glauber Costa <glauber@scylladb.com>
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
To: Avi Kivity <avi@scylladb.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, Dec 1, 2015 at 8:58 AM, Avi Kivity <avi@scylladb.com> wrote:
>
>
> On 12/01/2015 03:11 PM, Brian Foster wrote:
>>
>> On Tue, Dec 01, 2015 at 11:08:47AM +0200, Avi Kivity wrote:
>>>
>>> On 11/30/2015 06:14 PM, Brian Foster wrote:
>>>>
>>>> On Mon, Nov 30, 2015 at 04:29:13PM +0200, Avi Kivity wrote:
>>>>>
>>>>> On 11/30/2015 04:10 PM, Brian Foster wrote:
>>
>> ...
>>>>
>>>> The agsize/agcount mkfs-time heuristics change depending on the type of
>>>> storage. A single AG can be up to 1TB and if the fs is not considered
>>>> "multidisk" (e.g., no stripe unit/width is defined), 4 AGs is the
>>>> default up to 4TB. If a stripe unit is set, the agsize/agcount is
>>>> adjusted depending on the size of the overall volume (see
>>>> xfsprogs-dev/mkfs/xfs_mkfs.c:calc_default_ag_geometry() for details).
>>>
>>> We'll experiment with this.  Surely it depends on more than the amount of
>>> storage?  If you have a high op rate you'll be more likely to excite
>>> contention, no?
>>>
>> Sure. The absolute optimal configuration for your workload probably
>> depends on more than storage size, but mkfs doesn't have that
>> information. In general, it tries to use the most reasonable
>> configuration based on the storage and expected workload. If you want to
>> tweak it beyond that, indeed, the best bet is to experiment with what
>> works.
>
>
> We will do that.
>
>>>>> Are those locks held around I/O, or just CPU operations, or a mix?
>>>>
>>>> I believe it's a mix of modifications and I/O, though it looks like some
>>>> of the I/O cases don't necessarily wait on the lock. E.g., the AIL
>>>> pushing case will trylock and defer to the next list iteration if the
>>>> buffer is busy.
>>>>
>>> Ok.  For us sleeping in io_submit() is death because we have no other
>>> thread
>>> on that core to take its place.
>>>
>> The above is with regard to metadata I/O, whereas io_submit() is
>> obviously for user I/O.
>
>
> Won't io_submit() also trigger metadata I/O?  Or is that all deferred to
> async tasks?  I don't mind them blocking each other as long as they let my
> io_submit alone.
>
>>   io_submit() can probably block in a variety of
>> places afaict... it might have to read in the inode extent map, allocate
>> blocks, take inode/ag locks, reserve log space for transactions, etc.
>
>
> Any chance of changing all that to be asynchronous?  Doesn't sound too hard,
> if somebody else has to do it.
>
>>
>> It sounds to me that first and foremost you want to make sure you don't
>> have however many parallel operations you typically have running
>> contending on the same inodes or AGs. Hint: creating files under
>> separate subdirectories is a quick and easy way to allocate inodes under
>> separate AGs (the agno is encoded into the upper bits of the inode
>> number).
>
>
> Unfortunately our directory layout cannot be changed.  And doesn't this
> require having agcount == O(number of active files)?  That is easily in the
> thousands.

Actually, wouldn't agcount == O(nr_cpus) be good enough?

>
>>   Reducing the frequency of block allocation/frees might also be
>> another help (e.g., preallocate and reuse files,
>
>
> Isn't that discouraged for SSDs?
>
> We can do that for a subset of our files.
>
> We do use XFS_IOC_FSSETXATTR though.
>
>> 'mount -o ikeep,'
>
>
> Interesting.  Our files are large so we could try this.
>
>> etc.). Beyond that, you probably want to make sure the log is large
>> enough to support all concurrent operations. See the xfs_log_grant_*
>> tracepoints for a window into if/how long transaction reservations might
>> be waiting on the log.
>
>
> I see that on an 400G fs, the log is 180MB.  Seems plenty large for write
> operations that are mostly large sequential, though I've no real feel for
> the numbers.  Will keep an eye on this.
>
> Thanks for all the info.
>
>
>> Brian
>>
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
