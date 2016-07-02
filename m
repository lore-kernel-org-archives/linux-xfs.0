Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 200C27CA2
	for <xfs@oss.sgi.com>; Sat,  2 Jul 2016 17:10:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D70D930404E
	for <xfs@oss.sgi.com>; Sat,  2 Jul 2016 15:10:50 -0700 (PDT)
Received: from mail-vk0-f41.google.com (mail-vk0-f41.google.com
	[209.85.213.41]) by cuda.sgi.com with ESMTP id qqVJmO1hJzH26Enf
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 02 Jul 2016 15:10:48 -0700 (PDT)
Received: by mail-vk0-f41.google.com with SMTP id m127so133736073vkb.3
	for <xfs@oss.sgi.com>; Sat, 02 Jul 2016 15:10:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160702220217.GA25179@birch.djwong.org>
References: <CAC5UwBi8Skjx90_XC5Z5B8P+CadawBZ3iUabKtm-2ZvrkgocZQ@mail.gmail.com>
	<20160702201249.GH4917@birch.djwong.org>
	<CAC5UwBgS-q4e9KQmHNEZ9SNDQ8G9t8=U5+-YVs9vjZ_VCGiokQ@mail.gmail.com>
	<CAC5UwBhQATvw2=nHz3ebgU04cqm=BLq0OfzE8CRSSkexcd9_eQ@mail.gmail.com>
	<20160702220217.GA25179@birch.djwong.org>
