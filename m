Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr26p42im-ztdg06103201.me.com ([17.111.243.30]:23927 "EHLO
        mr26p42im-ztdg06103201.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726689AbeILAie (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Sep 2018 20:38:34 -0400
Received: from process-dkim-sign-daemon.mr26p42im-ztdg06103201.me.com by
 mr26p42im-ztdg06103201.me.com
 (Oracle Communications Messaging Server 8.0.2.2.20180531 64bit (built May 31
 2018)) id <0PEW00D00MA5UZ00@mr26p42im-ztdg06103201.me.com> for
 linux-xfs@vger.kernel.org; Tue, 11 Sep 2018 18:37:48 +0000 (GMT)
Received: from icloud.com ([127.0.0.1]) by mr26p42im-ztdg06103201.me.com
 (Oracle Communications Messaging Server 8.0.2.2.20180531 64bit (built May 31
 2018)) with ESMTPSA id <0PEW00HTTMEYYW20@mr26p42im-ztdg06103201.me.com> for
 linux-xfs@vger.kernel.org; Tue, 11 Sep 2018 18:37:47 +0000 (GMT)
From: Hugo Kuo <tonytkdk@me.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: quoted-printable
MIME-version: 1.0 (Mac OS X Mail 11.4 \(3445.8.2\))
Subject: How to read ERROR properly?
Message-id: <AC8D9C98-0333-480A-9E1B-9923909F5868@me.com>
Date: Tue, 11 Sep 2018 11:37:44 -0700
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi XFS team,

We have our storage with XFS. I wonder how=E2=80=99s the proper workflow =
for troubleshooting xfs_error that shows up in the kernel logs.

I=E2=80=99ve seen various different failed so far. It=E2=80=99s not easy =
to address the root cause by reading kernel logs. For this case, how can =
I know the meaning of Internal error XFS_WANT_CORRUPTED_RETURN at line =
163 of file fs/xfs/xfs_dir2_data.c. Caller =
xfs_dir3_block_verify+0x7a/0x90 [xfs] ?


[Mon Sep 10 07:34:14 2018] XFS: Internal error XFS_WANT_CORRUPTED_RETURN =
at line 163 of file fs/xfs/xfs_dir2_data.c. Caller =
xfs_dir3_block_verify+0x7a/0x90 [xfs]=20
[Mon Sep 10 07:34:14 2018] [<ffffffffa040504b>] =
xfs_error_report+0x3b/0x40 [xfs]=20
[Mon Sep 10 07:34:14 2018] XFS (sdq): xfs_log_force: error 5 returned.=20=

[Mon Sep 10 07:34:44 2018] XFS (sdq): xfs_log_force: error 5 returned.


* For the same case, it pop up an ERROR while running xfs_repair. Is =
there any clue about how the disk run into bad situation?


[root@hugo-ubuntu ~]# xfs_repair /dev/sdq=20
Phase 1 - find and verify superblock...=20
- reporting progress in intervals of 15 minutes=20
Phase 2 - using internal log=20
- zero log...=20
ERROR: The filesystem has valuable metadata changes in a log which needs =
to=20
be replayed. Mount the filesystem to replay the log, and unmount it =
before=20
re-running xfs_repair. If you are unable to mount the filesystem, then =
use=20
the -L option to destroy the log and attempt a repair.=20
Note that destroying the log may cause corruption -- please attempt a =
mount=20
of the filesystem before doing this.


Thanks // Hugo=
