Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f52.google.com ([209.85.161.52]:33855 "EHLO
        mail-yw1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFZUcP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 16:32:15 -0400
Received: by mail-yw1-f52.google.com with SMTP id q128so75764ywc.1
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 13:32:14 -0700 (PDT)
MIME-Version: 1.0
From: Rich Otero <rotero@editshare.com>
Date: Wed, 26 Jun 2019 16:32:02 -0400
Message-ID: <CAFVd4NsBRm_pbySuSc4U=a=G4wiowZ3gFBooLEQZGZJe9V748g@mail.gmail.com>
Subject: XFS Repair Error
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Steve Alves <steve.alves@editshare.com>

I have an XFS filesystem of approximately 56 TB on a RAID that has
been experiencing some disk failures. The disk problems seem to have
led to filesystem corruption, so I attempted to repair the filesystem
with `xfs_repair -L <device>`. Xfs_repair finished with a message
stating that an error occurred and to report the bug.

The requested files are in my Google Drive (links below):

xfs-repair-sdb1.txt: This is the output from `xfs_repair -L
/dev/sdb1`. I could only save as much as was still in my `screen`
buffer, so the beginning of the repair may be missing.
https://drive.google.com/file/d/1CTm4hUumqPLW6FUSnc2ykU-hzH1w0Yug/view?usp=sharing

xfs-meta-sdb1.bin.tar.gz: This tar archive contains the file generated
by `xfs_metadump -g /dev/sdb1`.
https://drive.google.com/file/d/160If17YDVdk5_hEhajlMpFcTvGeIqZsd/view?usp=sharing

Regards,
Rich Otero
EditShare
rotero@editshare.com
617-782-0479