From: Nick Fisk <friskyfisk10@googlemail.com>
Date: Sat, 2 Jul 2016 23:10:46 +0100
Message-ID: <CAC5UwBjJDfO4vr9gDdCnLY5qpTECNj4e_bVv-w9JS-xqcDaqhw@mail.gmail.com>
Subject: Re: High Fragmentation with XFS and NFS Sync
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On 2 July 2016 at 23:02, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> On Sat, Jul 02, 2016 at 10:30:56PM +0100, Nick Fisk wrote:
>> On 2 July 2016 at 22:00, Nick Fisk <friskyfisk10@googlemail.com> wrote:
>> > On 2 July 2016 at 21:12, Darrick J. Wong <darrick.wong@oracle.com> wrote:
>> >> On Sat, Jul 02, 2016 at 09:52:40AM +0100, Nick Fisk wrote:
>> >>> Hi, hope someone can help me here.
>> >>>
>> >>> I'm exporting some XFS fs's to ESX via NFS with the sync option enabled. I'm
>> >>> seeing really heavy fragmentation when multiple VM's are copied onto the
>> >>> share at the same time. I'm also seeing kmem_alloc failures, which is
>> >>> probably the biggest problem as this effectively takes everything down.
>> >>
>> >> (Probably a result of loading the millions of bmbt extents into memory?)
>> >
>> > Yes I thought that was the case.
>> >
>> >>
>> >>> Underlying storage is a Ceph RBD, the server the FS is running on, is
>> >>> running kernel 4.5.7. Mount options are currently default. I'm seeing
>> >>> Millions of extents, where the ideal is listed as a couple of thousand when
>> >>> running xfs_db, there is only a couple of 100 files on the FS. It looks
>> >>> like roughly the extent sizes roughly match the IO size that the VM's were
>> >>> written to XFS with. So it looks like each parallel IO thread is being
>> >>> allocated next to each other rather than at spaced out regions of the disk.
>> >>>
>> >>> From what I understand, this is because each NFS write opens and closes the
>> >>> file which throws off any chance that XFS will be able to use its allocation
>> >>> features to stop parallel write streams from interleaving with each other.
>> >>>
>> >>> Is there anything I can tune to try and give each write to each file a
>> >>> little bit of space, so that it at least gives readahead a chance when
>> >>> reading, that it might hit at least a few MB of sequential data?
>> >>
>> >> /me wonders if setting an extent size hint on the rootdir before copying
>> >> the files over would help here...
>> >
>> > I've set a 16M hint and will copy a new VM over, interested to see
>> > what happens. Thanks for the suggestion.
>>
>> Well, I set the 16M hint at the root of the FS and proceeded to copy
>> two VM's in parallel and got this after ~30-60s. But after rebooting,
>> it looks like the extents were being allocated in larger blocks, so I
>> guess you can call it progress. Any ideas?
>
> Yikes. :(
>
> Is that with or without filestreams?

No filestreams at the moment. That was just after running xfs_io on
the root of the FS with "-D -R 16M". I realise now after re-reading
the man page I didn't need to specify it recursively to take effect on
new files/directories.

xfs_repair has just finished and it looks like the inode that had the
problem was for another file, not the two that i was copying. Output
from xfs_repair:

correcting bt key (was 1068456, now 1068420) in inode 7054483473
                data fork, btree block 882994806
bad fwd (right) sibling pointer (saw 886329853 parent block says 896589269)
        in inode 7054483473 (data fork) bmap btree block 896588736
bad data fork in inode 7054483473
cleared inode 7054483473

entry "CLI-*****-FP-000001-sesparse.vmdk" at block 0 offset 1168 in
directory inode 7054483457 references free inode 7054483473
        clearing inode number in entry at offset 1168...

So I don't know if:

1. The changing of the hint had something to do with it
2. There was a xfs_fsr still running on the FS, so this could have
been the cause, but timing seems a bit coincidental.

I've kicked off another copy and it seems to be working better now,
certainly much bigger extents, so don't know if I was just unlucky.

0: [0..32767]: 268460040..268492807 32768 blocks
        1: [32768..65535]: 268541784..268574551 32768 blocks
        2: [65536..131071]: 268591112..268656647 65536 blocks
        3: [131072..163839]: 268664960..268697727 32768 blocks
        4: [163840..229375]: 268706904..268772439 65536 blocks
        5: [229376..262143]: 268786776..268819543 32768 blocks
        6: [262144..327679]: hole 65536 blocks
        7: [327680..458751]: 268885080..269016151 131072 blocks
        8: [458752..655359]: 269025408..269222015 196608 blocks
        9: [655360..884735]: 269246080..269475455 229376 blocks
        10: [884736..950271]: 269501016..269566551 65536 blocks
        11: [950272..983039]: 269737960..269770727 32768 blocks
        12: [983040..1048575]: 269794920..269860455 65536 blocks
        13: [1048576..1114111]: 268819544..268885079 65536 blocks
        14: [1114112..1212415]: 274521984..274620287 98304 blocks
        15: [1212416..1238143]: 275996672..276022399 25728 blocks
        16: [1238144..1310719]: 276022400..276094975 72576 blocks
        17: [1310720..1376255]: 276119424..276184959 65536 blocks
        18: [1376256..1441791]: 276188416..276253951 65536 blocks
        19: [1441792..1671167]: 276282496..276511871 229376 blocks
        20: [1671168..1802239]: 277119992..277251063 131072 blocks


>
> --D
>
>>
>>
>> Jul  2 22:11:56 Proxy3 kernel: [48777.591415] XFS (rbd8): Access to
>> block zero in inode 7054483473 start_block: 0 start_off: 0 blkcnt: 0
>> extent-state: 0 lastx: 30d18
>> Jul  2 22:11:56 Proxy3 kernel: [48777.602725] XFS (rbd8): Internal
>> error XFS_WANT_CORRUPTED_GOTO at line 1947 of file
>> /home/kernel/COD/linux/fs/xfs/libxfs/xfs_bmap.c.  Caller
>> xfs_bmapi_write+0x749/0xa00 [xfs]
>> Jul  2 22:11:56 Proxy3 kernel: [48777.608381] CPU: 3 PID: 1463 Comm:
>> nfsd Tainted: G           OE   4.5.7-040507-generic #201606100436
>> Jul  2 22:11:56 Proxy3 kernel: [48777.608385] Hardware name: VMware,
>> Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS
>> 6.00 09/17/2015
>> Jul  2 22:11:56 Proxy3 kernel: [48777.608389]  0000000000000286
>> 000000008a69edda ffff8800b76fb548 ffffffff813e1173
>> Jul  2 22:11:56 Proxy3 kernel: [48777.608395]  00000000000000cc
>> ffff8800b76fb6e0 ffff8800b76fb560 ffffffffc07ad60c
>> Jul  2 22:11:56 Proxy3 kernel: [48777.608399]  ffffffffc077c959
>> ffff8800b76fb658 ffffffffc0777a13 ffff8802116c9000
>> Jul  2 22:11:56 Proxy3 kernel: [48777.608403] Call Trace:
>> Jul  2 22:11:56 Proxy3 kernel: [48777.608471]  [<ffffffff813e1173>]
>> dump_stack+0x63/0x90
>> Jul  2 22:11:56 Proxy3 kernel: [48777.608566]  [<ffffffffc07ad60c>]
>> xfs_error_report+0x3c/0x40 [xfs]
>> Jul  2 22:11:56 Proxy3 kernel: [48777.608620]  [<ffffffffc077c959>] ?
>> xfs_bmapi_write+0x749/0xa00 [xfs]
>> Jul  2 22:11:56 Proxy3 kernel: [48777.608669]  [<ffffffffc0777a13>]
>> xfs_bmap_add_extent_delay_real+0x883/0x1ce0 [xfs]
>> Jul  2 22:11:56 Proxy3 kernel: [48777.608721]  [<ffffffffc077c959>]
>> xfs_bmapi_write+0x749/0xa00 [xfs]
>> Jul  2 22:11:56 Proxy3 kernel: [48777.608777]  [<ffffffffc07b8a8d>]
>> xfs_iomap_write_allocate+0x16d/0x380 [xfs]
>> Jul  2 22:11:56 Proxy3 kernel: [48777.608822]  [<ffffffffc07a25d3>]
>> xfs_map_blocks+0x173/0x240 [xfs]
>> Jul  2 22:11:56 Proxy3 kernel: [48777.608871]  [<ffffffffc07a33a8>]
>> xfs_vm_writepage+0x198/0x660 [xfs]
>> Jul  2 22:11:56 Proxy3 kernel: [48777.608902]  [<ffffffff811993a3>]
>> __writepage+0x13/0x30
>> Jul  2 22:11:56 Proxy3 kernel: [48777.608908]  [<ffffffff81199efe>]
>> write_cache_pages+0x1fe/0x530
>> Jul  2 22:11:56 Proxy3 kernel: [48777.608912]  [<ffffffff81199390>] ?
>> wb_position_ratio+0x1f0/0x1f0
>> Jul  2 22:11:56 Proxy3 kernel: [48777.608961]  [<ffffffffc07bbbaa>] ?
>> xfs_iunlock+0xea/0x120 [xfs]
>> Jul  2 22:11:56 Proxy3 kernel: [48777.608970]  [<ffffffff8119a281>]
>> generic_writepages+0x51/0x80
>> Jul  2 22:11:56 Proxy3 kernel: [48777.609019]  [<ffffffffc07a31c3>]
>> xfs_vm_writepages+0x53/0xa0 [xfs]
>> Jul  2 22:11:56 Proxy3 kernel: [48777.609028]  [<ffffffff8119c73e>]
>> do_writepages+0x1e/0x30
>> Jul  2 22:11:56 Proxy3 kernel: [48777.609048]  [<ffffffff8118f516>]
>> __filemap_fdatawrite_range+0xc6/0x100
>> Jul  2 22:11:56 Proxy3 kernel: [48777.609053]  [<ffffffff8118f691>]
>> filemap_write_and_wait_range+0x41/0x90
>> Jul  2 22:11:56 Proxy3 kernel: [48777.609103]  [<ffffffffc07af7d3>]
>> xfs_file_fsync+0x63/0x210 [xfs]
>> Jul  2 22:11:56 Proxy3 kernel: [48777.609130]  [<ffffffff81249e9b>]
>> vfs_fsync_range+0x4b/0xb0
>> Jul  2 22:11:56 Proxy3 kernel: [48777.609156]  [<ffffffffc04b856d>]
>> nfsd_vfs_write+0x14d/0x380 [nfsd]
>> Jul  2 22:11:56 Proxy3 kernel: [48777.609176]  [<ffffffffc04babf0>]
>> nfsd_write+0x120/0x2f0 [nfsd]
>> Jul  2 22:11:56 Proxy3 kernel: [48777.609190]  [<ffffffffc04c105c>]
>> nfsd3_proc_write+0xbc/0x150 [nfsd]
>> Jul  2 22:11:56 Proxy3 kernel: [48777.609207]  [<ffffffffc04b3348>]
>> nfsd_dispatch+0xb8/0x200 [nfsd]
>> Jul  2 22:11:56 Proxy3 kernel: [48777.609243]  [<ffffffffc03cd21c>]
>> svc_process_common+0x40c/0x650 [sunrpc]
>> Jul  2 22:11:56 Proxy3 kernel: [48777.609267]  [<ffffffffc03ce5c3>]
>> svc_process+0x103/0x1b0 [sunrpc]
>> Jul  2 22:11:56 Proxy3 kernel: [48777.609286]  [<ffffffffc04b2d8f>]
>> nfsd+0xef/0x160 [nfsd]
>> Jul  2 22:11:56 Proxy3 kernel: [48777.609297]  [<ffffffffc04b2ca0>] ?
>> nfsd_destroy+0x60/0x60 [nfsd]
>> Jul  2 22:11:56 Proxy3 kernel: [48777.609322]  [<ffffffff810a06a8>]
>> kthread+0xd8/0xf0
>> Jul  2 22:11:56 Proxy3 kernel: [48777.609329]  [<ffffffff810a05d0>] ?
>> kthread_create_on_node+0x1a0/0x1a0
>> Jul  2 22:11:56 Proxy3 kernel: [48777.609369]  [<ffffffff81825bcf>]
>> ret_from_fork+0x3f/0x70
>> Jul  2 22:11:56 Proxy3 kernel: [48777.609374]  [<ffffffff810a05d0>] ?
>> kthread_create_on_node+0x1a0/0x1a0
>> Jul  2 22:11:56 Proxy3 kernel: [48777.609444] XFS (rbd8): Internal
>> error xfs_trans_cancel at line 990 of file
>> /home/kernel/COD/linux/fs/xfs/xfs_trans.c.  Caller
>> xfs_iomap_write_allocate+0x270/0x380 [xfs]
>>
>> >
>> >>
>> >> --D
>> >>
>> >>>
>> >>> I have read that inode32 allocates more randomly compared to inode64, so I'm
>> >>> not sure if it's worth trying this as there will likely be less than a 1000
>> >>> files per FS.
>> >>>
>> >>> Or am I best just to run fsr after everything has been copied on?
>> >>>
>> >>> Thanks for any advice
>> >>> Nick
>> >>
>> >>> _______________________________________________
>> >>> xfs mailing list
>> >>> xfs@oss.sgi.com
>> >>> http://oss.sgi.com/mailman/listinfo/xfs
>> >>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
