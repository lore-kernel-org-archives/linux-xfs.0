Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jan 2008 07:19:31 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0TFJPrd008541
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 07:19:27 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2094F573F04
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 07:19:46 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 9QKpH282rch1iMqA for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 07:19:46 -0800 (PST)
Message-ID: <479F440F.2060506@sandeen.net>
Date: Tue, 29 Jan 2008 09:19:43 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mkfs.xfs doesn't detect size of storage correctly
References: <20080129093201.GA16203@citd.de> <43347.192.168.3.1.1201601702.squirrel@mail.aconex.com> <20080129122051.GA18165@citd.de>
In-Reply-To: <20080129122051.GA18165@citd.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matthias Schniedermeyer <ms@citd.de>
Cc: nscott@aconex.com, xfs@oss.sgi.com

Matthias Schniedermeyer wrote:

> A maybe important detail, i forgot to mention in the original mail is:
> The machine has 8GB of RAM, so i compiled the kernel with "64bit=yes" 
> (formaly x86_64), BUT(!) the userspace is 32bit or plain old i386.

If you think that's the issue, I'd try compiling the above as a 32-bit
binary and re-run.

Although, for a simple sparse-file-backed loopback device w/o loop-aes,
that doesn't cause any problem for me:

[root@inode tmp]# ls -l loopfile
-rw-r--r-- 1 root root 750156369920 2008-01-29 08:53 loopfile

[root@inode tmp]# losetup /dev/loop0 loopfile

[root@inode tmp]# ./gds32 /dev/loop0
1465149160 512 byte blocks (BLKGETSIZE64)
[root@inode tmp]# ./gds64 /dev/loop0
1465149160 512 byte blocks (BLKGETSIZE64)

-Eric

> Bis denn
> 
