Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3DF2h7N115147 for <xfs@oss.sgi.com>; Mon, 13 Apr 2009 10:02:53 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56E191CB8819
	for <xfs@oss.sgi.com>; Mon, 13 Apr 2009 08:02:26 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id KajmLPIAhBunDsgB for
	<xfs@oss.sgi.com>; Mon, 13 Apr 2009 08:02:26 -0700 (PDT)
Message-ID: <49E353FD.5060207@sandeen.net>
Date: Mon, 13 Apr 2009 10:02:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs - fixing wrong xfs size
References: <dbd747120904130713t7388971axf75ee779b5b1e1f2@mail.gmail.com>
In-Reply-To: <dbd747120904130713t7388971axf75ee779b5b1e1f2@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Nebojsa Trpkovic <trx.lists@gmail.com>
Cc: xfs@oss.sgi.com

Nebojsa Trpkovic wrote:
> hello.
> 
> I had problem with raid5 on my system.
> after recovering of the array, I can not mount XFS that resides on it.
> I've run xfs_check and xfs_repair (which fixed some errors) and now I
> can run them all day long without any errors.
> 
> but, when I try to mount that partition, I get:
> 
> mount: /dev/md0: can't read superblock
> 
> 
> and there's
> 
> Filesystem "md0": Disabling barriers, not supported by the underlying device
> 
> attempt to access beyond end of device
> md0: rw=0, want=123024384, limit=123023488
> I/O error in filesystem ("md0") meta-data dev md0 block 0x75533f8

       ("xfs_read_buf") error 5 buf count 4096
> 
> XFS: size check 2 failed

So, the superblock says that the fs is 896 1k-blocks longer than the
device actually is.

> in the dmesg.
> 
> 
> is there any way to "fix" this wrong size of XFS ?

hard to say, almost certainly sounds like an md problem; is there a
chance that your raid recovery led to a device which is somehow smaller
than it started?  You could change the superblock block-count value, but
I'm guessing that something else has gone wrong.

It might be useful to know what errors xfs_repair found.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
