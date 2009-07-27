Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6R1lMQc057368
	for <linux-xfs@oss.sgi.com>; Sun, 26 Jul 2009 20:47:23 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 734581D4F44F
	for <linux-xfs@oss.sgi.com>; Sun, 26 Jul 2009 18:48:08 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id nrJF5V5Og0ltA8i8 for
	<linux-xfs@oss.sgi.com>; Sun, 26 Jul 2009 18:48:08 -0700 (PDT)
Message-ID: <4A6D075B.9060601@sandeen.net>
Date: Sun, 26 Jul 2009 20:48:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: How to solve "No space left" problem on my 32bit machine?
References: <389deec70907252030s3524b2ecj9b35da9ea376020f@mail.gmail.com>
In-Reply-To: <389deec70907252030s3524b2ecj9b35da9ea376020f@mail.gmail.com>
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
To: hank peng <pengxihan@gmail.com>
Cc: linux-xfs@oss.sgi.com

hank peng wrote:
> Hi, folks:
> I have a 2.5T file system formatted with XFS, df tells me it still
> have about 10G space available, but I can't create new files or
> directory any more. Return message is "No space left on this device".
> I searched solution for this problem through google, and found this:
> http://oss.sgi.com/archives/xfs/2005-06/msg00347.html. I think it is a
> known "No space left" problem. I wonder whether it can only
> be solved on 64-bit machine? If on my 32-bit machine, what should I do?

On very recent kernels you can use 64-bit inodes on 32-bit machines; you
can try mounting with -o inode64 t allow this.

Be warned though that some applications use 32-bit stat calls still,
rather than 64-bit variants, and you may have some problems.  You should
file bugs against any such applications that you find...

-eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
