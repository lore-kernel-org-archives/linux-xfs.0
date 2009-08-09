Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n79A9B2M250215 for <xfs@oss.sgi.com>; Sun, 9 Aug 2009 05:09:11 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E5869146E48F
	for <xfs@oss.sgi.com>; Sun,  9 Aug 2009 03:09:55 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id Y2Xzkr6pwEJ9va2q for
	<xfs@oss.sgi.com>; Sun, 09 Aug 2009 03:09:55 -0700 (PDT)
Date: Sun, 9 Aug 2009 06:09:55 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.30.4 XFS(..?) regression
In-Reply-To: <00980BBF-1206-4BEF-A8AE-B4A8DAE7EC27@sgi.com>
Message-ID: <alpine.DEB.2.00.0908090605080.16485@p34.internal.lan>
References: <alpine.DEB.2.00.0908080422440.12329@p34.internal.lan>
	<00980BBF-1206-4BEF-A8AE-B4A8DAE7EC27@sgi.com>
MIME-Version: 1.0
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
To: Felix Blyakher <felixb@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Sat, 8 Aug 2009, Felix Blyakher wrote:

>
> On Aug 8, 2009, at 3:39 AM, Justin Piszcz wrote:
>
> The threads below don't ring a bell as something already seen or
> reported.
>
> Discounting bunch of spurious frames, here we're waiting for the
> xfs ilock.
>
> At this point xfs ilock is released in xfs_write(), and it shouldn't
> be holding the other thread. Though, some other thread is.
> We'd need more info to figure it out. Maybe the whole output of both
> sysrq-w and sysrq-t.
>
> Felix
>

Hi, as requested:

sysrq-w:

