Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6UJCZSL096083 for <xfs@oss.sgi.com>; Thu, 30 Jul 2009 14:12:36 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C6DEA10ED3CC
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2009 12:22:19 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id DSfBVxGKA3iEOjcC for
	<xfs@oss.sgi.com>; Thu, 30 Jul 2009 12:22:19 -0700 (PDT)
Message-ID: <4A71F0D1.1020005@sandeen.net>
Date: Thu, 30 Jul 2009 14:13:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs i/O error
References: <24742623.post@talk.nabble.com>
In-Reply-To: <24742623.post@talk.nabble.com>
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
To: rnb <neil.bell@gmail.com>
Cc: xfs@oss.sgi.com

rnb wrote:
> Running Ubuntu 9.04 kernel 2.26.28.14 generic
> Drive mounts fine.
> xfs_repair shows no errors
...

> 
> xfs_check did move a few things around but finished fine

Actually xfs_check never changes anything ;)

> sudo xfs_fsr -v /dev/sdg1 <== This is just so far it is still running.
> /media/Films start inode=0
> ino=140
> bad read of 0 bytes from ino=140: Input/output error

Anything in dmesg when this happens?

...

> Now my issue is how do I fix it if xfs_repair doesn't see a problem.

It must not be a problem on-disk.  At least, hopefully not.  :)

> Anything getting copied to the drive works fine in place wasn't until i
> tried to move it off I noticed the issue. Some things copy fine from it
> several others fail. Then i get Input/output error. It is a full 1tb drive .
> WD mybook it lost power which I think is what caused this issue. How can I
> correct the issue. Everything I try takes a hell of a long time and doesn't
> yield a positive result

Oh, so it's not just fsr that does it?  cp too?

Anyway, look at dmesg when you get the error and see if there are
messages logged from the kernel when this happens.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
