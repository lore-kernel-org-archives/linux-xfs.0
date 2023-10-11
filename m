Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B241CDB470
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 18:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbjJKSIL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 14:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbjJKSIK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:08:10 -0400
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FD993
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1697047683; x=1697306883;
        bh=IegZtfIvw8lwLyhEQoF1mtQeHGiYFpGwKG9lt2Lgftg=;
        h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=KZkbN9TPgsOTbvU2YfQvc/Nz25zVDStt1gMkFIKwcKoPKwQcwVxfLy4HdhLH45y4t
         KN9eXZPpLZ6GbnzzS8XLBJ7o/WX+rkDTdMKke8RPeJMe2QspY4cGw6xjPQvFqchbgy
         cykbwLOYtT4Ie03m5xPcApoXQ+NESeWpEgwucZpqlJ4z4txIasWlYbrJLMx1CYhTYj
         TJnuso0fHHT7CnUUaIykLBYV6UcQW6+jLh0lIamWOUT8X8QesUwYxa3KmbJYGc+F2Z
         6Zb4Yvb6yF1i9dgrJi10nozrko8R7aR+C/90aOVZCNbLB+5/vjFlfd1r+T20NLKqJz
         aiS86f97Mh9Mg==
Date:   Wed, 11 Oct 2023 18:07:46 +0000
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
From:   Nagisa BIOS <nagisa_bios@protonmail.com>
Subject: xfsprogs: bug feedback
Message-ID: <UhgwTYrnwqvjARAbTicViFlwB7jumckp2WZwXoXAiKefRHO9XU46pADFybp14c1BTMWt8s4Ht0FY7aQq6QShFS7GUiScn1lwqo5Ytw0lUDo=@protonmail.com>
Feedback-ID: 82509359:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

I found that if the xfs_fsr program defrag the large files, it may cause er=
rors.

My recommend is, do not defrag the large files if the available disk space =
is not enough.

Computer Setup (My Mini PC):
1135G7 CPU Mini PC
8GB DDR4 DRAM
500GB NVMe SSD
 200GB NTFS Partition: Windows 11
 200GB NTFS Partition
 75GB  XFS Partition: Ubuntu (GNOME) 22.04

Pastebin:

ubuntu@minipc:~$ xfs_fsr -V
xfs_fsr version 5.13.0

# nvme0n1p6 is XFS filesystem
ubuntu@minipc:~$ sudo df -h
Filesystem      Size   Used   Avail   Use%    Mounted
tmpfs           772M   2.3M    770M     1%    /run
/dev/nvme0n1p6   74G    55G    19G     75%    /
tmpfs           3.8G      0    3.8G     0%    /dev/shm
tmpfs           5.0M   4.0K    5.0M     1%    /run/lock
tmpfs           3.8G      0    3.8G     0%    /run/qemu
/dev/nvme0n1p1  256M    90M    167M    35%    /boot/efi
tmpfs           772M   120K    772M     1%    /run/user/1000

# win10.qcow2 file size is 21GB
ubuntu@minipc:~$ sudo ls -hs /var/lib/libvirt/images
total 26G
2.5G debian12-1.qcow2   1.7G debian12-2.qcow2   34M win10-1.qcow2   34M win=
10-2.qcow2
21G win10.qcow2   595M win2003-1.qcow2   502M win2003.qcow2

# Loop and stuck
ubuntu@minipc:~$ sudo xfs_fsr
xfs_fsr -m /proc/mountfs -t 7200 -f /var/tmp/.fsrlast_xfs ...
/ start inode=3D151308975
/ start inode=3D0
XFS_IOC_SWAPEXT failed: ino=3D117672225: Invalid argument
insufficient freespace for: ino=3D117681809: size=3D21608017920: ignoring
/ start inode=3D0
XFS_IOC_SWAPEXT failed: ino=3D117672225: Invalid argument
insufficient freespace for: ino=3D117681809: size=3D21608017920: ignoring
/ start inode=3D0
XFS_IOC_SWAPEXT failed: ino=3D117672225: Invalid argument
insufficient freespace for: ino=3D117681809: size=3D21608017920: ignoring
/ start inode=3D0
XFS_IOC_SWAPEXT failed: ino=3D117672225: Invalid argument
insufficient freespace for: ino=3D117681809: size=3D21608017920: ignoring
/ start inode=3D0
XFS_IOC_SWAPEXT failed: ino=3D117672225: Invalid argument
insufficient freespace for: ino=3D117681809: size=3D21608017920: ignoring

Pastebin (another Debian KVM):

# vda1 is XFS filesystem
debian@kvm:~$ sudo df -h
Filesystem      Size   Used   Avail   Use%    Mounted
udev            440M      0    448M     0%    /dev
tmpfs            94M   656K     94M     1%    /run
/dev/vda1       9.3G   1.4G    7.9G    15%    /
tmpfs           470M      0    470M     0%    /dev/shm
tmpfs           5.0M      0    5.0M     0%    /run/lock
/dev/vda2       121M   5.9M    115M     5%    /boot/efi
tmpfs            94M      0     94M     0%    /run/user/1000

# Normal case
debian@kvm:~$ sudo xfs_fsr
xfs_fsr -m /proc/mountfs -t 7200 -f /var/tmp/.fsrlast_xfs ...
/ start inode=3D0
/ start inode=3D0
/ start inode=3D0
/ start inode=3D0
/ start inode=3D0
/ start inode=3D0
/ start inode=3D0
/ start inode=3D0
/ start inode=3D0
/ start inode=3D0
Completed all 10 passes
