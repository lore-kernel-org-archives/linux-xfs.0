Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:47608 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751053AbdISIux (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Sep 2017 04:50:53 -0400
Received: by mail-io0-f177.google.com with SMTP id e189so8359649ioa.4
        for <linux-xfs@vger.kernel.org>; Tue, 19 Sep 2017 01:50:52 -0700 (PDT)
MIME-Version: 1.0
From: Tomasz Grabiec <tgrabiec@scylladb.com>
Date: Tue, 19 Sep 2017 10:50:51 +0200
Message-ID: <CAO2XSW6cctUGx18AdQQ29zHpjPiJ2vVJ-MHxrGcmoeMxzMvbbA@mail.gmail.com>
Subject: io_submit() blocks for writes for substantial amount of time
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

On some systems we are seeing one of our tests to trigger io_submit()
calls to block when submitting writes for an order of 100ms [1]. This
is problematic, because we heavily rely on io_submit() being async.

Workload: open, (ftruncate, append*)*, close.

Kernel version: 4.12.9-300.fc26.x86_64
mount: /dev/nvme0n1p3 on / type xfs (rw,relatime,seclabel,attr2,inode64,noquota)

The blocking happens in the following places:

(1)

            7fff9287472f __schedule ([kernel.kallsyms])
            7fff92874d16 schedule ([kernel.kallsyms])
            7fff92878d42 schedule_timeout ([kernel.kallsyms])
            7fff92876478 wait_for_completion ([kernel.kallsyms])
            7fffc05bf231 xfs_buf_submit_wait ([kernel.kallsyms])
            7fffc05bf3d3 _xfs_buf_read ([kernel.kallsyms])
            7fffc05bf4e4 xfs_buf_read_map ([kernel.kallsyms])
            7fffc05f53ca xfs_trans_read_buf_map ([kernel.kallsyms])
            7fffc058b432 xfs_btree_read_buf_block.constprop.34
([kernel.kallsyms])
            7fffc058b504 xfs_btree_lookup_get_block ([kernel.kallsyms])
            7fffc058f6ad xfs_btree_lookup ([kernel.kallsyms])
            7fffc0570919 xfs_alloc_lookup_eq ([kernel.kallsyms])
            7fffc0570c59 xfs_alloc_fixup_trees ([kernel.kallsyms])
            7fffc0573a2d xfs_alloc_ag_vextent_near ([kernel.kallsyms])
            7fffc0573db1 xfs_alloc_ag_vextent ([kernel.kallsyms])
            7fffc05749cb xfs_alloc_vextent ([kernel.kallsyms])
            7fffc0585ba8 xfs_bmap_btalloc ([kernel.kallsyms])
            7fffc058605e xfs_bmap_alloc ([kernel.kallsyms])
            7fffc0586d6d xfs_bmapi_write ([kernel.kallsyms])
            7fffc05cedd1 xfs_iomap_write_direct ([kernel.kallsyms])
            7fffc05cf0ec xfs_file_iomap_begin ([kernel.kallsyms])
            7fff922d46ca iomap_apply ([kernel.kallsyms])
            7fff922d4dfb iomap_dio_rw ([kernel.kallsyms])
            7fffc05c4091 xfs_file_dio_aio_write ([kernel.kallsyms])
            7fffc05c456d xfs_file_write_iter ([kernel.kallsyms])
            7fff922bc5d3 aio_write ([kernel.kallsyms])
            7fff922bcec1 do_io_submit ([kernel.kallsyms])
            7fff922bdd40 sys_io_submit ([kernel.kallsyms])
            7fff9287a6b7 entry_SYSCALL_64_fastpath ([kernel.kallsyms])
                     687 io_submit (/usr/lib64/libaio.so.1.0.1)
                  112373 seastar::reactor::flush_pending_aio
(/home/tgrabiec/src/scylla/build/release/tests/perf/perf_fast_forward_g)

(2)

  7fff9287472f __schedule ([kernel.kallsyms])
            7fff92874d16 schedule ([kernel.kallsyms])
            7fffc05e6265 _xfs_log_force ([kernel.kallsyms])
            7fffc05c2518 xfs_extent_busy_flush ([kernel.kallsyms])
            7fffc0572ccd xfs_alloc_ag_vextent_size ([kernel.kallsyms])
            7fffc0573d91 xfs_alloc_ag_vextent ([kernel.kallsyms])
            7fffc05749cb xfs_alloc_vextent ([kernel.kallsyms])
            7fffc0585ba8 xfs_bmap_btalloc ([kernel.kallsyms])
            7fffc058605e xfs_bmap_alloc ([kernel.kallsyms])
            7fffc0586d6d xfs_bmapi_write ([kernel.kallsyms])
            7fffc05cedd1 xfs_iomap_write_direct ([kernel.kallsyms])
            7fffc05cf0ec xfs_file_iomap_begin ([kernel.kallsyms])
            7fff922d46ca iomap_apply ([kernel.kallsyms])
            7fff922d4dfb iomap_dio_rw ([kernel.kallsyms])
            7fffc05c4091 xfs_file_dio_aio_write ([kernel.kallsyms])
            7fffc05c456d xfs_file_write_iter ([kernel.kallsyms])
            7fff922bc5d3 aio_write ([kernel.kallsyms])
            7fff922bcec1 do_io_submit ([kernel.kallsyms])
            7fff922bdd40 sys_io_submit ([kernel.kallsyms])
            7fff9287a6b7 entry_SYSCALL_64_fastpath ([kernel.kallsyms])
                     687 io_submit (/usr/lib64/libaio.so.1.0.1)
                  112373 seastar::reactor::flush_pending_aio
(/home/tgrabiec/src/scylla/build/release/tests/perf/perf_fast_forward_g)

Please advise, is this a known bug? When can it happen? Is there a way
to work it around to avoid blocking?

[1] https://github.com/scylladb/seastar/issues/340


Regards,
Tomasz Grabiec
