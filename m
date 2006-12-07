Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Dec 2006 10:19:41 -0800 (PST)
Received: from evaldomino.Falconstor.com (mail1.falconstor.com [216.223.47.230])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB7IJTaG032200
	for <xfs@oss.sgi.com>; Thu, 7 Dec 2006 10:19:33 -0800
Message-ID: <45785ABC.20208@falconstor.com>
Date: Thu, 07 Dec 2006 13:17:32 -0500
From: "Geir A. Myrestrand" <geir.myrestrand@falconstor.com>
Reply-To: geir.myrestrand@falconstor.com
MIME-Version: 1.0
Subject: Re: New CentOS4/RHEL4-compatible xfs module rpms
References: <4560AB84.9060200@sandeen.net> <45784E71.4080605@falconstor.com> <457854CB.5030507@sandeen.net>
In-Reply-To: <457854CB.5030507@sandeen.net>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>

Eric Sandeen wrote:
> Geir A. Myrestrand wrote:
> 
>> However, I run into issues with xfs_freeze as it often locks up when I 
>> try to freeze a file system where there is I/O activity. Sometimes it 
>> happen on the first xfs_freeze invocation to freeze the file system, 
>> other times I have to unfreeze and then it happens on the second time I 
>> freeze. xfs_freeze never returns when this happens.
>>
>> Looks like xfs_io get stuck --see partial output from `ps auxf`:
>>
>> strace -ff -o freeze.txt xfs_freeze -f /mnt/xfs
>>   \_ /bin/sh -f /usr/sbin/xfs_freeze -f /mnt/xfs
>>       \_ /usr/sbin/xfs_io -r -p xfs_freeze -x -c freeze /mnt/xfs
>>
>> Anyone else encountering this issue?
>>
> 
> Did you have this problem on the previous version?
> 
> You might do sysrq-t (echo t > /proc/sysrq-trigger) and see where the
> thread is stuck.

I reproduced it and dumped the task list.

The user-mode XFS processes were:

root      2816  0.0  0.1  2812  628 pts/3    S+   12:58   0:00  | 
\_ strace -ff -o freeze.txt xfs_freeze -f /mnt/xfs
root      2847  0.0  0.2 52752 1048 pts/3    T+   12:58   0:00  | 
     \_ /bin/sh -f /usr/sbin/xfs_freeze -f /mnt/xfs
root      2891  0.0  0.1 49976  600 pts/3    D+   12:58   0:00  | 
         \_ /usr/sbin/xfs_io -r -p xfs_freeze -x -c freeze /mnt/xfs

My I/O generating processes were:

root      3832  1.9  0.2 59644 1376 pts/1    S+   12:57   0:17  | 
\_ /usr/bin/perl ./test.pl
root      2992  0.0  0.0 49912  404 pts/1    D+   12:58   0:00  | 
     \_ touch 857

Here are some relevant information from /var/log/messages (I stuck in a 
divider when I pasted in sections that weren't just right after the 
previous section):


pdflush       D ffffffff8014a190     0    48      6            50    47 
(L-TLB)
000001001f99dcb8 0000000000000046 0000000080134722 ffffffffa0054a51
        000000001f99dc30 0000000000000000 000001001fa2e310 0000000000000000
        000001001f9737f0 00000000000000d9
Call Trace:<ffffffffa0054a51>{:ext3:ext3_ordered_writepage+0}
        <ffffffffa01d96b5>{:xfs:xlog_state_sync_all+456} 
<ffffffffa01f4b9c>{:xfs:pagebuf_rele+54}
        <ffffffff8014a190>{keventd_create_kthread+0} 
<ffffffff80302637>{__down+147}
        <ffffffff80132e8d>{default_wake_function+0} 
<ffffffff80303c13>{__down_failed+53}
        <ffffffffa01e59da>{:xfs:xfs_sync+0} 
<ffffffffa01f64ad>{:xfs:.text.lock.xfs_buf+15}
        <ffffffffa01df1fa>{:xfs:xfs_getsb+37} 
<ffffffffa01e5817>{:xfs:xfs_syncsub+2507}
        <ffffffff8014a190>{keventd_create_kthread+0} 
<ffffffff8010f459>{__down_trylock+68}
        <ffffffff8014a190>{keventd_create_kthread+0} 
<ffffffffa01f347a>{:xfs:linvfs_write_super+33}
        <ffffffff8017ca9e>{sync_supers+167} 
