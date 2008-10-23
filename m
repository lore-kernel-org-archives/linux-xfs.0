Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 01:16:39 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9N8GVAQ024751
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 01:16:31 -0700
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by netops-testserver-3.corp.sgi.com (Postfix) with SMTP id 357DB90897
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 01:18:16 -0700 (PDT)
Received: from [134.14.55.78] (redback.melbourne.sgi.com [134.14.55.78]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id TAA20936 for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 19:18:15 +1100
Message-ID: <4900412A.2050802@sgi.com>
Date: Thu, 23 Oct 2008 19:17:30 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: deadlock with latest xfs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

another problem with latest xfs

I ran fsstress with 1024 threads and they all locked up within a few minutes.

Some of the stacktraces are stuck in the log

Stack traceback for pid 6675
0xffff881003436d60     6675     6648  0    1   D  0xffff8810034371c8  fsstress
sp                ip                Function (args)
0xffff8810034e56d8 0xffffffff8155d9d6 thread_return
0xffff8810034e5770 0xffffffff8155de7f schedule_timeout+0x22 (0x7fffffffffffffff)
0xffff8810034e57e0 0xffffffff811a57bc xlog_grant_log_space+0x10a (0xffff881026beb230, 0xffff8807dc582d68)
0xffff8810034e5850 0xffffffff811a5b88 xfs_log_reserve+0x160 (0xffff88100d085b18, invalid, invalid, 0xffff8807d6ae5c40, invalid, invalid, 0x10)
0xffff8810034e5890 0xffffffff811b0de6 xfs_trans_reserve+0x173 (0xffff8807d6ae5c00, invalid, invalid, invalid, invalid, 0x2)
0xffff8810034e58e0 0xffffffff8119fab7 xfs_iomap_write_direct+0x204 (0xffff8808a4220000, 0xe3000, invalid, invalid, 0xffff8810034e5a38, 0xffff8810034e5a64, 0xffffc20000000001)
0xffff8810034e59e0 0xffffffff811a0588 xfs_iomap+0x282 (0xffff8808a4220000, 0xe3000, invalid, invalid, 0xffff8810034e5ab8, 0xffff8810034e5af4)
0xffff8810034e5aa0 0xffffffff811bc134 __xfs_get_blocks+0xa3 (0xffff8808a42202a0, invalid, 0xffff881026a8b830, invalid, invalid, invalid)
0xffff8810034e5b30 0xffffffff811bc29a xfs_get_blocks_direct+0x15
0xffff8810034e5b40 0xffffffff810d21b6 __blockdev_direct_IO+0x53c (invalid, invalid, 0xffff8808a42202a0, invalid, invalid, 0xd6c00, 0x1, 0xffffffff811bc285, 0xffffffff811bd031)
0xffff8810034e5be0 0xffffffff811bdcc0 xfs_vm_direct_IO+0xeb (invalid, 0xffff8810034e5de8, 0xffff8810034e5ed8, 0xd6c00, 0x1)
0xffff8810034e5c50 0xffffffff8107d42a generic_file_direct_write+0xfd (0xffff8810034e5de8, 0xffff8810034e5ed8, 0xffff8810034e5d78, 0xd6c00, 0xffff8810034e5e68, invalid, 0xce00)
0xffff8810034e5cb0 0xffffffff811c536f xfs_write+0x579 (0xffff8808a4220000, 0xffff8810034e5de8, 0xffff8810034e5ed8, 0x1, 0xffff8810034e5e68, 0x34e5e6800000005)
0xffff8810034e5dc0 0xffffffff811c0e00 __xfs_file_write+0x4c (invalid, invalid, invalid, invalid, invalid)
0xffff8810034e5dd0 0xffffffff811c0e26 xfs_file_aio_write+0x11 (invalid, invalid, invalid, invalid)
0xffff8810034e5de0 0xffffffff810a96ec do_sync_write+0xe2 (0xffff880fff69d680, 0x7f60ef402000, 0xce00, 0xffff8810034e5f48)
0xffff8810034e5f10 0xffffffff810a9ee8 vfs_write+0xae (0xffff880fff69d680, 0x7f60ef402000, invalid, 0xffff8810034e5f48)
0xffff8810034e5f40 0xffffffff810aa3f8 sys_write+0x47 (invalid, 0x7f60ef402000, 0xce00)

But most of the fsstress threads are stuck with stacktraces like this one

Stack traceback for pid 6674
0xffff881003435dc0     6674     6648  0    3   D  0xffff881003436228  fsstress
sp                ip                Function (args)
0xffff8810034e3848 0xffffffff8155d9d6 thread_return
0xffff8810034e38e0 0xffffffff8155de07 io_schedule+0x5c
0xffff8810034e3900 0xffffffff8107c1fc sync_page+0x3f (invalid)
0xffff8810034e3910 0xffffffff8155e09a __wait_on_bit+0x45 (0xffff880028071cc0, 0xffff8810034e3958, 0xffffffff8107c1bd, invalid)
0xffff8810034e3950 0xffffffff8107c442 wait_on_page_bit+0x6e (0xffffe2003a7de578, invalid)
0xffff8810034e39b0 0xffffffff81082e57 write_cache_pages+0x191 (0xffff880c3dab6a08, 0xffff8810034e3b18, 0xffffffff81082966, 0xffff880c3dab6a08)
0xffff8810034e3ab0 0xffffffff81083019 generic_writepages+0x22 (invalid)
0xffff8810034e3ac0 0xffffffff811bdb52 xfs_vm_writepages+0x46 (0xffff880c3dab6a08, 0xffff8810034e3b18)
0xffff8810034e3af0 0xffffffff8108304a do_writepages+0x2b (invalid, 0xffff8810034e3b18)
0xffff8810034e3b10 0xffffffff8107cafd __filemap_fdatawrite_range+0x5b (invalid, 0x0, 0x7fffffffffffffff, invalid)
0xffff8810034e3b70 0xffffffff8107ccad filemap_fdatawrite+0x1a
0xffff8810034e3b80 0xffffffff8107cccb filemap_write_and_wait+0x1c (0xffff880c3dab6a08)
0xffff8810034e3ba0 0xffffffff811c1296 xfs_flushinval_pages+0x4e (0xffff880c3dab6580, 0x78000)
0xffff8810034e3bd0 0xffffffff811b5718 xfs_free_file_space+0x196 (0xffff880c3dab6580, 0x78a52, 0x894ec, invalid)
0xffff8810034e3ce0 0xffffffff811b771a xfs_change_file_space+0x163 (0xffff880c3dab6580, invalid, 0xffff8810034e3d98, invalid, 0x0, invalid)
0xffff8810034e3d90 0xffffffff811c1faf xfs_ioc_space+0xab (0xffff880c3dab6580, invalid, 0xffff880fffbfb500, invalid, invalid, invalid)
0xffff8810034e3e00 0xffffffff811c2e8e xfs_ioctl+0x296 (0xffff880c3dab6580, 0xffff880fffbfb500, invalid, invalid, 0x7ffff7a32c20)
0xffff8810034e3e80 0xffffffff811c1173 xfs_file_ioctl+0x36 (invalid, invalid, invalid)
0xffff8810034e3eb0 0xffffffff810b5c42 vfs_ioctl+0x2a (0xffff880fffbfb500, invalid, 0x7ffff7a32c20)
0xffff8810034e3ee0 0xffffffff810b5eee do_vfs_ioctl+0x25f (invalid, invalid, invalid, 0x7ffff7a32c20)
0xffff8810034e3f30 0xffffffff810b5f62 sys_ioctl+0x57 (invalid, invalid, 0x7ffff7a32c20)

The system has plenty of memory available.  The deadlock is reproducible.
