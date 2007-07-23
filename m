Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jul 2007 23:36:48 -0700 (PDT)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.182])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6N6aibm010524
	for <xfs@oss.sgi.com>; Sun, 22 Jul 2007 23:36:46 -0700
Received: by wa-out-1112.google.com with SMTP id k22so2161979waf
        for <xfs@oss.sgi.com>; Sun, 22 Jul 2007 23:36:47 -0700 (PDT)
Message-ID: <5d96567b0707222309y61480271xa8220a0b179764e0@mail.gmail.com>
Date: Mon, 23 Jul 2007 09:09:03 +0300
From: Raz <raziebe@gmail.com>
Subject: Re: raid50 and 9TB volumes
In-Reply-To: <20070717005854.GL31489@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5d96567b0707160542t2144c382mbfe3da92f0990694@mail.gmail.com>
	 <20070716130140.GC31489@sgi.com>
	 <5d96567b0707160653m5951fac9v5a56bb4c92174d63@mail.gmail.com>
	 <20070716221831.GE31489@sgi.com>
	 <18076.1449.138328.66699@notabene.brown>
	 <20070717001205.GI31489@sgi.com>
	 <18076.4940.845633.149160@notabene.brown>
	 <20070717005854.GL31489@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 7/17/07, David Chinner <dgc@sgi.com> wrote:
> On Tue, Jul 17, 2007 at 10:54:36AM +1000, Neil Brown wrote:
> > On Tuesday July 17, dgc@sgi.com wrote:
> > > On Tue, Jul 17, 2007 at 09:56:25AM +1000, Neil Brown wrote:
> > > > On Tuesday July 17, dgc@sgi.com wrote:
> > > > > On Mon, Jul 16, 2007 at 04:53:22PM +0300, Raz wrote:
> > > > > >
> > > > > > Well you are right.  /proc/partitions  says:
> > > > > > ....
> > > > > >   8   241  488384001 sdp1
> > > > > >   9     1 3404964864 md1
> > > > > >   9     2 3418684416 md2
> > > > > >   9     3 6823647232 md3
> > > > > >
> > > > > > while xfs formats md3 as 9 TB.
> > ..
> > > >
> > > > If XFS is given a 6.8TB devices and formats it as 9TB, then I would be
> > > > looking at mkfs.xfs(??).
> > >
> > > mkfs.xfs tries to read the last block of the device that it is given
> > > and proceeds only if that read is successful. IOWs, mkfs.xfs has been
> > > told the size of the device is 9TB, it's successfully read from offset
> > > 9TB, so the device must be at least 9TB.
> >
> > Odd.
> > Given that the drives are 490GB, and there are 8 in a raid5 array,
> > the raid5 arrays are really under 3.5GB.  And two of them is less than
> > 7GB.  So there definitely are not 9TB worth of bytes..
> >
> > mkfs.xfs uses the BLKGETSIZE64 ioctl which returns
> > bdev->bi_inode->i_size, where as /proc/partitions uses get_capacity
> > which uses disk->capacity, so there is some room for them to return
> > different values... Except that on open, it calls
> >    bd_set_size(bdev, (loff_t)get_capacity(disk)<<9);
> > which makes sure the two have the same value.
> >
> > I cannot see where the size difference comes from.
> > What does
> >    /sbin/blockdev --getsize64
> > report for each of the different devices, as compared to what
> > /proc/partitions reports?
> And add to that the output of `xfs_growfs -n <mntpt>` so we can
> see what XFS really thinks the size of the filesystem is.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
>

My QA to re-installed the system. same kernel, different results. now,
/proc/paritions
reports :
   9     1 5114281984 md1
   9     2 5128001536 md2
   9     3 10242281472 md3

blockdev --getsize64 /dev/md3
10488096227328

but xfs keeps on crashing. when formatting it ot 6.3 TB we're OK. when
letting xfs's mkfs choose the

/dev/hda1             243M  155M   76M  68% /
/dev/hda1             243M  155M   76M  68% /
/dev/md0              1.9G   35M  1.8G   2% /d0
/dev/md3              6.3T  5.7T  593G  91% /d1


when formatting to 6.4 TB:
xfs_growfs -n ( or xfs_info ) reports:
meta-data=/dev/md3               isize=256    agcount=33, agsize=52428544 blks
              =                       sectsz=512   attr=0
data        =                       bsize=4096   blocks=1677721600, imaxpct=25
              =                       sunit=256    swidth=512 blks,
