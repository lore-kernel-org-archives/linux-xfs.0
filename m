Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 59D5F7F3F
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 07:33:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C7D55AC00A
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 05:33:43 -0800 (PST)
Received: from mail-vc0-f178.google.com (mail-vc0-f178.google.com
	[209.85.220.178]) by cuda.sgi.com with ESMTP id
	RVR5WJtMAgOaM0Zd (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 22 Nov 2013 05:33:42 -0800 (PST)
Received: by mail-vc0-f178.google.com with SMTP id lh4so877855vcb.9
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 05:33:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131121234116.GD6502@dastard>
References: <CACtJ3HZxp6xEjY_wOucCcqX4scNzEGuiAsovQYObJS9whtYJsQ@mail.gmail.com>
	<528A5C45.4080906@redhat.com> <20131119005740.GY6188@dastard>
	<CACtJ3Ha3C7JNi5VZRnNMn+-okNheygmbj=j9AnUMvfzfZjNwug@mail.gmail.com>
	<20131121092606.GU11434@dastard>
	<CACtJ3HZAsOtmLArMWraygfQxpGymtZjr+a_reXv8o6LJzoMbvw@mail.gmail.com>
	<CACtJ3Ha5P2Heu4qiEEk6c4g+tKyR=RrD-4E-Cqj+bP8YDjKQ6w@mail.gmail.com>
	<20131121234116.GD6502@dastard>
Date: Fri, 22 Nov 2013 08:33:41 -0500
Message-ID: <CACtJ3HYSfMjThUJc+qd-qFzhkr7Wyda1CPm+BngyVm8iOcj--w@mail.gmail.com>
Subject: Re: Filesystem writes on RAID5 too slow
From: Martin Boutin <martboutin@gmail.com>
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
Cc: "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>, "Kernel.org-Linux-EXT4" <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

Dave, I just applied your patch in my vanilla 3.10.10 Linux. Here are
the new performance figures for XFS:

$ dd if=/dev/zero of=/tmp/diskmnt/filewr.zero bs=1M count=1000 oflag=direct
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 4.95292 s, 212 MB/s

: )
So things make more sense now... I hit a bug in XFS and ext3 and ufs
do not support some kind of multiblock allocation.

Thank you all,
- Martin