[72037.131620]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72037.131620]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c029e16b>] ? strrchr+0xb/0x20
[72037.131620]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72037.131620]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72037.131620]  [<c016827e>] ? copy_strings+0x16e/0x190
[72037.131620]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72037.131620]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] sh            D 00000000     0 13142  13141
[72037.131620]  00000000 00000082 c168f1b0 00000000 cf810890 c462fc80 cf403a44 c0198e90
[72037.131620]  c64051bc ffffffff c168f1b0 c64051c0 c03e78bb c1549e04 c150be04 c168f1b0
[72037.131620]  c1495e70 00000000 c1495ef4 c1495e70 c03e7819 c016b423 c1495e84 cf80c8a0
[72037.131620] Call Trace:
[72037.131620]  [<c0198e90>] ? proc_delete_inode+0x0/0x50
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72037.131620]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72037.131620]  [<c016d573>] ? path_walk+0x53/0xb0
[72037.131620]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72037.131620]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[72037.131620]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[72037.131620]  [<c0169188>] ? do_execve+0x98/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script1.sh D c0144a8e     0 13145  13144
[72037.131620]  00000000 00000086 c168e7c0 c0144a8e c045146d c462f7a0 c5445380 c544539c
[72037.131620]  c049f170 c168e7c0 c0f05ddc c1200138 c03e72e5 c03e7311 c0f05dd4 c014111d
[72037.131620]  c0141155 c03e76f2 c10008a0 c0141150 c04c371c c168e7c0 c0f05df0 c11adae0
[72037.131620] Call Trace:
[72037.131620]  [<c0144a8e>] ? __rmqueue+0x1e/0x220
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script2.sh D c09c1f0c     0 13150  13148
[72037.131620]  00000000 00000082 c15b0b30 c09c1f0c c016b3d3 c462f120 cf80c8a0 00000000
[72037.131620]  c73f7cfc ffffffff c15b0b30 c73f7d00 c03e78bb c0e59e60 c1467e60 c15b0b30
[72037.131620]  00008068 ffffffea c9023814 00000000 c03e7819 c0162f63 00008068 75a6b2ed
[72037.131620] Call Trace:
[72037.131620]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c0162f63>] ? do_truncate+0x63/0x90
[72037.131620]  [<c0123571>] ? capable+0x21/0x60
[72037.131620]  [<c016c4a2>] ? may_open+0x182/0x200
[72037.131620]  [<c016e5aa>] ? do_filp_open+0x1ea/0x830
[72037.131620]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72037.131620]  [<c016208b>] ? do_sys_open+0x5b/0x110
[72037.131620]  [<c01621bc>] ? sys_open+0x2c/0x40
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script5.sh D 0000006c     0 13153  13152
[72037.131620]  00000000 00000086 c15b0e80 0000006c c045146d cc7a7b00 c5445380 c544539c
[72037.131620]  c049f170 c15b0e80 c1625ddc c1200080 c03e72e5 c03e7311 c1625dd4 c014111d
[72037.131620]  c0141155 c03e76f2 c1071d20 c0141150 c04c3440 c15b0e80 c1625df0 c101b6c0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] vsftpd        D 00000000     0 13160   1821
[72037.131620]  00000000 00000086 c168ee60 00000000 01007810 cc7a7960 c56955c0 80000000
[72037.131620]  c049f170 c168ee60 c5441c74 c1200110 c03e72e5 c03e7311 c5441c6c c014111d
[72037.131620]  c03e76f2 00000254 c01410f0 c04c371c c168ee60 c5441c88 c11bdd20 c01410cc
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c01410f0>] ? sync_page+0x0/0x60
[72037.131620]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72037.131620]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72037.131620]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c03e87dd>] ? error_code+0x65/0x6c
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72037.131620]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c029e16b>] ? strrchr+0xb/0x20
[72037.131620]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72037.131620]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72037.131620]  [<c016827e>] ? copy_strings+0x16e/0x190
[72037.131620]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72037.131620]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] vsftpd        D 00000000     0 13168   1821
[72037.131620]  00000000 00000082 c15b0140 00000000 01007810 cc7a7620 c4e339a0 80000000
[72037.131620]  c049f170 c15b0140 cce23c74 c1200110 c03e72e5 c03e7311 cce23c6c c014111d
[72037.131620]  c03e76f2 00000254 c01410f0 c04c371c c15b0140 cce23c88 c11bdd20 c01410cc
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c01410f0>] ? sync_page+0x0/0x60
[72037.131620]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72037.131620]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72037.131620]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c03e87dd>] ? error_code+0x65/0x6c
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72037.131620]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c029e16b>] ? strrchr+0xb/0x20
[72037.131620]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72037.131620]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72037.131620]  [<c016827e>] ? copy_strings+0x16e/0x190
[72037.131620]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72037.131620]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] vsftpd        D 00000000     0 13176   1821
[72037.131620]  00000000 00000082 cb82a1a0 00000000 01007810 cc7a7480 c86be4c0 80000000
[72037.131620]  c049f170 cb82a1a0 c1637c74 c1200110 c03e72e5 c03e7311 c1637c6c c014111d
[72037.131620]  c03e76f2 00000254 c01410f0 c04c371c cb82a1a0 c1637c88 c11bdd20 c01410cc
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c01410f0>] ? sync_page+0x0/0x60
[72037.131620]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72037.131620]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72037.131620]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c03e87dd>] ? error_code+0x65/0x6c
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72037.131620]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c029e16b>] ? strrchr+0xb/0x20
[72037.131620]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72037.131620]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72037.131620]  [<c016827e>] ? copy_strings+0x16e/0x190
[72037.131620]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72037.131620]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] vsftpd        D 00000000     0 13177   1821
[72037.131620]  00000000 00000082 cb82bc20 00000000 01007810 cc7a7140 cf373e20 80000000
[72037.131620]  c049f170 cb82bc20 c1615c74 c1200110 c03e72e5 c03e7311 c1615c6c c014111d
[72037.131620]  c03e76f2 00000254 c01410f0 c04c371c cb82bc20 c1615c88 c11bdd20 c01410cc
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c01410f0>] ? sync_page+0x0/0x60
[72037.131620]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72037.131620]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72037.131620]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c03e87dd>] ? error_code+0x65/0x6c
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72037.131620]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c029e16b>] ? strrchr+0xb/0x20
[72037.131620]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72037.131620]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72037.131620]  [<c016827e>] ? copy_strings+0x16e/0x190
[72037.131620]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72037.131620]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] sh            D 00000025     0 13187  13186
[72037.131620]  00000000 00000082 cb82aee0 00000025 00012c19 c9637d40 cfa4ec00 00000025
[72037.131620]  c64051bc ffffffff cb82aee0 c64051c0 c03e78bb c146fe04 c1495e04 cb82aee0
[72037.131620]  c1549e70 00000000 c1549ef4 c1549e70 c03e7819 c016b423 c1549e84 cf80c8a0
[72037.131620] Call Trace:
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72037.131620]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72037.131620]  [<c016d573>] ? path_walk+0x53/0xb0
[72037.131620]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72037.131620]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[72037.131620]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[72037.131620]  [<c0169188>] ? do_execve+0x98/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script1.sh D 0000006c     0 13190  13189
[72037.131620]  00000000 00000086 cb82ab90 0000006c c045146d c9637860 c8609380 c860939c
[72037.131620]  c049f170 cb82ab90 c14efddc c1200138 c03e72e5 c03e7311 c14efdd4 c014111d
[72037.131620]  c0141155 c03e76f2 c10c0f40 c0141150 c04c371c cb82ab90 c14efdf0 c11adae0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script5.sh D 0000006c     0 13193  13192
[72037.131620]  00000000 00000082 c154b5a0 0000006c c045146d c9637380 c8609380 c860939c
[72037.131620]  c049f170 c154b5a0 c16b1ddc c1200080 c03e72e5 c03e7311 c16b1dd4 c014111d
[72037.131620]  c0141155 c03e76f2 c113cd80 c0141150 c04c3440 c154b5a0 c16b1df0 c101b6c0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] vsftpd        D 00000000     0 13199   1821
[72037.131620]  00000000 00000082 cb82a4f0 00000000 01007810 c96371e0 cf373aa0 80000000
[72037.131620]  c049f170 cb82a4f0 c4effc74 c1200110 c03e72e5 c03e7311 c4effc6c c014111d
[72037.131620]  c03e76f2 00000254 c01410f0 c04c371c cb82a4f0 c4effc88 c11bdd20 c01410cc
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c01410f0>] ? sync_page+0x0/0x60
[72037.131620]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72037.131620]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72037.131620]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c03e87dd>] ? error_code+0x65/0x6c
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72037.131620]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c029e16b>] ? strrchr+0xb/0x20
[72037.131620]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72037.131620]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72037.131620]  [<c016827e>] ? copy_strings+0x16e/0x190
[72037.131620]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72037.131620]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] vsftpd        D 00000000     0 13207   1821
[72037.131620]  00000000 00000082 c154a860 00000000 01007810 c9637520 c9dd3340 80000000
[72037.131620]  c049f170 c154a860 c95fbc74 c1200110 c03e72e5 c03e7311 c95fbc6c c014111d
[72037.131620]  c03e76f2 00000254 c01410f0 c04c371c c154a860 c95fbc88 c11bdd20 c01410cc
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c01410f0>] ? sync_page+0x0/0x60
[72037.131620]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72037.131620]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72037.131620]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c03e87dd>] ? error_code+0x65/0x6c
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72037.131620]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c029e16b>] ? strrchr+0xb/0x20
[72037.131620]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72037.131620]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72037.131620]  [<c016827e>] ? copy_strings+0x16e/0x190
[72037.131620]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72037.131620]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] vsftpd        D 00000000     0 13215   1821
[72037.131620]  00000000 00000086 c154a1c0 00000000 01007810 c55e3dc0 cf373220 80000000
[72037.131620]  c049f170 c154a1c0 cc655c74 c1200110 c03e72e5 c03e7311 cc655c6c c014111d
[72037.131620]  c03e76f2 00000254 c01410f0 c04c371c c154a1c0 cc655c88 c11bdd20 c01410cc
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c01410f0>] ? sync_page+0x0/0x60
[72037.131620]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72037.131620]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72037.131620]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c03e87dd>] ? error_code+0x65/0x6c
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72037.131620]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c029e16b>] ? strrchr+0xb/0x20
[72037.131620]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72037.131620]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72037.131620]  [<c016827e>] ? copy_strings+0x16e/0x190
[72037.131620]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72037.131620]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] sh            D 00000000     0 13225  13224
[72037.131620]  00000000 00000086 c154abb0 00000000 cf810890 c55e3400 cf403b80 c0198e90
[72037.131620]  c64051bc ffffffff c154abb0 c64051c0 c03e78bb c37efe04 c1549e04 c154abb0
[72037.131620]  c146fe70 00000000 c146fef4 c146fe70 c03e7819 c016b423 c146fe84 cf80c8a0
[72037.131620] Call Trace:
[72037.131620]  [<c0198e90>] ? proc_delete_inode+0x0/0x50
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72037.131620]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72037.131620]  [<c011a562>] ? scheduler_tick+0x82/0x90
[72037.131620]  [<c016d573>] ? path_walk+0x53/0xb0
[72037.131620]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72037.131620]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[72037.131620]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[72037.131620]  [<c0120ab7>] ? __do_softirq+0x77/0xe0
[72037.131620]  [<c01042b8>] ? do_nmi+0x148/0x2a0
[72037.131620]  [<c0103269>] ? common_interrupt+0x29/0x30
[72037.131620]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[72037.131620]  [<c0169188>] ? do_execve+0x98/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script1.sh D 0000006c     0 13228  13227
[72037.131620]  00000000 00000082 c154a510 0000006c c045146d c55e38e0 ce14a380 ce14a39c
[72037.131620]  c049f170 c154a510 c16b9ddc c1200138 c03e72e5 c03e7311 c16b9dd4 c014111d
[72037.131620]  c0141155 c03e76f2 c113eea0 c0141150 c04c371c c154a510 c16b9df0 c11adae0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] sh            D 00000006     0 13230  13229
[72037.131620]  00000000 00000082 c16b3ac0 00000006 c5224011 c55e3a80 c16bde88 cf596ab4
[72037.131620]  ca6a9524 ca6a9524 c16bde70 c02750f0 c03e72e5 c03e85fd ca6a9528 c16b3ac0
[72037.131620]  c5224018 ca6a9524 00000000 cf373da0 c02750f0 c03e873a c16e5e70 ca6a9528
[72037.131620] Call Trace:
[72037.131620]  [<c02750f0>] ? xfs_dir_open+0x0/0x70
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e85fd>] ? rwsem_down_failed_common+0x7d/0x170
[72037.131620]  [<c02750f0>] ? xfs_dir_open+0x0/0x70
[72037.131620]  [<c03e873a>] ? rwsem_down_read_failed+0x1a/0x24
[72037.131620]  [<c03e874b>] ? call_rwsem_down_read_failed+0x7/0xc
[72037.131620]  [<c03e7d29>] ? down_read+0x9/0x10
[72037.131620]  [<c0250e36>] ? xfs_ilock_map_shared+0x16/0x40
[72037.131620]  [<c027512d>] ? xfs_dir_open+0x3d/0x70
[72037.131620]  [<c0162289>] ? __dentry_open+0x89/0x240
[72037.131620]  [<c0162533>] ? nameidata_to_filp+0x53/0x70
[72037.131620]  [<c016e605>] ? do_filp_open+0x245/0x830
[72037.131620]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72037.131620]  [<c016208b>] ? do_sys_open+0x5b/0x110
[72037.131620]  [<c01621bc>] ? sys_open+0x2c/0x40
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script3.sh D cfa5e400     0 13245  13232
[72037.131620]  00000000 00000082 c16cb7b0 cfa5e400 cf80c8a0 c58975e0 cf5a25d0 c0174677
[72037.131620]  cc79babc ffffffff c16cb7b0 cc79bac0 c03e78bb c16d5e04 c1465e08 c16cb7b0
[72037.131620]  c0829e74 00000000 c0829ed8 c0829e74 c03e7819 c016b423 c0829e88 cf80c8a0
[72037.131620] Call Trace:
[72037.131620]  [<c0174677>] ? touch_atime+0x97/0x140
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72037.131620]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72037.131620]  [<c0250c70>] ? xfs_iunlock+0x80/0xb0
[72037.131620]  [<c016d573>] ? path_walk+0x53/0xb0
[72037.131620]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72037.131620]  [<c016c756>] ? getname+0x96/0xd0
[72037.131620]  [<c016e22a>] ? user_path_at+0x5a/0x90
[72037.131620]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72037.131620]  [<c01671c7>] ? vfs_fstatat+0x37/0x70
[72037.131620]  [<c01672d8>] ? vfs_stat+0x18/0x20
[72037.131620]  [<c01672ef>] ? sys_stat64+0xf/0x30
[72037.131620]  [<c01649ff>] ? vfs_read+0xff/0x140
[72037.131620]  [<c0125927>] ? sys_rt_sigprocmask+0x67/0xe0
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script4.sh   D 00000246     0 13246  13237
[72037.131620]  c16cb5e4 00000082 c16cb460 00000246 00000001 c5897440 00000000 0000000e
[72037.131620]  cc79babc ffffffff c16cb460 cc79bac0 c03e78bb c16ebe08 c16d5e04 c16cb460
[72037.131620]  c16cfe74 00000000 c16cfed8 c16cfe74 c03e7819 c016b423 c16cfe88 cf80c8a0
[72037.131620] Call Trace:
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72037.131620]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72037.131620]  [<c0174698>] ? touch_atime+0xb8/0x140
[72037.131620]  [<c016d573>] ? path_walk+0x53/0xb0
[72037.131620]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72037.131620]  [<c016c756>] ? getname+0x96/0xd0
[72037.131620]  [<c016e22a>] ? user_path_at+0x5a/0x90
[72037.131620]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72037.131620]  [<c01671c7>] ? vfs_fstatat+0x37/0x70
[72037.131620]  [<c01672d8>] ? vfs_stat+0x18/0x20
[72037.131620]  [<c01672ef>] ? sys_stat64+0xf/0x30
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] sh            D 00000000     0 13249  13234
[72037.131620]  00000000 00000082 c16caa70 00000000 00000400 c5897780 00000004 ffffffff
[72037.131620]  cc79babc ffffffff c16caa70 cc79bac0 c03e78bb c16cfe08 c0829e08 c16caa70
[72037.131620]  c16d5e70 00000000 c16d5ef4 c16d5e70 c03e7819 c016b423 c16d5e84 cf80c8a0
[72037.131620] Call Trace:
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72037.131620]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72037.131620]  [<c016d573>] ? path_walk+0x53/0xb0
[72037.131620]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72037.131620]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[72037.131620]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[72037.131620]  [<c0169188>] ? do_execve+0x98/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script5.sh D 0000006c     0 13253  13243
[72037.131620]  00000000 00000086 c16dbb20 0000006c c045146d c55727a0 cc622380 cc62239c
[72037.131620]  c049f170 c16dbb20 c16ddddc c1200080 c03e72e5 c03e7311 c16dddd4 c014111d
[72037.131620]  c0141155 c03e76f2 c1034680 c0141150 c04c3440 c16dbb20 c16dddf0 c101b6c0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script2.sh D c0e59f0c     0 13262  13251
[72037.131620]  c16daf64 00000086 c16dade0 c0e59f0c c016b3d3 c5572460 cf80c8a0 c16dade0
[72037.131620]  c73f7cfc ffffffff c16dade0 c73f7d00 c03e78bb c16d1e60 c09c1e60 c16dade0
[72037.131620]  00008068 ffffffea c9023814 00000000 c03e7819 c0162f63 00008068 75a6b2ed
[72037.131620] Call Trace:
[72037.131620]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c0162f63>] ? do_truncate+0x63/0x90
[72037.131620]  [<c0123571>] ? capable+0x21/0x60
[72037.131620]  [<c016c4a2>] ? may_open+0x182/0x200
[72037.131620]  [<c016e5aa>] ? do_filp_open+0x1ea/0x830
[72037.131620]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72037.131620]  [<c016208b>] ? do_sys_open+0x5b/0x110
[72037.131620]  [<c01621bc>] ? sys_open+0x2c/0x40
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] sh            D 00000000     0 13288  13287
[72037.131620]  00000000 00000082 cb7a8a50 00000000 cf810890 c5572c80 cf403418 c0198e90
[72037.131620]  c64051bc ffffffff cb7a8a50 c64051c0 c03e78bb c0ee3e04 c146fe04 cb7a8a50
[72037.131620]  c37efe70 00000000 c37efef4 c37efe70 c03e7819 c016b423 c37efe84 cf80c8a0
[72037.131620] Call Trace:
[72037.131620]  [<c0198e90>] ? proc_delete_inode+0x0/0x50
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72037.131620]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72037.131620]  [<c016d573>] ? path_walk+0x53/0xb0
[72037.131620]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72037.131620]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[72037.131620]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[72037.131620]  [<c0169188>] ? do_execve+0x98/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script1.sh D 0000006c     0 13291  13290
[72037.131620]  00000000 00000082 c16ca080 0000006c c045146d c5572120 ccebe380 ccebe39c
[72037.131620]  c049f170 c16ca080 c4f57ddc c1200138 c03e72e5 c03e7311 c4f57dd4 c014111d
[72037.131620]  c0141155 c03e76f2 c1112600 c0141150 c04c371c c16ca080 c4f57df0 c11adae0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script5.sh D 0000006c     0 13294  13293
[72037.131620]  00000000 00000082 c16db7d0 0000006c c045146d c5897920 ccebe380 ccebe39c
[72037.131620]  c049f170 c16db7d0 c846fddc c1200080 c03e72e5 c03e7311 c846fdd4 c014111d
[72037.131620]  c0141155 c03e76f2 c1085a00 c0141150 c04c3440 c16db7d0 c846fdf0 c101b6c0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] vsftpd        D 00000000     0 13318   1821
[72037.131620]  00000000 00000086 c16db480 00000000 01007810 c58972a0 ccc9ef60 80000000
[72037.131620]  c049f170 c16db480 c4d75c74 c1200110 c03e72e5 c03e7311 c4d75c6c c014111d
[72037.131620]  c03e76f2 00000254 c01410f0 c04c371c c16db480 c4d75c88 c11bdd20 c01410cc
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c01410f0>] ? sync_page+0x0/0x60
[72037.131620]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72037.131620]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72037.131620]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c03e87dd>] ? error_code+0x65/0x6c
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72037.131620]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c029e16b>] ? strrchr+0xb/0x20
[72037.131620]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72037.131620]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72037.131620]  [<c016827e>] ? copy_strings+0x16e/0x190
[72037.131620]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72037.131620]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] vsftpd        D 00000000     0 13319   1821
[72037.131620]  00000000 00000086 c16daa90 00000000 01007810 c5897e00 ce373260 80000000
[72037.131620]  c049f170 c16daa90 cae8fc74 c1200110 c03e72e5 c03e7311 cae8fc6c c014111d
[72037.131620]  c03e76f2 00000254 c01410f0 c04c371c c16daa90 cae8fc88 c11bdd20 c01410cc
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c01410f0>] ? sync_page+0x0/0x60
[72037.131620]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72037.131620]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72037.131620]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c03e87dd>] ? error_code+0x65/0x6c
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72037.131620]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c029e16b>] ? strrchr+0xb/0x20
[72037.131620]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72037.131620]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72037.131620]  [<c016827e>] ? copy_strings+0x16e/0x190
[72037.131620]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72037.131620]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] vsftpd        D 00000000     0 13320   1821
[72037.131620]  00000000 00000086 c16da0a0 00000000 01007810 c3de3da0 c38bd740 80000000
[72037.131620]  c049f170 c16da0a0 cc175c74 c1200110 c03e72e5 c03e7311 cc175c6c c014111d
[72037.131620]  c03e76f2 00000254 c01410f0 c04c371c c16da0a0 cc175c88 c11bdd20 c01410cc
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c01410f0>] ? sync_page+0x0/0x60
[72037.131620]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72037.131620]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72037.131620]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c03e87dd>] ? error_code+0x65/0x6c
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72037.131620]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c029e16b>] ? strrchr+0xb/0x20
[72037.131620]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72037.131620]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72037.131620]  [<c016827e>] ? copy_strings+0x16e/0x190
[72037.131620]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72037.131620]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] sh            D cb7a8700     0 13330  13329
[72037.131620]  00000000 00000082 cb7a8700 cb7a8700 cb7a872c c3de33e0 00000fff c011798f
[72037.131620]  c64051bc ffffffff cb7a8700 c64051c0 c03e78bb c0e77e04 c37efe04 cb7a8700
[72037.131620]  c0ee3e70 00000000 c0ee3ef4 c0ee3e70 c03e7819 c016b423 c0ee3e84 cf80c8a0
[72037.131620] Call Trace:
[72037.131620]  [<c011798f>] ? task_tick_fair+0x4f/0x90
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72037.131620]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72037.131620]  [<c016d573>] ? path_walk+0x53/0xb0
[72037.131620]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72037.131620]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[72037.131620]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[72037.131620]  [<c0169188>] ? do_execve+0x98/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script1.sh D c0144a8e     0 13333  13332
[72037.131620]  00000000 00000086 c069b7f0 c0144a8e c045146d c3de38c0 cb8f3380 cb8f339c
[72037.131620]  c049f170 c069b7f0 c0c75ddc c1200138 c03e72e5 c03e7311 c0c75dd4 c014111d
[72037.131620]  c0141155 c03e76f2 c1018400 c0141150 c04c371c c069b7f0 c0c75df0 c11adae0
[72037.131620] Call Trace:
[72037.131620]  [<c0144a8e>] ? __rmqueue+0x1e/0x220
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script2.sh D 75a6b2ed     0 13338  13336
[72037.131620]  00000000 00000082 c069a410 75a6b2ed c01042b8 c6c0dc20 00000002 c9023824
[72037.131620]  c73f7cfc ffffffff c069a410 c73f7d00 c03e78bb c16f7e60 c0e59e60 c069a410
[72037.131620]  00008068 ffffffea c9023814 00000000 c03e7819 c0162f63 00008068 ffffffcf
[72037.131620] Call Trace:
[72037.131620]  [<c01042b8>] ? do_nmi+0x148/0x2a0
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c0162f63>] ? do_truncate+0x63/0x90
[72037.131620]  [<c0173a92>] ? __d_lookup+0x62/0x100
[72037.131620]  [<c0123571>] ? capable+0x21/0x60
[72037.131620]  [<c016c4a2>] ? may_open+0x182/0x200
[72037.131620]  [<c016e5aa>] ? do_filp_open+0x1ea/0x830
[72037.131620]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72037.131620]  [<c016208b>] ? do_sys_open+0x5b/0x110
[72037.131620]  [<c01621bc>] ? sys_open+0x2c/0x40
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script5.sh D 0000006c     0 13341  13340
[72037.131620]  00000000 00000082 c069a760 0000006c c045146d c6c0d740 cb8f3380 cb8f339c
[72037.131620]  c049f170 c069a760 c16d9ddc c1200080 c03e72e5 c03e7311 c16d9dd4 c014111d
[72037.131620]  c0141155 c03e76f2 c106e620 c0141150 c04c3440 c069a760 c16d9df0 c101b6c0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] sh            D 00001000     0 13371  13370
[72037.131620]  00000000 00000086 c16e0e20 00001000 c011a562 c6c0d260 00000000 00000002
[72037.131620]  c64051bc ffffffff c16e0e20 c64051c0 c03e78bb c5513e04 c0ee3e04 c16e0e20
[72037.131620]  c0e77e70 00000000 c0e77ef4 c0e77e70 c03e7819 c016b423 c0e77e84 cf80c8a0
[72037.131620] Call Trace:
[72037.131620]  [<c011a562>] ? scheduler_tick+0x82/0x90
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72037.131620]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72037.131620]  [<c03e888d>] ? nmi_stack_correct+0x28/0x2d
[72037.131620]  [<c016d573>] ? path_walk+0x53/0xb0
[72037.131620]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72037.131620]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[72037.131620]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[72037.131620]  [<c0169188>] ? do_execve+0x98/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script1.sh D 0000006c     0 13374  13373
[72037.131620]  00000000 00000082 c16e0ad0 0000006c c045146d ce123c40 c8574380 c857439c
[72037.131620]  c049f170 c16e0ad0 c9f43ddc c1200138 c03e72e5 c03e7311 c9f43dd4 c014111d
[72037.131620]  c0141155 c03e76f2 c10e4600 c0141150 c04c371c c16e0ad0 c9f43df0 c11adae0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c011791d>] ? check_preempt_wakeup+0xad/0xd0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script5.sh D 0000006c     0 13377  13376
[72037.131620]  00000000 00000086 c0adbb80 0000006c c045146d ce123760 c8574380 c857439c
[72037.131620]  c049f170 c0adbb80 c16d7ddc c1200080 c03e72e5 c03e7311 c16d7dd4 c014111d
[72037.131620]  c0141155 c03e76f2 c11ffa60 c0141150 c04c3440 c0adbb80 c16d7df0 c101b6c0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] vsftpd        D 00000000     0 13397   1821
[72037.131620]  00000000 00000086 c0ada100 00000000 01007810 ce1235c0 c970b4e0 80000000
[72037.131620]  c049f170 c0ada100 c9607c74 c1200110 c03e72e5 c03e7311 c9607c6c c014111d
[72037.131620]  c03e76f2 00000254 c01410f0 c04c371c c0ada100 c9607c88 c11bdd20 c01410cc
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c01410f0>] ? sync_page+0x0/0x60
[72037.131620]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72037.131620]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72037.131620]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c03e87dd>] ? error_code+0x65/0x6c
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72037.131620]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c029e16b>] ? strrchr+0xb/0x20
[72037.131620]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72037.131620]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72037.131620]  [<c016827e>] ? copy_strings+0x16e/0x190
[72037.131620]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72037.131620]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] vsftpd        D 00000000     0 13398   1821
[72037.131620]  00000000 00000082 c0adb4e0 00000000 01007810 ce123280 c8ef4820 80000000
[72037.131620]  c049f170 c0adb4e0 c562dc74 c1200110 c03e72e5 c03e7311 c562dc6c c014111d
[72037.131620]  c03e76f2 00000254 c01410f0 c04c371c c0adb4e0 c562dc88 c11bdd20 c01410cc
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c01410f0>] ? sync_page+0x0/0x60
[72037.131620]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72037.131620]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72037.131620]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c03e87dd>] ? error_code+0x65/0x6c
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72037.131620]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c029e16b>] ? strrchr+0xb/0x20
[72037.131620]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72037.131620]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72037.131620]  [<c016827e>] ? copy_strings+0x16e/0x190
[72037.131620]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72037.131620]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] sh            D 00000000     0 13408  13407
[72037.131620]  00000000 00000086 c0adaaf0 00000000 cf810890 c6688e00 cf4d6730 00000010
[72037.131620]  c64051bc ffffffff c0adaaf0 c64051c0 c03e78bb c35a9e04 c0e77e04 c0adaaf0
[72037.131620]  c5513e70 00000000 c5513ef4 c5513e70 c03e7819 c016b423 c5513e84 cf80c8a0
[72037.131620] Call Trace:
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72037.131620]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72037.131620]  [<c016d573>] ? path_walk+0x53/0xb0
[72037.131620]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72037.131620]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[72037.131620]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[72037.131620]  [<c0169188>] ? do_execve+0x98/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script1.sh D 0000006c     0 13411  13410
[72037.131620]  00000000 00000082 c0adb830 0000006c c045146d c6688920 c6129380 c612939c
[72037.131620]  c049f170 c0adb830 c0addddc c1200138 c03e72e5 c03e7311 c0adddd4 c014111d
[72037.131620]  c0141155 c03e76f2 c10891e0 c0141150 c04c371c c0adb830 c0adddf0 c11adae0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] sh            D 00000006     0 13413  13412
[72037.131620]  00000000 00000082 c4e6b850 00000006 c8f62011 c6688780 c16e5e88 cf596ab4
[72037.131620]  ca6a9524 ca6a9524 c16e5e70 c02750f0 c03e72e5 c03e85fd ca6a9528 c4e6b850
[72037.131620]  c8f62018 ca6a9524 00000000 ccd380a0 c02750f0 c03e873a ccccbe70 c16bde70
[72037.131620] Call Trace:
[72037.131620]  [<c02750f0>] ? xfs_dir_open+0x0/0x70
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e85fd>] ? rwsem_down_failed_common+0x7d/0x170
[72037.131620]  [<c02750f0>] ? xfs_dir_open+0x0/0x70
[72037.131620]  [<c03e873a>] ? rwsem_down_read_failed+0x1a/0x24
[72037.131620]  [<c03e874b>] ? call_rwsem_down_read_failed+0x7/0xc
[72037.131620]  [<c03e7d29>] ? down_read+0x9/0x10
[72037.131620]  [<c0250e36>] ? xfs_ilock_map_shared+0x16/0x40
[72037.131620]  [<c027512d>] ? xfs_dir_open+0x3d/0x70
[72037.131620]  [<c0162289>] ? __dentry_open+0x89/0x240
[72037.131620]  [<c0162533>] ? nameidata_to_filp+0x53/0x70
[72037.131620]  [<c016e605>] ? do_filp_open+0x245/0x830
[72037.131620]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72037.131620]  [<c016208b>] ? do_sys_open+0x5b/0x110
[72037.131620]  [<c01621bc>] ? sys_open+0x2c/0x40
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script3.sh D cfa5e400     0 13416  13415
[72037.131620]  00000000 00000086 c4e6ae60 cfa5e400 cf80c8a0 c6688100 cf5a25d0 c0174677
[72037.131620]  cc79babc ffffffff c4e6ae60 cc79bac0 c03e78bb c16f3e08 c16cfe08 c4e6ae60
[72037.131620]  c16ebe74 00000000 c16ebed8 c16ebe74 c03e7819 c016b423 c16ebe88 cf80c8a0
[72037.131620] Call Trace:
[72037.131620]  [<c0174677>] ? touch_atime+0x97/0x140
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72037.131620]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72037.131620]  [<c0250c70>] ? xfs_iunlock+0x80/0xb0
[72037.131620]  [<c016d573>] ? path_walk+0x53/0xb0
[72037.131620]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72037.131620]  [<c016c756>] ? getname+0x96/0xd0
[72037.131620]  [<c016e22a>] ? user_path_at+0x5a/0x90
[72037.131620]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72037.131620]  [<c01671c7>] ? vfs_fstatat+0x37/0x70
[72037.131620]  [<c01672d8>] ? vfs_stat+0x18/0x20
[72037.131620]  [<c01672ef>] ? sys_stat64+0xf/0x30
[72037.131620]  [<c01649ff>] ? vfs_read+0xff/0x140
[72037.131620]  [<c0125927>] ? sys_rt_sigprocmask+0x67/0xe0
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script2.sh D c16f7f0c     0 13421  13419
[72037.131620]  00000000 00000082 c16f5bc0 c16f7f0c c016b3d3 c9dad940 cf80c8a0 c16f5bc0
[72037.131620]  c73f7cfc ffffffff c16f5bc0 c73f7d00 c03e78bb cf053e60 c16d1e60 c16f5bc0
[72037.131620]  00008068 ffffffea c9023814 00000000 c03e7819 c0162f63 00008068 75a6b2ed
[72037.131620] Call Trace:
[72037.131620]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c0162f63>] ? do_truncate+0x63/0x90
[72037.131620]  [<c0123571>] ? capable+0x21/0x60
[72037.131620]  [<c016c4a2>] ? may_open+0x182/0x200
[72037.131620]  [<c016e5aa>] ? do_filp_open+0x1ea/0x830
[72037.131620]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72037.131620]  [<c016208b>] ? do_sys_open+0x5b/0x110
[72037.131620]  [<c01621bc>] ? sys_open+0x2c/0x40
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script4.sh   D c117a8a0     0 13424  13423
[72037.131620]  00000000 00000086 c4e6a120 c117a8a0 00000000 c9dad460 0bd45067 0000000e
[72037.131620]  cc79babc ffffffff c4e6a120 cc79bac0 c03e78bb ca0d3e08 c16ebe08 c4e6a120
[72037.131620]  c16f3e74 00000000 c16f3ed8 c16f3e74 c03e7819 c016b423 c16f3e88 cf80c8a0
[72037.131620] Call Trace:
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72037.131620]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72037.131620]  [<c0174698>] ? touch_atime+0xb8/0x140
[72037.131620]  [<c016d573>] ? path_walk+0x53/0xb0
[72037.131620]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72037.131620]  [<c016c756>] ? getname+0x96/0xd0
[72037.131620]  [<c016e22a>] ? user_path_at+0x5a/0x90
[72037.131620]  [<c012db5a>] ? __wake_up_bit+0x2a/0x30
[72037.131620]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72037.131620]  [<c01671c7>] ? vfs_fstatat+0x37/0x70
[72037.131620]  [<c01672d8>] ? vfs_stat+0x18/0x20
[72037.131620]  [<c01672ef>] ? sys_stat64+0xf/0x30
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script5.sh D 0000006c     0 13429  13428
[72037.131620]  00000000 00000086 c16f4490 0000006c c045146d c3833ca0 c6129380 c612939c
[72037.131620]  c049f170 c16f4490 c144bddc c1200080 c03e72e5 c03e7311 c144bdd4 c014111d
[72037.131620]  c0141155 c03e76f2 c10556c0 c0141150 c04c3440 c16f4490 c144bdf0 c101b6c0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] vsftpd        D 00000000     0 13444   1821
[72037.131620]  00000000 00000082 c0adb190 00000000 01007810 c3833e40 c66af660 80000000
[72037.131620]  c049f170 c0adb190 c59c5c74 c1200110 c03e72e5 c03e7311 c59c5c6c c014111d
[72037.131620]  c03e76f2 00000254 c01410f0 c04c371c c0adb190 c59c5c88 c11bdd20 c01410cc
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c01410f0>] ? sync_page+0x0/0x60
[72037.131620]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72037.131620]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72037.131620]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c03e87dd>] ? error_code+0x65/0x6c
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72037.131620]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c029e16b>] ? strrchr+0xb/0x20
[72037.131620]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72037.131620]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72037.131620]  [<c016827e>] ? copy_strings+0x16e/0x190
[72037.131620]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72037.131620]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] sh            D c35a9df0     0 13469  13468
[72037.131620]  00000000 00000082 c16f51d0 c35a9df0 c1200838 c38332e0 c012db5a c35a9df0
[72037.131620]  c64051bc ffffffff c16f51d0 c64051c0 c03e78bb c36fbe04 c5513e04 c16f51d0
[72037.131620]  c35a9e70 00000000 c35a9ef4 c35a9e70 c03e7819 c016b423 c35a9e84 cf80c8a0
[72037.131620] Call Trace:
[72037.131620]  [<c012db5a>] ? __wake_up_bit+0x2a/0x30
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72037.131620]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72037.131620]  [<c016d573>] ? path_walk+0x53/0xb0
[72037.131620]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72037.131620]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[72037.131620]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[72037.131620]  [<c0169188>] ? do_execve+0x98/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script1.sh D 0000006c     0 13472  13471
[72037.131620]  00000000 00000082 cc6d35a0 0000006c c045146d c3833620 c63be380 c63be39c
[72037.131620]  c049f170 cc6d35a0 c9f25ddc c1200138 c03e72e5 c03e7311 c9f25dd4 c014111d
[72037.131620]  c0141155 c03e76f2 c1140820 c0141150 c04c371c cc6d35a0 c9f25df0 c11adae0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script5.sh D 0000006c     0 13475  13474
[72037.131620]  00000000 00000086 cc6d2860 0000006c c045146d c3f5cba0 c63be380 c63be39c
[72037.131620]  c049f170 cc6d2860 c9ca1ddc c1200080 c03e72e5 c03e7311 c9ca1dd4 c014111d
[72037.131620]  c0141155 c03e76f2 c1194a40 c0141150 c04c3440 cc6d2860 c9ca1df0 c101b6c0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] sh            D 00000000     0 13508  13507
[72037.131620]  00000000 00000086 c16f4140 00000000 cf810890 c3f5c6c0 cf4037cc c0198e90
[72037.131620]  c64051bc ffffffff c16f4140 c64051c0 c03e78bb cb8b5e04 c35a9e04 c16f4140
[72037.131620]  c36fbe70 00000000 c36fbef4 c36fbe70 c03e7819 c016b423 c36fbe84 cf80c8a0
[72037.131620] Call Trace:
[72037.131620]  [<c0198e90>] ? proc_delete_inode+0x0/0x50
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72037.131620]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72037.131620]  [<c016d573>] ? path_walk+0x53/0xb0
[72037.131620]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72037.131620]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[72037.131620]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[72037.131620]  [<c0169188>] ? do_execve+0x98/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script1.sh D 0000006c     0 13511  13510
[72037.131620]  00000000 00000082 c9fd7b00 0000006c c045146d c3f5c1e0 c5291380 c529139c
[72037.131620]  c049f170 c9fd7b00 c66d9ddc c1200138 c03e72e5 c03e7311 c66d9dd4 c014111d
[72037.131620]  c0141155 c03e76f2 c11aa100 c0141150 c04c371c c9fd7b00 c66d9df0 c11adae0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script2.sh D cf053f0c     0 13516  13514
[72037.131620]  00000000 00000082 c9fd6080 cf053f0c c016b3d3 c534aa20 cf80c8a0 c9fd6080
[72037.131620]  c73f7cfc ffffffff c9fd6080 c73f7d00 c03e78bb c8a43e60 c16f7e60 c9fd6080
[72037.131620]  00008068 ffffffea c9023814 00000000 c03e7819 c0162f63 00008068 75a6b2ed
[72037.131620] Call Trace:
[72037.131620]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c0162f63>] ? do_truncate+0x63/0x90
[72037.131620]  [<c0123571>] ? capable+0x21/0x60
[72037.131620]  [<c016c4a2>] ? may_open+0x182/0x200
[72037.131620]  [<c016e5aa>] ? do_filp_open+0x1ea/0x830
[72037.131620]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72037.131620]  [<c016208b>] ? do_sys_open+0x5b/0x110
[72037.131620]  [<c01621bc>] ? sys_open+0x2c/0x40
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script5.sh D 0000006c     0 13519  13518
[72037.131620]  00000000 00000082 c9fd63d0 0000006c c045146d c534a540 c5291380 c529139c
[72037.131620]  c049f170 c9fd63d0 cfab1ddc c1200080 c03e72e5 c03e7311 cfab1dd4 c014111d
[72037.131620]  c0141155 c03e76f2 c104be00 c0141150 c04c3440 c9fd63d0 cfab1df0 c101b6c0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] sh            D 00000000     0 13549  13548
[72037.131620]  00000000 00000086 c463cde0 00000000 cf810890 c534a200 cf4031a0 c0198e90
[72037.131620]  c64051bc ffffffff c463cde0 c64051c0 c03e78bb c8d2be04 c36fbe04 c463cde0
[72037.131620]  cb8b5e70 00000000 cb8b5ef4 cb8b5e70 c03e7819 c016b423 cb8b5e84 cf80c8a0
[72037.131620] Call Trace:
[72037.131620]  [<c0198e90>] ? proc_delete_inode+0x0/0x50
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72037.131620]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72037.131620]  [<c016d573>] ? path_walk+0x53/0xb0
[72037.131620]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72037.131620]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[72037.131620]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[72037.131620]  [<c0169188>] ? do_execve+0x98/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script1.sh D 0000006c     0 13552  13551
[72037.131620]  00000000 00000086 c463d480 0000006c c045146d ce1abaa0 ce37a380 ce37a39c
[72037.131620]  c049f170 c463d480 ce337ddc c1200138 c03e72e5 c03e7311 ce337dd4 c014111d
[72037.131620]  c0141155 c03e76f2 c10e52a0 c0141150 c04c371c c463d480 ce337df0 c11adae0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script5.sh D 0000006c     0 13555  13554
[72037.131620]  00000000 00000086 c93677f0 0000006c c045146d ce1ab5c0 ce37a380 ce37a39c
[72037.131620]  c049f170 c93677f0 c4585ddc c1200080 c03e72e5 c03e7311 c4585dd4 c014111d
[72037.131620]  c0141155 c03e76f2 c1180540 c0141150 c04c3440 c93677f0 c4585df0 c101b6c0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] vsftpd        D 00000000     0 13561   1821
[72037.131620]  00000000 00000082 c463d130 00000000 01007810 ce1ab0e0 c4d7e5e0 80000000
[72037.131620]  c049f170 c463d130 c84f9c74 c1200110 c03e72e5 c03e7311 c84f9c6c c014111d
[72037.131620]  c03e76f2 00000254 c01410f0 c04c371c c463d130 c84f9c88 c11bdd20 c01410cc
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c01410f0>] ? sync_page+0x0/0x60
[72037.131620]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72037.131620]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72037.131620]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c03e87dd>] ? error_code+0x65/0x6c
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72037.131620]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c029e16b>] ? strrchr+0xb/0x20
[72037.131620]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72037.131620]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72037.131620]  [<c016827e>] ? copy_strings+0x16e/0x190
[72037.131620]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72037.131620]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] vsftpd        D 00000000     0 13562   1821
[72037.131620]  00000000 00000082 c93674a0 00000000 01007810 ce1ab420 c874ab20 80000000
[72037.131620]  c049f170 c93674a0 c9c81c74 c1200110 c03e72e5 c03e7311 c9c81c6c c014111d
[72037.131620]  c03e76f2 00000254 c01410f0 c04c371c c93674a0 c9c81c88 c11bdd20 c01410cc
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c01410f0>] ? sync_page+0x0/0x60
[72037.131620]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72037.131620]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72037.131620]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c03e87dd>] ? error_code+0x65/0x6c
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72037.131620]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c029e16b>] ? strrchr+0xb/0x20
[72037.131620]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72037.131620]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72037.131620]  [<c016827e>] ? copy_strings+0x16e/0x190
[72037.131620]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72037.131620]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] vsftpd        D 00000000     0 13577   1821
[72037.131620]  00000000 00000086 c93660c0 00000000 01007810 ce1ab760 c4d7ed60 80000000
[72037.131620]  c049f170 c93660c0 c4fc7c74 c1200110 c03e72e5 c03e7311 c4fc7c6c c014111d
[72037.131620]  c03e76f2 00000254 c01410f0 c04c371c c93660c0 c4fc7c88 c11bdd20 c01410cc
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c01410f0>] ? sync_page+0x0/0x60
[72037.131620]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72037.131620]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72037.131620]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c03e87dd>] ? error_code+0x65/0x6c
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72037.131620]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c029e16b>] ? strrchr+0xb/0x20
[72037.131620]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72037.131620]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72037.131620]  [<c016827e>] ? copy_strings+0x16e/0x190
[72037.131620]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72037.131620]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] sh            D 00000000     0 13587  13586
[72037.131620]  00000000 00000086 c9366ab0 00000000 cf810890 c8c65a00 cf4d6730 c0198e90
[72037.131620]  c64051bc ffffffff c9366ab0 c64051c0 c03e78bb c2251e04 cb8b5e04 c9366ab0
[72037.131620]  c8d2be70 00000000 c8d2bef4 c8d2be70 c03e7819 c016b423 c8d2be84 cf80c8a0
[72037.131620] Call Trace:
[72037.131620]  [<c0198e90>] ? proc_delete_inode+0x0/0x50
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72037.131620]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72037.131620]  [<c016d573>] ? path_walk+0x53/0xb0
[72037.131620]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72037.131620]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[72037.131620]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[72037.131620]  [<c0169188>] ? do_execve+0x98/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script1.sh D c0144a8e     0 13590  13589
[72037.131620]  00000000 00000082 c9366410 c0144a8e c045146d c8c65520 c396b380 c396b39c
[72037.131620]  c049f170 c9366410 c45ffddc c1200138 c03e72e5 c03e7311 c45ffdd4 c014111d
[72037.131620]  c0141155 c03e76f2 c10301e0 c0141150 c04c371c c9366410 c45ffdf0 c11adae0
[72037.131620] Call Trace:
[72037.131620]  [<c0144a8e>] ? __rmqueue+0x1e/0x220
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] sh            D 00000006     0 13592  13591
[72037.131620]  00000000 00000082 c9367150 00000006 c9760011 c8c65380 ccccbe88 cf596ab4
[72037.131620]  ca6a9524 ca6a9524 ccccbe70 c02750f0 c03e72e5 c03e85fd ca6a9528 c9367150
[72037.131620]  c9760018 ca6a9524 00000000 c9faf440 c02750f0 c03e873a c1433e70 c16e5e70
[72037.131620] Call Trace:
[72037.131620]  [<c02750f0>] ? xfs_dir_open+0x0/0x70
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e85fd>] ? rwsem_down_failed_common+0x7d/0x170
[72037.131620]  [<c02750f0>] ? xfs_dir_open+0x0/0x70
[72037.131620]  [<c03e873a>] ? rwsem_down_read_failed+0x1a/0x24
[72037.131620]  [<c03e874b>] ? call_rwsem_down_read_failed+0x7/0xc
[72037.131620]  [<c03e7d29>] ? down_read+0x9/0x10
[72037.131620]  [<c0250e36>] ? xfs_ilock_map_shared+0x16/0x40
[72037.131620]  [<c027512d>] ? xfs_dir_open+0x3d/0x70
[72037.131620]  [<c0162289>] ? __dentry_open+0x89/0x240
[72037.131620]  [<c0162533>] ? nameidata_to_filp+0x53/0x70
[72037.131620]  [<c016e605>] ? do_filp_open+0x245/0x830
[72037.131620]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72037.131620]  [<c016208b>] ? do_sys_open+0x5b/0x110
[72037.131620]  [<c01621bc>] ? sys_open+0x2c/0x40
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script3.sh D cfa5e400     0 13595  13594
[72037.131620]  00000000 00000086 ccc8c7c0 cfa5e400 cf80c8a0 c539fbc0 cf5a25d0 c0174677
[72037.131620]  cc79babc ffffffff ccc8c7c0 cc79bac0 c03e78bb cb18fe08 c16f3e08 ccc8c7c0
[72037.131620]  ca0d3e74 00000000 ca0d3ed8 ca0d3e74 c03e7819 c016b423 ca0d3e88 cf80c8a0
[72037.131620] Call Trace:
[72037.131620]  [<c0174677>] ? touch_atime+0x97/0x140
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72037.131620]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72037.131620]  [<c0250c70>] ? xfs_iunlock+0x80/0xb0
[72037.131620]  [<c016d573>] ? path_walk+0x53/0xb0
[72037.131620]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72037.131620]  [<c016c756>] ? getname+0x96/0xd0
[72037.131620]  [<c016e22a>] ? user_path_at+0x5a/0x90
[72037.131620]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72037.131620]  [<c01671c7>] ? vfs_fstatat+0x37/0x70
[72037.131620]  [<c01672d8>] ? vfs_stat+0x18/0x20
[72037.131620]  [<c01672ef>] ? sys_stat64+0xf/0x30
[72037.131620]  [<c01649ff>] ? vfs_read+0xff/0x140
[72037.131620]  [<c0125927>] ? sys_rt_sigprocmask+0x67/0xe0
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script2.sh D c8a43f0c     0 13600  13598
[72037.131620]  00000000 00000082 ca2cb520 c8a43f0c c016b3d3 c539f540 cf80c8a0 ca2cb520
[72037.131620]  c73f7cfc ffffffff ca2cb520 c73f7d00 c03e78bb c2eade60 cf053e60 ca2cb520
[72037.131620]  00008068 ffffffea c9023814 00000000 c03e7819 c0162f63 00008068 75a6b2ed
[72037.131620] Call Trace:
[72037.131620]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c0162f63>] ? do_truncate+0x63/0x90
[72037.131620]  [<c0123571>] ? capable+0x21/0x60
[72037.131620]  [<c016c4a2>] ? may_open+0x182/0x200
[72037.131620]  [<c016e5aa>] ? do_filp_open+0x1ea/0x830
[72037.131620]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72037.131620]  [<c016208b>] ? do_sys_open+0x5b/0x110
[72037.131620]  [<c01621bc>] ? sys_open+0x2c/0x40
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script4.sh   D 00000246     0 13603  13602
[72037.131620]  00000000 00000086 ca2cb870 00000246 00000001 c539f060 00000000 0000000e
[72037.131620]  cc79babc ffffffff ca2cb870 cc79bac0 c03e78bb c842fe08 ca0d3e08 ca2cb870
[72037.131620]  cb18fe74 00000000 cb18fed8 cb18fe74 c03e7819 c016b423 cb18fe88 cf80c8a0
[72037.131620] Call Trace:
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72037.131620]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72037.131620]  [<c0174698>] ? touch_atime+0xb8/0x140
[72037.131620]  [<c016d573>] ? path_walk+0x53/0xb0
[72037.131620]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72037.131620]  [<c016c756>] ? getname+0x96/0xd0
[72037.131620]  [<c016e22a>] ? user_path_at+0x5a/0x90
[72037.131620]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72037.131620]  [<c01671c7>] ? vfs_fstatat+0x37/0x70
[72037.131620]  [<c01672d8>] ? vfs_stat+0x18/0x20
[72037.131620]  [<c01672ef>] ? sys_stat64+0xf/0x30
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script5.sh D 0000006c     0 13610  13609
[72037.131620]  00000000 00000086 c82af540 0000006c c045146d ccf488a0 c396b380 c396b39c
[72037.131620]  c049f170 c82af540 cc845ddc c1200080 c03e72e5 c03e7311 cc845dd4 c014111d
[72037.131620]  c0141155 c03e76f2 c1043ba0 c0141150 c04c3440 c82af540 cc845df0 c101b6c0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] sh            D 00000025     0 13647  13646
[72037.131620]  00000000 00000086 c82ae160 00000025 00012dce ccf48700 cfa4ec00 00000025
[72037.131620]  c64051bc ffffffff c82ae160 c64051c0 c03e78bb c2e81e04 c8d2be04 c82ae160
[72037.131620]  c2251e70 00000000 c2251ef4 c2251e70 c03e7819 c016b423 c2251e84 cf80c8a0
[72037.131620] Call Trace:
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72037.131620]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72037.131620]  [<c016d573>] ? path_walk+0x53/0xb0
[72037.131620]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72037.131620]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[72037.131620]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[72037.131620]  [<c0169188>] ? do_execve+0x98/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script1.sh D 0000006c     0 13650  13649
[72037.131620]  00000000 00000082 c82afbe0 0000006c c045146d ccf48080 c9c7e380 c9c7e39c
[72037.131620]  c049f170 c82afbe0 c4167ddc c1200138 c03e72e5 c03e7311 c4167dd4 c014111d
[72037.131620]  c0141155 c03e76f2 c11df300 c0141150 c04c371c c82afbe0 c4167df0 c11adae0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script5.sh D 0000006c     0 13653  13652
[72037.131620]  00000000 00000082 ca2cab30 0000006c c045146d c5863a80 c9c7e380 c9c7e39c
[72037.131620]  c049f170 ca2cab30 c8bd7ddc c1200080 c03e72e5 c03e7311 c8bd7dd4 c014111d
[72037.131620]  c0141155 c03e76f2 c10ec5c0 c0141150 c04c3440 ca2cab30 c8bd7df0 c101b6c0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] sh            D 00000000     0 13686  13685
[72037.131620]  00000000 00000086 c2e55ac0 00000000 cf810890 c5863400 cf4e9498 c0198e90
[72037.131620]  c64051bc ffffffff c2e55ac0 c64051c0 c03e78bb c7b81e04 c2251e04 c2e55ac0
[72037.131620]  c2e81e70 00000000 c2e81ef4 c2e81e70 c03e7819 c016b423 c2e81e84 cf80c8a0
[72037.131620] Call Trace:
[72037.131620]  [<c0198e90>] ? proc_delete_inode+0x0/0x50
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72037.131620]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72037.131620]  [<c016d573>] ? path_walk+0x53/0xb0
[72037.131620]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72037.131620]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[72037.131620]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[72037.131620]  [<c0169188>] ? do_execve+0x98/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script1.sh D 0000006c     0 13689  13688
[72037.131620]  00000000 00000086 c2e55770 0000006c c045146d c58630c0 cbabd380 cbabd39c
[72037.131620]  c049f170 c2e55770 c424dddc c1200138 c03e72e5 c03e7311 c424ddd4 c014111d
[72037.131620]  c0141155 c03e76f2 c1132300 c0141150 c04c371c c2e55770 c424ddf0 c11adae0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script2.sh D c2eadf0c     0 13694  13692
[72037.131620]  00000000 00000086 cb51dae0 c2eadf0c c016b3d3 c3d89900 cf80c8a0 cb51dae0
[72037.131620]  c73f7cfc ffffffff cb51dae0 c73f7d00 c03e78bb cbb7fe60 c8a43e60 cb51dae0
[72037.131620]  00008068 ffffffea c9023814 00000000 c03e7819 c0162f63 00008068 75a6b2ed
[72037.131620] Call Trace:
[72037.131620]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c0162f63>] ? do_truncate+0x63/0x90
[72037.131620]  [<c0123571>] ? capable+0x21/0x60
[72037.131620]  [<c016c4a2>] ? may_open+0x182/0x200
[72037.131620]  [<c016e5aa>] ? do_filp_open+0x1ea/0x830
[72037.131620]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72037.131620]  [<c016208b>] ? do_sys_open+0x5b/0x110
[72037.131620]  [<c01621bc>] ? sys_open+0x2c/0x40
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script5.sh D 0000006c     0 13697  13696
[72037.131620]  00000000 00000082 c2e54040 0000006c c045146d c3d89420 cbabd380 cbabd39c
[72037.131620]  c049f170 c2e54040 c2df3ddc c1200080 c03e72e5 c03e7311 c2df3dd4 c014111d
[72037.131620]  c0141155 c03e76f2 00000000 c0141150 c04c3440 c2e54040 c2df3df0 c101b6c0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015a256>] ? page_add_new_anon_rmap+0x56/0x80
[72037.131620]  [<c0153a7e>] ? handle_mm_fault+0x42e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] vsftpd        D 00000000     0 13718   1821
[72037.131620]  00000000 00000082 cb51cda0 00000000 01007810 c3d890e0 c8f703e0 80000000
[72037.131620]  c049f170 cb51cda0 ce81dc74 c1200110 c03e72e5 c03e7311 ce81dc6c c014111d
[72037.131620]  c03e76f2 00000254 c01410f0 c04c371c cb51cda0 ce81dc88 c11bdd20 c01410cc
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c01410f0>] ? sync_page+0x0/0x60
[72037.131620]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72037.131620]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72037.131620]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c03e87dd>] ? error_code+0x65/0x6c
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72037.131620]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c029e16b>] ? strrchr+0xb/0x20
[72037.131620]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72037.131620]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72037.131620]  [<c016827e>] ? copy_strings+0x16e/0x190
[72037.131620]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72037.131620]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] sh            D 00000030     0 13728  13727
[72037.131620]  00000000 00000086 cb51ca50 00000030 00000000 c4556ba0 00000046 c7b81e1c
[72037.131620]  c64051bc ffffffff cb51ca50 c64051c0 c03e78bb cc879e04 c2e81e04 cb51ca50
[72037.131620]  c7b81e70 00000000 c7b81ef4 c7b81e70 c03e7819 c016b423 c7b81e84 cf80c8a0
[72037.131620] Call Trace:
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72037.131620]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72037.131620]  [<c016d573>] ? path_walk+0x53/0xb0
[72037.131620]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72037.131620]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[72037.131620]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[72037.131620]  [<c0169188>] ? do_execve+0x98/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script1.sh D 0000006c     0 13731  13730
[72037.131620]  00000000 00000086 cb51c060 0000006c c045146d c45566c0 c3715380 c371539c
[72037.131620]  c049f170 cb51c060 cca77ddc c1200138 c03e72e5 c03e7311 cca77dd4 c014111d
[72037.131620]  c0141155 c03e76f2 c10d2aa0 c0141150 c04c371c cb51c060 cca77df0 c11adae0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script5.sh D c769d110     0 13734  13733
[72037.131620]  00000000 00000082 c769d110 c769d110 c769d13c c45561e0 00000fff c011798f
[72037.131620]  c049f170 c769d110 cbf57ddc c1200080 c03e72e5 c03e7311 cbf57dd4 c014111d
[72037.131620]  c0141155 c03e76f2 c0130c89 c0141150 c04c3440 c769d110 cbf57df0 c101b6c0
[72037.131620] Call Trace:
[72037.131620]  [<c011798f>] ? task_tick_fair+0x4f/0x90
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0130c89>] ? hrtimer_run_pending+0x29/0xc0
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] vsftpd        D 00000000     0 13740   1821
[72037.131620]  00000000 00000082 c769c3d0 00000000 01007810 c4556380 c5a160c0 80000000
[72037.131620]  c049f170 c769c3d0 c5f97c74 c1200110 c03e72e5 c03e7311 c5f97c6c c014111d
[72037.131620]  c03e76f2 00000254 c01410f0 c04c371c c769c3d0 c5f97c88 c11bdd20 c01410cc
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c01410f0>] ? sync_page+0x0/0x60
[72037.131620]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72037.131620]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72037.131620]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c03e87dd>] ? error_code+0x65/0x6c
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72037.131620]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c029e16b>] ? strrchr+0xb/0x20
[72037.131620]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72037.131620]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72037.131620]  [<c016827e>] ? copy_strings+0x16e/0x190
[72037.131620]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72037.131620]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] vsftpd        D 00000000     0 13741   1821
[72037.131620]  00000000 00000082 cb51c3b0 00000000 01007810 c87d1d80 c4f8f920 80000000
[72037.131620]  c049f170 cb51c3b0 c7857c74 c1200110 c03e72e5 c03e7311 c7857c6c c014111d
[72037.131620]  c03e76f2 00000254 c01410f0 c04c371c cb51c3b0 c7857c88 c11bdd20 c01410cc
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c01410f0>] ? sync_page+0x0/0x60
[72037.131620]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72037.131620]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72037.131620]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72037.131620]  [<c013fd8e>] ? rcu_process_callbacks+0x1e/0x20
[72037.131620]  [<c0120ab7>] ? __do_softirq+0x77/0xe0
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c03e87dd>] ? error_code+0x65/0x6c
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72037.131620]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c029e16b>] ? strrchr+0xb/0x20
[72037.131620]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72037.131620]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72037.131620]  [<c016827e>] ? copy_strings+0x16e/0x190
[72037.131620]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72037.131620]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] vsftpd        D 00000000     0 13742   1821
[72037.131620]  00000000 00000082 c769c080 00000000 01007810 c87d1080 c5a16d40 80000000
[72037.131620]  c049f170 c769c080 c7833c74 c1200110 c03e72e5 c03e7311 c7833c6c c014111d
[72037.131620]  c03e76f2 00000254 c01410f0 c04c371c c769c080 c7833c88 c11bdd20 c01410cc
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c01410f0>] ? sync_page+0x0/0x60
[72037.131620]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72037.131620]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72037.131620]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c03e87dd>] ? error_code+0x65/0x6c
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72037.131620]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c029e16b>] ? strrchr+0xb/0x20
[72037.131620]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72037.131620]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72037.131620]  [<c016827e>] ? copy_strings+0x16e/0x190
[72037.131620]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72037.131620]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] vsftpd        D 00000000     0 13757   1821
[72037.131620]  00000000 00000082 c769ca70 00000000 01007810 c87d1be0 c3b744a0 80000000
[72037.131620]  c049f170 c769ca70 cbd6dc74 c1200110 c03e72e5 c03e7311 cbd6dc6c c014111d
[72037.131620]  c03e76f2 00000254 c01410f0 c04c371c c769ca70 cbd6dc88 c11bdd20 c01410cc
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c01410f0>] ? sync_page+0x0/0x60
[72037.131620]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72037.131620]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72037.131620]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c03e87dd>] ? error_code+0x65/0x6c
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72037.131620]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72037.131620]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72037.131620]  [<c029e16b>] ? strrchr+0xb/0x20
[72037.131620]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0152937>] ? follow_page+0x117/0x150
[72037.131620]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72037.131620]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72037.131620]  [<c016827e>] ? copy_strings+0x16e/0x190
[72037.131620]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72037.131620]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] sh            D c811ee20     0 13767  13766
[72037.131620]  00000000 00000086 c811ee20 c811ee20 c811ee4c c87d13c0 00000fff 00000010
[72037.131620]  c64051bc ffffffff c811ee20 c64051c0 c03e78bb c64051c0 c7b81e04 c811ee20
[72037.131620]  cc879e70 00000000 cc879ef4 cc879e70 c03e7819 c016b423 cc879e84 cf80c8a0
[72037.131620] Call Trace:
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72037.131620]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72037.131620]  [<c016d573>] ? path_walk+0x53/0xb0
[72037.131620]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72037.131620]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[72037.131620]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[72037.131620]  [<c0169188>] ? do_execve+0x98/0x360
[72037.131620]  [<c01016e6>] ? sys_execve+0x46/0x70
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script1.sh D 0000006c     0 13770  13769
[72037.131620]  00000000 00000086 c811fb60 0000006c c045146d c87d18a0 c6725380 c672539c
[72037.131620]  c049f170 c811fb60 c304dddc c1200138 c03e72e5 c03e7311 c304ddd4 c014111d
[72037.131620]  c0141155 c03e76f2 c11ecf80 c0141150 c04c371c c811fb60 c304ddf0 c11adae0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] sh            D 00000006     0 13772  13771
[72037.131620]  00000000 00000086 c811f4c0 00000006 c94c9011 c3606da0 c1433e88 cf596ab4
[72037.131620]  ca6a9524 ca6a9524 c1433e70 c02750f0 c03e72e5 c03e85fd ca6a9528 c811f4c0
[72037.131620]  c94c9018 ca6a9524 00000000 c4d70a20 c02750f0 c03e873a ca6a9528 ccccbe70
[72037.131620] Call Trace:
[72037.131620]  [<c02750f0>] ? xfs_dir_open+0x0/0x70
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e85fd>] ? rwsem_down_failed_common+0x7d/0x170
[72037.131620]  [<c02750f0>] ? xfs_dir_open+0x0/0x70
[72037.131620]  [<c03e873a>] ? rwsem_down_read_failed+0x1a/0x24
[72037.131620]  [<c03e874b>] ? call_rwsem_down_read_failed+0x7/0xc
[72037.131620]  [<c03e7d29>] ? down_read+0x9/0x10
[72037.131620]  [<c0250e36>] ? xfs_ilock_map_shared+0x16/0x40
[72037.131620]  [<c027512d>] ? xfs_dir_open+0x3d/0x70
[72037.131620]  [<c0162289>] ? __dentry_open+0x89/0x240
[72037.131620]  [<c0162533>] ? nameidata_to_filp+0x53/0x70
[72037.131620]  [<c016e605>] ? do_filp_open+0x245/0x830
[72037.131620]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72037.131620]  [<c016208b>] ? do_sys_open+0x5b/0x110
[72037.131620]  [<c01621bc>] ? sys_open+0x2c/0x40
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script3.sh D cfa5e400     0 13775  13774
[72037.131620]  00000000 00000082 c64afb80 cfa5e400 cf80c8a0 c3606720 cf5a25d0 c0174677
[72037.131620]  cc79babc ffffffff c64afb80 cc79bac0 c03e78bb c3aa5e08 cb18fe08 c64afb80
[72037.131620]  c842fe74 00000000 c842fed8 c842fe74 c03e7819 c016b423 c842fe88 cf80c8a0
[72037.131620] Call Trace:
[72037.131620]  [<c0174677>] ? touch_atime+0x97/0x140
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72037.131620]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72037.131620]  [<c0250c70>] ? xfs_iunlock+0x80/0xb0
[72037.131620]  [<c016d573>] ? path_walk+0x53/0xb0
[72037.131620]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72037.131620]  [<c016c756>] ? getname+0x96/0xd0
[72037.131620]  [<c016e22a>] ? user_path_at+0x5a/0x90
[72037.131620]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72037.131620]  [<c01671c7>] ? vfs_fstatat+0x37/0x70
[72037.131620]  [<c01672d8>] ? vfs_stat+0x18/0x20
[72037.131620]  [<c01672ef>] ? sys_stat64+0xf/0x30
[72037.131620]  [<c01649ff>] ? vfs_read+0xff/0x140
[72037.131620]  [<c0125927>] ? sys_rt_sigprocmask+0x67/0xe0
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script2.sh D cbb7ff0c     0 13780  13778
[72037.131620]  00000000 00000086 c64aeaf0 cbb7ff0c c016b3d3 c36060a0 cf80c8a0 c64aeaf0
[72037.131620]  c73f7cfc ffffffff c64aeaf0 c73f7d00 c03e78bb c73f7d00 c2eade60 c64aeaf0
[72037.131620]  00008068 ffffffea c9023814 00000000 c03e7819 c0162f63 00008068 75a6b2ed
[72037.131620] Call Trace:
[72037.131620]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c0162f63>] ? do_truncate+0x63/0x90
[72037.131620]  [<c0123571>] ? capable+0x21/0x60
[72037.131620]  [<c016c4a2>] ? may_open+0x182/0x200
[72037.131620]  [<c016e5aa>] ? do_filp_open+0x1ea/0x830
[72037.131620]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72037.131620]  [<c016208b>] ? do_sys_open+0x5b/0x110
[72037.131620]  [<c01621bc>] ? sys_open+0x2c/0x40
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script4.sh   D 00000246     0 13783  13782
[72037.131620]  00000000 00000082 c64aee40 00000246 00000001 c3873a80 00000000 0000000e
[72037.131620]  cc79babc ffffffff c64aee40 cc79bac0 c03e78bb cc79bac0 c842fe08 c64aee40
[72037.131620]  c3aa5e74 00000000 c3aa5ed8 c3aa5e74 c03e7819 c016b423 c3aa5e88 cf80c8a0
[72037.131620] Call Trace:
[72037.131620]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72037.131620]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72037.131620]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72037.131620]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72037.131620]  [<c0174698>] ? touch_atime+0xb8/0x140
[72037.131620]  [<c016d573>] ? path_walk+0x53/0xb0
[72037.131620]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72037.131620]  [<c016c756>] ? getname+0x96/0xd0
[72037.131620]  [<c016e22a>] ? user_path_at+0x5a/0x90
[72037.131620]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72037.131620]  [<c01671c7>] ? vfs_fstatat+0x37/0x70
[72037.131620]  [<c01672d8>] ? vfs_stat+0x18/0x20
[72037.131620]  [<c01672ef>] ? sys_stat64+0xf/0x30
[72037.131620]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72037.131620]  [<c0113910>] ? do_page_fault+0x0/0x290
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72037.131620] script5.sh D 0000006c     0 13789  13788
[72037.131620]  00000000 00000086 c4d0ee60 0000006c c045146d c3873400 c6725380 c672539c
[72037.131620]  c049f170 c4d0ee60 c3637ddc c1200080 c03e72e5 c03e7311 c3637dd4 c014111d
[72037.131620]  c0141155 c03e76f2 c1060640 c0141150 c04c3440 c4d0ee60 c3637df0 c101b6c0
[72037.131620] Call Trace:
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e7311>] ? io_schedule+0x11/0x20
[72037.131620]  [<c014111d>] ? sync_page+0x2d/0x60
[72037.131620]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72037.131620]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72037.131620]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72037.131620]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72037.131620]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72037.131620]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72037.131620]  [<c0279716>] ? xfs_read+0x166/0x230
[72037.131620]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72037.131620]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72037.131620]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72037.131620]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72037.131620]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72037.131620]  [<c016499d>] ? vfs_read+0x9d/0x140
[72037.131620]  [<c0164b11>] ? sys_read+0x41/0x80
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26

