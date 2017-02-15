Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:33631 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750732AbdBOFNP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Feb 2017 00:13:15 -0500
Received: by mail-vk0-f47.google.com with SMTP id k127so92841848vke.0
        for <linux-xfs@vger.kernel.org>; Tue, 14 Feb 2017 21:13:15 -0800 (PST)
MIME-Version: 1.0
From: Vaibhaw Pandey <vaibhaw@scalegrid.io>
Date: Wed, 15 Feb 2017 10:43:14 +0530
Message-ID: <CADWLRhrhPD9sPpXPFPx8BvsjwDc4nJFasTC8bRr+5rd3c48xxg@mail.gmail.com>
Subject: XFS doesn't auto mount on boot when /etc/fstab entry has fs type set
 to auto
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

Needed guidance.

I am trying to move my EC2 machine deployment code to start creating
XFS volumes as opposed to ext4 volumes like it used to. An issue I
have run into is that the XFS volume doesn't get mounted automatically
on reboot with the /etc/fstab entry which used to work fine for ext4.
A manual mount later works perfectly.

Version:
$ uname -a
Linux ip-172-31-39-239 4.4.44-39.55.amzn1.x86_64 #1 SMP Mon Jan 30
18:15:53 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
sudo cat /etc/fstab
#
LABEL=/     /           ext4    defaults,noatime  1   1
tmpfs       /dev/shm    tmpfs   defaults        0   0
devpts      /dev/pts    devpts  gid=5,mode=620  0   0
sysfs       /sys        sysfs   defaults        0   0
proc        /proc       proc    defaults        0   0
/dev/sdb /redis_data auto noatime,noexec,nodiratime 0 0
$ df -T /redis_data/
Filesystem     Type 1K-blocks  Used Available Use% Mounted on
/dev/xvdb      xfs    5232640 32940   5199700   1% /redis_data

However if I change the /etc/fstab directive to:

/dev/sdb /redis_data xfs noatime,noexec,nodiratime 0 0

the auto mount starts working fine. Now this isn't a major problem
since the functionality ultimately works. But I would certainly like
to have the flexibility to avoid hard coding the fs type in the code
that generates these fstab entries.

Any pointers or help is much appreciated. :)

Thanks,
Vaibhaw