On Thu, Nov 21, 2013 at 6:41 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Nov 21, 2013 at 08:31:38AM -0500, Martin Boutin wrote:
>> $ uname -a
>> Linux haswell1 3.10.10 #1 SMP PREEMPT Wed Oct 2 11:22:22 CEST 2013
>> i686 GNU/Linux
>
> Oh, it's 32 bit system. Things you don't know from the obfuscating
> codenames everyone uses these days...
>
>> $ mkfs.xfs -s size=4096 -f -l size=32m /dev/md0
>> $ mount -t xfs /dev/md0 /tmp/diskmnt/
>> $ dd if=/dev/zero of=/tmp/diskmnt/filewr.zero bs=1M count=1000 oflag=direct
>> 1000+0 records in
>> 1000+0 records out
>> 1048576000 bytes (1.0 GB) copied, 28.0304 s, 37.4 MB/s
> ....
>> $ cat /proc/mounts
>> (...)
>> /dev/md0 /tmp/diskmnt xfs
>> rw,relatime,attr2,inode64,sunit=1024,swidth=2048,noquota 0 0
>
> sunit/swidth is 512k/1MB
>
>> # same layout for other disks
>> $ fdisk -c -u /dev/sda
> ....
>>    Device Boot      Start         End      Blocks   Id  System
>> /dev/sda1            2048    20565247    10281600   83  Linux
>
> Aligned to 1 MB.
>
>> /dev/sda2        20565248  1953525167   966479960   83  Linux
>
> And that isn't aligned to 1MB. 20565248 / 2048 = 10041.625. It is
> aligned to 4k, though, so there shouldn't be any hardware RMW
> cycles.
>
>> $ xfs_info /dev/md0
>> meta-data=/dev/md0               isize=256    agcount=32, agsize=15101312 blks
>>          =                       sectsz=4096  attr=2
>> data     =                       bsize=4096   blocks=483239168, imaxpct=5
>>          =                       sunit=12
>
> sunit/swidth of 512k/1MB, so it matches the MD device.
>
>> $ xfs_bmap -vvp /tmp/diskmnt/filewr.zero
>> /tmp/diskmnt/filewr.zero:
>>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET            TOTAL FLAGS
>>    0: [0..2047999]:    2049056..4097055  0 (2049056..4097055) 2048000 01111
>>  FLAG Values:
>>     010000 Unwritten preallocated extent
>>     001000 Doesn't begin on stripe unit
>>     000100 Doesn't end   on stripe unit
>>     000010 Doesn't begin on stripe width
>>     000001 Doesn't end   on stripe width
>> # this does not look good, does it?
>
> Yup, looks broken.
>
> /me digs through git.
>
> Yup, commit 27a3f8f ("xfs: introduce xfs_bmap_last_extent") broke
> the code that sets stripe unit alignment for the initial allocation
> way back in 3.2.
>
> [ Hmmm, that would explain the very occasional failure that
> generic/223 throws outi (maybe once a month I see it fail). ]
>
> Which means MD is doing RMW cycles for it's parity calculations, and
> that's where performance is going south.
>
> Current code:
>
> $ xfs_io -fd -c "truncate 0" -c "falloc 0 1g" -c "bmap -vvp" -c "pwrite 0 1g -b 1280k" testfile
> testfile:
>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET          TOTAL FLAGS
>    0: [0..2097151]:    1056..2098207     0 (1056..2098207)  2097152 11111
>  FLAG Values:
>     010000 Unwritten preallocated extent
>     001000 Doesn't begin on stripe unit
>     000100 Doesn't end   on stripe unit
>     000010 Doesn't begin on stripe width
>     000001 Doesn't end   on stripe width
> wrote 1073741824/1073741824 bytes at offset 0
> 1 GiB, 1024 ops; 0:00:02.00 (343.815 MiB/sec and 268.6054 ops/sec)
> $
>
> Which indicates that even if we take direct IO based allocation out
> of the picture, the allocation does not get aligned properly. This
> in on a 3.5TB 12 SAS disk MD RAID6 with sunit=64k,swidth=640k.
>
> With a fixed kernel:
>
> $ xfs_io -fd -c "truncate 0" -c "falloc 0 1g" -c "bmap -vvp" -c "pwrite 0 1g -b 1280k" testfile
> testfile:
>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET            TOTAL FLAGS
>    0: [0..2097151]:    6293504..8390655  0 (6293504..8390655) 2097152 10000
>  FLAG Values:
>     010000 Unwritten preallocated extent
>     001000 Doesn't begin on stripe unit
>     000100 Doesn't end   on stripe unit
>     000010 Doesn't begin on stripe width
>     000001 Doesn't end   on stripe width
> wrote 1073741824/1073741824 bytes at offset 0
> 1 GiB, 820 ops; 0:00:02.00 (415.192 MiB/sec and 332.4779 ops/sec)
> $
>
> It;s clear we have completely stripe swidth aligned allocation and it's 25% faster.
>
> Take fallocate out of the picture so the direct IO does the
> allocation:
>
> $ xfs_io -fd -c "truncate 0" -c "pwrite 0 1g -b 1280k" -c "bmap -vvp" testfile
> wrote 1073741824/1073741824 bytes at offset 0
> 1 GiB, 820 ops; 0:00:02.00 (368.241 MiB/sec and 294.8807 ops/sec)
> testfile:
>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET            TOTAL FLAGS
>    0: [0..2097151]:    2099200..4196351  0 (2099200..4196351) 2097152 00000
>  FLAG Values:
>     010000 Unwritten preallocated extent
>     001000 Doesn't begin on stripe unit
>     000100 Doesn't end   on stripe unit
>     000010 Doesn't begin on stripe width
>     000001 Doesn't end   on stripe width
>
> It's slower than with preallocation (no surprise - no allocation
> overhead per write(2) call after preallocation is done) but the
> allocation is still correctly aligned.
>
> The patch below should fix the unaligned allocation problem you are
> seeing, but because XFS defaults to stripe unit alignment for large
> allocations, you might still see RMW cycles when it aligns to a
> stripe unit that is not the first in a MD stripe. I'll have a quick
> look at fixing that behaviour when the swalloc mount option is
> specified....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
> xfs: align initial file allocations correctly.
>
> From: Dave Chinner <dchinner@redhat.com>
>
> The function xfs_bmap_isaeof() is used to indicate that an
> allocation is occurring at or past the end of file, and as such
> should be aligned to the underlying storage geometry if possible.
>
> Commit 27a3f8f ("xfs: introduce xfs_bmap_last_extent") changed the
> behaviour of this function for empty files - it turned off
> allocation alignment for this case accidentally. Hence large initial
> allocations from direct IO are not getting correctly aligned to the
> underlying geometry, and that is cause write performance to drop in
> alignment sensitive configurations.
>
> Fix it by considering allocation into empty files as requiring
> aligned allocation again.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_bmap.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
> index 3ef11b2..8401f11 100644
> --- a/fs/xfs/xfs_bmap.c
> +++ b/fs/xfs/xfs_bmap.c
> @@ -1635,7 +1635,7 @@ xfs_bmap_last_extent(
>   * blocks at the end of the file which do not start at the previous data block,
>   * we will try to align the new blocks at stripe unit boundaries.
>   *
> - * Returns 0 in bma->aeof if the file (fork) is empty as any new write will be
> + * Returns 1 in bma->aeof if the file (fork) is empty as any new write will be
>   * at, or past the EOF.
>   */
>  STATIC int
> @@ -1650,9 +1650,14 @@ xfs_bmap_isaeof(
>         bma->aeof = 0;
>         error = xfs_bmap_last_extent(NULL, bma->ip, whichfork, &rec,
>                                      &is_empty);
> -       if (error || is_empty)
> +       if (error)
>                 return error;
>
> +       if (is_empty) {
> +               bma->aeof = 1;
> +               return 0;
> +       }
> +
>         /*
>          * Check if we are allocation or past the last extent, or at least into
>          * the last delayed allocated extent.



-- 
Martin Boutin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
