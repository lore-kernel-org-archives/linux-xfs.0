Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 340627F3F
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 03:59:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9F714AC002
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 01:59:46 -0700 (PDT)
Received: from smtp1.ispfabriek.nl (smtp1.ispfabriek.nl [37.251.0.168]) by
	cuda.sgi.com with ESMTP id bMe9IjT5nlztR263 for
	<xfs@oss.sgi.com>; Tue, 25 Mar 2014 01:59:43 -0700 (PDT)
Message-ID: <5331456E.8010201@1st-setup.nl>
Date: Tue, 25 Mar 2014 09:59:26 +0100
From: "Michel Verbraak(1st-Setup)" <info@1st-setup.nl>
MIME-Version: 1.0
Subject: Re: xfs blocks (blocked for more than 120 seconds)
References: <532FF9DD.5080700@1st-setup.nl>
	<20140324173636.GD18572@destitution>
In-Reply-To: <20140324173636.GD18572@destitution>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7384924300485465615=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============7384924300485465615==
Content-Type: multipart/alternative;
 boundary="------------040304010601080400030508"

This is a multi-part message in MIME format.
--------------040304010601080400030508
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

op 24-03-14 18:36, Dave Chinner schreef:
> On Mon, Mar 24, 2014 at 10:24:45AM +0100, Michel Verbraak(1st-Setup) wrote:
>> Hi,
>>
>> We have a problem with one of our systems which is using XFS but we are
>> unable to find the problem. Recently we had two moments, Tuesday 4th of
>> March and Friday the 21st of March, where we had to reboot the system to
>> get it up and running again.
>>
>> What happens:
>> - The programs handling files on the XFS disc stop working when
>> creating, deleting or writing files. They do not error they are just
>> waiting on the command to complete.
>> - One of our programs, a java application, goes into very high cpu usage
>> (50%) which normally is at 1%. This could be something in our java
>> application but it happens at the moment handling files gets stuck.
>> - A nice restart of the programs does not succeed as wel a kill -9 does
>> not work.
>> - Trying to reboot the servers in a normal fashion does not work. As it
>> is a virtual machine we have to do a shutdown (unplug power) and start
>> it up again to get it up and running.
> ......
>> Following details I have for you:
>>
>> System OS: Ubuntu 12.04 LTS
>> Kernel: 3.2.0-37-generic #58-Ubuntu SMP Thu Jan 24 15:28:10 UTC 2013
>> x86_64 x86_64 x86_64 GNU/Linux
>> Server: Virtual machine in a VMWare setup.
>> Disc: 300GB direct attached LUN
>>
>> We have an exact clone of this system for our acceptance environment. In
>> this environment we are unable to reproduce this problem/situation.
>>
>> Differences between the two days is that our services on 2014-03-21 were
>> quit busy with a lot of file changes on the xfs disc and on 2014-03-04
>> the system was very quiet on the moment the kernel traces appear and the
>> services get stuck.
>>
>> Any help is appreciated.
>>
>> Regards Michel Verbraak.
>>
>> Following we see in the syslog on both moments (2014-03-04 and 2014-03-21):
>>
> ....
>> Mar 21 06:32:20 ealxs00169 kernel: [1412280.930543] flush-8:16      D
>> 0000000000000000     0 13864      2 0x00000000
>> [<ffffffff8165b34f>] schedule+0x3f/0x60
>> [<ffffffff8165b3ff>] io_schedule+0x8f/0xd0
>> [<ffffffff8111836e>] sleep_on_page+0xe/0x20
>> [<ffffffff8165baca>] __wait_on_bit_lock+0x5a/0xc0
>> [<ffffffff81118357>] __lock_page+0x67/0x70
>> [<ffffffff81122bd4>] write_cache_pages+0x3d4/0x460
>> [<ffffffff81122caa>] generic_writepages+0x4a/0x70
>> [<ffffffffa007980d>] xfs_vm_writepages+0x4d/0x60 [xfs]
>> [<ffffffff81123b71>] do_writepages+0x21/0x40
>> [<ffffffff811a2990>] writeback_single_inode+0x180/0x430
>> [<ffffffff811a3056>] writeback_sb_inodes+0x1b6/0x270
>> [<ffffffff811a31ae>] __writeback_inodes_wb+0x9e/0xd0
>> [<ffffffff811a345b>] wb_writeback+0x27b/0x330
>> [<ffffffff811a35af>] wb_check_old_data_flush+0x9f/0xb0
>> [<ffffffff811a4481>] wb_do_writeback+0x151/0x1d0
>> [<ffffffff811a4583>] bdi_writeback_thread+0x83/0x2a0
>> [<ffffffff8108b27c>] kthread+0x8c/0xa0
> Writeback is blocked on a locked page, and is waiting for IO
> completion.
>
>
>> Mar 21 06:34:20 ealxs00169 kernel: [1412400.891181] archiver.pl     D
>> [<ffffffff8165b34f>] schedule+0x3f/0x60
>> [<ffffffff8165b995>] schedule_timeout+0x2a5/0x320
>> [<ffffffff8165c5f0>] __down_common+0xa5/0xf5
>> [<ffffffff8165c6b3>] __down+0x1d/0x1f
>> [<ffffffff810912e1>] down+0x41/0x50
>> [<ffffffffa007c0f4>] xfs_buf_lock+0x44/0x110 [xfs]
>> [<ffffffffa007c295>] _xfs_buf_find+0xd5/0x240 [xfs]
>> [<ffffffffa007c684>] xfs_buf_get+0x34/0x1c0 [xfs]
>> [<ffffffffa007cf2d>] xfs_buf_read+0x2d/0x120 [xfs]
>> [<ffffffffa00d89ff>] xfs_trans_read_buf+0x2bf/0x470 [xfs]
>> [<ffffffffa0094775>] xfs_read_agf+0x65/0x1a0 [xfs]
>> [<ffffffffa00948e2>] xfs_alloc_read_agf+0x32/0x60 [xfs]
>> [<ffffffffa00966ff>] xfs_alloc_fix_freelist+0x42f/0x490 [xfs]
>> [<ffffffffa0096802>] xfs_free_extent+0xa2/0x120 [xfs]
>> [<ffffffffa00a6e14>] xfs_bmap_finish+0x164/0x1b0 [xfs]
>> [<ffffffffa00c143b>] xfs_itruncate_extents+0xdb/0x1e0 [xfs]
>> [<ffffffffa00c15a6>] xfs_itruncate_data+0x66/0x150 [xfs]
>> [<ffffffffa009056e>] xfs_inactive+0x2fe/0x460 [xfs]
>> [<ffffffffa008afad>] xfs_fs_evict_inode+0xad/0x110 [xfs]
>> [<ffffffff81193e98>] evict+0xb8/0x1c0
>> [<ffffffff81194088>] iput_final+0xe8/0x210
>> [<ffffffff811941ee>] iput+0x3e/0x50
>> [<ffffffff81188be3>] do_unlinkat+0x153/0x1d0
>> [<ffffffff811897b6>] sys_unlink+0x16/0x20
>> [<ffffffff81665842>] system_call_fastpath+0x16/0x1b
> 120s later, unlinking a file, blocked waiting on an AGF lock.
>
>> Mar 21 06:34:20 ealxs00169 kernel: [1412400.891686] flush-8:16      D
> writeback again, 120s later.
>
>> Mar 21 06:36:20 ealxs00169 kernel: [1412520.861471] java            D
>> [<ffffffff8165b995>] schedule_timeout+0x2a5/0x320
>> [<ffffffff8165c5f0>] __down_common+0xa5/0xf5
>> [<ffffffff8165c6b3>] __down+0x1d/0x1f
>> [<ffffffff810912e1>] down+0x41/0x50
>> [<ffffffffa007c0f4>] xfs_buf_lock+0x44/0x110 [xfs]
>> [<ffffffffa007c295>] _xfs_buf_find+0xd5/0x240 [xfs]
>> [<ffffffffa007c684>] xfs_buf_get+0x34/0x1c0 [xfs]
>> [<ffffffffa007cf2d>] xfs_buf_read+0x2d/0x120 [xfs]
>> [<ffffffffa00d89ff>] xfs_trans_read_buf+0x2bf/0x470 [xfs]
>> [<ffffffffa0094775>] xfs_read_agf+0x65/0x1a0 [xfs]
>> [<ffffffffa00948e2>] xfs_alloc_read_agf+0x32/0x60 [xfs]
>> [<ffffffffa00966ff>] xfs_alloc_fix_freelist+0x42f/0x490 [xfs]
>> [<ffffffffa0096a4b>] xfs_alloc_vextent+0x1cb/0x690 [xfs]
>> [<ffffffffa00a02c1>] xfs_bmap_btalloc+0x2b1/0x770 [xfs]
>> [<ffffffffa00a07a4>] xfs_bmap_alloc+0x24/0x40 [xfs]
>> [<ffffffffa00a594e>] xfs_bmapi_allocate+0xce/0x2d0 [xfs]
>> [<ffffffffa00a85c3>] xfs_bmapi_write+0x4c3/0x720 [xfs]
>> [<ffffffffa0086988>] xfs_iomap_write_allocate+0x178/0x330 [xfs]
>> [<ffffffffa00799c3>] xfs_map_blocks+0x183/0x250 [xfs]
>> [<ffffffffa007aa56>] xfs_vm_writepage+0x196/0x510 [xfs]
>> [<ffffffff81122217>] __writepage+0x17/0x40
>> [<ffffffff81122a0d>] write_cache_pages+0x20d/0x460
>> [<ffffffff81122caa>] generic_writepages+0x4a/0x70
>> [<ffffffffa007980d>] xfs_vm_writepages+0x4d/0x60 [xfs]
>> [<ffffffff81123b71>] do_writepages+0x21/0x40
>> [<ffffffff81119f2b>] __filemap_fdatawrite_range+0x5b/0x60
>> [<ffffffff81119f82>] filemap_write_and_wait_range+0x52/0x80
>> [<ffffffffa007f05d>] xfs_file_fsync+0x5d/0x300 [xfs]
>> [<ffffffff811a7eb6>] do_fsync+0x56/0x80
>> [<ffffffff811a81e0>] sys_fsync+0x10/0x20
>> [<ffffffff81665842>] system_call_fastpath+0x16/0x1b
> 120s later, fsync() blocks and AGF lock trying to do allocation.
>
>> Mar 21 06:36:20 ealxs00169 kernel: [1412520.862112] archiver.pl     D
>> [<ffffffff8165b34f>] schedule+0x3f/0x60
>> [<ffffffff8165b995>] schedule_timeout+0x2a5/0x320
>> [<ffffffff8165c5f0>] __down_common+0xa5/0xf5
>> [<ffffffff8165c6b3>] __down+0x1d/0x1f
>> [<ffffffff810912e1>] down+0x41/0x50
>> [<ffffffffa007c0f4>] xfs_buf_lock+0x44/0x110 [xfs]
>> [<ffffffffa007c295>] _xfs_buf_find+0xd5/0x240 [xfs]
>> [<ffffffffa007c684>] xfs_buf_get+0x34/0x1c0 [xfs]
>> [<ffffffffa007cf2d>] xfs_buf_read+0x2d/0x120 [xfs]
>> [<ffffffffa00d89ff>] xfs_trans_read_buf+0x2bf/0x470 [xfs]
>> [<ffffffffa0094775>] xfs_read_agf+0x65/0x1a0 [xfs]
>> [<ffffffffa00948e2>] xfs_alloc_read_agf+0x32/0x60 [xfs]
>> [<ffffffffa00966ff>] xfs_alloc_fix_freelist+0x42f/0x490 [xfs]
>> [<ffffffffa0096802>] xfs_free_extent+0xa2/0x120 [xfs]
>> [<ffffffffa00a6e14>] xfs_bmap_finish+0x164/0x1b0 [xfs]
>> [<ffffffffa00c143b>] xfs_itruncate_extents+0xdb/0x1e0 [xfs]
>> [<ffffffffa00c15a6>] xfs_itruncate_data+0x66/0x150 [xfs]
>> [<ffffffffa009056e>] xfs_inactive+0x2fe/0x460 [xfs]
>> [<ffffffffa008afad>] xfs_fs_evict_inode+0xad/0x110 [xfs]
>> [<ffffffff81193e98>] evict+0xb8/0x1c0
>> [<ffffffff81194088>] iput_final+0xe8/0x210
>> [<ffffffff811941ee>] iput+0x3e/0x50
>> [<ffffffff81188be3>] do_unlinkat+0x153/0x1d0
>> [<ffffffff811897b6>] sys_unlink+0x16/0x20
>> [<ffffffff81665842>] system_call_fastpath+0x16/0x1b
> Still blocked on AGF in unlink.
>
>
>> Mar 21 06:38:20 ealxs00169 kernel: [1412640.821037] java            D
>> [<ffffffff8165b34f>] schedule+0x3f/0x60
>> [<ffffffff8165c157>] __mutex_lock_slowpath+0xd7/0x150
>> [<ffffffff8165bd6a>] mutex_lock+0x2a/0x50
>> [<ffffffff81188b1e>] do_unlinkat+0x8e/0x1d0
>> [<ffffffff811897b6>] sys_unlink+0x16/0x20
>> [<ffffffff81665842>] system_call_fastpath+0x16/0x1b
> 120s later, unlink blocked on a directory mutex.
>
> (others stuck on AGF lock).
>
>> From this moment on the services are not working anymore. Complete stuck.
> Yup, everything is stuck waiting for writeback to complete.
>
> can you reproduce this? does the IO subsystem go idle when this
> occurs? or is it running flat out?
We are not yet able to reproduce. But your added explanation might help
us in reproducing. The production environment is very dynamic in when
clients connect to the service and what kind of requests they do.

