Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36538 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbeAWQK4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jan 2018 11:10:56 -0500
Received: by mail-wm0-f48.google.com with SMTP id f3so2989547wmc.1
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2018 08:10:55 -0800 (PST)
From: Avi Kivity <avi@scylladb.com>
Subject: aio/dio write vs. file_update_time
Message-ID: <52c2b3db-26cb-df95-2a77-866d27ce146c@scylladb.com>
Date: Tue, 23 Jan 2018 18:10:51 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

I'm seeing the following lock contention in io_submit() (unfortunately, 
older kernel again)


  0xffffffff816ab231 : __schedule+0x531/0x9b0 [kernel]
  0xffffffff816ab6d9 : schedule+0x29/0x70 [kernel]
  0xffffffff816acfc5 : rwsem_down_write_failed+0x225/0x3a0 [kernel]
  0xffffffff81333ca7 : call_rwsem_down_write_failed+0x17/0x30 [kernel]
  0xffff8819bc3f3bf8 : 0xffff8819bc3f3bf8
  0xffffffff816aa8bd : down_write+0x2d/0x3d [kernel]
  0xffffffffc00ca1d1 : xfs_ilock+0xc1/0x120 [xfs]
  0xffffffffc00c7c8d : xfs_vn_update_time+0xcd/0x150 [xfs]
  0xffffffff8121eda5 : update_time+0x25/0xd0 [kernel]
  0xffffffff8121eef0 : file_update_time+0xa0/0xf0 [kernel]
  0xffffffffc00be3a5 : xfs_file_aio_write_checks+0x185/0x1f0 [xfs]
  0xffffffffc00be6c9 : xfs_file_dio_aio_write+0xd9/0x390 [xfs]
  0xffffffffc00bed42 : xfs_file_aio_write+0x102/0x1b0 [xfs]
  0xffffffffc00bec40 : xfs_file_aio_write+0x0/0x1b0 [xfs]
  0xffffffff81255ff8 : do_io_submit+0x3b8/0x870 [kernel]


There is only one thread issuing those writes, and nobody is reading the 
file. Who could possibly be contending on this lock?


I'm seeing 200ms stalls, so my guess is a log flush is involved.


Is this lock contention covered by RWF_NOWAIT?

