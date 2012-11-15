Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAF8W1SK248089 for <xfs@oss.sgi.com>; Thu, 15 Nov 2012 02:32:02 -0600
Received: from galenis.iv.lt (galenis.iv.lt [195.14.170.242]) by cuda.sgi.com
	with ESMTP id oLCcgdqSZ7OH9dOo (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 00:34:05 -0800 (PST)
Received: from fwdr-2.fwdr-0.fwdr-168.fwdr-192 ([192.168.0.2]
	helo=galenis.iv.lt) by galenis.iv.lt with esmtp (Exim 4.72)
	(envelope-from <linas.j@iv.lt>) id 1TYute-00052N-OJ
	for xfs@oss.sgi.com; Thu, 15 Nov 2012 10:34:02 +0200
Message-ID: <50A4A8FA.30403@iv.lt>
Date: Thu, 15 Nov 2012 10:34:02 +0200
From: Linas Jankauskas <linas.j@iv.lt>
MIME-Version: 1.0
Subject: Re: Slow performance after ~4.5TB
References: <50A0AFD5.2020607@iv.lt> <20121112090448.GS24575@dastard>
	<50A0C590.6020602@iv.lt> <20121112123222.GT24575@dastard>
	<50A10077.2060908@iv.lt> <20121112223623.GV24575@dastard>
	<50A20F53.80405@iv.lt> <20121114211356.GJ1710@dastard>
In-Reply-To: <20121114211356.GJ1710@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Ok,

thanks for your help.
We will try to make 200 allocation groups and enable inode64 option. 
Hope it will solve a problem.

Thanks
Linas

On 11/14/2012 11:13 PM, Dave Chinner wrote:
> On Tue, Nov 13, 2012 at 11:13:55AM +0200, Linas Jankauskas wrote:
>> trace-cmd output was about 300mb, so im pasting first 100 lines of
>> it, is it enough?:
> ....
>>
>> Rsync command:
>>
>> /usr/bin/rsync -e ssh -c blowfish -a --inplace --numeric-ids
>> --hard-links --ignore-errors --delete --force
>
> Ok, so you are overwriting in place and deleting files/dirs that
> don't exist anymore. And they are all small files.
>
>> xfs_bmap on one random file:
>>
>>   EXT: FILE-OFFSET      BLOCK-RANGE              AG AG-OFFSET
>> TOTAL FLAGS
>>     0: [0..991]:        26524782560..26524783551 12 (754978880..754979871)   992 00000
>>
>> xfs_db -r -c "frag" /dev/sda5
>> actual 81347252, ideal 80737778, fragmentation factor 0.75%
>
> And that indicates file fragmentation is not an issue.
>>
>>
>> agno: 0
>
> Not too bad.
>
>> agno: 1
>>
>>     from      to extents  blocks    pct
>>        1       1   74085   74085   0.05
>>        2       3   97017  237788   0.15
>>        4       7  165766  918075   0.59
>>        8      15 2557055 35731152  22.78
>
> And there's the problem. Free space is massively fragmented in the
> 8-16 block size (32-64k) range. All the other AGs show the same
> pattern:
>
>>        8      15 2477693 34631683  18.51
>>        8      15 2479273 34656696  20.37
>>        8      15 2440290 34132542  20.51
>>        8      15 2461646 34419704  20.38
>>        8      15 2463571 34439233  21.06
>>        8      15 2487324 34785498  19.92
>>        8      15 2474275 34589732  19.85
>>        8      15 2438528 34100460  20.69
>>        8      15 2467056 34493555  20.04
>>        8      15 2457983 34364055  20.14
>>        8      15 2438076 34112592  22.48
>>        8      15 2465147 34481897  19.79
>>        8      15 2466844 34492253  21.44
>>        8      15 2445986 34205258  21.35
>>        8      15 2436154 34060275  19.60
>>        8      15 2438373 34082653  20.59
>>        8      15 2435860 34057838  21.01
>
> Given the uniform distribution of the freespace fragmentation, the
> problem is most likely the fact you are using the inode32 allocator.
>
> What is does is keep inodes in AG 0 (below 1TB) and rotor's data
> extents across all other AGs. Hence AG 0 has a different freespace
> pattern because it mainly contains metadata. The data AGs are
> showing the signs of files with no reference locality being packed
> adjacent to each other when written, then randomly removed, which
> leaves a swiss-cheese style of freespace fragmentation.
>
> The result is freespace btrees that are much, much larger than
> usual, and each AG is being randomly accessed by each userspace
> process. This leads to long lock hold times during searches, and
> access from multiple CPUs at once slows things down and adds to lock
> contention.
>
> It appears that the threshold that limits performance for your
> workload and configuration is around 2.5million freespace extents in
> a single size range. most likely it is a linear scan of duplicate
> sizes trying to find the best block number match that is chewing up
> all the CPU. That's roughly what the event trace shows.
>
> I don't think you can fix a filesystem once it's got into this
> state. It's aged severely and the only way to fix freespace
> fragmentation is to remove files from the filesystem. In this case,
> mkfs.xfs is going to be the only sane way to do that, because it's
> much faster than removing 90million inodes...
>
> So, how to prevent it from happening again on a new filesystem?
>
> Using the inode64 allocator should prevent this freespace
> fragmentation from happening. It allocates file data in the same AG
> as the inode and inodes are grouped in an AG based on the parent
> directory location. Directory inodes are rotored across AGs to
> spread them out. The way it searches for free space for new files is
> different, too, and will tend to fill holes near to the inode before
> searching wider. Hence it's a much more local search, and it will
> fill holes created by deleting files/dirs much faster, leaving less
> swiss chess freespace fragmentation around.
>
> The other thing is that if you have lots of rsyncs running at once
> is increase the number of AGs to reduce their size. More AGs will
> increase allocation parallelism, reducing contention, and also
> reducing the size of each free space trees if freespace
> fragmentation does occur. Given you are tracking lots of small
> files, (90 million inodes so far), I'd suggest increase the number
> of AGs by an order of magnitude so that the size drops from 1TB down
> to 100GB. Even if freespace fragmentation then does occur, it is
> Spread over 10x the number of freespace trees, and hence will have
> significantly less effect on performance.
>
> FWIW, you probably also want to set allocsize=4k as well, as you
> don't need specualtive EOF preallocation on your workload to avoid
> file fragmentation....
>
> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