The colleague handling the incident tried to get some info but because
he was alarmed quit late he decided for the reboot instead to get our
production qorking again. For the next time we are preparing some
scripts to gather information which might tell more.
If you have any suggestions on commands we can run when it happens again
please let me know? Currently we are configuring kdump as suggested by
Mark and some other queries against our own software.
> Cheers,
>
> Dave.
Some extra info: this system has been running for about 1 year without
any problems. During this time it was never rebooted or restarted until
the issue on the 4th. Only change could be in the usage of java service
running on it by external clients. We are looking into this.

Thank you for looking into it.

Michel.

--------------040304010601080400030508
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta content="text/html; charset=ISO-8859-1"
      http-equiv="Content-Type">
  </head>
  <body text="#666666" bgcolor="#FFFFFF">
    <div class="moz-cite-prefix">op 24-03-14 18:36, Dave Chinner
      schreef:<br>
    </div>
    <blockquote cite="mid:20140324173636.GD18572@destitution"
      type="cite">
      <pre wrap="">On Mon, Mar 24, 2014 at 10:24:45AM +0100, Michel Verbraak(1st-Setup) wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="">Hi,

We have a problem with one of our systems which is using XFS but we are
unable to find the problem. Recently we had two moments, Tuesday 4th of
March and Friday the 21st of March, where we had to reboot the system to
get it up and running again.

