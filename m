Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4A5hAQF049184 for <xfs@oss.sgi.com>; Tue, 10 May 2011 00:43:11 -0500
Received: from tyo201.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 65F711E2452E
	for <xfs@oss.sgi.com>; Mon,  9 May 2011 22:43:08 -0700 (PDT)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193]) by
	cuda.sgi.com with ESMTP id rXwkahees5o5Sdfw for
	<xfs@oss.sgi.com>; Mon, 09 May 2011 22:43:08 -0700 (PDT)
Received: from mailgate3.nec.co.jp ([10.7.69.195])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id p4A5h6Cx003968
	for <xfs@oss.sgi.com>; Tue, 10 May 2011 14:43:06 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp
	(8.11.7/3.7W-MAILGATE-NEC) id p4A5h6b28725 for xfs@oss.sgi.com;
	Tue, 10 May 2011 14:43:06 +0900 (JST)
Received: from mail02.kamome.nec.co.jp (mail02.kamome.nec.co.jp [10.25.43.5])
	by mailsv3.nec.co.jp (8.13.8/8.13.4) with ESMTP id p4A5h6Wv027445
	for <xfs@oss.sgi.com>; Tue, 10 May 2011 14:43:06 +0900 (JST)
Message-ID: <4DC8D01F.5060704@wm.jp.nec.com>
Date: Tue, 10 May 2011 14:41:51 +0900
From: Utako Kusaka <u-kusaka@wm.jp.nec.com>
MIME-Version: 1.0
Subject: direct IO question
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs <xfs@oss.sgi.com>

Hi,

When I tested concurrent mmap write and direct IO to the same file,
it was corrupted. Kernel version is 2.6.39-rc4.
I have two questions concerning xfs direct IO.

The first is dirty pages are released in direct read. xfs direct IO uses
xfs_flushinval_pages(), which writes out and releases dirty pages.
If pages are marked as dirty after filemap_write_and_wait_range(),
they will be released in truncate_inode_pages_range() without writing out.

sys_read()
  vfs_read()
    do_sync_read()
      xfs_file_aio_read()
        xfs_flushinval_pages()
          filemap_write_and_wait_range()
          truncate_inode_pages_range()      <---
        generic_file_aio_read()
          filemap_write_and_wait_range()
          xfs_vm_direct_IO()

ext3 calls generic_file_aio_read() only and does not call
truncate_inode_pages_range().

sys_read()
  vfs_read()
    do_sync_read()
      generic_file_aio_read()
        filemap_write_and_wait_range()
        ext3_direct_IO()

xfs_file_aio_read() and xfs_file_dio_aio_write() call generic function. And
both xfs functions and generic functions call filemap_write_and_wait_range().
So I wonder whether xfs_flushinval_pages() is necessary.


Then, the write range in xfs_flushinval_pages() called from direct IO is
from start pos to -1, or LLONG_MAX, and is not IO range. Is there any reason?
In generic_file_aio_read and generic_file_direct_write(), it is from start pos
to (pos + len - 1).
I think xfs_flushinval_pages() should be called with same range.

Regards,
Utako

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
