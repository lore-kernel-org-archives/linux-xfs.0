Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Jul 2007 18:59:30 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6P1xQbm008196
	for <xfs@oss.sgi.com>; Tue, 24 Jul 2007 18:59:28 -0700
Received: from agami.com (mail [192.168.168.5])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id l6P1x61J011208
	for <xfs@oss.sgi.com>; Tue, 24 Jul 2007 18:59:06 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id l6P1xU2x010785
	for <xfs@oss.sgi.com>; Tue, 24 Jul 2007 18:59:30 -0700
Message-ID: <46A6AE99.3000502@agami.com>
Date: Tue, 24 Jul 2007 18:59:53 -0700
From: Michael Nishimoto <miken@agami.com>
MIME-Version: 1.0
Subject: Couple of code comments
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: XFS Mailing List <xfs@oss.sgi.com>

Hi,

I've got a couple of code comments.  In xfs_write, there is a
call to bhv_vop_flushinval_pages().  It appears that this function call
is not needed because the call to generic_file_direct_write() done
later in xfs_write does the same work.

generic_file_direct_write -> generic_file_direct_IO ->
(filemap_write_and_wait + invalidate_inode_pages2_range)

bhv_vop_flushinval_pages -> fs_flushinval_pages ->
(filemap_write_and_wait + truncate_inode_pages)

The code isn't exactly the same, but it appears to do the same work.

Also, within xfs_swap_extents() the code fixes up on-disk inode block
counts, but doesn't change the block counts for the Linux inode.

Comments?

    Michael