<ffffffff8015d8e8>{wb_kupdate+36}
        <ffffffff8015e38c>{pdflush+323} <ffffffff8015d8c4>{wb_kupdate+0}
        <ffffffff8015e249>{pdflush+0} <ffffffff8014a167>{kthread+200}
        <ffffffff80110ca3>{child_rip+8} 
<ffffffff8014a190>{keventd_create_kthread+0}
        <ffffffff8014a09f>{kthread+0} <ffffffff80110c9b>{child_rip+0}

----------------------------------------------------------------------------

xfs           S 0000000000000006     0  2723      1          2742  2697 
(NOTLB)
00000100156e9d78 0000000000000002 00000100156e9d98 0000010000000074
        000001001eb87880 000001001eb878f0 000000d000000000 0000000100000246
        00000100154cc030 0000000000005f88
Call Trace:<ffffffff8013ea74>{__mod_timer+293} 
<ffffffff803039b3>{schedule_timeout+244}
        <ffffffff8013f49e>{process_timeout+0} 
<ffffffff8018902b>{do_select+939}
        <ffffffff80188bc5>{__pollwait+0} <ffffffff801893aa>{sys_select+820}
        <ffffffff801908fc>{dnotify_parent+34} 
<ffffffff80110052>{system_call+126}

----------------------------------------------------------------------------

xfslogd/0     S ffffffffa01f54b0     0  3818      6          3819  1981 
(L-TLB)
00000100104e5e68 0000000000000046 0000000000000283 0000010011a268e0
        ffffffffa01f54b0 0000000000000246 ffffffff80303cc1 00000000a01bb7a8
        0000010011d377f0 000000000000023e
Call Trace:<ffffffffa01f54b0>{:xfs:pagebuf_iodone_work+0} 
<ffffffff80303cc1>{__up_wakeup+53}
        <ffffffffa01f54b0>{:xfs:pagebuf_iodone_work+0} 
<ffffffff80146431>{worker_thread+226}
        <ffffffff80132e8d>{default_wake_function+0} 
<ffffffff80132e8d>{default_wake_function+0}
        <ffffffff8014a190>{keventd_create_kthread+0} 
<ffffffff8014634f>{worker_thread+0}
        <ffffffff8014a190>{keventd_create_kthread+0} 
<ffffffff8014a167>{kthread+200}
        <ffffffff80110ca3>{child_rip+8} 
<ffffffff8014a190>{keventd_create_kthread+0}
        <ffffffff8014a09f>{kthread+0} <ffffffff80110c9b>{child_rip+0}

xfslogd/1     S ffffffffa01f54b0     0  3819      6          3820  3818 
(L-TLB)
00000100105d7e68 0000000000000046 0000000000000287 ffffffffa01e2960
        000001000e48eb20 000001000e48eb20 0000010012d7e260 0000000100000246
        000001001053f7f0 000000000000022f
Call Trace:<ffffffffa01e2960>{:xfs:xfs_trans_delete_ail+45} 
<ffffffffa01f54b0>{:xfs:pagebuf_iodone_work+0}
        <ffffffff80146431>{worker_thread+226} 
<ffffffff80132e8d>{default_wake_function+0}
        <ffffffff80132e8d>{default_wake_function+0} 
<ffffffff8014a190>{keventd_create_kthread+0}
        <ffffffff8014634f>{worker_thread+0} 
<ffffffff8014a190>{keventd_create_kthread+0}
        <ffffffff8014a167>{kthread+200} <ffffffff80110ca3>{child_rip+8}
        <ffffffff8014a190>{keventd_create_kthread+0} 
<ffffffff8014a09f>{kthread+0}
        <ffffffff80110c9b>{child_rip+0}
xfsdatad/0    S 00000100164aa9c0     0  3820      6          3821  3819 
(L-TLB)
00000100104e1e68 0000000000000046 000000000032a7bd 000000190000006a
        000001001053e7f0 000000000000006a 0000010001707840 0000000000187397
        000001001053f030 0000000000000d8a
Call Trace:<ffffffff8014a190>{keventd_create_kthread+0} 
<ffffffff8014634f>{worker_thread+0}
        <ffffffff80146431>{worker_thread+226} 
<ffffffff80132e8d>{default_wake_function+0}
        <ffffffff80132e8d>{default_wake_function+0} 
