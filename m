Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 04D3B7F3F
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 18:35:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A88768F8040
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 16:35:39 -0700 (PDT)
Received: from mail-wi0-f169.google.com (mail-wi0-f169.google.com
	[209.85.212.169]) by cuda.sgi.com with ESMTP id
	b5waheKB8q33ryGs (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 16:35:37 -0700 (PDT)
Received: by mail-wi0-f169.google.com with SMTP id hm4so3794979wib.0
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 16:35:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140408053117.GJ27017@dastard>
References: <CAJhmKHmwvCBx=arJ6m2ZhuQVq=Jj-XbBGvEPjTPY5a1QtWRTCQ@mail.gmail.com>
	<20140408015012.GB22917@dastard>
	<CAJhmKHnap0vu8m4AXBxJr9L0RKoquFrm3NjKQdDBJwpRTYmfpw@mail.gmail.com>
	<20140408053117.GJ27017@dastard>
Date: Tue, 22 Apr 2014 19:35:34 -0400
Message-ID: <CAJhmKHk5fWVaDTEfL_oESULspavk83eBEsyw7=qEp8bC7f2S2g@mail.gmail.com>
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

On Tue, Apr 8, 2014 at 1:31 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Apr 07, 2014 at 11:42:02PM -0400, Keyur Govande wrote:
>> On Mon, Apr 7, 2014 at 9:50 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > [cc the XFS mailing list <xfs@oss.sgi.com>]
>> >
>> > On Mon, Apr 07, 2014 at 06:53:46PM -0400, Keyur Govande wrote:
>> >> Hello,
>> >>
>> >> I'm currently investigating a MySQL performance degradation on XFS due
>> >> to file fragmentation.
>> >>
>> >> The box has a 16 drive RAID 10 array with a 1GB battery backed cache
>> >> running on a 12 core box.
>> >>
>> >> xfs_info shows:
>> >> meta-data=/dev/sda4    isize=256    agcount=24, agsize=24024992 blks
>> >>                =                 sectsz=512   attr=2, projid32bit=0
>> >> data         =                 bsize=4096   blocks=576599552, imaxpct=5
>> >>                =                 sunit=16     swidth=512 blks
>> >> naming   = version 2     bsize=4096   ascii-ci=0
>> >> log         = internal       bsize=4096   blocks=281552, version=2
>> >>              =                   sectsz=512   sunit=16 blks, lazy-count=1
>> >> realtime = none            extsz=4096   blocks=0, rtextents=0
>> >>
>> >> The kernel version is: 3.14.0-1.el6.elrepo.x86_64 and the XFS
>> >> partition is mounted with: rw,noatime,allocsize=128m,inode64,swalloc.
>> >> The partition is 2TB in size and 40% full to simulate production.
>> >>
>> >> Here's a test program that appends 512KB like MySQL does (write and
>> >> then fsync). To exacerbate the issue, it loops a bunch of times:
>> >> https://gist.github.com/keyurdg/961c19175b81c73fdaa3
>> >>
>> >> When run, this creates ~9500 extents most of length 1024.
>> >
>> > 1024 of what? Most likely it is 1024 basic blocks, which is 512KB,
>> > the size of your writes.
>>
>> Yeah, 1024 basic blocks of 512 bytes each.
>>
>> >
>> > Could you post the output of the xfs_bmap commands you are using to
>> > get this information?
>>
>> I'm getting the extent information via xfs_bmap -v <file name>. Here's
>> a sample: https://gist.github.com/keyurdg/291b2a429f03c9a649ad
>
> Yup, looks like fragmented free space so it's only finding islands
> of 512kb of freespace near to the inode to allocate out of.
>
> Can you post the output of /proc/mounts so I can check what the
> allocator behaviour is being used?
>
>> >> cat'ing the
>> >> file to /dev/null after dropping the caches reads at an average of 75
>> >> MBps, way less than the hardware is capable of.
>> >
>> > What you are doing is "open-seekend-write-fsync-close".  You haven't
>> > told the filesystem you are doing append writes (O_APPEND, or the
>> > append inode flag) so it can't optimise for them.
>>
>> I tried this; adding O_APPEND the the open() in the pathological
>> pwrite.c makes no difference to the extent allocation and hence the
>> read performance.
>
> Yeah, I had a look at what XFS does and in the close path it doesn't
> know that the FD was O_APPEND because that state is available to the
> ->release path.
>
>> > You are also cleaning the file before closing it, so you are
>> > defeating the current heuristics that XFS uses to determine whether
>> > to remove speculative preallocation on close() - if the inode is
>> > dirty at close(), then it won't be removed. Hence speculative
>> > preallocation does nothing for your IO pattern (i.e. the allocsize
>> > mount option is completely useless). Remove the fsync and you'll
>> > see your fragmentation problem go away completely.
>>
>> I agree, but the MySQL data files (*.ibd) on our production cluster
>> are appended to in bursts and they have thousands of tiny (512KB)
>> extents. Getting rid of fsync is not possible given the use case.
>
> Sure - just demonstrating that it's the fsync that is causing the
> problems. i.e. it's application driven behaviour that the filesystem
> can't easily detect and optimise...
>
>> Arguably, MySQL does not close the files, but it writes out
>> infrequently enough that I couldn't make a good and small test case
>> for it. But the output of xfs_bmap is exactly the same as that of
>> pwrite.c
>
> Once you've fragmented free space, the only way to defrag it is to
> remove whatever is using the space between the small freespace
> extents. Usually the condition occurs when you intermix long lived
> files with short lived files - removing the short lived files
> results in fragmented free space that cannot be made contiguous
> until both the short lived and long lived data has been removed.
>
> If you want an idea of whether you've fragmented free space, use
> the xfs_db freespace command. To see what each ag looks like
> (change it to iterate all the ags in your fs):
>
> $ for i in 0 1 2 3; do echo "*** AG $i:" ; sudo xfs_db -c "freesp -a $i -s" /dev/vda; done
> *** AG 0:
>    from      to extents  blocks    pct
>       1       1     129     129   0.02
>       2       3     119     283   0.05
>       4       7     125     641   0.11
>       8      15      93     944   0.16
>      16      31      64    1368   0.23
>      32      63      53    2300   0.39
>      64     127      21    1942   0.33
>     128     255      16    3145   0.53
>     256     511       6    1678   0.28
>     512    1023       1     680   0.11
>   16384   32767       1   23032   3.87
>  524288 1048576       1  558825  93.93
> total free extents 629
> total free blocks 594967
> average free extent size 945.893
> *** AG 1:
>    from      to extents  blocks    pct
>       1       1     123     123   0.01
>       2       3     125     305   0.04
>       4       7      79     418   0.05
> ......
>
> And that will tell us what state your filesystem is in w.r.t.
> freespace fragmentation...
>
>> >> When I add a posix_fallocate before calling pwrite() as shown here
>> >> https://gist.github.com/keyurdg/eb504864d27ebfe7b40a the file
>> >> fragments an order of magnitude less (~30 extents), and cat'ing to
>> >> /dev/null proceeds at ~1GBps.
>> >
>> > That should make no difference on XFS as you are only preallocating
>> > the 512KB region beyond EOF that you are about to write into and
>> > hence both delayed allocation and preallocation have the same
>> > allocation target (the current EOF block). Hence in both cases the
>> > allocation patterns should be identical if the freespace extent they
>> > are being allocated out of are identical.
>> >
>> > Did you remove the previous test files and sync the filesystem
>> > between test runs so that the available freespace was identical for
>> > the different test runs? If you didn't then the filesystem allocated
>> > the files out of different free space extents and hence you'll get
>> > different allocation patterns...
>>
>> I do clear everything and sync the FS before every run, and this is
>> reproducible across multiple machines in our cluster.
>
> Which indicates that you've probably already completely fragmented
> free space in the filesystems.
>
>> I've re-run the
>> programs at least a 1000 times now, and every time get the same
>> results. For some reason even the tiny 512KB fallocate() seems to be
>> triggering some form of extent "merging" and placement.
>
> Both methods of allocation shoul dbe doing the same thing - they use
> exactly the same algorithm to select the next extent to allocate.
> Can you tell me the:
>
>         a) inode number of each of the target files that show
>         different output
>         b) the xfs_bmap output of the different files.
>
>> > Alternatively, set an extent size hint on the log files to define
>> > the minimum sized allocation (e.g. 32MB) and this will limit
>> > fragmentation without you having to modify the MySQL code at all...
>> >
>>
>> I tried enabling extsize to 32MB, but it seems to make no difference.
>> [kgovande@host]# xfs_io -c "extsize" /var/lib/mysql/xfs/plain_pwrite.werr
>> [33554432] /var/lib/mysql/xfs/plain_pwrite.werr
>> [kgovande@host]# xfs_bmap -v /var/lib/mysql/xfs/*.werr  | wc -l
>> 20001
>> [kgovande@host]# sync; echo 3 > /proc/sys/vm/drop_caches; pv
>> plain_pwrite.werr > /dev/null
>> 9.77GB 0:02:41 [61.7MB/s] [========================================>] 100%
>
> Ah, extent size hints are not being considered in
> xfs_can_free_eofblocks(). I suspect they should be, and that would
> fix the problem.
>
> Can you add this to xfs_can_free_eofblocks() in your kernel and see
> what happens?
>
>
>         /* prealloc/delalloc exists only on regular files */
>         if (!S_ISREG(ip->i_d.di_mode))
>                 return false;
>
> +       if (xfs_get_extsz_hint(ip))
> +               return false;
> +
>         /*
>          * Zero sized files with no cached pages and delalloc blocks will not
>          * have speculative prealloc/delalloc blocks to remove.
>          */
>
> If that solves the problem, then I suspect that we might need to
> modify this code to take into account the allocsize mount option as
> well...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