What happens:
- The programs handling files on the XFS disc stop working when
creating, deleting or writing files. They do not error they are just
waiting on the command to complete.
- One of our programs, a java application, goes into very high cpu usage
(50%) which normally is at 1%. This could be something in our java
application but it happens at the moment handling files gets stuck.
- A nice restart of the programs does not succeed as wel a kill -9 does
not work.
- Trying to reboot the servers in a normal fashion does not work. As it
is a virtual machine we have to do a shutdown (unplug power) and start
it up again to get it up and running.
</pre>
      </blockquote>
      <pre wrap="">......
</pre>
      <blockquote type="cite">
        <pre wrap="">
Following details I have for you:

System OS: Ubuntu 12.04 LTS
Kernel: 3.2.0-37-generic #58-Ubuntu SMP Thu Jan 24 15:28:10 UTC 2013
x86_64 x86_64 x86_64 GNU/Linux
Server: Virtual machine in a VMWare setup.
Disc: 300GB direct attached LUN

We have an exact clone of this system for our acceptance environment. In
this environment we are unable to reproduce this problem/situation.

Differences between the two days is that our services on 2014-03-21 were
quit busy with a lot of file changes on the xfs disc and on 2014-03-04
the system was very quiet on the moment the kernel traces appear and the
services get stuck.

