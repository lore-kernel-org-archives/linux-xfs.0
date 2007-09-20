Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 21:32:19 -0700 (PDT)
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.245])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8K4WCuw018453
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 21:32:13 -0700
Received: by an-out-0708.google.com with SMTP id c38so79802ana
        for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 21:32:15 -0700 (PDT)
Subject: The problem in installing the linux-2.6-xfs kernel
From: hxsrmeng <hxsrmeng@gmail.com>
Reply-To: hxsrmeng@gmail.com
Content-Type: text/plain
Date: Thu, 20 Sep 2007 00:01:58 -0400
Message-Id: <1190260918.24375.4.camel@OpenSUSE-desktop.Home>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: XFS <xfs@oss.sgi.com>

Hi, 

When I do:
$/sbin/mkinitrd -k vmlinuz-2.6-xfs -i initrd-2.6-xfs

I got:
"
Filesystem modules:
WARNING: Couldn't open
directory /var/tmp/mkinitramfs.C23294/mnt/lib/modules/2.6.23-rc4: No
such file or directory
FATAL: Could not
open /var/tmp/mkinitramfs.C23294/mnt/lib/modules/2.6.23-rc4/modules.dep.temp for writing: No such file or directory
"
So, does this mean it failed?

If I can still boot this kernel, are the file system features OK?
Especially, I want to try XFS and "Concurrent Multi-File Data Streams".

Thanks in advance!