Hey Dave,

I spent some more time figuring out the MySQL write semantics and it
doesn't open/close files often and initial test script was incorrect.

It uses O_DIRECT and appends to the file; I modified my test binary to
take this into account here:
https://gist.github.com/keyurdg/54e0613e27dbe7946035

I've been testing on the 3.10 kernel. The set up is a empty 2 TB XFS partition.
[root@dbtest09 linux-3.10.37]# xfs_info /dev/sda4
meta-data=/dev/sda4              isize=256    agcount=24, agsize=24024992 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=576599552, imaxpct=5
         =                       sunit=16     swidth=512 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=281552, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

[root@dbtest09 linux-3.10.37]# cat /proc/mounts
rootfs / rootfs rw 0 0
proc /proc proc rw,relatime 0 0
sysfs /sys sysfs rw,relatime 0 0
devtmpfs /dev devtmpfs
rw,relatime,size=49573060k,nr_inodes=12393265,mode=755 0 0
devpts /dev/pts devpts rw,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /dev/shm tmpfs rw,relatime 0 0
/dev/sda2 / ext3
rw,noatime,errors=continue,user_xattr,acl,barrier=1,data=ordered 0 0
/dev/sda1 /boot ext3
rw,relatime,errors=continue,user_xattr,acl,barrier=1,data=ordered 0 0
none /proc/sys/fs/binfmt_misc binfmt_misc rw,relatime 0 0
/dev/sda4 /var/lib/mysql xfs
rw,noatime,swalloc,attr2,inode64,logbsize=64k,sunit=128,swidth=4096,noquota
0 0