Any help is appreciated.

Regards Michel Verbraak.

Following we see in the syslog on both moments (2014-03-04 and 2014-03-21):

</pre>
      </blockquote>
      <pre wrap="">....
</pre>
      <blockquote type="cite">
        <pre wrap="">Mar 21 06:32:20 ealxs00169 kernel: [1412280.930543] flush-8:16      D
0000000000000000     0 13864      2 0x00000000
[&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60
[&lt;ffffffff8165b3ff&gt;] io_schedule+0x8f/0xd0
[&lt;ffffffff8111836e&gt;] sleep_on_page+0xe/0x20
[&lt;ffffffff8165baca&gt;] __wait_on_bit_lock+0x5a/0xc0
[&lt;ffffffff81118357&gt;] __lock_page+0x67/0x70
[&lt;ffffffff81122bd4&gt;] write_cache_pages+0x3d4/0x460
[&lt;ffffffff81122caa&gt;] generic_writepages+0x4a/0x70
[&lt;ffffffffa007980d&gt;] xfs_vm_writepages+0x4d/0x60 [xfs]
[&lt;ffffffff81123b71&gt;] do_writepages+0x21/0x40
[&lt;ffffffff811a2990&gt;] writeback_single_inode+0x180/0x430
[&lt;ffffffff811a3056&gt;] writeback_sb_inodes+0x1b6/0x270
[&lt;ffffffff811a31ae&gt;] __writeback_inodes_wb+0x9e/0xd0
[&lt;ffffffff811a345b&gt;] wb_writeback+0x27b/0x330
[&lt;ffffffff811a35af&gt;] wb_check_old_data_flush+0x9f/0xb0
[&lt;ffffffff811a4481&gt;] wb_do_writeback+0x151/0x1d0
[&lt;ffffffff811a4583&gt;] bdi_writeback_thread+0x83/0x2a0
[&lt;ffffffff8108b27c&gt;] kthread+0x8c/0xa0
</pre>
      </blockquote>
      <pre wrap="">
Writeback is blocked on a locked page, and is waiting for IO
completion.


</pre>
      <blockquote type="cite">
        <pre wrap="">Mar 21 06:34:20 ealxs00169 kernel: [1412400.891181] archiver.pl     D
[&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60
[&lt;ffffffff8165b995&gt;] schedule_timeout+0x2a5/0x320
[&lt;ffffffff8165c5f0&gt;] __down_common+0xa5/0xf5
[&lt;ffffffff8165c6b3&gt;] __down+0x1d/0x1f
[&lt;ffffffff810912e1&gt;] down+0x41/0x50
[&lt;ffffffffa007c0f4&gt;] xfs_buf_lock+0x44/0x110 [xfs]
[&lt;ffffffffa007c295&gt;] _xfs_buf_find+0xd5/0x240 [xfs]
[&lt;ffffffffa007c684&gt;] xfs_buf_get+0x34/0x1c0 [xfs]
[&lt;ffffffffa007cf2d&gt;] xfs_buf_read+0x2d/0x120 [xfs]
[&lt;ffffffffa00d89ff&gt;] xfs_trans_read_buf+0x2bf/0x470 [xfs]
[&lt;ffffffffa0094775&gt;] xfs_read_agf+0x65/0x1a0 [xfs]
[&lt;ffffffffa00948e2&gt;] xfs_alloc_read_agf+0x32/0x60 [xfs]
[&lt;ffffffffa00966ff&gt;] xfs_alloc_fix_freelist+0x42f/0x490 [xfs]
[&lt;ffffffffa0096802&gt;] xfs_free_extent+0xa2/0x120 [xfs]
[&lt;ffffffffa00a6e14&gt;] xfs_bmap_finish+0x164/0x1b0 [xfs]
[&lt;ffffffffa00c143b&gt;] xfs_itruncate_extents+0xdb/0x1e0 [xfs]
[&lt;ffffffffa00c15a6&gt;] xfs_itruncate_data+0x66/0x150 [xfs]
[&lt;ffffffffa009056e&gt;] xfs_inactive+0x2fe/0x460 [xfs]
[&lt;ffffffffa008afad&gt;] xfs_fs_evict_inode+0xad/0x110 [xfs]
[&lt;ffffffff81193e98&gt;] evict+0xb8/0x1c0
[&lt;ffffffff81194088&gt;] iput_final+0xe8/0x210
[&lt;ffffffff811941ee&gt;] iput+0x3e/0x50
[&lt;ffffffff81188be3&gt;] do_unlinkat+0x153/0x1d0
[&lt;ffffffff811897b6&gt;] sys_unlink+0x16/0x20
[&lt;ffffffff81665842&gt;] system_call_fastpath+0x16/0x1b
</pre>
      </blockquote>
      <pre wrap="">
120s later, unlinking a file, blocked waiting on an AGF lock.

</pre>
      <blockquote type="cite">
        <pre wrap="">Mar 21 06:34:20 ealxs00169 kernel: [1412400.891686] flush-8:16      D
</pre>
      </blockquote>
      <pre wrap="">
writeback again, 120s later.

</pre>
      <blockquote type="cite">
        <pre wrap="">Mar 21 06:36:20 ealxs00169 kernel: [1412520.861471] java            D
[&lt;ffffffff8165b995&gt;] schedule_timeout+0x2a5/0x320
[&lt;ffffffff8165c5f0&gt;] __down_common+0xa5/0xf5
[&lt;ffffffff8165c6b3&gt;] __down+0x1d/0x1f
[&lt;ffffffff810912e1&gt;] down+0x41/0x50
[&lt;ffffffffa007c0f4&gt;] xfs_buf_lock+0x44/0x110 [xfs]
[&lt;ffffffffa007c295&gt;] _xfs_buf_find+0xd5/0x240 [xfs]
[&lt;ffffffffa007c684&gt;] xfs_buf_get+0x34/0x1c0 [xfs]
[&lt;ffffffffa007cf2d&gt;] xfs_buf_read+0x2d/0x120 [xfs]
[&lt;ffffffffa00d89ff&gt;] xfs_trans_read_buf+0x2bf/0x470 [xfs]
[&lt;ffffffffa0094775&gt;] xfs_read_agf+0x65/0x1a0 [xfs]
[&lt;ffffffffa00948e2&gt;] xfs_alloc_read_agf+0x32/0x60 [xfs]
[&lt;ffffffffa00966ff&gt;] xfs_alloc_fix_freelist+0x42f/0x490 [xfs]
[&lt;ffffffffa0096a4b&gt;] xfs_alloc_vextent+0x1cb/0x690 [xfs]
[&lt;ffffffffa00a02c1&gt;] xfs_bmap_btalloc+0x2b1/0x770 [xfs]
[&lt;ffffffffa00a07a4&gt;] xfs_bmap_alloc+0x24/0x40 [xfs]
[&lt;ffffffffa00a594e&gt;] xfs_bmapi_allocate+0xce/0x2d0 [xfs]
[&lt;ffffffffa00a85c3&gt;] xfs_bmapi_write+0x4c3/0x720 [xfs]
[&lt;ffffffffa0086988&gt;] xfs_iomap_write_allocate+0x178/0x330 [xfs]
[&lt;ffffffffa00799c3&gt;] xfs_map_blocks+0x183/0x250 [xfs]
[&lt;ffffffffa007aa56&gt;] xfs_vm_writepage+0x196/0x510 [xfs]
[&lt;ffffffff81122217&gt;] __writepage+0x17/0x40
[&lt;ffffffff81122a0d&gt;] write_cache_pages+0x20d/0x460
[&lt;ffffffff81122caa&gt;] generic_writepages+0x4a/0x70
[&lt;ffffffffa007980d&gt;] xfs_vm_writepages+0x4d/0x60 [xfs]
[&lt;ffffffff81123b71&gt;] do_writepages+0x21/0x40
[&lt;ffffffff81119f2b&gt;] __filemap_fdatawrite_range+0x5b/0x60
[&lt;ffffffff81119f82&gt;] filemap_write_and_wait_range+0x52/0x80
[&lt;ffffffffa007f05d&gt;] xfs_file_fsync+0x5d/0x300 [xfs]
[&lt;ffffffff811a7eb6&gt;] do_fsync+0x56/0x80
[&lt;ffffffff811a81e0&gt;] sys_fsync+0x10/0x20
[&lt;ffffffff81665842&gt;] system_call_fastpath+0x16/0x1b
</pre>
      </blockquote>
      <pre wrap="">
120s later, fsync() blocks and AGF lock trying to do allocation.

</pre>
      <blockquote type="cite">
        <pre wrap="">Mar 21 06:36:20 ealxs00169 kernel: [1412520.862112] archiver.pl     D
[&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60
[&lt;ffffffff8165b995&gt;] schedule_timeout+0x2a5/0x320
[&lt;ffffffff8165c5f0&gt;] __down_common+0xa5/0xf5
[&lt;ffffffff8165c6b3&gt;] __down+0x1d/0x1f
[&lt;ffffffff810912e1&gt;] down+0x41/0x50
[&lt;ffffffffa007c0f4&gt;] xfs_buf_lock+0x44/0x110 [xfs]
[&lt;ffffffffa007c295&gt;] _xfs_buf_find+0xd5/0x240 [xfs]
[&lt;ffffffffa007c684&gt;] xfs_buf_get+0x34/0x1c0 [xfs]
[&lt;ffffffffa007cf2d&gt;] xfs_buf_read+0x2d/0x120 [xfs]
[&lt;ffffffffa00d89ff&gt;] xfs_trans_read_buf+0x2bf/0x470 [xfs]
[&lt;ffffffffa0094775&gt;] xfs_read_agf+0x65/0x1a0 [xfs]
[&lt;ffffffffa00948e2&gt;] xfs_alloc_read_agf+0x32/0x60 [xfs]
[&lt;ffffffffa00966ff&gt;] xfs_alloc_fix_freelist+0x42f/0x490 [xfs]
[&lt;ffffffffa0096802&gt;] xfs_free_extent+0xa2/0x120 [xfs]
[&lt;ffffffffa00a6e14&gt;] xfs_bmap_finish+0x164/0x1b0 [xfs]
[&lt;ffffffffa00c143b&gt;] xfs_itruncate_extents+0xdb/0x1e0 [xfs]
[&lt;ffffffffa00c15a6&gt;] xfs_itruncate_data+0x66/0x150 [xfs]
[&lt;ffffffffa009056e&gt;] xfs_inactive+0x2fe/0x460 [xfs]
[&lt;ffffffffa008afad&gt;] xfs_fs_evict_inode+0xad/0x110 [xfs]
[&lt;ffffffff81193e98&gt;] evict+0xb8/0x1c0
[&lt;ffffffff81194088&gt;] iput_final+0xe8/0x210
[&lt;ffffffff811941ee&gt;] iput+0x3e/0x50
[&lt;ffffffff81188be3&gt;] do_unlinkat+0x153/0x1d0
[&lt;ffffffff811897b6&gt;] sys_unlink+0x16/0x20
[&lt;ffffffff81665842&gt;] system_call_fastpath+0x16/0x1b
</pre>
      </blockquote>
      <pre wrap="">
Still blocked on AGF in unlink.


</pre>
      <blockquote type="cite">
        <pre wrap="">Mar 21 06:38:20 ealxs00169 kernel: [1412640.821037] java            D
[&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60
[&lt;ffffffff8165c157&gt;] __mutex_lock_slowpath+0xd7/0x150
[&lt;ffffffff8165bd6a&gt;] mutex_lock+0x2a/0x50
[&lt;ffffffff81188b1e&gt;] do_unlinkat+0x8e/0x1d0
[&lt;ffffffff811897b6&gt;] sys_unlink+0x16/0x20
[&lt;ffffffff81665842&gt;] system_call_fastpath+0x16/0x1b
</pre>
      </blockquote>
      <pre wrap="">
120s later, unlink blocked on a directory mutex.

(others stuck on AGF lock).

</pre>
      <blockquote type="cite">
        <pre wrap="">From this moment on the services are not working anymore. Complete stuck.
</pre>
      </blockquote>
      <pre wrap="">
Yup, everything is stuck waiting for writeback to complete.

can you reproduce this? does the IO subsystem go idle when this
occurs? or is it running flat out?
</pre>
    </blockquote>
    We are not yet able to reproduce. But your added explanation might
    help us in reproducing. The production environment is very dynamic
    in when clients connect to the service and what kind of requests
    they do.<br>
    <br>
    The colleague handling the incident tried to get some info but
    because he was alarmed quit late he decided for the reboot instead
    to get our production qorking again. For the next time we are
    preparing some scripts to gather information which might tell more.<br>
    If you have any suggestions on commands we can run when it happens
    again please let me know? Currently we are configuring kdump as
    suggested by Mark and some other queries against our own software.<br>
    <blockquote cite="mid:20140324173636.GD18572@destitution"
      type="cite">
      <pre wrap="">
Cheers,

Dave.
</pre>
    </blockquote>
    Some extra info: this system has been running for about 1 year
    without any problems. During this time it was never rebooted or
    restarted until the issue on the 4th. Only change could be in the
    usage of java service running on it by external clients. We are
    looking into this.<br>
    <br>
    Thank you for looking into it.<br>
    <br>
    Michel.<br>
  </body>
</html>

--------------040304010601080400030508--


--===============7384924300485465615==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7384924300485465615==--
