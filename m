Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33704 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751991AbdGSNLo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2017 09:11:44 -0400
Received: by mail-wm0-f65.google.com with SMTP id 65so63293wmf.0
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2017 06:11:43 -0700 (PDT)
Subject: Re: [PATCH, RFC] xfs: fix multi-AG deadlock in xfs_bunmapi
References: <20170718172545.18065-1-hch@lst.de>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <ac50dda7-6147-1bb2-78ed-b49dafaec242@gmail.com>
Date: Wed, 19 Jul 2017 16:11:40 +0300
MIME-Version: 1.0
In-Reply-To: <20170718172545.18065-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org



On 18.07.2017 20:25, Christoph Hellwig wrote:
> Just like in the allocator we must avoid touching multiple AGs out of
> order when freeing blocks, as freeing still locks the AGF and can cause
> the same AB-BA deadlocks as in the allocation path.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.d> Reported-by: Nikolay Borisov <n.borisov.lkml@gmail.com>

Unfortunately I this patch is not enough. I just tested on a 3.12 kernel ( the issue was easiest to repro there) 
and I still get stack traces. I will also test on a 4.4-based kernel as well but I assume the results are going to
be the same. 

Excerpt: 

[ 8167.898643] SysRq : Show Blocked State
[ 8167.902006] fio             D 0000000000000005     0 15744  15690 0x00000000
[ 8167.902006]  ffff88007f81d390 0000000000000086 0000000000000002 ffff8800952720a0
[ 8167.902006]  ffff88007f81dfd8 ffff88007f81dfd8 ffff88007f81dfd8 ffff8800952720a0
[ 8167.902006]  ffff88007a462f30 7fffffffffffffff ffff8800952720a0 0000000000000001
[ 8167.902006] Call Trace:
[ 8167.902006]  [<ffffffff81524ff9>] schedule_timeout+0x1d9/0x2a0
[ 8167.902006]  [<ffffffff81528960>] __down+0x70/0x100
[ 8167.902006]  [<ffffffff810a231c>] down+0x3c/0x50
[ 8167.902006]  [<ffffffffa01e0b13>] xfs_buf_lock+0x33/0x100 [xfs]
[ 8167.902006]  [<ffffffffa01e0dce>] _xfs_buf_find+0x1ee/0x420 [xfs]
[ 8167.902006]  [<ffffffffa01e12d3>] xfs_buf_get_map+0x23/0x200 [xfs]
[ 8167.902006]  [<ffffffffa01e2141>] xfs_buf_read_map+0x21/0x160 [xfs]
[ 8167.902006]  [<ffffffffa0254423>] xfs_trans_read_buf_map+0x413/0x5d0 [xfs]
[ 8167.902006]  [<ffffffffa0200561>] xfs_read_agf+0xa1/0x150 [xfs]
[ 8167.902006]  [<ffffffffa020066d>] xfs_alloc_read_agf+0x5d/0x180 [xfs]
[ 8167.902006]  [<ffffffffa0200c00>] xfs_alloc_fix_freelist+0x430/0x4c0 [xfs]
[ 8167.902006]  [<ffffffffa0200ebb>] xfs_alloc_vextent+0x22b/0x7b0 [xfs]
[ 8167.902006]  [<ffffffffa02143f7>] xfs_bmap_btalloc+0x407/0x960 [xfs]
[ 8167.902006]  [<ffffffffa021506e>] __xfs_bmapi_allocate+0xde/0x340 [xfs]
[ 8167.902006]  [<ffffffffa01ddc55>] xfs_bmapi_allocate+0xa5/0xb0 [xfs]
[ 8167.902006]  [<ffffffffa0215914>] xfs_bmapi_write+0x644/0xab0 [xfs]
[ 8167.902006]  [<ffffffffa01ef589>] xfs_iomap_write_direct+0x1e9/0x390 [xfs]
[ 8167.902006]  [<ffffffffa01d9f24>] __xfs_get_blocks+0x494/0x930 [xfs]
[ 8167.902006]  [<ffffffff811efbdc>] do_blockdev_direct_IO+0xadc/0x2ea0
[ 8167.902006]  [<ffffffffa01d8b48>] xfs_vm_direct_IO+0x78/0xa0 [xfs]
[ 8167.902006]  [<ffffffffa01e7751>] xfs_file_dio_aio_write.isra.9+0x171/0x430 [xfs]
[ 8167.902006]  [<ffffffffa01e7d35>] xfs_file_aio_write+0x155/0x170 [xfs]
[ 8167.902006]  [<ffffffff81201847>] do_io_submit+0x797/0x830
[ 8167.902006]  [<ffffffff81533249>] system_call_fastpath+0x16/0x1b
[ 8167.902006]  [<00007f73754296f7>] 0x7f73754296f6
[ 8167.902006] fio             D ffff8801394b20a0     0 15746  15690 0x00000000
[ 8167.902006]  ffff8800741c5390 0000000000000086 0000000000000010 ffff8801394b20a0
[ 8167.902006]  ffff8800741c5fd8 ffff8800741c5fd8 ffff8800741c5fd8 ffff8801394b20a0
[ 8167.902006]  ffff88007a462030 7fffffffffffffff ffff8801394b20a0 00000000015f9001
[ 8167.902006] Call Trace:
[ 8167.902006]  [<ffffffff81524ff9>] schedule_timeout+0x1d9/0x2a0
[ 8167.902006]  [<ffffffff81528960>] __down+0x70/0x100
[ 8167.902006]  [<ffffffff810a231c>] down+0x3c/0x50
[ 8167.902006]  [<ffffffffa01e0b13>] xfs_buf_lock+0x33/0x100 [xfs]
[ 8167.902006]  [<ffffffffa01e0dce>] _xfs_buf_find+0x1ee/0x420 [xfs]
[ 8167.902006]  [<ffffffffa01e12d3>] xfs_buf_get_map+0x23/0x200 [xfs]
[ 8167.902006]  [<ffffffffa01e2141>] xfs_buf_read_map+0x21/0x160 [xfs]
[ 8167.902006]  [<ffffffffa0254423>] xfs_trans_read_buf_map+0x413/0x5d0 [xfs]
[ 8167.902006]  [<ffffffffa0200561>] xfs_read_agf+0xa1/0x150 [xfs]
[ 8167.902006]  [<ffffffffa020066d>] xfs_alloc_read_agf+0x5d/0x180 [xfs]
[ 8167.902006]  [<ffffffffa0200c00>] xfs_alloc_fix_freelist+0x430/0x4c0 [xfs]
[ 8167.902006]  [<ffffffffa0200ebb>] xfs_alloc_vextent+0x22b/0x7b0 [xfs]
[ 8167.902006]  [<ffffffffa02143f7>] xfs_bmap_btalloc+0x407/0x960 [xfs]
[ 8167.902006]  [<ffffffffa021506e>] __xfs_bmapi_allocate+0xde/0x340 [xfs]
[ 8167.902006]  [<ffffffffa01ddc55>] xfs_bmapi_allocate+0xa5/0xb0 [xfs]
[ 8167.902006]  [<ffffffffa0215914>] xfs_bmapi_write+0x644/0xab0 [xfs]
[ 8167.902006]  [<ffffffffa01ef589>] xfs_iomap_write_direct+0x1e9/0x390 [xfs]
[ 8167.902006]  [<ffffffffa01d9f24>] __xfs_get_blocks+0x494/0x930 [xfs]
[ 8167.902006]  [<ffffffff811efbdc>] do_blockdev_direct_IO+0xadc/0x2ea0
[ 8167.902006]  [<ffffffffa01d8b48>] xfs_vm_direct_IO+0x78/0xa0 [xfs]
[ 8167.902006]  [<ffffffffa01e7751>] xfs_file_dio_aio_write.isra.9+0x171/0x430 [xfs]
[ 8167.902006]  [<ffffffffa01e7d35>] xfs_file_aio_write+0x155/0x170 [xfs]
[ 8167.902006]  [<ffffffff81201847>] do_io_submit+0x797/0x830
[ 8167.902006]  [<ffffffff81533249>] system_call_fastpath+0x16/0x1b
[ 8167.902006]  [<00007f73754296f7>] 0x7f73754296f6
[ 8167.902006] fio             D ffffffff81625900     0 15747  15690 0x00000000
[ 8167.902006]  ffff88004be11390 0000000000000086 00000000000003ff ffff8800b9a94140
[ 8167.902006]  ffff88004be11fd8 ffff88004be11fd8 ffff88004be11fd8 ffff8800b9a94140
[ 8167.902006]  ffff88007a462f30 7fffffffffffffff ffff8800b9a94140 0000000000000001
[ 8167.902006] Call Trace:
[ 8167.902006]  [<ffffffff81524ff9>] schedule_timeout+0x1d9/0x2a0
[ 8167.902006]  [<ffffffff81528960>] __down+0x70/0x100
[ 8167.902006]  [<ffffffff810a231c>] down+0x3c/0x50
[ 8167.902006]  [<ffffffffa01e0b13>] xfs_buf_lock+0x33/0x100 [xfs]
[ 8167.902006]  [<ffffffffa01e0dce>] _xfs_buf_find+0x1ee/0x420 [xfs]
[ 8167.902006]  [<ffffffffa01e12d3>] xfs_buf_get_map+0x23/0x200 [xfs]
[ 8167.902006]  [<ffffffffa01e2141>] xfs_buf_read_map+0x21/0x160 [xfs]
[ 8167.902006]  [<ffffffffa0254423>] xfs_trans_read_buf_map+0x413/0x5d0 [xfs]
[ 8167.902006]  [<ffffffffa0200561>] xfs_read_agf+0xa1/0x150 [xfs]
[ 8167.902006]  [<ffffffffa020066d>] xfs_alloc_read_agf+0x5d/0x180 [xfs]
[ 8167.902006]  [<ffffffffa0200c00>] xfs_alloc_fix_freelist+0x430/0x4c0 [xfs]
[ 8167.902006]  [<ffffffffa0200ebb>] xfs_alloc_vextent+0x22b/0x7b0 [xfs]
[ 8167.902006]  [<ffffffffa02143f7>] xfs_bmap_btalloc+0x407/0x960 [xfs]
[ 8167.902006]  [<ffffffffa021506e>] __xfs_bmapi_allocate+0xde/0x340 [xfs]
[ 8167.902006]  [<ffffffffa01ddc55>] xfs_bmapi_allocate+0xa5/0xb0 [xfs]
[ 8167.902006]  [<ffffffffa0215914>] xfs_bmapi_write+0x644/0xab0 [xfs]
[ 8167.902006]  [<ffffffffa01ef589>] xfs_iomap_write_direct+0x1e9/0x390 [xfs]
[ 8167.902006]  [<ffffffffa01d9f24>] __xfs_get_blocks+0x494/0x930 [xfs]
[ 8167.902006]  [<ffffffff811efbdc>] do_blockdev_direct_IO+0xadc/0x2ea0
[ 8167.902006]  [<ffffffffa01d8b48>] xfs_vm_direct_IO+0x78/0xa0 [xfs]
[ 8167.902006]  [<ffffffffa01e7751>] xfs_file_dio_aio_write.isra.9+0x171/0x430 [xfs]
[ 8167.902006]  [<ffffffffa01e7d35>] xfs_file_aio_write+0x155/0x170 [xfs]
[ 8167.902006]  [<ffffffff81201847>] do_io_submit+0x797/0x830
[ 8167.902006]  [<ffffffff81533249>] system_call_fastpath+0x16/0x1b
[ 8167.902006]  [<00007f73754296f7>] 0x7f73754296f6
[ 8167.902006] fio             D ffffffff81625900     0 15748  15690 0x00000000
[ 8167.902006]  ffff8800b5c35390 0000000000000086 00000000000003ff ffff8800b9a90000
[ 8167.902006]  ffff8800b5c35fd8 ffff8800b5c35fd8 ffff8800b5c35fd8 ffff8800b9a90000
[ 8167.902006]  ffff88007a462f30 7fffffffffffffff ffff8800b9a90000 0000000000000001
[ 8167.902006] Call Trace:
[ 8167.902006]  [<ffffffff81524ff9>] schedule_timeout+0x1d9/0x2a0
[ 8167.902006]  [<ffffffff81528960>] __down+0x70/0x100
[ 8167.902006]  [<ffffffffa01e0dce>] _xfs_buf_find+0x1ee/0x420 [xfs]
[ 8167.902006]  [<ffffffffa01e12d3>] xfs_buf_get_map+0x23/0x200 [xfs]
[ 8167.902006]  [<ffffffffa01e2141>] xfs_buf_read_map+0x21/0x160 [xfs]
[ 8167.902006]  [<ffffffffa0254423>] xfs_trans_read_buf_map+0x413/0x5d0 [xfs]
[ 8167.902006]  [<ffffffffa0200561>] xfs_read_agf+0xa1/0x150 [xfs]
[ 8167.902006]  [<ffffffffa020066d>] xfs_alloc_read_agf+0x5d/0x180 [xfs]
[ 8167.902006]  [<ffffffffa0200c00>] xfs_alloc_fix_freelist+0x430/0x4c0 [xfs]
[ 8167.902006]  [<ffffffffa0200ebb>] xfs_alloc_vextent+0x22b/0x7b0 [xfs]
[ 8167.902006]  [<ffffffffa02142ed>] xfs_bmap_btalloc+0x2fd/0x960 [xfs]
[ 8167.902006]  [<ffffffffa021506e>] __xfs_bmapi_allocate+0xde/0x340 [xfs]
[ 8167.902006]  [<ffffffffa01ddc55>] xfs_bmapi_allocate+0xa5/0xb0 [xfs]
[ 8167.902006]  [<ffffffffa0215914>] xfs_bmapi_write+0x644/0xab0 [xfs]
[ 8167.902006]  [<ffffffffa01ef589>] xfs_iomap_write_direct+0x1e9/0x390 [xfs]
[ 8167.902006]  [<ffffffffa01d9f24>] __xfs_get_blocks+0x494/0x930 [xfs]
[ 8167.902006]  [<ffffffff811efbdc>] do_blockdev_direct_IO+0xadc/0x2ea0
[ 8167.902006]  [<ffffffffa01d8b48>] xfs_vm_direct_IO+0x78/0xa0 [xfs]
[ 8167.902006]  [<ffffffffa01e7751>] xfs_file_dio_aio_write.isra.9+0x171/0x430 [xfs]
[ 8167.902006]  [<ffffffffa01e7d35>] xfs_file_aio_write+0x155/0x170 [xfs]
[ 8167.902006]  [<ffffffff81201847>] do_io_submit+0x797/0x830
[ 8167.902006]  [<ffffffff81533249>] system_call_fastpath+0x16/0x1b
[ 8167.902006]  [<00007f73754296f7>] 0x7f73754296f6
[ 8167.902006] fio             D ffffffff81625900     0 15749  15690 0x00000000
[ 8167.902006]  ffff8800b5c0fc10 0000000000000082 0000000000000003 ffff8800b8800000
[ 8167.902006]  ffff8800b5c0ffd8 ffff8800b5c0ffd8 ffff8800b5c0ffd8 ffff8800b8800000
[ 8167.902006]  ffff8800b5c0fd20 ffff8800b5c0fd18 7fffffffffffffff ffff8800b8800000
[ 8167.902006] xfs_io          D ffffffff81625900     0 15854  15342 0x00000000
[ 8167.902006]  ffff880095179910 0000000000000082 ffff8801396f9c80 ffff88004bc40000
[ 8167.902006]  ffff880095179fd8 ffff880095179fd8 ffff880095179fd8 ffff88004bc40000
[ 8167.902006]  ffff88007a462030 7fffffffffffffff ffff88004bc40000 00000000015f9001
[ 8167.902006] Call Trace:
[ 8167.902006]  [<ffffffff81524ff9>] schedule_timeout+0x1d9/0x2a0
[ 8167.902006]  [<ffffffff81528960>] __down+0x70/0x100
[ 8167.902006]  [<ffffffff810a231c>] down+0x3c/0x50
[ 8167.902006]  [<ffffffffa01e0b13>] xfs_buf_lock+0x33/0x100 [xfs]
[ 8167.902006]  [<ffffffffa01e0dce>] _xfs_buf_find+0x1ee/0x420 [xfs]
[ 8167.902006]  [<ffffffffa01e12d3>] xfs_buf_get_map+0x23/0x200 [xfs]
[ 8167.902006]  [<ffffffffa01e2141>] xfs_buf_read_map+0x21/0x160 [xfs]
[ 8167.902006]  [<ffffffffa0254423>] xfs_trans_read_buf_map+0x413/0x5d0 [xfs]
[ 8167.902006]  [<ffffffffa0200561>] xfs_read_agf+0xa1/0x150 [xfs]
[ 8167.902006]  [<ffffffffa020066d>] xfs_alloc_read_agf+0x5d/0x180 [xfs]
[ 8167.902006]  [<ffffffffa0200c00>] xfs_alloc_fix_freelist+0x430/0x4c0 [xfs]
[ 8167.902006]  [<ffffffffa0201509>] xfs_free_extent+0xc9/0x140 [xfs]
[ 8167.902006]  [<ffffffffa01dd69a>] xfs_bmap_finish+0x15a/0x1b0 [xfs]
[ 8167.902006]  [<ffffffffa023a21e>] xfs_itruncate_extents+0x2ce/0x470 [xfs]
[ 8167.902006]  [<ffffffffa01f19c3>] xfs_setattr_size+0x353/0x3f0 [xfs]
[ 8167.902006]  [<ffffffffa01f1b70>] xfs_vn_setattr+0x60/0x80 [xfs]
[ 8167.902006]  [<ffffffff811d0a51>] notify_change+0x241/0x3b0
[ 8167.902006]  [<ffffffff811b1b92>] do_truncate+0x62/0x90
[ 8167.902006]  [<ffffffff811b1f0b>] do_sys_ftruncate.constprop.11+0x12b/0x180
[ 8167.902006]  [<ffffffff81533249>] system_call_fastpath+0x16/0x1b
[ 8167.902006]  [<00007f5cb95239f7>] 0x7f5cb95239f6

