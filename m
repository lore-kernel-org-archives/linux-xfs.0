Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:33030 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752982AbdGRVvW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2017 17:51:22 -0400
Received: by mail-wr0-f180.google.com with SMTP id v105so17770794wrb.0
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2017 14:51:21 -0700 (PDT)
MIME-Version: 1.0
From: Yaron Presente <yaron@zadarastorage.com>
Date: Wed, 19 Jul 2017 00:51:20 +0300
Message-ID: <CAH4CUCPgFnm0s07uEU3ke6V8cPtSvQxMLo60nemuuqGygmZRhA@mail.gmail.com>
Subject: XFS group quota incorrectly "inherits" its hard limit from user 0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,
I'm running a Linux system with kernel version 3.18.19.
While experimenting with groups quota, I did the following steps:

1. Mounted XFS with both users and groups quota enabled
2. Set user 0 (aka the SuperUser) hard limit to 800000 . I believe
that this has the same affect as using xfs_quota limit command with
"-d" (i.e. setting the default hard limit for users which don't have
their hard limit set explicitly)
3. Set user 2001117 hard limit to 1024000 (I set a different limit
than user 0's on purpose, in order to show that the group hard limit
was not inherited from this user, but from user 0)
4. Created a 1MB file that is owned by user 2001117 and group 2000514
5. Group 2000514 which previously didn't have any hard limit defined
now "inherited" user 0 hard limit of 800000 .

See output of xfs_quota below.
Thanks,
Yaron


Before creating the file:
==================

root@vsa-0000011e-vc-0:~# xfs_quota -x -c "report -L0 -U 2100000"
/export/share_3
User quota on /export/share_3 (/dev/dm-28)
                               Blocks
User ID          Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
#0                  0               0      800000      00  [--------]
#2001117       0               0     1024000     00 [--------]

Group quota on /export/share_3 (/dev/dm-28)
                               Blocks
Group ID         Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
#0                  0               0          0          00 [--------]

(group 2000514  is not listed since it does not have a hard limit and
its quota is not used by any file)

After creating the file:
================

root@vsa-0000011e-vc-0:~# xfs_quota -x -c "report -L0 -U 2100000"
/export/share_3
User quota on /export/share_3 (/dev/dm-28)
                               Blocks
User ID          Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
#0                  0               0     800000      00  [--------]
#2001117      1024         0    1024000     00 [--------]

Group quota on /export/share_3 (/dev/dm-28)
                               Blocks
Group ID         Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
#0                  0               0          0           00 [--------]
#2000514      1024         0      800000     00 [--------]
   <===   This is the problem. It's not clear where this hard limit
came from
