Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from w1.tutanota.de ([81.3.6.162]:27562 "EHLO w1.tutanota.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbfDYOee (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Apr 2019 10:34:34 -0400
Received: from w2.tutanota.de (unknown [192.168.1.163])
        by w1.tutanota.de (Postfix) with ESMTP id 5602AFA0214
        for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2019 14:34:32 +0000 (UTC)
Date: Thu, 25 Apr 2019 16:34:32 +0200 (CEST)
From: Jan <bug-reporter@tuta.io>
Message-ID: <LdJupgK--3-1@tuta.io>
In-Reply-To: <LUbcIN3--3-1@tuta.io>
References: <LUbcIN3--3-1@tuta.io>
Subject: Re: 'stripe width' inconsistency
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linux Xfs <linux-xfs@vger.kernel.org>

Hi!

It's been some time but if anybody finds this thread later on, here is how I solved the problem:

Dec 26, 2018, 12:09 AM by bug-reporter@tuta.io:

> Recently, I ran into problems mounting one of my XFS file systems. It's been a while since I used that HDD but I'm almost certain there were no problems. 'xfs_repair' complains about 'bad stripe width in superblock' but 'xfs_db' has no problems parsing the filesystem. It reports (among other information)
>
> > unit = 8
> > width = 65535
> [...]
> > crc = 0xe9e260b (correct)
>
In the end it worked to use 'xfs_db -x' to change the width to '65536'. (Actually, I used a dm snapshot so I did not have to touch the actual block device, but that was just a safety measure.) After that, I could mount the filesystem normally again. Just to be safe, I mounted it read-only, made a backup and recreated the filesystem with (manually set) sane parameters.

As a recommendation: it would be nice if such "defect" filesystems were still mountable, even if read only ;-)


Regards, Jan
