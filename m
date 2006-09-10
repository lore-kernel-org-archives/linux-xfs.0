Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 10 Sep 2006 16:36:16 -0700 (PDT)
Received: from rapidforum.com (www.rapidforum.com [80.237.244.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8ANa8DW019605
	for <xfs@oss.sgi.com>; Sun, 10 Sep 2006 16:36:09 -0700
Message-ID: <4504A12C.9090608@rapidforum.com>
Date: Mon, 11 Sep 2006 01:35:08 +0200
From: Christian Schmid <webmaster@rapidforum.com>
MIME-Version: 1.0
Subject: Re: Critical xfs bug in 2.6.17.11?
References: <4504151F.6050704@rapidforum.com> <Pine.LNX.4.64.0609101731150.29937@p34.internal.lan> <45048E1E.6040002@rapidforum.com> <Pine.LNX.4.64.0609101835390.29937@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0609101835390.29937@p34.internal.lan>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

I am using www.linuxfromscratch.org. Kernel is vanilla 2.6.17.11 from kernel.org, xfsprogs is 2.7.3, 
libc is 2.3.3. I was not doing anything special. In fact its a heavy-duty tmpfs with up to 300 
write-streams at once, reads and deletes. So basically a heavy stress-test on a SMP. Maybe a 
race-condition? Pure speculations from my side. But memory is ok. Memory-test with ECC disabled ran 
through 12 hours without any errors. ECC is on now of course, so the possibility of a simple 
hardware problem is eliminated from my side.

Justin Piszcz wrote:
> ACK, scary, will wait for Nathan Scott's/other SGI members reply on this 
> one...
> 
> I have not had that happen to me yet, what were you doing that caused 
> the problem? Is it repeatable?  Have you checked the XFS FAQ for the FS 
> fix for 2.6.17-17.6? just to check if there is indeed any problems 
> (basically an xfs check on your FS), if you do it, dont use knoppix 
> 5.0.2 (contains the 2.6.17 XFS corruption bug), use 4.0.2.
> 
> Justin.
> 
> On Mon, 11 Sep 2006, Christian Schmid wrote:
> 
>> This file-system was created 2 days before with the same kernel.
>>
>> Justin Piszcz wrote:
>>
>>> I hope this is not a repeat of 2.6.17 -> 2.6.17.6..
>>>
>>> $ grep -i xfs ChangeLog-2.6.17.*
>>> ChangeLog-2.6.17.7:    XFS: corruption fix
>>> ChangeLog-2.6.17.7:    check in xfs_dir2_leafn_remove() fails every 
>>> time and xfs_dir2_shrink_inode()
>>>
>>> It appears the only changes to the XFS code though went into 2.6.17.7 
>>> so I am not sure what you are seeing there, had you fixed your 
>>> filesystem from the 2.6.17 -> .17.6 bug?
>>>
>>> Justin.
>>>
>>> On Sun, 10 Sep 2006, Christian Schmid wrote:
>>>
>>>> Hello.
>>>>
>>>> Instead of a tmpfs, I use a raid 10 softraid. Unfortunately it 
>>>> crashed after 10 hours of extreme activities (read/block-writes with 
>>>> up to 250 streams/deletes)
>>>>
>>>> 12 gb memory-test successful. 2 cpu xeon smp system.
>>>>
>>>> Tell me if this helps you:
>>>>
>>>> Sep  9 18:08:49 inode430 kernel: [87433.143498] 0x0: 58 41 47 46 00 
>>>> 00 00 01 00 00 00 00 00 04 34 a0 Sep  9 18:08:49 inode430 kernel: 
>>>> [87433.143672] Filesystem "md5": XFS internal error 
>>>> xfs_alloc_read_agf at line 2176 of file fs/xfs/xfs_alloc.c. Caller 
>>>> 0xfffffff
>>>> f80314069 Sep  9 18:08:49 inode430 kernel: [87433.143904] Sep  9 
>>>> 18:08:49 inode430 kernel: [87433.143905] Call Trace: 
>>>> <ffffffff8033c909>{xfs_corruption_error+244}
>>>> Sep  9 18:08:49 inode430 kernel: [87433.143995] 
>>>> <ffffffff80346efa>{xfs_iext_insert+65} 
>>>> <ffffffff803588d1>{xfs_trans_read_buf+203}
>>>> Sep  9 18:08:49 inode430 kernel: [87433.144353] 
>>>> <ffffffff803121d9>{xfs_alloc_read_agf+281} 
>>>> <ffffffff80314069>{xfs_alloc_fix_freelist+356}
>>>> Sep  9 18:08:49 inode430 kernel: [87433.144628] 
>>>> <ffffffff80314069>{xfs_alloc_fix_freelist+356} 
>>>> <ffffffff80515a1f>{__down_read+18} Sep  9 18:08:49 inode430 kernel: 
>>>> [87433.144855] <ffffffff8031450f>{xfs_alloc_vextent+289} 
>>>> <ffffffff80323945>{xfs_bmapi+4061}
>>>> Sep  9 18:08:49 inode430 kernel: [87433.145091] 
>>>> <ffffffff803215ba>{xfs_bmap_search_multi_extents+175} Sep  9 
>>>> 18:08:49 inode430 kernel: [87433.145226] 
>>>> <ffffffff80349aad>{xfs_iomap_write_allocate+675} 
>>>> <ffffffff80348c29>{xfs_iomap+701} Sep  9 18:08:49 inode430 kernel: 
>>>> [87433.145473] <ffffffff803797f1>{generic_make_request+515} 
>>>> <ffffffff803632f3>{xfs_map_blocks+67}
>>>> Sep  9 18:08:49 inode430 kernel: [87433.145846] 
>>>> <ffffffff80363a09>{xfs_page_state_convert+722} 
>>>> <ffffffff80364344>{xfs_vm_writepage+179} Sep  9 18:08:49 inode430 
>>>> kernel: [87433.146079] <ffffffff802986ed>{mpage_writepages+459} 
>>>> <ffffffff80364291>{xfs_vm_writepage+0}
>>>> Sep  9 18:08:49 inode430 kernel: [87433.146330] 
>>>> <ffffffff802553c1>{do_writepages+41} 
>>>> <ffffffff80296de0>{__writeback_single_inode+559}
>>>> Sep  9 18:08:49 inode430 kernel: [87433.146583] 
>>>> <ffffffff8022a82c>{default_wake_function+0} 
>>>> <ffffffff8022a82c>{default_wake_function+0}
>>>> Sep  9 18:08:49 inode430 kernel: [87433.146847] 
>>>> <ffffffff80357f56>{xfs_trans_first_ail+28} 
>>>> <ffffffff802974be>{sync_sb_inodes+501}
>>>> Sep  9 18:08:49 inode430 kernel: [87433.147230] 
>>>> <ffffffff802444b4>{keventd_create_kthread+0} 
>>>> <ffffffff802977cd>{writeback_inodes+144}
>>>> Sep  9 18:08:49 inode430 kernel: [87433.147463] 
>>>> <ffffffff802551fc>{wb_kupdate+148} <ffffffff80255bfd>{pdflush+313}
>>>> Sep  9 18:08:49 inode430 kernel: [87433.147825] 
>>>> <ffffffff80255168>{wb_kupdate+0} <ffffffff80255ac4>{pdflush+0}
>>>> Sep  9 18:08:49 inode430 kernel: [87433.148142] 
>>>> <ffffffff80244479>{kthread+218} <ffffffff8020a992>{child_rip+8}
>>>> Sep  9 18:08:49 inode430 kernel: [87433.148420] 
>>>> <ffffffff802444b4>{keventd_create_kthread+0} 
>>>> <ffffffff8024439f>{kthread+0}
>>>> Sep  9 18:08:49 inode430 kernel: [87433.148775] 
>>>> <ffffffff8020a98a>{child_rip+0} Sep  9 18:08:49 inode430 kernel: 
>>>> [87433.149105] Filesystem "md5": XFS internal error xfs_trans_cancel 
>>>> at line 1150 of file fs/xfs/xfs_trans.c. Caller 0xffffffff8
>>>> 0349bf8 Sep  9 18:08:49 inode430 kernel: [87433.149262] Sep  9 
>>>> 18:08:49 inode430 kernel: [87433.149263] Call Trace: 
>>>> <ffffffff803574e9>{xfs_trans_cancel+111} Sep  9 18:08:49 inode430 
>>>> kernel: [87433.149348] 
>>>> <ffffffff80349bf8>{xfs_iomap_write_allocate+1006} 
>>>> <ffffffff80348c29>{xfs_iomap+701} Sep  9 18:08:49 inode430 kernel: 
>>>> [87433.149568] <ffffffff803797f1>{generic_make_request+515} 
>>>> <ffffffff803632f3>{xfs_map_blocks+67}
>>>> Sep  9 18:08:49 inode430 kernel: [87433.149847] 
>>>> <ffffffff80363a09>{xfs_page_state_convert+722} 
>>>> <ffffffff80364344>{xfs_vm_writepage+179} Sep  9 18:08:49 inode430 
>>>> kernel: [87433.150169] <ffffffff802986ed>{mpage_writepages+459} 
>>>> <ffffffff80364291>{xfs_vm_writepage+0}
>>>> Sep  9 18:08:49 inode430 kernel: [87433.150435] 
>>>> <ffffffff802553c1>{do_writepages+41} 
>>>> <ffffffff80296de0>{__writeback_single_inode+559}
>>>> Sep  9 18:08:49 inode430 kernel: [87433.150593] 
>>>> <ffffffff8022a82c>{default_wake_function+0} 
>>>> <ffffffff8022a82c>{default_wake_function+0}
>>>> Sep  9 18:08:49 inode430 kernel: [87433.150807] 
>>>> <ffffffff80357f56>{xfs_trans_first_ail+28} 
>>>> <ffffffff802974be>{sync_sb_inodes+501}
>>>> Sep  9 18:08:49 inode430 kernel: [87433.151042] 
>>>> <ffffffff802444b4>{keventd_create_kthread+0} 
>>>> <ffffffff802977cd>{writeback_inodes+144}
>>>> Sep  9 18:08:49 inode430 kernel: [87433.151271] 
>>>> <ffffffff802551fc>{wb_kupdate+148} <ffffffff80255bfd>{pdflush+313}
>>>> Sep  9 18:08:49 inode430 kernel: [87433.151439] 
>>>> <ffffffff80255168>{wb_kupdate+0} <ffffffff80255ac4>{pdflush+0}
>>>> Sep  9 18:08:49 inode430 kernel: [87433.151680] 
>>>> <ffffffff80244479>{kthread+218} <ffffffff8020a992>{child_rip+8}
>>>> Sep  9 18:08:49 inode430 kernel: [87433.151922] 
>>>> <ffffffff802444b4>{keventd_create_kthread+0} 
>>>> <ffffffff8024439f>{kthread+0}
>>>> Sep  9 18:08:49 inode430 kernel: [87433.152086] 
>>>> <ffffffff8020a98a>{child_rip+0} Sep  9 18:08:49 inode430 kernel: 
>>>> [87433.152489] xfs_force_shutdown(md5,0x8) called from line 1151 of 
>>>> file fs/xfs/xfs_trans.c.  Return address = 0xffffffff80357507
>>>> Sep  9 18:08:49 inode430 kernel: [87433.168623] Filesystem "md5": 
>>>> Corruption of in-memory data detected.  Shutting down filesystem: md5
>>>> Sep  9 18:08:49 inode430 kernel: [87433.168903] Please umount the 
>>>> filesystem, and rectify the problem(s)
>>>>
>>>>
>>>>
>>>
>>>
>>
>>
> 
> 
