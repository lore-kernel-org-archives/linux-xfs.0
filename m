Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35006 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752325AbeEJVUD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 May 2018 17:20:03 -0400
Subject: Re: Question about inode64
References: <CABnRu57R+xakqCPmhM7bjLoAfLAAEuoQDtoU9F9t6CxeNOaPJg@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d7e616a7-9978-939a-2056-9846aadf20ef@sandeen.net>
Date: Thu, 10 May 2018 16:20:01 -0500
MIME-Version: 1.0
In-Reply-To: <CABnRu57R+xakqCPmhM7bjLoAfLAAEuoQDtoU9F9t6CxeNOaPJg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Su Yue <damenly.su@gmail.com>, linux-xfs@vger.kernel.org

On 5/10/18 12:31 PM, Su Yue wrote:
> Hi, XFS developers
> 
> Recently, I was told that some 32bit applications don't work
> on large XFS filesystems. And it is caused by ino overflow in syscalls.
> 
> If I don't misunderstand libxfs/xfs_format, XFS' absolute inode number
> consists of agno_log
> -agblklog-inopblog bits.
> So significative bits = ROUND(log2(Disk size / AG size)) + ROUND(log2(AG
> size / BLK size)) + ROUND(log2(BLK size / inode size)). Right?

> Does it mean that it's feasible to avoid ino overflow by control of disk
> size, AG size, block size, inode size when mkfs even the disk will be mount
> with option inode64.

Yes, inode number is an encoded disk location, and the encoding depends
on various other bits of filesystem geometry.

Note that "inode64" only means that it will /allow/ some inodes to exceed
32 bits, it does not mean that every inode number /will/ be > 32 bits.

But most people don't want to constrain their filesystem geometry around
inode number sizing; if you require 32-bit inodes, just use the inode32 mount
option.

Or better yet, fix the application.  :)

-Eric

> Thanks,
> Su
