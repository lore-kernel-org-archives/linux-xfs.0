Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:45720 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755861AbeDZO6B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Apr 2018 10:58:01 -0400
Received: by mail-pf0-f194.google.com with SMTP id l27so18585513pfk.12
        for <linux-xfs@vger.kernel.org>; Thu, 26 Apr 2018 07:58:01 -0700 (PDT)
MIME-Version: 1.0
From: Jorge Garcia <jorge.garcia101011@gmail.com>
Date: Thu, 26 Apr 2018 16:58:00 +0200
Message-ID: <CAN==6Xc9aNnEShwAtCfdtNeYHVFORFjJhzOss=x2KBSp0Qb2=Q@mail.gmail.com>
Subject: XFS quotas: Skipping quotacheck in the initial mount
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

I tried to add XFS quotas in a fileserver with a capacity of 260TB
(112TB occupied), but after adding the user and project quota options
for this disk in the fstab file and remounting it, the mount rest
hanged running the quota check process. I waited for 20 minutes, but
this process did not finish. Due to this server can't be unavailable,
I had to cancel the process and remove the quota options from fstab
file.

My question is: Would it be possible to run the quota check process in
the background? If not, how could I get the estimated time to finish
this process?

Additional info:

This server is running 3.10.0-693.21.1.el7.x86_64 kernel (CentOS 7.4),
and here the number of inodes:

Filesystem         Inodes    IUsed      IFree IUse% Mounted on
/dev/sda       5625717696 39592403 5586125293    1% /export

Thanks in advance!
Jorge