sysrq-t:

000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script1.sh D 0000006c     0 13472  13471
[72119.690410]  00000000 00000082 cc6d35a0 0000006c c045146d c3833620 c63be380 c63be39c
[72119.690410]  c049f170 cc6d35a0 c9f25ddc c1200138 c03e72e5 c03e7311 c9f25dd4 c014111d
[72119.690410]  c0141155 c03e76f2 c1140820 c0141150 c04c371c cc6d35a0 c9f25df0 c11adae0
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7311>] ? io_schedule+0x11/0x20
[72119.690410]  [<c014111d>] ? sync_page+0x2d/0x60
[72119.690410]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72119.690410]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72119.690410]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72119.690410]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72119.690410]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72119.690410]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72119.690410]  [<c0279716>] ? xfs_read+0x166/0x230
[72119.690410]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S ccc15e88     0 13473   1897
[72119.690410]  00000000 00000086 cc6d38f0 ccc15e88 cf42ee54 c38337c0 c016b3d3 ccc15e9c
[72119.690410]  c6ffee00 ccc15edc ccc15f60 00001000 c03e72e5 c016a175 00000000 cc6d38f0
[72119.690410]  c012dbe0 c6ffee00 c6ffee00 cc744ec0 ccc15edc c016aa6e 000007ca ccc15f60
[72119.690410] Call Trace:
[72119.690410]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13474  13473
[72119.690410]  00000000 00000086 cc6d2bb0 00000000 c11a2500 c9dad2c0 c0152354 0d128067
[72119.690410]  cc6d2ba8 cc6d2bb0 cc6d2cd0 00000003 c03e72e5 c011edd0 cc423f68 00000003
[72119.690410]  00000000 00000004 00000000 bfadaa68 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script5.sh D 0000006c     0 13475  13474
[72119.690410]  00000000 00000086 cc6d2860 0000006c c045146d c3f5cba0 c63be380 c63be39c
[72119.690410]  c049f170 cc6d2860 c9ca1ddc c1200080 c03e72e5 c03e7311 c9ca1dd4 c014111d
[72119.690410]  c0141155 c03e76f2 c1194a40 c0141150 c04c3440 cc6d2860 c9ca1df0 c101b6c0
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7311>] ? io_schedule+0x11/0x20
[72119.690410]  [<c014111d>] ? sync_page+0x2d/0x60
[72119.690410]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72119.690410]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72119.690410]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72119.690410]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72119.690410]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72119.690410]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72119.690410]  [<c0279716>] ? xfs_read+0x166/0x230
[72119.690410]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S c62c5e88     0 13506   1897
[72119.690410]  00000000 00000082 c9fd6dc0 c62c5e88 cf42ee54 c3f5cd40 c016b3d3 c62c5e9c
[72119.690410]  c6ffe200 c62c5edc c62c5f60 00001000 c03e72e5 c016a175 00000000 c9fd6dc0
[72119.690410]  c012dbe0 c6ffe200 c6ffe200 c559fa40 c62c5edc c016aa6e 00000843 c62c5f60
[72119.690410] Call Trace:
[72119.690410]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13507  13506
[72119.690410]  00000000 00000086 c9fd6a70 00000000 c11be1e0 c3f5ca00 c0152354 0df0f067
[72119.690410]  c9fd6a68 c9fd6a70 c9fd6b90 00000003 c03e72e5 c011edd0 c385df68 00000003
[72119.690410]  00000000 00000004 00000000 bf938938 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            D 00000000     0 13508  13507
[72119.690410]  00000000 00000086 c16f4140 00000000 cf810890 c3f5c6c0 cf4037cc c0198e90
[72119.690410]  c64051bc ffffffff c16f4140 c64051c0 c03e78bb cb8b5e04 c35a9e04 c16f4140
[72119.690410]  c36fbe70 00000000 c36fbef4 c36fbe70 c03e7819 c016b423 c36fbe84 cf80c8a0
[72119.690410] Call Trace:
[72119.690410]  [<c0198e90>] ? proc_delete_inode+0x0/0x50
[72119.690410]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72119.690410]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72119.690410]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72119.690410]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72119.690410]  [<c016d573>] ? path_walk+0x53/0xb0
[72119.690410]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72119.690410]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[72119.690410]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[72119.690410]  [<c0169188>] ? do_execve+0x98/0x360
[72119.690410]  [<c01016e6>] ? sys_execve+0x46/0x70
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S c8415e88     0 13509   1897
[72119.690410]  00000000 00000082 c9fd7110 c8415e88 cf42ee54 c3f5c520 c016b3d3 c8415e9c
[72119.690410]  c6ffe800 c8415edc c8415f60 00001000 c03e72e5 c016a175 00000000 c9fd7110
[72119.690410]  c012dbe0 c6ffe800 c6ffe800 c559fd40 c8415edc c016aa6e 00000a5e c8415f60
[72119.690410] Call Trace:
[72119.690410]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13510  13509
[72119.690410]  00000000 00000086 cc6d2510 00000000 c115f9a0 c3f5c860 c0152354 0afcd067
[72119.690410]  cc6d2508 cc6d2510 cc6d2630 00000003 c03e72e5 c011edd0 ccfa7f68 00000003
[72119.690410]  00000000 00000004 00000000 bfde9548 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script1.sh D 0000006c     0 13511  13510
[72119.690410]  00000000 00000082 c9fd7b00 0000006c c045146d c3f5c1e0 c5291380 c529139c
[72119.690410]  c049f170 c9fd7b00 c66d9ddc c1200138 c03e72e5 c03e7311 c66d9dd4 c014111d
[72119.690410]  c0141155 c03e76f2 c11aa100 c0141150 c04c371c c9fd7b00 c66d9df0 c11adae0
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7311>] ? io_schedule+0x11/0x20
[72119.690410]  [<c014111d>] ? sync_page+0x2d/0x60
[72119.690410]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72119.690410]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72119.690410]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72119.690410]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72119.690410]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72119.690410]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72119.690410]  [<c0279716>] ? xfs_read+0x166/0x230
[72119.690410]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S c8f37e88     0 13512   1897
[72119.690410]  00000000 00000082 c9fd7460 c8f37e88 cf42ee54 c3f5c380 c016b3d3 c8f37e9c
[72119.690410]  c6ffea00 c8f37edc c8f37f60 00001000 c03e72e5 c016a175 00000000 c9fd7460
[72119.690410]  c012dbe0 c6ffea00 c6ffea00 cc744a40 c8f37edc c016aa6e 000007bc c8f37f60
[72119.690410] Call Trace:
[72119.690410]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13513  13512
[72119.690410]  00000000 00000082 c9fd77b0 00000000 c1154ac0 c3f5c040 c0152354 0aa56067
[72119.690410]  c9fd77a8 c9fd77b0 c9fd78d0 00000003 c03e72e5 c011edd0 cccd9f68 00000003
[72119.690410]  00000000 00000004 00000000 bfbc66c8 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script2.sh S 00000000     0 13514  13513
[72119.690410]  00000000 00000086 c9fd6720 00000000 c10f6560 c534abc0 c0152354 07b2b067
[72119.690410]  c9fd6718 c9fd6720 c9fd6840 00000003 c03e72e5 c011edd0 c6659f68 00000003
[72119.690410]  00000000 00000004 00000000 bfcd16e8 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script2.sh D cf053f0c     0 13516  13514
[72119.690410]  00000000 00000082 c9fd6080 cf053f0c c016b3d3 c534aa20 cf80c8a0 c9fd6080
[72119.690410]  c73f7cfc ffffffff c9fd6080 c73f7d00 c03e78bb c8a43e60 c16f7e60 c9fd6080
[72119.690410]  00008068 ffffffea c9023814 00000000 c03e7819 c0162f63 00008068 75a6b2ed
[72119.690410] Call Trace:
[72119.690410]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[72119.690410]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72119.690410]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72119.690410]  [<c0162f63>] ? do_truncate+0x63/0x90
[72119.690410]  [<c0123571>] ? capable+0x21/0x60
[72119.690410]  [<c016c4a2>] ? may_open+0x182/0x200
[72119.690410]  [<c016e5aa>] ? do_filp_open+0x1ea/0x830
[72119.690410]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72119.690410]  [<c016208b>] ? do_sys_open+0x5b/0x110
[72119.690410]  [<c01621bc>] ? sys_open+0x2c/0x40
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S c8505e88     0 13517   1897
[72119.690410]  00000000 00000086 c463db20 c8505e88 cf42ee54 c534ad60 c016b3d3 c8505e9c
[72119.690410]  c59dae00 c8505edc c8505f60 00001000 c03e72e5 c016a175 00000000 c463db20
[72119.690410]  c012dbe0 c59dae00 c59dae00 cc7442c0 c8505edc c016aa6e 00000911 c8505f60
[72119.690410] Call Trace:
[72119.690410]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13518  13517
[72119.690410]  00000000 00000082 c463d7d0 00000000 c11d8280 c534a880 c0152354 0ec14067
[72119.690410]  c463d7c8 c463d7d0 c463d8f0 00000003 c03e72e5 c011edd0 c5b3df68 00000003
[72119.690410]  00000000 00000004 00000000 bfe2c078 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script5.sh D 0000006c     0 13519  13518
[72119.690410]  00000000 00000082 c9fd63d0 0000006c c045146d c534a540 c5291380 c529139c
[72119.690410]  c049f170 c9fd63d0 cfab1ddc c1200080 c03e72e5 c03e7311 cfab1dd4 c014111d
[72119.690410]  c0141155 c03e76f2 c104be00 c0141150 c04c3440 c9fd63d0 cfab1df0 c101b6c0
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7311>] ? io_schedule+0x11/0x20
[72119.690410]  [<c014111d>] ? sync_page+0x2d/0x60
[72119.690410]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72119.690410]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72119.690410]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72119.690410]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72119.690410]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72119.690410]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72119.690410]  [<c0279716>] ? xfs_read+0x166/0x230
[72119.690410]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S 00000001     0 13547   1897
[72119.690410]  00000000 00000086 cc6d21c0 00000001 c04c3784 c534a3a0 c03efda0 0000002c
[72119.690410]  c59da400 c6013edc c6013f60 00001000 c03e72e5 c016a175 00000000 cc6d21c0
[72119.690410]  c012dbe0 c59da400 c59da400 c3881d40 c6013edc c016aa6e 000008ac c6013f60
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0134e54>] ? getnstimeofday+0x54/0x110
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13548  13547
[72119.690410]  00000000 00000082 c9367b40 00000000 c10b9080 c534a6e0 c0152354 05c84067
[72119.690410]  c9367b38 c9367b40 c9367c60 00000003 c03e72e5 c011edd0 ceca5f68 00000003
[72119.690410]  00000000 00000004 00000000 bff5c4e8 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            D 00000000     0 13549  13548
[72119.690410]  00000000 00000086 c463cde0 00000000 cf810890 c534a200 cf4031a0 c0198e90
[72119.690410]  c64051bc ffffffff c463cde0 c64051c0 c03e78bb c8d2be04 c36fbe04 c463cde0
[72119.690410]  cb8b5e70 00000000 cb8b5ef4 cb8b5e70 c03e7819 c016b423 cb8b5e84 cf80c8a0
[72119.690410] Call Trace:
[72119.690410]  [<c0198e90>] ? proc_delete_inode+0x0/0x50
[72119.690410]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72119.690410]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72119.690410]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72119.690410]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72119.690410]  [<c016d573>] ? path_walk+0x53/0xb0
[72119.690410]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72119.690410]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[72119.690410]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[72119.690410]  [<c0169188>] ? do_execve+0x98/0x360
[72119.690410]  [<c01016e6>] ? sys_execve+0x46/0x70
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S cc4a5e88     0 13550   1897
[72119.690410]  00000000 00000086 c463c740 cc4a5e88 cf42ee54 c534a060 c016b3d3 cc4a5e9c
[72119.690410]  c59da000 cc4a5edc cc4a5f60 00001000 c03e72e5 c016a175 00000000 c463c740
[72119.690410]  c012dbe0 c59da000 c59da000 c874ac20 cc4a5edc c016aa6e 000007f4 cc4a5f60
[72119.690410] Call Trace:
[72119.690410]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13551  13550
[72119.690410]  00000000 00000082 c463c3f0 00000000 c1042a80 ce1abde0 c0152354 02154067
[72119.690410]  c463c3e8 c463c3f0 c463c510 00000003 c03e72e5 c011edd0 c8ccbf68 00000003
[72119.690410]  00000000 00000004 00000000 bfbbfe68 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script1.sh D 0000006c     0 13552  13551
[72119.690410]  00000000 00000086 c463d480 0000006c c045146d ce1abaa0 ce37a380 ce37a39c
[72119.690410]  c049f170 c463d480 ce337ddc c1200138 c03e72e5 c03e7311 ce337dd4 c014111d
[72119.690410]  c0141155 c03e76f2 c10e52a0 c0141150 c04c371c c463d480 ce337df0 c11adae0
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7311>] ? io_schedule+0x11/0x20
[72119.690410]  [<c014111d>] ? sync_page+0x2d/0x60
[72119.690410]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72119.690410]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72119.690410]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72119.690410]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72119.690410]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72119.690410]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72119.690410]  [<c0279716>] ? xfs_read+0x166/0x230
[72119.690410]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S c3d73e88     0 13553   1897
[72119.690410]  00000000 00000082 c463c0a0 c3d73e88 c04c3774 ce1abc40 c03efda0 0000002c
[72119.690410]  c59daa00 c3d73edc c3d73f60 00001000 c03e72e5 c016a175 00000000 c463c0a0
[72119.690410]  c012dbe0 c59daa00 c59daa00 c3881b40 c3d73edc c016aa6e 000008cc c3d73f60
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13554  13553
[72119.690410]  00000000 00000086 c463ca90 00000000 c10ec560 ce1ab900 c0152354 0762b067
[72119.690410]  c463ca88 c463ca90 c463cbb0 00000003 c03e72e5 c011edd0 c16fdf68 00000003
[72119.690410]  00000000 00000004 00000000 bfd79898 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script5.sh D 0000006c     0 13555  13554
[72119.690410]  00000000 00000086 c93677f0 0000006c c045146d ce1ab5c0 ce37a380 ce37a39c
[72119.690410]  c049f170 c93677f0 c4585ddc c1200080 c03e72e5 c03e7311 c4585dd4 c014111d
[72119.690410]  c0141155 c03e76f2 c1180540 c0141150 c04c3440 c93677f0 c4585df0 c101b6c0
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7311>] ? io_schedule+0x11/0x20
[72119.690410]  [<c014111d>] ? sync_page+0x2d/0x60
[72119.690410]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72119.690410]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72119.690410]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72119.690410]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72119.690410]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72119.690410]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72119.690410]  [<c0279716>] ? xfs_read+0x166/0x230
[72119.690410]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] vsftpd        D 00000000     0 13561   1821
[72119.690410]  00000000 00000082 c463d130 00000000 01007810 ce1ab0e0 c4d7e5e0 80000000
[72119.690410]  c049f170 c463d130 c84f9c74 c1200110 c03e72e5 c03e7311 c84f9c6c c014111d
[72119.690410]  c03e76f2 00000254 c01410f0 c04c371c c463d130 c84f9c88 c11bdd20 c01410cc
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7311>] ? io_schedule+0x11/0x20
[72119.690410]  [<c014111d>] ? sync_page+0x2d/0x60
[72119.690410]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72119.690410]  [<c01410f0>] ? sync_page+0x0/0x60
[72119.690410]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72119.690410]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72119.690410]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72119.690410]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72119.690410]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72119.690410]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72119.690410]  [<c0113910>] ? do_page_fault+0x0/0x290
[72119.690410]  [<c03e87dd>] ? error_code+0x65/0x6c
[72119.690410]  [<c0113910>] ? do_page_fault+0x0/0x290
[72119.690410]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72119.690410]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72119.690410]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72119.690410]  [<c029e16b>] ? strrchr+0xb/0x20
[72119.690410]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72119.690410]  [<c0152937>] ? follow_page+0x117/0x150
[72119.690410]  [<c0152937>] ? follow_page+0x117/0x150
[72119.690410]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72119.690410]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72119.690410]  [<c016827e>] ? copy_strings+0x16e/0x190
[72119.690410]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72119.690410]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72119.690410]  [<c01016e6>] ? sys_execve+0x46/0x70
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] vsftpd        D 00000000     0 13562   1821
[72119.690410]  00000000 00000082 c93674a0 00000000 01007810 ce1ab420 c874ab20 80000000
[72119.690410]  c049f170 c93674a0 c9c81c74 c1200110 c03e72e5 c03e7311 c9c81c6c c014111d
[72119.690410]  c03e76f2 00000254 c01410f0 c04c371c c93674a0 c9c81c88 c11bdd20 c01410cc
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7311>] ? io_schedule+0x11/0x20
[72119.690410]  [<c014111d>] ? sync_page+0x2d/0x60
[72119.690410]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72119.690410]  [<c01410f0>] ? sync_page+0x0/0x60
[72119.690410]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72119.690410]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72119.690410]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72119.690410]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72119.690410]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72119.690410]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72119.690410]  [<c0113910>] ? do_page_fault+0x0/0x290
[72119.690410]  [<c03e87dd>] ? error_code+0x65/0x6c
[72119.690410]  [<c0113910>] ? do_page_fault+0x0/0x290
[72119.690410]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72119.690410]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72119.690410]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72119.690410]  [<c029e16b>] ? strrchr+0xb/0x20
[72119.690410]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72119.690410]  [<c0152937>] ? follow_page+0x117/0x150
[72119.690410]  [<c0152937>] ? follow_page+0x117/0x150
[72119.690410]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72119.690410]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72119.690410]  [<c016827e>] ? copy_strings+0x16e/0x190
[72119.690410]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72119.690410]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72119.690410]  [<c01016e6>] ? sys_execve+0x46/0x70
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] vsftpd        D 00000000     0 13577   1821
[72119.690410]  00000000 00000086 c93660c0 00000000 01007810 ce1ab760 c4d7ed60 80000000
[72119.690410]  c049f170 c93660c0 c4fc7c74 c1200110 c03e72e5 c03e7311 c4fc7c6c c014111d
[72119.690410]  c03e76f2 00000254 c01410f0 c04c371c c93660c0 c4fc7c88 c11bdd20 c01410cc
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7311>] ? io_schedule+0x11/0x20
[72119.690410]  [<c014111d>] ? sync_page+0x2d/0x60
[72119.690410]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72119.690410]  [<c01410f0>] ? sync_page+0x0/0x60
[72119.690410]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72119.690410]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72119.690410]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72119.690410]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72119.690410]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72119.690410]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72119.690410]  [<c0113910>] ? do_page_fault+0x0/0x290
[72119.690410]  [<c03e87dd>] ? error_code+0x65/0x6c
[72119.690410]  [<c0113910>] ? do_page_fault+0x0/0x290
[72119.690410]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72119.690410]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72119.690410]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72119.690410]  [<c029e16b>] ? strrchr+0xb/0x20
[72119.690410]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72119.690410]  [<c0152937>] ? follow_page+0x117/0x150
[72119.690410]  [<c0152937>] ? follow_page+0x117/0x150
[72119.690410]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72119.690410]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72119.690410]  [<c016827e>] ? copy_strings+0x16e/0x190
[72119.690410]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72119.690410]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72119.690410]  [<c01016e6>] ? sys_execve+0x46/0x70
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S c3ddde88     0 13585   1897
[72119.690410]  00000000 00000082 ccc8d500 c3ddde88 c04c377c ce1ab280 c03efda0 0000002c
[72119.690410]  c5054400 c3dddedc c3dddf60 00001000 c03e72e5 c016a175 00000000 ccc8d500
[72119.690410]  c012dbe0 c5054400 c5054400 ce2d99e0 c3dddedc c016aa6e 00000845 c3dddf60
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13586  13585
[72119.690410]  00000000 00000082 ccc8d1b0 00000000 c10330c0 c8c65d40 c0152354 01986067
[72119.690410]  ccc8d1a8 ccc8d1b0 ccc8d2d0 00000003 c03e72e5 c011edd0 c90eff68 00000003
[72119.690410]  00000000 00000004 00000000 bfe0f588 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            D 00000000     0 13587  13586
[72119.690410]  00000000 00000086 c9366ab0 00000000 cf810890 c8c65a00 cf4d6730 c0198e90
[72119.690410]  c64051bc ffffffff c9366ab0 c64051c0 c03e78bb c2251e04 cb8b5e04 c9366ab0
[72119.690410]  c8d2be70 00000000 c8d2bef4 c8d2be70 c03e7819 c016b423 c8d2be84 cf80c8a0
[72119.690410] Call Trace:
[72119.690410]  [<c0198e90>] ? proc_delete_inode+0x0/0x50
[72119.690410]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72119.690410]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72119.690410]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72119.690410]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72119.690410]  [<c016d573>] ? path_walk+0x53/0xb0
[72119.690410]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72119.690410]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[72119.690410]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[72119.690410]  [<c0169188>] ? do_execve+0x98/0x360
[72119.690410]  [<c01016e6>] ? sys_execve+0x46/0x70
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S c57e1e88     0 13588   1897
[72119.690410]  00000000 00000086 ccc8d850 c57e1e88 cf42ee54 c8c65ba0 c016b3d3 c57e1e9c
[72119.690410]  c5054a00 c57e1edc c57e1f60 00001000 c03e72e5 c016a175 00000000 ccc8d850
[72119.690410]  c012dbe0 c5054a00 c5054a00 c9faf8c0 c57e1edc c016aa6e 00000862 c57e1f60
[72119.690410] Call Trace:
[72119.690410]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13589  13588
[72119.690410]  00000000 00000086 c9366e00 00000000 c11673a0 c8c65860 c0152354 0b39d067
[72119.690410]  c9366df8 c9366e00 c9366f20 00000003 c03e72e5 c011edd0 cbba9f68 00000003
[72119.690410]  00000000 00000004 00000000 bfd40868 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script1.sh D c0144a8e     0 13590  13589
[72119.690410]  00000000 00000082 c9366410 c0144a8e c045146d c8c65520 c396b380 c396b39c
[72119.690410]  c049f170 c9366410 c45ffddc c1200138 c03e72e5 c03e7311 c45ffdd4 c014111d
[72119.690410]  c0141155 c03e76f2 c10301e0 c0141150 c04c371c c9366410 c45ffdf0 c11adae0
[72119.690410] Call Trace:
[72119.690410]  [<c0144a8e>] ? __rmqueue+0x1e/0x220
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7311>] ? io_schedule+0x11/0x20
[72119.690410]  [<c014111d>] ? sync_page+0x2d/0x60
[72119.690410]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72119.690410]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72119.690410]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72119.690410]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72119.690410]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72119.690410]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72119.690410]  [<c0279716>] ? xfs_read+0x166/0x230
[72119.690410]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S c668fe88     0 13591   1897
[72119.690410]  00000000 00000086 ccc8dba0 c668fe88 cf42ee54 c8c656c0 c016b3d3 c668fe9c
[72119.690410]  c4d8ce00 c668fedc c668ff60 00001000 c03e72e5 c016a175 00000000 ccc8dba0
[72119.690410]  c012dbe0 c4d8ce00 c4d8ce00 c559f1c0 c668fedc c016aa6e 00000799 c668ff60
[72119.690410] Call Trace:
[72119.690410]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            D 00000006     0 13592  13591
[72119.690410]  00000000 00000082 c9367150 00000006 c9760011 c8c65380 ccccbe88 cf596ab4
[72119.690410]  ca6a9524 ca6a9524 ccccbe70 c02750f0 c03e72e5 c03e85fd ca6a9528 c9367150
[72119.690410]  c9760018 ca6a9524 00000000 c9faf440 c02750f0 c03e873a c1433e70 c16e5e70
[72119.690410] Call Trace:
[72119.690410]  [<c02750f0>] ? xfs_dir_open+0x0/0x70
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e85fd>] ? rwsem_down_failed_common+0x7d/0x170
[72119.690410]  [<c02750f0>] ? xfs_dir_open+0x0/0x70
[72119.690410]  [<c03e873a>] ? rwsem_down_read_failed+0x1a/0x24
[72119.690410]  [<c03e874b>] ? call_rwsem_down_read_failed+0x7/0xc
[72119.690410]  [<c03e7d29>] ? down_read+0x9/0x10
[72119.690410]  [<c0250e36>] ? xfs_ilock_map_shared+0x16/0x40
[72119.690410]  [<c027512d>] ? xfs_dir_open+0x3d/0x70
[72119.690410]  [<c0162289>] ? __dentry_open+0x89/0x240
[72119.690410]  [<c0162533>] ? nameidata_to_filp+0x53/0x70
[72119.690410]  [<c016e605>] ? do_filp_open+0x245/0x830
[72119.690410]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72119.690410]  [<c016208b>] ? do_sys_open+0x5b/0x110
[72119.690410]  [<c01621bc>] ? sys_open+0x2c/0x40
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S cbd63e88     0 13593   1897
[72119.690410]  00000000 00000082 ccc8ce60 cbd63e88 c04c3784 c8c651e0 c03efda0 0000002c
[72119.690410]  c4d8ca00 cbd63edc cbd63f60 00001000 c03e72e5 c016a175 00000000 ccc8ce60
[72119.690410]  c012dbe0 c4d8ca00 c4d8ca00 c9fafcc0 cbd63edc c016aa6e 000011c0 cbd63f60
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13594  13593
[72119.690410]  00000000 00000082 ccc8cb10 00000000 c11905a0 c8c65040 c0152354 0c82d067
[72119.690410]  ccc8cb08 ccc8cb10 ccc8cc30 00000003 c03e72e5 c011edd0 cc92ff68 00000003
[72119.690410]  00000000 00000004 00000000 bfcd22e8 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script3.sh D cfa5e400     0 13595  13594
[72119.690410]  00000000 00000086 ccc8c7c0 cfa5e400 cf80c8a0 c539fbc0 cf5a25d0 c0174677
[72119.690410]  cc79babc ffffffff ccc8c7c0 cc79bac0 c03e78bb cb18fe08 c16f3e08 ccc8c7c0
[72119.690410]  ca0d3e74 00000000 ca0d3ed8 ca0d3e74 c03e7819 c016b423 ca0d3e88 cf80c8a0
[72119.690410] Call Trace:
[72119.690410]  [<c0174677>] ? touch_atime+0x97/0x140
[72119.690410]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72119.690410]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72119.690410]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72119.690410]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72119.690410]  [<c0250c70>] ? xfs_iunlock+0x80/0xb0
[72119.690410]  [<c016d573>] ? path_walk+0x53/0xb0
[72119.690410]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72119.690410]  [<c016c756>] ? getname+0x96/0xd0
[72119.690410]  [<c016e22a>] ? user_path_at+0x5a/0x90
[72119.690410]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72119.690410]  [<c01671c7>] ? vfs_fstatat+0x37/0x70
[72119.690410]  [<c01672d8>] ? vfs_stat+0x18/0x20
[72119.690410]  [<c01672ef>] ? sys_stat64+0xf/0x30
[72119.690410]  [<c01649ff>] ? vfs_read+0xff/0x140
[72119.690410]  [<c0125927>] ? sys_rt_sigprocmask+0x67/0xe0
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S c011a562     0 13596   1897
[72119.690410]  00000000 00000086 ccc8c470 c011a562 ccc8c470 c539fd60 c82b5e3c c82b5e3c
[72119.690410]  c4d8c600 c82b5edc c82b5f60 00001000 c03e72e5 c016a175 00000000 ccc8c470
[72119.690410]  c012dbe0 c4d8c600 c4d8c600 c5b4d7a0 c82b5edc c016aa6e 0000064d c82b5f60
[72119.690410] Call Trace:
[72119.690410]  [<c011a562>] ? scheduler_tick+0x82/0x90
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13597  13596
[72119.690410]  00000000 00000082 ccc8c120 00000000 c1182f00 c539fa20 c0152354 0c178067
[72119.690410]  ccc8c118 ccc8c120 ccc8c240 00000003 c03e72e5 c011edd0 c7ab3f68 00000003
[72119.690410]  00000000 00000004 00000000 bfecf8d8 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script2.sh S 00000000     0 13598  13597
[72119.690410]  00000000 00000082 ca2cbbc0 00000000 c1049340 c539f6e0 c0152354 0249a067
[72119.690410]  ca2cbbb8 ca2cbbc0 ca2cbce0 00000003 c03e72e5 c011edd0 cbe1bf68 00000003
[72119.690410]  00000000 00000004 00000000 bfa3c788 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script2.sh D c8a43f0c     0 13600  13598
[72119.690410]  00000000 00000082 ca2cb520 c8a43f0c c016b3d3 c539f540 cf80c8a0 ca2cb520
[72119.690410]  c73f7cfc ffffffff ca2cb520 c73f7d00 c03e78bb c2eade60 cf053e60 ca2cb520
[72119.690410]  00008068 ffffffea c9023814 00000000 c03e7819 c0162f63 00008068 75a6b2ed
[72119.690410] Call Trace:
[72119.690410]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[72119.690410]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72119.690410]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72119.690410]  [<c0162f63>] ? do_truncate+0x63/0x90
[72119.690410]  [<c0123571>] ? capable+0x21/0x60
[72119.690410]  [<c016c4a2>] ? may_open+0x182/0x200
[72119.690410]  [<c016e5aa>] ? do_filp_open+0x1ea/0x830
[72119.690410]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72119.690410]  [<c016208b>] ? do_sys_open+0x5b/0x110
[72119.690410]  [<c01621bc>] ? sys_open+0x2c/0x40
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S c723de88     0 13601   1897
[72119.690410]  00000000 00000082 ca2cb1d0 c723de88 c04c3784 c539f880 c03efda0 0000002c
[72119.690410]  c4d8c200 c723dedc c723df60 00001000 c03e72e5 c016a175 00000000 ca2cb1d0
[72119.690410]  c012dbe0 c4d8c200 c4d8c200 c9faf740 c723dedc c016aa6e 00000772 c723df60
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13602  13601
[72119.690410]  00000000 00000086 ca2cae80 00000000 c104e800 c539f3a0 c0152354 02740067
[72119.690410]  ca2cae78 ca2cae80 ca2cafa0 00000003 c03e72e5 c011edd0 c7255f68 00000003
[72119.690410]  00000000 00000004 00000000 bffc80f8 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script4.sh   D 00000246     0 13603  13602
[72119.690410]  00000000 00000086 ca2cb870 00000246 00000001 c539f060 00000000 0000000e
[72119.690410]  cc79babc ffffffff ca2cb870 cc79bac0 c03e78bb c842fe08 ca0d3e08 ca2cb870
[72119.690410]  cb18fe74 00000000 cb18fed8 cb18fe74 c03e7819 c016b423 cb18fe88 cf80c8a0
[72119.690410] Call Trace:
[72119.690410]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72119.690410]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72119.690410]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72119.690410]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72119.690410]  [<c0174698>] ? touch_atime+0xb8/0x140
[72119.690410]  [<c016d573>] ? path_walk+0x53/0xb0
[72119.690410]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72119.690410]  [<c016c756>] ? getname+0x96/0xd0
[72119.690410]  [<c016e22a>] ? user_path_at+0x5a/0x90
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c01671c7>] ? vfs_fstatat+0x37/0x70
[72119.690410]  [<c01672d8>] ? vfs_stat+0x18/0x20
[72119.690410]  [<c01672ef>] ? sys_stat64+0xf/0x30
[72119.690410]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72119.690410]  [<c0113910>] ? do_page_fault+0x0/0x290
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S 00000000     0 13606   1897
[72119.690410]  00000000 00000082 ca2ca490 00000000 00000000 ccf48be0 c04c3740 00000246
[72119.690410]  cce7dc00 cfd8bedc cfd8bf60 00001000 c03e72e5 c016a175 00000000 ca2ca490
[72119.690410]  c012dbe0 cce7dc00 cce7dc00 c874a6a0 cfd8bedc c016aa6e 00000a5f cfd8bf60
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13609  13606
[72119.690410]  00000000 00000086 c82af890 00000000 c11457a0 c539f200 c0152354 0a2bd067
[72119.690410]  c82af888 c82af890 c82af9b0 00000003 c03e72e5 c011edd0 c19d1f68 00000003
[72119.690410]  00000000 00000004 00000000 bfb16c88 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script5.sh D 0000006c     0 13610  13609
[72119.690410]  00000000 00000086 c82af540 0000006c c045146d ccf488a0 c396b380 c396b39c
[72119.690410]  c049f170 c82af540 cc845ddc c1200080 c03e72e5 c03e7311 cc845dd4 c014111d
[72119.690410]  c0141155 c03e76f2 c1043ba0 c0141150 c04c3440 c82af540 cc845df0 c101b6c0
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7311>] ? io_schedule+0x11/0x20
[72119.690410]  [<c014111d>] ? sync_page+0x2d/0x60
[72119.690410]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72119.690410]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72119.690410]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72119.690410]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72119.690410]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72119.690410]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72119.690410]  [<c0279716>] ? xfs_read+0x166/0x230
[72119.690410]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S c2a53e88     0 13645   1897
[72119.690410]  00000000 00000086 c9366760 c2a53e88 c04c3784 ccf48560 c03efda0 0000002c
[72119.690410]  c4d8c000 c2a53edc c2a53f60 00001000 c03e72e5 c016a175 00000000 c9366760
[72119.690410]  c012dbe0 c4d8c000 c4d8c000 c528d7e0 c2a53edc c016aa6e 000008d0 c2a53f60
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13646  13645
[72119.690410]  c82af374 00000082 c82af1f0 00000000 c10e0be0 ccf48220 c0152354 0705f067
[72119.690410]  c82af1e8 c82af1f0 c82af310 00000003 c03e72e5 c011edd0 c4991f68 00000003
[72119.690410]  00000000 00000004 00000000 bf918db8 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            D 00000025     0 13647  13646
[72119.690410]  00000000 00000086 c82ae160 00000025 00012dce ccf48700 cfa4ec00 00000025
[72119.690410]  c64051bc ffffffff c82ae160 c64051c0 c03e78bb c2e81e04 c8d2be04 c82ae160
[72119.690410]  c2251e70 00000000 c2251ef4 c2251e70 c03e7819 c016b423 c2251e84 cf80c8a0
[72119.690410] Call Trace:
[72119.690410]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72119.690410]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72119.690410]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72119.690410]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72119.690410]  [<c016d573>] ? path_walk+0x53/0xb0
[72119.690410]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72119.690410]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[72119.690410]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[72119.690410]  [<c0169188>] ? do_execve+0x98/0x360
[72119.690410]  [<c01016e6>] ? sys_execve+0x46/0x70
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S c227be88     0 13648   1897
[72119.690410]  00000000 00000082 c82aeea0 c227be88 c04c3784 ccf48a40 c03efda0 0000002c
[72119.690410]  cce7d600 c227bedc c227bf60 00001000 c03e72e5 c016a175 00000000 c82aeea0
[72119.690410]  c012dbe0 cce7d600 cce7d600 c56aea20 c227bedc c016aa6e 00000635 c227bf60
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13649  13648
[72119.690410]  00000000 00000086 c82ae4b0 00000000 c1031220 ccf483c0 c0152354 01891067
[72119.690410]  c82ae4a8 c82ae4b0 c82ae5d0 00000003 c03e72e5 c011edd0 cdbebf68 00000003
[72119.690410]  00000000 00000004 00000000 bfedc998 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script1.sh D 0000006c     0 13650  13649
[72119.690410]  00000000 00000082 c82afbe0 0000006c c045146d ccf48080 c9c7e380 c9c7e39c
[72119.690410]  c049f170 c82afbe0 c4167ddc c1200138 c03e72e5 c03e7311 c4167dd4 c014111d
[72119.690410]  c0141155 c03e76f2 c11df300 c0141150 c04c371c c82afbe0 c4167df0 c11adae0
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7311>] ? io_schedule+0x11/0x20
[72119.690410]  [<c014111d>] ? sync_page+0x2d/0x60
[72119.690410]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72119.690410]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72119.690410]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72119.690410]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72119.690410]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72119.690410]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72119.690410]  [<c0279716>] ? xfs_read+0x166/0x230
[72119.690410]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S c468fe88     0 13651   1897
[72119.690410]  00000000 00000082 c82ae800 c468fe88 c04c3784 ccf48d80 c03efda0 0000002c
[72119.690410]  cce7d200 c468fedc c468ff60 00001000 c03e72e5 c016a175 00000000 c82ae800
[72119.690410]  c012dbe0 cce7d200 cce7d200 c528d160 c468fedc c016aa6e 00000920 c468ff60
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13652  13651
[72119.690410]  00000000 00000086 ca2ca140 00000000 c115ac20 c5863dc0 c0152354 0ad61067
[72119.690410]  ca2ca138 ca2ca140 ca2ca260 00000003 c03e72e5 c011edd0 cc979f68 00000003
[72119.690410]  00000000 00000004 00000000 bf958f58 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script5.sh D 0000006c     0 13653  13652
[72119.690410]  00000000 00000082 ca2cab30 0000006c c045146d c5863a80 c9c7e380 c9c7e39c
[72119.690410]  c049f170 ca2cab30 c8bd7ddc c1200080 c03e72e5 c03e7311 c8bd7dd4 c014111d
[72119.690410]  c0141155 c03e76f2 c10ec5c0 c0141150 c04c3440 ca2cab30 c8bd7df0 c101b6c0
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7311>] ? io_schedule+0x11/0x20
[72119.690410]  [<c014111d>] ? sync_page+0x2d/0x60
[72119.690410]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72119.690410]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72119.690410]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72119.690410]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72119.690410]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72119.690410]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72119.690410]  [<c0279716>] ? xfs_read+0x166/0x230
[72119.690410]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S c7085e88     0 13684   1897
[72119.690410]  00000000 00000082 c2e54a30 c7085e88 c04c3784 c5863c20 c03efda0 0000002c
[72119.690410]  c663cc00 c7085edc c7085f60 00001000 c03e72e5 c016a175 00000000 c2e54a30
[72119.690410]  c012dbe0 c663cc00 c663cc00 c3b74c20 c7085edc c016aa6e 0000080d c7085f60
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13685  13684
[72119.690410]  00000000 00000082 c2e546e0 00000000 c11b5e40 c58638e0 c0152354 0daf2067
[72119.690410]  c2e546d8 c2e546e0 c2e54800 00000003 c03e72e5 c011edd0 cb1f7f68 00000003
[72119.690410]  00000000 00000004 00000000 bfc38f18 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            D 00000000     0 13686  13685
[72119.690410]  00000000 00000086 c2e55ac0 00000000 cf810890 c5863400 cf4e9498 c0198e90
[72119.690410]  c64051bc ffffffff c2e55ac0 c64051c0 c03e78bb c7b81e04 c2251e04 c2e55ac0
[72119.690410]  c2e81e70 00000000 c2e81ef4 c2e81e70 c03e7819 c016b423 c2e81e84 cf80c8a0
[72119.690410] Call Trace:
[72119.690410]  [<c0198e90>] ? proc_delete_inode+0x0/0x50
[72119.690410]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72119.690410]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72119.690410]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72119.690410]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72119.690410]  [<c016d573>] ? path_walk+0x53/0xb0
[72119.690410]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72119.690410]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[72119.690410]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[72119.690410]  [<c0169188>] ? do_execve+0x98/0x360
[72119.690410]  [<c01016e6>] ? sys_execve+0x46/0x70
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S ca371e88     0 13687   1897
[72119.690410]  00000000 00000082 ca2ca7e0 ca371e88 c04c3784 c5863740 c03efda0 0000002c
[72119.690410]  c663c400 ca371edc ca371f60 00001000 c03e72e5 c016a175 00000000 ca2ca7e0
[72119.690410]  c012dbe0 c663c400 c663c400 c4d702a0 ca371edc c016aa6e 0000088f ca371f60
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13688  13687
[72119.690410]  00000000 00000086 c2e54d80 00000000 c10b91c0 c58635a0 c0152354 05c8e067
[72119.690410]  c2e54d78 c2e54d80 c2e54ea0 00000003 c03e72e5 c011edd0 c27f5f68 00000003
[72119.690410]  00000000 00000004 00000000 bfebb7e8 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script1.sh D 0000006c     0 13689  13688
[72119.690410]  00000000 00000086 c2e55770 0000006c c045146d c58630c0 cbabd380 cbabd39c
[72119.690410]  c049f170 c2e55770 c424dddc c1200138 c03e72e5 c03e7311 c424ddd4 c014111d
[72119.690410]  c0141155 c03e76f2 c1132300 c0141150 c04c371c c2e55770 c424ddf0 c11adae0
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7311>] ? io_schedule+0x11/0x20
[72119.690410]  [<c014111d>] ? sync_page+0x2d/0x60
[72119.690410]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72119.690410]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72119.690410]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72119.690410]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72119.690410]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72119.690410]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72119.690410]  [<c0279716>] ? xfs_read+0x166/0x230
[72119.690410]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S cbf01e88     0 13690   1897
[72119.690410]  00000000 00000086 c2e550d0 cbf01e88 c04c3784 c5863260 c03efda0 0000002c
[72119.690410]  c663c000 cbf01edc cbf01f60 00001000 c03e72e5 c016a175 00000000 c2e550d0
[72119.690410]  c012dbe0 c663c000 c663c000 c8f70260 cbf01edc c016aa6e 00000610 cbf01f60
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13691  13690
[72119.690410]  00000000 00000082 c2e55420 00000000 c1192a20 c3d89de0 c0152354 0c951067
[72119.690410]  c2e55418 c2e55420 c2e55540 00000003 c03e72e5 c011edd0 ca645f68 00000003
[72119.690410]  00000000 00000004 00000000 bfb8a658 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script2.sh S 00000000     0 13692  13691
[72119.690410]  00000000 00000086 c2e54390 00000000 c11a4760 c3d89aa0 c0152354 0d23b067
[72119.690410]  c2e54388 c2e54390 c2e544b0 00000003 c03e72e5 c011edd0 c30e1f68 00000003
[72119.690410]  00000000 00000004 00000000 bfb577f8 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script2.sh D c2eadf0c     0 13694  13692
[72119.690410]  00000000 00000086 cb51dae0 c2eadf0c c016b3d3 c3d89900 cf80c8a0 cb51dae0
[72119.690410]  c73f7cfc ffffffff cb51dae0 c73f7d00 c03e78bb cbb7fe60 c8a43e60 cb51dae0
[72119.690410]  00008068 ffffffea c9023814 00000000 c03e7819 c0162f63 00008068 75a6b2ed
[72119.690410] Call Trace:
[72119.690410]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[72119.690410]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72119.690410]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72119.690410]  [<c0162f63>] ? do_truncate+0x63/0x90
[72119.690410]  [<c0123571>] ? capable+0x21/0x60
[72119.690410]  [<c016c4a2>] ? may_open+0x182/0x200
[72119.690410]  [<c016e5aa>] ? do_filp_open+0x1ea/0x830
[72119.690410]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72119.690410]  [<c016208b>] ? do_sys_open+0x5b/0x110
[72119.690410]  [<c01621bc>] ? sys_open+0x2c/0x40
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S c011a562     0 13695   1897
[72119.690410]  00000000 00000082 cb51d790 c011a562 cb51d790 c3d89c40 ca051e3c ca051e3c
[72119.690410]  c663ce00 ca051edc ca051f60 00001000 c03e72e5 c016a175 00000000 cb51d790
[72119.690410]  c012dbe0 c663ce00 c663ce00 c3b74420 ca051edc c016aa6e 000007c5 ca051f60
[72119.690410] Call Trace:
[72119.690410]  [<c011a562>] ? scheduler_tick+0x82/0x90
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13696  13695
[72119.690410]  00000000 00000086 cb51d440 00000000 c1180940 c3d89760 c0152354 0c04a067
[72119.690410]  cb51d438 cb51d440 cb51d560 00000003 c03e72e5 c011edd0 ca263f68 00000003
[72119.690410]  00000000 00000004 00000000 bfb691e8 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script5.sh D 0000006c     0 13697  13696
[72119.690410]  00000000 00000082 c2e54040 0000006c c045146d c3d89420 cbabd380 cbabd39c
[72119.690410]  c049f170 c2e54040 c2df3ddc c1200080 c03e72e5 c03e7311 c2df3dd4 c014111d
[72119.690410]  c0141155 c03e76f2 00000000 c0141150 c04c3440 c2e54040 c2df3df0 c101b6c0
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7311>] ? io_schedule+0x11/0x20
[72119.690410]  [<c014111d>] ? sync_page+0x2d/0x60
[72119.690410]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72119.690410]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72119.690410]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72119.690410]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72119.690410]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72119.690410]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72119.690410]  [<c0279716>] ? xfs_read+0x166/0x230
[72119.690410]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015a256>] ? page_add_new_anon_rmap+0x56/0x80
[72119.690410]  [<c0153a7e>] ? handle_mm_fault+0x42e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] vsftpd        D 00000000     0 13718   1821
[72119.690410]  00000000 00000082 cb51cda0 00000000 01007810 c3d890e0 c8f703e0 80000000
[72119.690410]  c049f170 cb51cda0 ce81dc74 c1200110 c03e72e5 c03e7311 ce81dc6c c014111d
[72119.690410]  c03e76f2 00000254 c01410f0 c04c371c cb51cda0 ce81dc88 c11bdd20 c01410cc
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7311>] ? io_schedule+0x11/0x20
[72119.690410]  [<c014111d>] ? sync_page+0x2d/0x60
[72119.690410]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72119.690410]  [<c01410f0>] ? sync_page+0x0/0x60
[72119.690410]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72119.690410]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72119.690410]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72119.690410]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72119.690410]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72119.690410]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72119.690410]  [<c0113910>] ? do_page_fault+0x0/0x290
[72119.690410]  [<c03e87dd>] ? error_code+0x65/0x6c
[72119.690410]  [<c0113910>] ? do_page_fault+0x0/0x290
[72119.690410]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72119.690410]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72119.690410]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72119.690410]  [<c029e16b>] ? strrchr+0xb/0x20
[72119.690410]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72119.690410]  [<c0152937>] ? follow_page+0x117/0x150
[72119.690410]  [<c0152937>] ? follow_page+0x117/0x150
[72119.690410]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72119.690410]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72119.690410]  [<c016827e>] ? copy_strings+0x16e/0x190
[72119.690410]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72119.690410]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72119.690410]  [<c01016e6>] ? sys_execve+0x46/0x70
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S c7c77e88     0 13726   1897
[72119.690410]  00000000 00000082 c769d7b0 c7c77e88 c04c3784 c3d89280 c03efda0 0000002c
[72119.690410]  c4f1ce00 c7c77edc c7c77f60 00001000 c03e72e5 c016a175 00000000 c769d7b0
[72119.690410]  c012dbe0 c4f1ce00 c4f1ce00 c5a16e40 c7c77edc c016aa6e 00000902 c7c77f60
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13727  13726
[72119.690410]  00000000 00000086 c769d460 00000000 c1080460 c3d895c0 c0152354 04023067
[72119.690410]  c769d458 c769d460 c769d580 00000003 c03e72e5 c011edd0 caa0ff68 00000003
[72119.690410]  00000000 00000004 00000000 bfff91d8 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            D 00000030     0 13728  13727
[72119.690410]  00000000 00000086 cb51ca50 00000030 00000000 c4556ba0 00000046 c7b81e1c
[72119.690410]  c64051bc ffffffff cb51ca50 c64051c0 c03e78bb cc879e04 c2e81e04 cb51ca50
[72119.690410]  c7b81e70 00000000 c7b81ef4 c7b81e70 c03e7819 c016b423 c7b81e84 cf80c8a0
[72119.690410] Call Trace:
[72119.690410]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72119.690410]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72119.690410]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72119.690410]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72119.690410]  [<c016d573>] ? path_walk+0x53/0xb0
[72119.690410]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72119.690410]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[72119.690410]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[72119.690410]  [<c0169188>] ? do_execve+0x98/0x360
[72119.690410]  [<c01016e6>] ? sys_execve+0x46/0x70
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S c9b43e88     0 13729   1897
[72119.690410]  00000000 00000082 c769db00 c9b43e88 c04c3784 c4556d40 c03efda0 0000002c
[72119.690410]  c4f1c400 c9b43edc c9b43f60 00001000 c03e72e5 c016a175 00000000 c769db00
[72119.690410]  c012dbe0 c4f1c400 c4f1c400 c4f8fca0 c9b43edc c016aa6e 00000811 c9b43f60
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13730  13729
[72119.690410]  00000000 00000086 cb51c700 00000000 c1027bc0 c4556a00 c0152354 013de067
[72119.690410]  cb51c6f8 cb51c700 cb51c820 00000003 c03e72e5 c011edd0 c30c1f68 00000003
[72119.690410]  00000000 00000004 00000000 bf9c91b8 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script1.sh D 0000006c     0 13731  13730
[72119.690410]  00000000 00000086 cb51c060 0000006c c045146d c45566c0 c3715380 c371539c
[72119.690410]  c049f170 cb51c060 cca77ddc c1200138 c03e72e5 c03e7311 cca77dd4 c014111d
[72119.690410]  c0141155 c03e76f2 c10d2aa0 c0141150 c04c371c cb51c060 cca77df0 c11adae0
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7311>] ? io_schedule+0x11/0x20
[72119.690410]  [<c014111d>] ? sync_page+0x2d/0x60
[72119.690410]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72119.690410]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72119.690410]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72119.690410]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72119.690410]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72119.690410]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72119.690410]  [<c0279716>] ? xfs_read+0x166/0x230
[72119.690410]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S cb60fe88     0 13732   1897
[72119.690410]  00000000 00000086 c82aeb50 cb60fe88 c04c3784 c4556860 c03efda0 0000002c
[72119.690410]  c4f1ca00 cb60fedc cb60ff60 00001000 c03e72e5 c016a175 00000000 c82aeb50
[72119.690410]  c012dbe0 c4f1ca00 c4f1ca00 c57f3340 cb60fedc c016aa6e 0000084e cb60ff60
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13733  13732
[72119.690410]  00000000 00000082 cb51d0f0 00000000 c104e340 c4556520 c0152354 0271a067
[72119.690410]  cb51d0e8 cb51d0f0 cb51d210 00000003 c03e72e5 c011edd0 c2a6bf68 00000003
[72119.690410]  00000000 00000004 00000000 bff86438 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script5.sh D c769d110     0 13734  13733
[72119.690410]  00000000 00000082 c769d110 c769d110 c769d13c c45561e0 00000fff c011798f
[72119.690410]  c049f170 c769d110 cbf57ddc c1200080 c03e72e5 c03e7311 cbf57dd4 c014111d
[72119.690410]  c0141155 c03e76f2 c0130c89 c0141150 c04c3440 c769d110 cbf57df0 c101b6c0
[72119.690410] Call Trace:
[72119.690410]  [<c011798f>] ? task_tick_fair+0x4f/0x90
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7311>] ? io_schedule+0x11/0x20
[72119.690410]  [<c014111d>] ? sync_page+0x2d/0x60
[72119.690410]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72119.690410]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72119.690410]  [<c0130c89>] ? hrtimer_run_pending+0x29/0xc0
[72119.690410]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72119.690410]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72119.690410]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72119.690410]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72119.690410]  [<c0279716>] ? xfs_read+0x166/0x230
[72119.690410]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] vsftpd        D 00000000     0 13740   1821
[72119.690410]  00000000 00000082 c769c3d0 00000000 01007810 c4556380 c5a160c0 80000000
[72119.690410]  c049f170 c769c3d0 c5f97c74 c1200110 c03e72e5 c03e7311 c5f97c6c c014111d
[72119.690410]  c03e76f2 00000254 c01410f0 c04c371c c769c3d0 c5f97c88 c11bdd20 c01410cc
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7311>] ? io_schedule+0x11/0x20
[72119.690410]  [<c014111d>] ? sync_page+0x2d/0x60
[72119.690410]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72119.690410]  [<c01410f0>] ? sync_page+0x0/0x60
[72119.690410]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72119.690410]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72119.690410]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72119.690410]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72119.690410]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72119.690410]  [<c0113910>] ? do_page_fault+0x0/0x290
[72119.690410]  [<c03e87dd>] ? error_code+0x65/0x6c
[72119.690410]  [<c0113910>] ? do_page_fault+0x0/0x290
[72119.690410]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72119.690410]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72119.690410]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72119.690410]  [<c029e16b>] ? strrchr+0xb/0x20
[72119.690410]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72119.690410]  [<c0152937>] ? follow_page+0x117/0x150
[72119.690410]  [<c0152937>] ? follow_page+0x117/0x150
[72119.690410]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72119.690410]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72119.690410]  [<c016827e>] ? copy_strings+0x16e/0x190
[72119.690410]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72119.690410]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72119.690410]  [<c01016e6>] ? sys_execve+0x46/0x70
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] vsftpd        D 00000000     0 13741   1821
[72119.690410]  00000000 00000082 cb51c3b0 00000000 01007810 c87d1d80 c4f8f920 80000000
[72119.690410]  c049f170 cb51c3b0 c7857c74 c1200110 c03e72e5 c03e7311 c7857c6c c014111d
[72119.690410]  c03e76f2 00000254 c01410f0 c04c371c cb51c3b0 c7857c88 c11bdd20 c01410cc
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7311>] ? io_schedule+0x11/0x20
[72119.690410]  [<c014111d>] ? sync_page+0x2d/0x60
[72119.690410]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72119.690410]  [<c01410f0>] ? sync_page+0x0/0x60
[72119.690410]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72119.690410]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72119.690410]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72119.690410]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72119.690410]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72119.690410]  [<c013fd8e>] ? rcu_process_callbacks+0x1e/0x20
[72119.690410]  [<c0120ab7>] ? __do_softirq+0x77/0xe0
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72119.690410]  [<c0113910>] ? do_page_fault+0x0/0x290
[72119.690410]  [<c03e87dd>] ? error_code+0x65/0x6c
[72119.690410]  [<c0113910>] ? do_page_fault+0x0/0x290
[72119.690410]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72119.690410]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72119.690410]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72119.690410]  [<c029e16b>] ? strrchr+0xb/0x20
[72119.690410]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72119.690410]  [<c0152937>] ? follow_page+0x117/0x150
[72119.690410]  [<c0152937>] ? follow_page+0x117/0x150
[72119.690410]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72119.690410]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72119.690410]  [<c016827e>] ? copy_strings+0x16e/0x190
[72119.690410]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72119.690410]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72119.690410]  [<c01016e6>] ? sys_execve+0x46/0x70
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] vsftpd        D 00000000     0 13742   1821
[72119.690410]  00000000 00000082 c769c080 00000000 01007810 c87d1080 c5a16d40 80000000
[72119.690410]  c049f170 c769c080 c7833c74 c1200110 c03e72e5 c03e7311 c7833c6c c014111d
[72119.690410]  c03e76f2 00000254 c01410f0 c04c371c c769c080 c7833c88 c11bdd20 c01410cc
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7311>] ? io_schedule+0x11/0x20
[72119.690410]  [<c014111d>] ? sync_page+0x2d/0x60
[72119.690410]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72119.690410]  [<c01410f0>] ? sync_page+0x0/0x60
[72119.690410]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72119.690410]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72119.690410]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72119.690410]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72119.690410]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72119.690410]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72119.690410]  [<c0113910>] ? do_page_fault+0x0/0x290
[72119.690410]  [<c03e87dd>] ? error_code+0x65/0x6c
[72119.690410]  [<c0113910>] ? do_page_fault+0x0/0x290
[72119.690410]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72119.690410]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72119.690410]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72119.690410]  [<c029e16b>] ? strrchr+0xb/0x20
[72119.690410]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72119.690410]  [<c0152937>] ? follow_page+0x117/0x150
[72119.690410]  [<c0152937>] ? follow_page+0x117/0x150
[72119.690410]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72119.690410]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72119.690410]  [<c016827e>] ? copy_strings+0x16e/0x190
[72119.690410]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72119.690410]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72119.690410]  [<c01016e6>] ? sys_execve+0x46/0x70
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] vsftpd        D 00000000     0 13757   1821
[72119.690410]  00000000 00000082 c769ca70 00000000 01007810 c87d1be0 c3b744a0 80000000
[72119.690410]  c049f170 c769ca70 cbd6dc74 c1200110 c03e72e5 c03e7311 cbd6dc6c c014111d
[72119.690410]  c03e76f2 00000254 c01410f0 c04c371c c769ca70 cbd6dc88 c11bdd20 c01410cc
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7311>] ? io_schedule+0x11/0x20
[72119.690410]  [<c014111d>] ? sync_page+0x2d/0x60
[72119.690410]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72119.690410]  [<c01410f0>] ? sync_page+0x0/0x60
[72119.690410]  [<c01410cc>] ? __lock_page+0x8c/0xa0
[72119.690410]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72119.690410]  [<c014127f>] ? find_lock_page+0x4f/0x70
[72119.690410]  [<c0141805>] ? filemap_fault+0x115/0x3e0
[72119.690410]  [<c0151c62>] ? __do_fault+0x42/0x3d0
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72119.690410]  [<c0113910>] ? do_page_fault+0x0/0x290
[72119.690410]  [<c03e87dd>] ? error_code+0x65/0x6c
[72119.690410]  [<c0113910>] ? do_page_fault+0x0/0x290
[72119.690410]  [<c02a0d3f>] ? clear_user+0x2f/0x50
[72119.690410]  [<c01967cc>] ? load_elf_binary+0x8bc/0x1960
[72119.690410]  [<c014668c>] ? __alloc_pages_internal+0xac/0x460
[72119.690410]  [<c029e16b>] ? strrchr+0xb/0x20
[72119.690410]  [<c0193b24>] ? load_misc_binary+0x84/0x390
[72119.690410]  [<c0152937>] ? follow_page+0x117/0x150
[72119.690410]  [<c0152937>] ? follow_page+0x117/0x150
[72119.690410]  [<c0153c7a>] ? __get_user_pages+0xfa/0x310
[72119.690410]  [<c01680aa>] ? get_arg_page+0x4a/0xb0
[72119.690410]  [<c016827e>] ? copy_strings+0x16e/0x190
[72119.690410]  [<c01683f6>] ? search_binary_handler+0x56/0x140
[72119.690410]  [<c01693ab>] ? do_execve+0x2bb/0x360
[72119.690410]  [<c01016e6>] ? sys_execve+0x46/0x70
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S c2f1be88     0 13765   1897
[72119.690410]  00000000 00000082 c811ead0 c2f1be88 c04c3784 c4556040 c03efda0 0000002c
[72119.690410]  cbb5ea00 c2f1bedc c2f1bf60 00001000 c03e72e5 c016a175 00000000 c811ead0
[72119.690410]  c012dbe0 cbb5ea00 cbb5ea00 c5942240 c2f1bedc c016aa6e 000006e9 c2f1bf60
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13766  13765
[72119.690410]  00000000 00000082 c811e780 00000000 c10fc3c0 c87d1220 c0152354 07e1e067
[72119.690410]  c811e778 c811e780 c811e8a0 00000003 c03e72e5 c011edd0 c237df68 00000003
[72119.690410]  00000000 00000004 00000000 bff864f8 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            D c811ee20     0 13767  13766
[72119.690410]  00000000 00000086 c811ee20 c811ee20 c811ee4c c87d13c0 00000fff 00000010
[72119.690410]  c64051bc ffffffff c811ee20 c64051c0 c03e78bb c64051c0 c7b81e04 c811ee20
[72119.690410]  cc879e70 00000000 cc879ef4 cc879e70 c03e7819 c016b423 cc879e84 cf80c8a0
[72119.690410] Call Trace:
[72119.690410]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72119.690410]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72119.690410]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72119.690410]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72119.690410]  [<c016d573>] ? path_walk+0x53/0xb0
[72119.690410]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72119.690410]  [<c01651ca>] ? get_empty_filp+0x3a/0xd0
[72119.690410]  [<c016e49b>] ? do_filp_open+0xdb/0x830
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0168c7f>] ? open_exec+0x2f/0xc0
[72119.690410]  [<c0169188>] ? do_execve+0x98/0x360
[72119.690410]  [<c01016e6>] ? sys_execve+0x46/0x70
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S c78b5e88     0 13768   1897
[72119.690410]  00000000 00000086 c811f810 c78b5e88 c04c3784 c87d1560 c03efda0 0000002c
[72119.690410]  cbb5e000 c78b5edc c78b5f60 00001000 c03e72e5 c016a175 00000000 c811f810
[72119.690410]  c012dbe0 cbb5e000 cbb5e000 c39d4ce0 c78b5edc c016aa6e 000006cb c78b5f60
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13769  13768
[72119.690410]  00000000 00000086 c769cdc0 00000000 c1186f80 c87d1700 c0152354 0c37c067
[72119.690410]  c769cdb8 c769cdc0 c769cee0 00000003 c03e72e5 c011edd0 c75cbf68 00000003
[72119.690410]  00000000 00000004 00000000 bfa51618 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script1.sh D 0000006c     0 13770  13769
[72119.690410]  00000000 00000086 c811fb60 0000006c c045146d c87d18a0 c6725380 c672539c
[72119.690410]  c049f170 c811fb60 c304dddc c1200138 c03e72e5 c03e7311 c304ddd4 c014111d
[72119.690410]  c0141155 c03e76f2 c11ecf80 c0141150 c04c371c c811fb60 c304ddf0 c11adae0
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7311>] ? io_schedule+0x11/0x20
[72119.690410]  [<c014111d>] ? sync_page+0x2d/0x60
[72119.690410]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72119.690410]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72119.690410]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72119.690410]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72119.690410]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72119.690410]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72119.690410]  [<c0279716>] ? xfs_read+0x166/0x230
[72119.690410]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S c1591e88     0 13771   1897
[72119.690410]  00000000 00000082 c811f170 c1591e88 c04c3774 c87d1a40 c03efda0 0000002c
[72119.690410]  cbb5e400 c1591edc c1591f60 00001000 c03e72e5 c016a175 00000000 c811f170
[72119.690410]  c012dbe0 cbb5e400 cbb5e400 c57f35c0 c1591edc c016aa6e 0000087b c1591f60
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            D 00000006     0 13772  13771
[72119.690410]  00000000 00000086 c811f4c0 00000006 c94c9011 c3606da0 c1433e88 cf596ab4
[72119.690410]  ca6a9524 ca6a9524 c1433e70 c02750f0 c03e72e5 c03e85fd ca6a9528 c811f4c0
[72119.690410]  c94c9018 ca6a9524 00000000 c4d70a20 c02750f0 c03e873a ca6a9528 ccccbe70
[72119.690410] Call Trace:
[72119.690410]  [<c02750f0>] ? xfs_dir_open+0x0/0x70
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e85fd>] ? rwsem_down_failed_common+0x7d/0x170
[72119.690410]  [<c02750f0>] ? xfs_dir_open+0x0/0x70
[72119.690410]  [<c03e873a>] ? rwsem_down_read_failed+0x1a/0x24
[72119.690410]  [<c03e874b>] ? call_rwsem_down_read_failed+0x7/0xc
[72119.690410]  [<c03e7d29>] ? down_read+0x9/0x10
[72119.690410]  [<c0250e36>] ? xfs_ilock_map_shared+0x16/0x40
[72119.690410]  [<c027512d>] ? xfs_dir_open+0x3d/0x70
[72119.690410]  [<c0162289>] ? __dentry_open+0x89/0x240
[72119.690410]  [<c0162533>] ? nameidata_to_filp+0x53/0x70
[72119.690410]  [<c016e605>] ? do_filp_open+0x245/0x830
[72119.690410]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72119.690410]  [<c016208b>] ? do_sys_open+0x5b/0x110
[72119.690410]  [<c01621bc>] ? sys_open+0x2c/0x40
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S c151be88     0 13773   1897
[72119.690410]  00000000 00000086 c811e430 c151be88 cf42ee54 c3606c00 c016b3d3 c151be9c
[72119.690410]  c6cace00 c151bedc c151bf60 00001000 c03e72e5 c016a175 00000000 c811e430
[72119.690410]  c012dbe0 c6cace00 c6cace00 c5942d40 c151bedc c016aa6e 000008fc c151bf60
[72119.690410] Call Trace:
[72119.690410]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13774  13773
[72119.690410]  00000000 00000086 c811e0e0 00000000 c10ed040 c3606a60 c0152354 07682067
[72119.690410]  c811e0d8 c811e0e0 c811e200 00000003 c03e72e5 c011edd0 c9dfdf68 00000003
[72119.690410]  00000000 00000004 00000000 bfbbca88 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script3.sh D cfa5e400     0 13775  13774
[72119.690410]  00000000 00000082 c64afb80 cfa5e400 cf80c8a0 c3606720 cf5a25d0 c0174677
[72119.690410]  cc79babc ffffffff c64afb80 cc79bac0 c03e78bb c3aa5e08 cb18fe08 c64afb80
[72119.690410]  c842fe74 00000000 c842fed8 c842fe74 c03e7819 c016b423 c842fe88 cf80c8a0
[72119.690410] Call Trace:
[72119.690410]  [<c0174677>] ? touch_atime+0x97/0x140
[72119.690410]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72119.690410]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72119.690410]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72119.690410]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72119.690410]  [<c0250c70>] ? xfs_iunlock+0x80/0xb0
[72119.690410]  [<c016d573>] ? path_walk+0x53/0xb0
[72119.690410]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72119.690410]  [<c016c756>] ? getname+0x96/0xd0
[72119.690410]  [<c016e22a>] ? user_path_at+0x5a/0x90
[72119.690410]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72119.690410]  [<c01671c7>] ? vfs_fstatat+0x37/0x70
[72119.690410]  [<c01672d8>] ? vfs_stat+0x18/0x20
[72119.690410]  [<c01672ef>] ? sys_stat64+0xf/0x30
[72119.690410]  [<c01649ff>] ? vfs_read+0xff/0x140
[72119.690410]  [<c0125927>] ? sys_rt_sigprocmask+0x67/0xe0
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S ce08fe88     0 13776   1897
[72119.690410]  00000000 00000086 c64af830 ce08fe88 cf42ee54 c36068c0 c016b3d3 ce08fe9c
[72119.690410]  c6caca00 ce08fedc ce08ff60 00001000 c03e72e5 c016a175 00000000 c64af830
[72119.690410]  c012dbe0 c6caca00 c6caca00 c660ed20 ce08fedc c016aa6e 00000786 ce08ff60
[72119.690410] Call Trace:
[72119.690410]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13777  13776
[72119.690410]  00000000 00000082 c64af4e0 00000000 c11b3f40 c3606580 c0152354 0d9fa067
[72119.690410]  c64af4d8 c64af4e0 c64af600 00000003 c03e72e5 c011edd0 cf363f68 00000003
[72119.690410]  00000000 00000004 00000000 bfcd0098 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script2.sh S 00000000     0 13778  13777
[72119.690410]  00000000 00000082 c64af190 00000000 c10ef780 c3606240 c0152354 077bc067
[72119.690410]  c64af188 c64af190 c64af2b0 00000003 c03e72e5 c011edd0 c53ddf68 00000003
[72119.690410]  00000000 00000004 00000000 bf929778 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script2.sh D cbb7ff0c     0 13780  13778
[72119.690410]  00000000 00000086 c64aeaf0 cbb7ff0c c016b3d3 c36060a0 cf80c8a0 c64aeaf0
[72119.690410]  c73f7cfc ffffffff c64aeaf0 c73f7d00 c03e78bb c73f7d00 c2eade60 c64aeaf0
[72119.690410]  00008068 ffffffea c9023814 00000000 c03e7819 c0162f63 00008068 75a6b2ed
[72119.690410] Call Trace:
[72119.690410]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[72119.690410]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72119.690410]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72119.690410]  [<c0162f63>] ? do_truncate+0x63/0x90
[72119.690410]  [<c0123571>] ? capable+0x21/0x60
[72119.690410]  [<c016c4a2>] ? may_open+0x182/0x200
[72119.690410]  [<c016e5aa>] ? do_filp_open+0x1ea/0x830
[72119.690410]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72119.690410]  [<c016208b>] ? do_sys_open+0x5b/0x110
[72119.690410]  [<c01621bc>] ? sys_open+0x2c/0x40
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S 00000000     0 13781   1897
[72119.690410]  00000000 00000082 c64ae7a0 00000000 c04c3774 c36063e0 c03efda0 0000002c
[72119.690410]  c6cac600 c9fb5edc c9fb5f60 00001000 c03e72e5 c016a175 00000000 c64ae7a0
[72119.690410]  c012dbe0 c6cac600 c6cac600 c8cf1bc0 c9fb5edc c016aa6e 000005ca c9fb5f60
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13782  13781
[72119.690410]  00000000 00000086 c64ae450 00000000 c11034a0 c3873dc0 c0152354 081a5067
[72119.690410]  c64ae448 c64ae450 c64ae570 00000003 c03e72e5 c011edd0 c153df68 00000003
[72119.690410]  00000000 00000004 00000000 bf9b0d88 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script4.sh   D 00000246     0 13783  13782
[72119.690410]  00000000 00000082 c64aee40 00000246 00000001 c3873a80 00000000 0000000e
[72119.690410]  cc79babc ffffffff c64aee40 cc79bac0 c03e78bb cc79bac0 c842fe08 c64aee40
[72119.690410]  c3aa5e74 00000000 c3aa5ed8 c3aa5e74 c03e7819 c016b423 c3aa5e88 cf80c8a0
[72119.690410] Call Trace:
[72119.690410]  [<c03e78bb>] ? __mutex_lock_slowpath+0x4b/0x80
[72119.690410]  [<c03e7819>] ? mutex_lock+0x9/0x10
[72119.690410]  [<c016b423>] ? do_lookup+0xe3/0x1e0
[72119.690410]  [<c016ce59>] ? __link_path_walk+0x6c9/0xc40
[72119.690410]  [<c0174698>] ? touch_atime+0xb8/0x140
[72119.690410]  [<c016d573>] ? path_walk+0x53/0xb0
[72119.690410]  [<c016d69b>] ? do_path_lookup+0x7b/0x140
[72119.690410]  [<c016c756>] ? getname+0x96/0xd0
[72119.690410]  [<c016e22a>] ? user_path_at+0x5a/0x90
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c01671c7>] ? vfs_fstatat+0x37/0x70
[72119.690410]  [<c01672d8>] ? vfs_stat+0x18/0x20
[72119.690410]  [<c01672ef>] ? sys_stat64+0xf/0x30
[72119.690410]  [<c0113a42>] ? do_page_fault+0x132/0x290
[72119.690410]  [<c0113910>] ? do_page_fault+0x0/0x290
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] cron          S c6d9de88     0 13787   1897
[72119.690410]  00000000 00000082 c4d0f500 c6d9de88 cf42ee54 c3873c20 c016b3d3 c6d9de9c
[72119.690410]  c4d11e00 c6d9dedc c6d9df60 00001000 c03e72e5 c016a175 00000000 c4d0f500
[72119.690410]  c012dbe0 c4d11e00 c4d11e00 c4c1db60 c6d9dedc c016aa6e 00000836 c6d9df60
[72119.690410] Call Trace:
[72119.690410]  [<c016b3d3>] ? do_lookup+0x93/0x1e0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c016a175>] ? pipe_wait+0x45/0x60
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c016aa6e>] ? pipe_read+0x36e/0x430
[72119.690410]  [<c0140eac>] ? find_get_page+0x1c/0x70
[72119.690410]  [<c014124b>] ? find_lock_page+0x1b/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sh            S 00000000     0 13788  13787
[72119.690410]  00000000 00000082 c4d0f1b0 00000000 c1146240 c3873740 c0152354 0a312067
[72119.690410]  c4d0f1a8 c4d0f1b0 c4d0f2d0 00000003 c03e72e5 c011edd0 c9d61f68 00000003
[72119.690410]  00000000 00000004 00000000 bff82f28 00000000 00000004 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] script5.sh D 0000006c     0 13789  13788
[72119.690410]  00000000 00000086 c4d0ee60 0000006c c045146d c3873400 c6725380 c672539c
[72119.690410]  c049f170 c4d0ee60 c3637ddc c1200080 c03e72e5 c03e7311 c3637dd4 c014111d
[72119.690410]  c0141155 c03e76f2 c1060640 c0141150 c04c3440 c4d0ee60 c3637df0 c101b6c0
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7311>] ? io_schedule+0x11/0x20
[72119.690410]  [<c014111d>] ? sync_page+0x2d/0x60
[72119.690410]  [<c0141155>] ? sync_page_killable+0x5/0x40
[72119.690410]  [<c03e76f2>] ? __wait_on_bit_lock+0x42/0x80
[72119.690410]  [<c0141150>] ? sync_page_killable+0x0/0x40
[72119.690410]  [<c014102c>] ? __lock_page_killable+0x8c/0xa0
[72119.690410]  [<c012dc30>] ? wake_bit_function+0x0/0x70
[72119.690410]  [<c0142c77>] ? generic_file_aio_read+0x3e7/0x6a0
[72119.690410]  [<c0279716>] ? xfs_read+0x166/0x230
[72119.690410]  [<c02753d2>] ? xfs_file_aio_read+0x62/0x70
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c015379e>] ? handle_mm_fault+0x14e/0x530
[72119.690410]  [<c0163c60>] ? do_sync_read+0x0/0x120
[72119.690410]  [<c016499d>] ? vfs_read+0x9d/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sshd          S 00000000     0 13803   1528
[72119.690410]  00000000 00000086 c4d0fba0 00000000 00000000 c38730c0 00000000 00000000
[72119.690410]  c536de2c 7fffffff 7fffffff 00000000 c03e72e5 c03e74cd c536ddb8 c536ddb8
[72119.690410]  cb90be2c cf6c2e24 c536ddfc cf6c2e30 c012dbfb 000000c1 c536de2c 00000000
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e74cd>] ? schedule_timeout+0xdd/0x110
[72119.690410]  [<c012dbfb>] ? autoremove_wake_function+0x1b/0x50
[72119.690410]  [<c03c27e4>] ? unix_stream_recvmsg+0x374/0x4d0
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c0358ab5>] ? sock_aio_read+0x125/0x140
[72119.690410]  [<c0163d35>] ? do_sync_read+0xd5/0x120
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c0164a2f>] ? vfs_read+0x12f/0x140
[72119.690410]  [<c0164b11>] ? sys_read+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] sshd          S c64ae118     0 13805  13803
[72119.690410]  00000000 00000082 c4d0f850 c64ae118 cb90bb28 c38738e0 c8cf1840 08103269
[72119.690410]  00000000 00000000 00000000 00000000 c03e72e5 c03e7ba5 182d9ae0 00000001
[72119.690410]  00000000 00000000 00000082 cbaf2000 c02d9ae0 00000082 00000000 00000000
[72119.690410] Call Trace:
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e7ba5>] ? schedule_hrtimeout_range+0x125/0x140
[72119.690410]  [<c02d9ae0>] ? n_tty_poll+0x0/0x1a0
[72119.690410]  [<c0170ace>] ? poll_schedule_timeout+0x2e/0x50
[72119.690410]  [<c017154b>] ? do_select+0x3cb/0x4f0
[72119.690410]  [<c0171bf0>] ? __pollwait+0x0/0xf0
[72119.690410]  [<c0171ce0>] ? pollwake+0x0/0x50
[72119.690410]  [<c0171ce0>] ? pollwake+0x0/0x50
[72119.690410]  [<c0171ce0>] ? pollwake+0x0/0x50
[72119.690410]  [<c0171ce0>] ? pollwake+0x0/0x50
[72119.690410]  [<c038ca85>] ? ip_local_out+0x15/0x20
[72119.690410]  [<c038d1e3>] ? ip_queue_xmit+0x193/0x370
[72119.690410]  [<c0134e54>] ? getnstimeofday+0x54/0x110
[72119.690410]  [<c03a26e4>] ? tcp_v4_send_check+0x44/0xf0
[72119.690410]  [<c039eb34>] ? tcp_transmit_skb+0x444/0x680
[72119.690410]  [<c035c16c>] ? sk_reset_timer+0xc/0x20
[72119.690410]  [<c03a0b2b>] ? tcp_write_xmit+0x1fb/0x9a0
[72119.690410]  [<c0360fd2>] ? __alloc_skb+0x52/0x130
[72119.690410]  [<c035bdbc>] ? release_sock+0xc/0x80
[72119.690410]  [<c0394d64>] ? tcp_sendmsg+0x694/0xa40
[72119.690410]  [<c017184e>] ? core_sys_select+0x1de/0x310
[72119.690410]  [<c0163c15>] ? do_sync_write+0xd5/0x120
[72119.690410]  [<c02d6e4f>] ? tty_wakeup+0x2f/0x70
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c0171b5f>] ? sys_select+0x2f/0xc0
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] bash          S c02d7c50     0 13806  13805
[72119.690410]  c4d0ec94 00000086 c4d0eb10 c02d7c50 c4c1d7e0 c3873260 cc406000 c016f78f
[72119.690410]  c4d0eb08 c4d0eb10 c4d0ec30 00000003 c03e72e5 c011edd0 cc407f68 00000003
[72119.690410]  00000000 0000000e 00000000 bfa1c678 00000000 0000000e 00000000 0000000e
[72119.690410] Call Trace:
[72119.690410]  [<c02d7c50>] ? tty_ioctl+0x0/0x740
[72119.690410]  [<c016f78f>] ? vfs_ioctl+0x1f/0x80
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] su            S 00000000     0 13823  13806
[72119.690410]  c4d0e5f4 00000086 c4d0e470 00000000 c1092920 cc6adc60 c0152354 04949067
[72119.690410]  c4d0e468 c4d0e470 c4d0e590 00000003 c03e72e5 c011edd0 c6dcdf68 00000003
[72119.690410]  00000000 00000006 00000000 bfa92db8 00000000 00000006 00000000 00000006
[72119.690410] Call Trace:
[72119.690410]  [<c0152354>] ? do_wp_page+0x104/0x5d0
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c011edd0>] ? do_wait+0x260/0x300
[72119.690410]  [<c0118a10>] ? default_wake_function+0x0/0x10
[72119.690410]  [<c011eeeb>] ? sys_wait4+0x7b/0xd0
[72119.690410]  [<c011ef67>] ? sys_waitpid+0x27/0x30
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] bash          R running      0 13824  13823
[72119.690410]  c6c63dbe c6c63eaf 00000000 00000001 00000008 00000001 00000010 ffffffff
[72119.690410]  6666ffff 31306666 36393331 0000000a ffffffff 3233ffff 00000016 c00b97c0
[72119.690410]  00000019 c1201d00 c04053a0 00000001 c02e54c1 c6c63e08 00000003 c1201d00
[72119.690410] Call Trace:
[72119.690410]  [<c02e54c1>] ? scrup+0xe1/0xf0
[72119.690410]  [<c011c86a>] ? __call_console_drivers+0x3a/0x50
[72119.690410]  [<c011c86a>] ? __call_console_drivers+0x3a/0x50
[72119.690410]  [<c03e6ce5>] ? printk+0x17/0x1b
[72119.690410]  [<c0105bd9>] ? print_trace_address+0x49/0x60
[72119.690410]  [<c0105bd9>] ? print_trace_address+0x49/0x60
[72119.690410]  [<c0105bd9>] ? print_trace_address+0x49/0x60
[72119.690410]  [<c0105c3e>] ? print_context_stack+0x4e/0xb0
[72119.690410]  [<c0104e1d>] ? dump_trace+0x6d/0xb0
[72119.690410]  [<c0105b5b>] ? show_trace_log_lvl+0x4b/0x60
[72119.690410]  [<c0104b1e>] ? show_stack_log_lvl+0x5e/0x100
[72119.690410]  [<c0105b0b>] ? show_stack+0x1b/0x20
[72119.690410]  [<c0119b4e>] ? show_state_filter+0x4e/0x70
[72119.690410]  [<c02ea4a0>] ? __handle_sysrq+0xe0/0x130
[72119.690410]  [<c02ea4f0>] ? write_sysrq_trigger+0x0/0x30
[72119.690410]  [<c02ea51e>] ? write_sysrq_trigger+0x2e/0x30
[72119.690410]  [<c0198d37>] ? proc_reg_write+0x47/0x70
[72119.690410]  [<c0198cf0>] ? proc_reg_write+0x0/0x70
[72119.690410]  [<c0164750>] ? vfs_write+0xa0/0x140
[72119.690410]  [<c01648c1>] ? sys_write+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26
[72119.690410] dmesg         D c769c720     0 13832  13824
[72119.690410]  00000000 00000086 c4d0e7c0 c769c720 c3237260 cc6ad2a0 cfa47200 c017cb26
[72119.690410]  00000286 044805f1 c5d6bd18 0448058d c03e72e5 c03e74a0 00004000 c053f2e0
[72119.690410]  c14c3d18 c6457d18 044805f1 c0124de0 c4d0e7c0 c053c7c0 c049f170 00000064
[72119.690410] Call Trace:
[72119.690410]  [<c017cb26>] ? __writeback_single_inode+0x126/0x380
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e74a0>] ? schedule_timeout+0xb0/0x110
[72119.690410]  [<c0124de0>] ? process_timeout+0x0/0x10
[72119.690410]  [<c03e6d71>] ? io_schedule_timeout+0x11/0x20
[72119.690410]  [<c0150b83>] ? congestion_wait+0x53/0x70
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c0147c10>] ? balance_dirty_pages_ratelimited_nr+0xb0/0x1e0
[72119.690410]  [<c0142021>] ? generic_file_buffered_write+0x1a1/0x300
[72119.690410]  [<c02791ea>] ? xfs_write+0x77a/0x860
[72119.690410]  [<c0134e54>] ? getnstimeofday+0x54/0x110
[72119.690410]  [<c0275361>] ? xfs_file_aio_write+0x61/0x70
[72119.690410]  [<c0163c15>] ? do_sync_write+0xd5/0x120
[72119.690410]  [<c0117958>] ? task_tick_fair+0x18/0x90
[72119.690410]  [<c013815f>] ? tick_handle_periodic+0xf/0x80
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c0163b40>] ? do_sync_write+0x0/0x120
[72119.690410]  [<c0164750>] ? vfs_write+0xa0/0x140
[72119.690410]  [<c01648c1>] ? sys_write+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