<ffffffff8014a190>{keventd_create_kthread+0}
        <ffffffff8014634f>{worker_thread+0} 
<ffffffff8014a190>{keventd_create_kthread+0}
        <ffffffff8014a167>{kthread+200} <ffffffff80110ca3>{child_rip+8}
        <ffffffff8014a190>{keventd_create_kthread+0} 
<ffffffff8014a09f>{kthread+0}
        <ffffffff80110c9b>{child_rip+0}
xfsdatad/1    S 00000100164aaa40     0  3821      6                3820 
(L-TLB)
00000100104e3e68 0000000000000046 000000260000000a 0000001900000074
        000001001f9bd030 0000000000000074 000001000170f840 000000010032ba4b
        000001001053e7f0 0000000000000b24
Call Trace:<ffffffff8014a190>{keventd_create_kthread+0} 
<ffffffff8014634f>{worker_thread+0}
        <ffffffff80146431>{worker_thread+226} 
<ffffffff80132e8d>{default_wake_function+0}
        <ffffffff80132e8d>{default_wake_function+0} 
<ffffffff8014a190>{keventd_create_kthread+0}
        <ffffffff8014634f>{worker_thread+0} 
<ffffffff8014a190>{keventd_create_kthread+0}
        <ffffffff8014a167>{kthread+200} <ffffffff80110ca3>{child_rip+8}
        <ffffffff8014a190>{keventd_create_kthread+0} 
<ffffffff8014a09f>{kthread+0}
        <ffffffff80110c9b>{child_rip+0}
xfsbufd       S 000000010027d0c0     0  3822      1          3827  3815 
(L-TLB)
00000100111fdea8 0000000000000046 ffffffff803d9920 0000001900000073
        000001001f9bd030 0000000000000073 0000010001707840 0000000080138348
        000001001053e030 000000000000019b
Call Trace:<ffffffff8013ea74>{__mod_timer+293} 
<ffffffff803039b3>{schedule_timeout+244}
        <ffffffff8013f49e>{process_timeout+0} 
<ffffffffa01f62db>{:xfs:xfsbufd+172}
        <ffffffff80110ca3>{child_rip+8} 
<ffffffff8011de14>{flat_send_IPI_mask+0}
        <ffffffffa01f622f>{:xfs:xfsbufd+0} <ffffffff80110c9b>{child_rip+0}

xfssyncd      S ffffffffa01f36b9     0  3827      1                3822 
(L-TLB)
0000010011f0fea8 0000000000000046 ffffffffa01f36b9 0000000000000202
        ffffffff8010f459 00000100126e2d40 000001001d5e3980 0000000100000000
        000001001e4dd7f0 00000000000025eb
Call Trace:<ffffffffa01f36b9>{:xfs:linvfs_fill_super+0} 
<ffffffff8010f459>{__down_trylock+68}
        <ffffffff8013ea74>{__mod_timer+293} 
<ffffffffa01f36b9>{:xfs:linvfs_fill_super+0}
        <ffffffff803039b3>{schedule_timeout+244} 
<ffffffff8013f49e>{process_timeout+0}
        <ffffffffa01f323c>{:xfs:xfssyncd+120} 
<ffffffff80110ca3>{child_rip+8}
        <ffffffffa01f36b9>{:xfs:linvfs_fill_super+0} 
<ffffffff801cc053>{dummy_d_instantiate+0}
        <ffffffffa01f31c4>{:xfs:xfssyncd+0} <ffffffff80110c9b>{child_rip+0}

----------------------------------------------------------------------------

xfs_freeze    t 00000000006c51e0     0  2847   2816          2891 
(NOTLB)
00000100074d7e78 0000000000000002 0000010015654030 00000100111fec40
        0000000000000206 ffffffff801410a6 0000000000000011 0000000000040004
        0000010015654030 0000000000001a97
Call Trace:<ffffffff801410a6>{do_notify_parent_cldstop+243} 
<ffffffff801418d8>{ptrace_stop+315}
        <ffffffff801419c4>{ptrace_notify+139} 
<ffffffff8011419b>{syscall_trace+37}
        <ffffffff8011420f>{syscall_trace_enter+43} 
<ffffffff80110156>{tracesys+113}

