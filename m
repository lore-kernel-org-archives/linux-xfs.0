Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 785707FEF
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 22:42:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 44F5B8F8035
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 20:42:06 -0700 (PDT)
Received: from mail-wi0-f171.google.com (mail-wi0-f171.google.com
	[209.85.212.171]) by cuda.sgi.com with ESMTP id
	FPqVJFNP0bGOrr80 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 20:42:04 -0700 (PDT)
Received: by mail-wi0-f171.google.com with SMTP id q5so6277464wiv.4
	for <xfs@oss.sgi.com>; Mon, 07 Apr 2014 20:42:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140408015012.GB22917@dastard>
References: <CAJhmKHmwvCBx=arJ6m2ZhuQVq=Jj-XbBGvEPjTPY5a1QtWRTCQ@mail.gmail.com>
	<20140408015012.GB22917@dastard>
Date: Mon, 7 Apr 2014 23:42:02 -0400
Message-ID: <CAJhmKHnap0vu8m4AXBxJr9L0RKoquFrm3NjKQdDBJwpRTYmfpw@mail.gmail.com>
Subject: Re: XFS fragmentation on file append
From: Keyur Govande <keyurgovande@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Apr 7, 2014 at 9:50 PM, Dave Chinner <david@fromorbit.com> wrote:
> [cc the XFS mailing list <xfs@oss.sgi.com>]
>
> On Mon, Apr 07, 2014 at 06:53:46PM -0400, Keyur Govande wrote:
>> Hello,
>>
>> I'm currently investigating a MySQL performance degradation on XFS due
>> to file fragmentation.
>>
>> The box has a 16 drive RAID 10 array with a 1GB battery backed cache
>> running on a 12 core box.
>>
>> xfs_info shows:
>> meta-data=/dev/sda4    isize=256    agcount=24, agsize=24024992 blks
>>                =                 sectsz=512   attr=2, projid32bit=0
>> data         =                 bsize=4096   blocks=576599552, imaxpct=5
>>                =                 sunit=16     swidth=512 blks
>> naming   = version 2     bsize=4096   ascii-ci=0
>> log         = internal       bsize=4096   blocks=281552, version=2
>>              =                   sectsz=512   sunit=16 blks, lazy-count=1
>> realtime = none            extsz=4096   blocks=0, rtextents=0
>>
>> The kernel version is: 3.14.0-1.el6.elrepo.x86_64 and the XFS
>> partition is mounted with: rw,noatime,allocsize=128m,inode64,swalloc.
>> The partition is 2TB in size and 40% full to simulate production.
>>
>> Here's a test program that appends 512KB like MySQL does (write and
>> then fsync). To exacerbate the issue, it loops a bunch of times:
>> https://gist.github.com/keyurdg/961c19175b81c73fdaa3
>>
>> When run, this creates ~9500 extents most of length 1024.
>
> 1024 of what? Most likely it is 1024 basic blocks, which is 512KB,
> the size of your writes.

Yeah, 1024 basic blocks of 512 bytes each.

>
> Could you post the output of the xfs_bmap commands you are using to
> get this information?

I'm getting the extent information via xfs_bmap -v <file name>. Here's
a sample: https://gist.github.com/keyurdg/291b2a429f03c9a649ad

>
>> cat'ing the
>> file to /dev/null after dropping the caches reads at an average of 75
>> MBps, way less than the hardware is capable of.
>
> What you are doing is "open-seekend-write-fsync-close".  You haven't
> told the filesystem you are doing append writes (O_APPEND, or the
> append inode flag) so it can't optimise for them.

I tried this; adding O_APPEND the the open() in the pathological
pwrite.c makes no difference to the extent allocation and hence the
read performance.

>
> You are also cleaning the file before closing it, so you are
> defeating the current heuristics that XFS uses to determine whether
> to remove speculative preallocation on close() - if the inode is
> dirty at close(), then it won't be removed. Hence speculative
> preallocation does nothing for your IO pattern (i.e. the allocsize
> mount option is completely useless). Remove the fsync and you'll
> see your fragmentation problem go away completely.

I agree, but the MySQL data files (*.ibd) on our production cluster
are appended to in bursts and they have thousands of tiny (512KB)
extents. Getting rid of fsync is not possible given the use case.

Arguably, MySQL does not close the files, but it writes out
infrequently enough that I couldn't make a good and small test case
for it. But the output of xfs_bmap is exactly the same as that of
pwrite.c

>
>> When I add a posix_fallocate before calling pwrite() as shown here
>> https://gist.github.com/keyurdg/eb504864d27ebfe7b40a the file
>> fragments an order of magnitude less (~30 extents), and cat'ing to
>> /dev/null proceeds at ~1GBps.
>
> That should make no difference on XFS as you are only preallocating
> the 512KB region beyond EOF that you are about to write into and
> hence both delayed allocation and preallocation have the same
> allocation target (the current EOF block). Hence in both cases the
> allocation patterns should be identical if the freespace extent they
> are being allocated out of are identical.
>
> Did you remove the previous test files and sync the filesystem
> between test runs so that the available freespace was identical for
> the different test runs? If you didn't then the filesystem allocated
> the files out of different free space extents and hence you'll get
> different allocation patterns...

I do clear everything and sync the FS before every run, and this is
reproducible across multiple machines in our cluster. I've re-run the
programs at least a 1000 times now, and every time get the same
results. For some reason even the tiny 512KB fallocate() seems to be
triggering some form of extent "merging" and placement.

I tried this on ext4 as well: with and without fallocate perform
exactly the same (~450 MBps), but XFS with fallocate is 2X faster (~1
GBps).

>
>> The same behavior is seen even when the allocsize option is removed
>> and the partition remounted.
>
> See above.
>
>> This is somewhat unexpected and I'm working on a patch to add
>> fallocate to MySQL, wanted to check in here if I'm missing anything
>> obvious here.
>
> fallocate() of 512KB sized regions will not prevent fragmentation
> into 512KB sized extents with the write pattern you are using.
>
> If you use the inode APPEND attribute for your log files, this lets
> the filesystem optimise it's block management for append IO. In the
> case of XFS, it then will not remove preallocation beyond EOF when
> the fd is closed because the next write will be at EOF where the
> speculative preallocation already exists. Then allocsize=128M will
> actually work for your log files....
>
> Alternatively, set an extent size hint on the log files to define
> the minimum sized allocation (e.g. 32MB) and this will limit
> fragmentation without you having to modify the MySQL code at all...
>

I tried enabling extsize to 32MB, but it seems to make no difference.

[kgovande@host]# xfs_io -c "extsize" /var/lib/mysql/xfs/plain_pwrite.werr
[33554432] /var/lib/mysql/xfs/plain_pwrite.werr
[kgovande@host]# xfs_bmap -v /var/lib/mysql/xfs/*.werr  | wc -l
20001
[kgovande@host]# sync; echo 3 > /proc/sys/vm/drop_caches; pv
plain_pwrite.werr > /dev/null
9.77GB 0:02:41 [61.7MB/s] [========================================>] 100%

# With fallocate
[kgovande@host]# xfs_bmap -v /var/lib/mysql/xfs/*.werr  | wc -l
[kgovande@host]# sync; echo 3 > /proc/sys/vm/drop_caches; pv
falloc_pwrite.werr > /dev/null
9.77GB 0:00:09 [1.03GB/s] [========================================>] 100%

> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
