Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B065CD6E4C
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 09:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbjJKJCm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 05:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345903AbjJKJC3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 05:02:29 -0400
Received: from mail-4318.protonmail.ch (mail-4318.protonmail.ch [185.70.43.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A1A10EA
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 02:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1697014907; x=1697274107;
        bh=ptQazkX9Q4aM5fkWGbbWe6HB+OCAKlZ+vE3TNUBDNBc=;
        h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=TbVjHaXXQA0MFHRCN2hv+S7zPoHjmOnn0z/segIgYAD0oiVnfI6GuggigFvpPA/7V
         kGGJCbnlXGBCbhgqxpweU3c7hN1j8u/r8/VPsdD6anFXMkXtCglqEgA6BHMblKmzv8
         VsCd/9DEb7IZpWQuV+L6tWgHHSBe+hHOJhXVK5x6EZdocLCdimhtQwsu0T9bsdUVNB
         qRbyss6ky1WmH9PERrGAYoW8mqAg/lj7NusjeCdEgZyyOC4/TEfIvgkn4gicGzIluK
         3A9t8G+aiKZCwGiO9sanoOPZzHm0DgFIp2FaJGkMhe5MinYskwe3ge/oVMWoAx0JJH
         RD2jjm0PjV5Bg==
Date:   Wed, 11 Oct 2023 09:01:33 +0000
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
From:   Nagisa BIOS <nagisa_bios@protonmail.com>
Subject: xfs_fsr (8) bug feedback
Message-ID: <21Gb4363VJqI6o5yiULkiUWVzi-MPdlbAXKY9PqIdf6oZibHzKfoNmGZIaNXfVhKMuIMqkcA74eeOZLaY_Tl0FgTyvUQEHqm6ori9XyxmCw=@protonmail.com>
Feedback-ID: 82509359:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,
I found if the xfs_fsr (8) defragment the large files, it may cause errors.=
 My recommend is, do not defragment the large files if the free disk space =
is not enough.

Computer Setup:
1135G7 CPU (Mini PC)
8GB DDR4 DRAM
500GB NVMe SSD
200GB NTFS Partition: Windows 11
200GB NTFS Partition
75GB  XFS Partition: Ubuntu (GNOME) 22.04
Yes, I haven't create SWAP partition for Ubuntu.

Pastebin (Mini PC):

ubuntu@minipc:~$ xfs_fsr -V
xfs_fsr version 5.13.0

ubuntu@minipc:~$ sudo df -h
Filesystem      Size   Used   Avail   Use%    Mounted
tmpfs           772M   2.3M    770M     1%    /run
/dev/nvme0n1p6   74G    55G    19G     75%    /
tmpfs           3.8G      0    3.8G     0%    /dev/shm
tmpfs           5.0M   4.0K    5.0M     1%    /run/lock
tmpfs           3.8G      0    3.8G     0%    /run/qemu
/dev/nvme0n1p1  256M    90M    167M    35%    /boot/efi
tmpfs           772M   120K    772M     1%    /run/user/1000

ubuntu@minipc:~$ sudo ls -hs /var/lib/libvirt/images
total 26G
2.5G debian12-1.qcow2   1.7G debian12-2.qcow2   34M win10-1.qcow2   34M win=
10-2.qcow2   21G win10.qcow2
595M win2003-1.qcow2    502M win2003.qcow2

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
(stucking ......)

Pastebin (Debian KVM - Normal case - root partition is XFS):

debian@kvm:~$ sudo df -h
Filesystem      Size   Used   Avail   Use%    Mounted
udev            440M      0    448M     0%    /dev
tmpfs            94M   656K     94M     1%    /run
/dev/vda1       9.3G   1.4G    7.9G    15%    /
tmpfs           470M      0    470M     0%    /dev/shm
tmpfs           5.0M      0    5.0M     0%    /run/lock
/dev/vda2       121M   5.9M    115M     5%    /boot/efi
tmpfs            94M      0     94M     0%    /run/user/1000

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