xfs_io        D 00000100146af380     0  2891   2816                2847 
(NOTLB)
00000100075c9af8 0000000000000002 000001000a415b80 0000000000000064
        000000000007d000 ffffffff802499ca ffffffff80134722 00000001075c9a90
        000001000e83f7f0 0000000001a7ca67
Call Trace:<ffffffff802499ca>{generic_make_request+355} 
<ffffffff80134722>{autoremove_wake_function+0}
        <ffffffff80302637>{__down+147} 
<ffffffff80132e8d>{default_wake_function+0}
        <ffffffff80303c13>{__down_failed+53} 
<ffffffffa01f2a45>{:xfs:xfs_bdstrat_cb+0}
        <ffffffffa01f64ad>{:xfs:.text.lock.xfs_buf+15} 
<ffffffffa01f60f6>{:xfs:xfs_flush_buftarg+213}
        <ffffffffa01e59af>{:xfs:xfs_quiesce_fs+69} 
<ffffffffa01f34c1>{:xfs:linvfs_sync_super+65}
        <ffffffff80178367>{freeze_bdev+215} 
<ffffffffa01f0cd1>{:xfs:xfs_ioctl+5161}
        <ffffffff801588f0>{find_get_page+65} 
<ffffffff801593d2>{filemap_nopage+378}
        <ffffffff80131c6d>{finish_task_switch+55} 
<ffffffff80303358>{thread_return+42}
        <ffffffff8014191f>{ptrace_stop+386} 
<ffffffff801419e0>{ptrace_notify+167}
        <ffffffffa01ef380>{:xfs:linvfs_ioctl+112} 
<ffffffff80188631>{sys_ioctl+853}
        <ffffffff801101b6>{tracesys+209}
touch         D 0000000000239000     0  2992   3832 
(NOTLB)
0000010008dd76e8 0000000000000006 0000000000000001 0000000000000001
        0000000000000016 ffffffff80131931 0000000100000000 0000000000000003
        000001001ed54030 00000000000078de
Call Trace:<ffffffff80131931>{try_to_wake_up+734} 
<ffffffffa01f4dc2>{:xfs:_pagebuf_find+327}
        <ffffffff80302637>{__down+147} 
<ffffffff80132e8d>{default_wake_function+0}
        <ffffffff80303c13>{__down_failed+53} 
<ffffffffa01f64ad>{:xfs:.text.lock.xfs_buf+15}
        <ffffffffa01f4de1>{:xfs:_pagebuf_find+358} 
<ffffffffa01f5065>{:xfs:xfs_buf_get_flags+100}
        <ffffffffa01b1be0>{:xfs:xfs_bmap_search_extents+92}
        <ffffffffa01f5b01>{:xfs:xfs_buf_read_flags+16} 
<ffffffffa01e30b3>{:xfs:xfs_trans_read_buf+428}
        <ffffffffa01bc37c>{:xfs:xfs_da_do_buf+984} 
<ffffffffa01bc605>{:xfs:xfs_da_read_buf+21}
        <ffffffffa01bc87b>{:xfs:xfs_da_node_lookup_int+145}
        <ffffffffa01bc87b>{:xfs:xfs_da_node_lookup_int+145}
        <ffffffffa01c58a2>{:xfs:xfs_dir2_node_addname+83} 
<ffffffffa01d26bc>{:xfs:xfs_ichgtime+93}
        <ffffffff8018f975>{wake_up_inode+6} 
<ffffffffa01b286b>{:xfs:xfs_bmap_last_offset+179}
        <ffffffffa01c056e>{:xfs:xfs_dir2_createname+283} 
<ffffffffa01e8818>{:xfs:xfs_create+992}
        <ffffffff801cbecc>{dummy_inode_permission+0} 
<ffffffffa01f0fb7>{:xfs:linvfs_mknod+453}
        <ffffffffa01bbf7c>{:xfs:xfs_da_brelse+116} 
<ffffffffa01c6167>{:xfs:xfs_dir2_node_lookup+170}
        <ffffffffa01c042d>{:xfs:xfs_dir2_lookup+248} 
<ffffffff80184d4b>{vfs_create+214}
        <ffffffff80185179>{open_namei+430} <ffffffff80176558>{filp_open+39}
        <ffffffff801ea045>{strncpy_from_user+74} 
<ffffffff80176661>{get_unused_fd+230}
        <ffffffff80176750>{sys_open+57} <ffffffff80110052>{system_call+126}
-- 

Geir A. Myrestrand
