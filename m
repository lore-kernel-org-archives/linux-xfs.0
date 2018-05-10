Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:34589 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966632AbeEJRbc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 13:31:32 -0400
Received: by mail-ua0-f177.google.com with SMTP id f22-v6so1841676uam.1
        for <linux-xfs@vger.kernel.org>; Thu, 10 May 2018 10:31:32 -0700 (PDT)
MIME-Version: 1.0
From: Su Yue <damenly.su@gmail.com>
Date: Thu, 10 May 2018 17:31:21 +0000
Message-ID: <CABnRu57R+xakqCPmhM7bjLoAfLAAEuoQDtoU9F9t6CxeNOaPJg@mail.gmail.com>
Subject: Question about inode64
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi, XFS developers

Recently, I was told that some 32bit applications don't work
on large XFS filesystems. And it is caused by ino overflow in syscalls.

If I don't misunderstand libxfs/xfs_format, XFS' absolute inode number
consists of agno_log
-agblklog-inopblog bits.
So significative bits = ROUND(log2(Disk size / AG size)) + ROUND(log2(AG
size / BLK size)) + ROUND(log2(BLK size / inode size)). Right?
Does it mean that it's feasible to avoid ino overflow by control of disk
size, AG size, block size, inode size when mkfs even the disk will be mount
with option inode64.

Thanks,
Su