unwritten=1
naming   =   version 2        bsize=4096
log         =   internal          bsize=4096   blocks=32768, version=1
             =                        sectsz=512   sunit=0 blks
realtime =none                 extsz=2097152 blocks=0, rtextents=0

when formatting without any size argument, xfs_growfs reports:

meta-data=/dev/md3               isize=256    agcount=33, agsize=80017664 blks
              =                          sectsz=512   attr=0
data        =                           bsize=4096
blocks=2560570368, imaxpct=25
              =                          sunit=256    swidth=512 blks,
unwritten=1
naming   = version 2             bsize=4096
log         = internal               bsize=4096   blocks=32768, version=1
             =                           sectsz=512   sunit=0 blks
realtime =none                     extsz=2097152 blocks=0, rtextents=0

in this case , xfs crashes again.
[4613896.794000]  <c10d36e9> xfs_alloc_read_agf+0x199/0x220
<c10d31ea> xfs_alloc_fix_freelist+0x41a/0x4b0
[4613896.794000]  <c10d31ea> xfs_alloc_fix_freelist+0x41a/0x4b0
<c10d31ea> xfs_alloc_fix_freelist+0x41a/0x4b0
[4613896.794000]  <c1006ebc> timer_interrupt+0x6c/0xa0  <c1042e64>
__do_IRQ+0xc4/0x120
[4613896.795000]  <c100595e> do_IRQ+0x1e/0x30  <c1003aba>
common_interrupt+0x1a/0x20
[4613896.795000]  <c10d3a77> xfs_alloc_vextent+0x307/0x5b0  <c10e49fb>
xfs_bmap_btalloc+0x41b/0x980
[4613896.795000]  <c1114a46> xfs_iext_bno_to_ext+0x126/0x1d0
<c10283b6> update_wall_time_one_tick+0x6/0x80
[4613896.795000]  <c102846a> update_wall_time+0xa/0x40  <c10e9355>
xfs_bmapi+0x1495/0x18d0
[4613896.795000]  <c1114a46> xfs_iext_bno_to_ext+0x126/0x1d0
<c10e698c> xfs_bmap_search_multi_extents+0xfc/0x110
[4613896.795000]  <c1117a07> xfs_iomap_write_allocate+0x327/0x620
<c104807c> mempool_free+0x4c/0xa0
[4613896.795000]  <c104807c> mempool_free+0x4c/0xa0  <c106b3f8>
bio_fs_destructor+0x18/0x20
[4613896.795000]  <c11164a0> xfs_iomap+0x440/0x570  <c113979b>
xfs_map_blocks+0x5b/0xa0
[4613896.795000]  <c113aa3a> xfs_page_state_convert+0x46a/0x7a0
<c1044d7b> find_get_pages_tag+0x7b/0x90
[4613896.795000]  <c113add9> xfs_vm_writepage+0x69/0x100  <c108df58>
mpage_writepages+0x218/0x3f0
[4613896.795000]  <c113ad70> xfs_vm_writepage+0x0/0x100  <c104b614>
do_writepages+0x54/0x60
[4613896.795000]  <c108be86> __sync_single_inode+0x66/0x1f0
<c108c098> __writeback_single_inode+0x88/0x1b0
[4613896.795000]  <c1028120> del_timer_sync+0x10/0x20  <c1298ee0>
schedule_timeout+0x60/0xb0
[4613896.795000]  <c10288a0> process_timeout+0x0/0x10  <c108c3a7>
sync_sb_inodes+0x1e7/0x300
[4613896.795000]  <c108c595> writeback_inodes+0xd5/0xf0  <c104afc2>
balance_dirty_pages+0xd2/0x190
[4613896.795000]  <c106a07c> generic_commit_write+0x7c/0xa0
<c1046950> generic_file_buffered_write+0x310/0x6b0
[4613896.795000]  <c1082b7d> file_update_time+0x5d/0xe0  <c114366a>
xfs_write+0xc0a/0xe00
[4613896.795000]  <c1156eef> __bitmap_weight+0x5f/0x80  <c1141f47>
xfs_read+0x1a7/0x370
[4613896.795000]  <c113dc9f> xfs_file_aio_write+0x8f/0xa0  <c1065a71>
do_sync_write+0xd1/0x120
[4613896.795000]  <c1033650> autoremove_wake_function+0x0/0x60
<c1065b88> vfs_write+0xc8/0x190
[4613896.795000]  <c1065d21> sys_write+0x51/0x80  <c10030ef>
syscall_call+0x7/0xb
[root@video1 eyal_kaufer]$


-- 
Raz