[root@dbtest09 linux-3.10.37]# xfs_io -c "extsize " /var/lib/mysql/xfs/
[0] /var/lib/mysql/xfs/

Here's how the first 3 AG's look like:
https://gist.github.com/keyurdg/82b955fb96b003930e4f

After a run of the dpwrite program, here's how the bmap looks like:
https://gist.github.com/keyurdg/11196897

The files have nicely interleaved with each other, mostly
XFS_IEXT_BUFSZ size extents. The average read speed is 724 MBps. After
defragmenting the file to 1 extent, the speed improves 30% to 1.09
GBps.

I noticed that XFS chooses the AG based on the parent directory's AG
and only the next sequential one if there's no space available. A
small patch that chooses the AG randomly fixes the fragmentation issue
very nicely. All of the MySQL data files are in a single directory and
we see this in Production where a parent inode AG is filled, then the
sequential next, and so on.

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index c8f5ae1..7841509 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -517,7 +517,7 @@ xfs_ialloc_ag_select(
         * to mean that blocks must be allocated for them,
         * if none are currently free.
         */
-       agno = pagno;
+       agno = ((xfs_agnumber_t) prandom_u32()) % agcount;
        flags = XFS_ALLOC_FLAG_TRYLOCK;
        for (;;) {
                pag = xfs_perag_get(mp, agno);

I couldn't find guidance on the internet on how many allocation groups
to use for a 2 TB partition, but this random selection won't scale for
many hundreds of concurrently written files, but for a few heavily
writtent-to files it works nicely.

I noticed that for non-DIRECT_IO + every write fsync'd, XFS would
cleverly keep doubling the allocation block size as the file kept
growing.

The "extsize" option seems to me a bit too static because the size of
tables we use varies widely and large new tables come and go.

Could the same doubling logic be applied for DIRECT_IO writes as well?
I tried out this extremely rough patch based on the delayed write
code; if you think this is reasonable I can try to make it more
acceptable. It provides very nice performance indeed, for a 2GB file,
here's how the bmap looks like:
https://gist.github.com/keyurdg/ac6ed8536f864c8fffc8

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 8f8aaee..2682f53 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -118,6 +118,16 @@ xfs_alert_fsblock_zero(
        return EFSCORRUPTED;
 }

+STATIC int
+xfs_iomap_eof_want_preallocate(
+       xfs_mount_t     *mp,
+       xfs_inode_t     *ip,
+       xfs_off_t       offset,
+       size_t          count,
+       xfs_bmbt_irec_t *imap,
+       int             nimaps,
+       int             *prealloc);
+
 int
 xfs_iomap_write_direct(
        xfs_inode_t     *ip,
@@ -152,7 +162,32 @@ xfs_iomap_write_direct(
        offset_fsb = XFS_B_TO_FSBT(mp, offset);
        last_fsb = XFS_B_TO_FSB(mp, ((xfs_ufsize_t)(offset + count)));
        if ((offset + count) > XFS_ISIZE(ip)) {
-               error = xfs_iomap_eof_align_last_fsb(mp, ip, extsz, &last_fsb);
+               xfs_extlen_t    new_extsz = extsz;
+
+               if (!extsz) {
+                       int prealloc;
+                       xfs_bmbt_irec_t prealloc_imap[XFS_WRITE_IMAPS];
+
+                       error = xfs_iomap_eof_want_preallocate(mp, ip,
offset, count,
+                                               prealloc_imap,
XFS_WRITE_IMAPS, &prealloc);
+
+                       if (prealloc) {
+                               xfs_fileoff_t   temp_start_fsb;
+                               int             temp_imaps = 1;
+
+                               temp_start_fsb = XFS_B_TO_FSB(mp, offset);
+                               if (temp_start_fsb)
+                                       temp_start_fsb--;
+
+                               error = xfs_bmapi_read(ip,
temp_start_fsb, 1, prealloc_imap, &temp_imaps, XFS_BMAPI_ENTIRE);
+                               if (error)
+                                       return XFS_ERROR(error);
+
+                               new_extsz = prealloc_imap[0].br_blockcount << 1;
+                       }
+               }
+
+               error = xfs_iomap_eof_align_last_fsb(mp, ip,
new_extsz, &last_fsb);
                if (error)
                        return XFS_ERROR(error);
        } else {

Cheers,
Keyur.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
