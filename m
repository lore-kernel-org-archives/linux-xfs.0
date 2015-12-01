Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4A11E7F59
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 07:58:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B1BD7AC002
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 05:58:36 -0800 (PST)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com
	[74.125.82.44]) by cuda.sgi.com with ESMTP id Cq6Ap3DB87FCYtNc
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2015 05:58:32 -0800 (PST)
Received: by wmww144 with SMTP id w144so14425571wmw.0
	for <xfs@oss.sgi.com>; Tue, 01 Dec 2015 05:58:30 -0800 (PST)
Subject: Re: sleeps and waits during io_submit
References: <CAD-J=zZh1dtJsfrW_Gwxjg+qvkZMu7ED-QOXrMMO6B-G0HY2-A@mail.gmail.com>
	<20151130141000.GC24765@bfoster.bfoster>
	<565C5D39.8080300@scylladb.com>
	<20151130161438.GD24765@bfoster.bfoster>
	<565D639F.8070403@scylladb.com>
	<20151201131114.GA26129@bfoster.bfoster>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <565DA784.5080003@scylladb.com>
Date: Tue, 1 Dec 2015 15:58:28 +0200
MIME-Version: 1.0
In-Reply-To: <20151201131114.GA26129@bfoster.bfoster>
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



On 12/01/2015 03:11 PM, Brian Foster wrote:
> On Tue, Dec 01, 2015 at 11:08:47AM +0200, Avi Kivity wrote:
>> On 11/30/2015 06:14 PM, Brian Foster wrote:
>>> On Mon, Nov 30, 2015 at 04:29:13PM +0200, Avi Kivity wrote:
>>>> On 11/30/2015 04:10 PM, Brian Foster wrote:
> ...
>>> The agsize/agcount mkfs-time heuristics change depending on the type of
>>> storage. A single AG can be up to 1TB and if the fs is not considered
>>> "multidisk" (e.g., no stripe unit/width is defined), 4 AGs is the
>>> default up to 4TB. If a stripe unit is set, the agsize/agcount is
>>> adjusted depending on the size of the overall volume (see
>>> xfsprogs-dev/mkfs/xfs_mkfs.c:calc_default_ag_geometry() for details).
>> We'll experiment with this.  Surely it depends on more than the amount of
>> storage?  If you have a high op rate you'll be more likely to excite
>> contention, no?
>>
> Sure. The absolute optimal configuration for your workload probably
> depends on more than storage size, but mkfs doesn't have that
> information. In general, it tries to use the most reasonable
> configuration based on the storage and expected workload. If you want to
> tweak it beyond that, indeed, the best bet is to experiment with what
> works.

We will do that.

>>>> Are those locks held around I/O, or just CPU operations, or a mix?
>>> I believe it's a mix of modifications and I/O, though it looks like some
>>> of the I/O cases don't necessarily wait on the lock. E.g., the AIL
>>> pushing case will trylock and defer to the next list iteration if the
>>> buffer is busy.
>>>
>> Ok.  For us sleeping in io_submit() is death because we have no other thread
>> on that core to take its place.
>>
> The above is with regard to metadata I/O, whereas io_submit() is
> obviously for user I/O.

Won't io_submit() also trigger metadata I/O?  Or is that all deferred to 
async tasks?  I don't mind them blocking each other as long as they let 
my io_submit alone.

>   io_submit() can probably block in a variety of
> places afaict... it might have to read in the inode extent map, allocate
> blocks, take inode/ag locks, reserve log space for transactions, etc.

Any chance of changing all that to be asynchronous?  Doesn't sound too 
hard, if somebody else has to do it.

>
> It sounds to me that first and foremost you want to make sure you don't
> have however many parallel operations you typically have running
> contending on the same inodes or AGs. Hint: creating files under
> separate subdirectories is a quick and easy way to allocate inodes under
> separate AGs (the agno is encoded into the upper bits of the inode
> number).

Unfortunately our directory layout cannot be changed.  And doesn't this 
require having agcount == O(number of active files)?  That is easily in 
the thousands.

>   Reducing the frequency of block allocation/frees might also be
> another help (e.g., preallocate and reuse files,

Isn't that discouraged for SSDs?

We can do that for a subset of our files.

We do use XFS_IOC_FSSETXATTR though.

> 'mount -o ikeep,'

Interesting.  Our files are large so we could try this.

> etc.). Beyond that, you probably want to make sure the log is large
> enough to support all concurrent operations. See the xfs_log_grant_*
> tracepoints for a window into if/how long transaction reservations might
> be waiting on the log.

I see that on an 400G fs, the log is 180MB.  Seems plenty large for 
write operations that are mostly large sequential, though I've no real 
feel for the numbers.  Will keep an eye on this.

Thanks for all the info.

> Brian
>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
