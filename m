Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CB09A7F5E
	for <xfs@OSS.SGI.com>; Thu, 23 Oct 2014 11:20:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9D0A48F804C
	for <xfs@OSS.SGI.com>; Thu, 23 Oct 2014 09:20:44 -0700 (PDT)
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com
	[66.111.4.25]) by cuda.sgi.com with ESMTP id ykD793YgYf5upNQt
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@OSS.SGI.com>; Thu, 23 Oct 2014 09:20:39 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by gateway2.nyi.internal (Postfix) with ESMTP id F2F9B20A44
	for <xfs@OSS.SGI.com>; Thu, 23 Oct 2014 12:20:38 -0400 (EDT)
Message-ID: <54492AD5.3040704@fastmail.fm>
Date: Thu, 23 Oct 2014 18:20:37 +0200
From: Bernd Schubert <bernd.schubert@fastmail.fm>
MIME-Version: 1.0
Subject: Re: Problem about very high Average Read/Write Request Time
References: <CALSoAzD4ccHXBuD6mT3ggqMf1j_kDEK-RNMOeRLq+N+NiWVQXg@mail.gmail.com>	<20141018143848.3baf3266@galadriel.home>	<21571.36364.518119.806191@tree.ty.sabi.co.uk>	<5444C122.4080104@fastmail.fm>
	<21574.42382.795064.152229@tree.ty.sabi.co.uk>
In-Reply-To: <21574.42382.795064.152229@tree.ty.sabi.co.uk>
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
To: Peter Grandi <pg@xfs.list.sabi.co.UK>, Linux fs XFS <xfs@OSS.SGI.com>, quanjun hu <huquanjun@gmail.com>

On 10/21/2014 08:27 PM, Peter Grandi wrote:
>>> [ ... ]  supposed to hold the object storage layer of a BeeFS
>>> highly parallel filesystem, and therefore will likely have
>>> mostly-random accesses.
> 
>> Where do you get the assumption from that FhGFS/BeeGFS is
>> going to do random reads/writes or the application of top of
>> it is going to do that?
> 
> In this specific case it is not an assumption, thanks to the
> prominent fact that the original poster was testing (locally I
> guess) and complaining about concurrent read/writes, which
> result in random like arm movement even if each of the read and
> write streams are entirely sequential. I even pointed this out,
> probably not explicitly enough:
> 
>   >> when doing only reading / only writing , the speed is very
>   >> fast(~1.5G), but when do both the speed is very slow
>   >> (100M), and high r_await(160) and w_await(200000).

The OP is trying to figure out what is going on. Low speed and high
latencies are not sufficient information to speculate about the cause.

> 
>   BTW the 100MB/s aggregate over 31 drives means around 3MB/s
>   per drive, which seems pretty good for a RW workload with
>   mostly-random accesses with high RMW correlation.

The op did not provide sufficient information about the IO pattern to
know if there is RMW or random access involved.

> 
> Also if this testing was appropriate then it was because the
> intended workload was indeed concurrent reads and writes to the
> object store.
> 
> It is not a mere assumption in the general case either; it
> is both commonly observed and a simple deduction, because of
> the nature of distributed filesystems and in particular parallel
> HPC ones like Lustre or BeeGFS, but also AFS and even NFS ones.
> 
> * Clients have caches. Therefore most of the locality in the

Correct is: Client *might* have caches. Besides of application directio,
for BeeGFS the cache type is a configuration option.

>   (read) access patterns will hopefully be filtered out by the
>   client cache. This applies (ideally) to any distributed
>   filesystem.

You cannot filter out everything, e.g. random reads of a large file.
Local or remote file system does not matter here.

> * HPC/parallel servers tend to whave many clients (e.g. for an
>   it could be 10,000 clients and 500 object storage servers) and
>   hopefully each client works on a different subset of the data
>   tree, and distribution of data objects onto servers hopefully
>   random.
>   Therefore it is likely that many clients will access with
>   concurrent read and write many different files on the same
>   server resulting in many random "hotspots" in each server's
>   load.

If that would be important here there would be no difference between
single write and parallel read/write. So irrelevant.

>   Note that each client could be doing entirely sequential IO to
>   each file they access, but the concurrent accesses do possibly
>   widely scattered files will turn that into random IO at the
>   server level.

How does this matter if the op is comparing 1-thread write vs. 2-thread
read/write?

> 
> Just about the only case where sequential client workloads don't
> become random workloads at the server is when the client
> workload is such that only one file is "hot" per server.
> 
> There is an additional issue favouring random access patterns:
> 
>   * Typically large fileservers are setup with a lot of storage
>     because of anticipated lifetime usage, so they start mostly
>     empty.
>   * Most filesystems then allocate new data in regular patterns,
>     often starting from the beginning of available storage, in
>     an attempt to minimize arm travel time usually (XFS uses
>     various heuristics, which are somewhat different whether the
>     option 'inode64' is specified or not).
>   * Unfortunately as the filetree becomes larger new allocations
>     have to be made farther away, resulting in longer travel
>     times and more apparent randomness at the storage server
>     level.
>   * Eventually if the object server reaches a steady state where
>     roughly as much data is deleted and created the free storage
>     areas will become widely scattered, leading to essentially
>     random allocation, the more random the more capacity used.

All of that is irrelevant if a single write is fast and a parallel
read/write is slow.

> 
>   Leaving a significant percentage of capacity free, like at
>   least 10% and more like 20%, greatly increases the chance of
>   finding free space near to put new data near to existing
>   "related" data. This increases locality, but only at the
>   single-stream level; therefore is usually does not help that
>   much widely shared distributed servers; and in particular does
>   not apply that much to object stores, because usually they
>   obscure which data object is related to which data object.
> 
> The above issues are pretty much "network and distributed
> filesystems for beginners" notes, but in significant part also
> apply to widely shared non network and non distributed servers
> on which XFS is often used, so they may be usefully mentioned
> in this list.

It is lots of text and does not help the op at all. And the
claim/speculation that the parallel file system would introduce random
access is also wrong.


Before anyone can even start to speculate, the op first needs to provide
the exact IO pattern and information about /dev/sdc.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
