Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBQI6PqL006974 for <xfs@oss.sgi.com>; Fri, 26 Dec 2008 12:06:25 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 70D61178C8C6
	for <xfs@oss.sgi.com>; Fri, 26 Dec 2008 10:06:24 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id lghKEyTpWyoYjoe9 for <xfs@oss.sgi.com>;
	Fri, 26 Dec 2008 10:06:24 -0800 (PST)
Message-ID: <49551019.7030802@sandeen.net>
Date: Fri, 26 Dec 2008 11:10:49 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_db 2.9.8: coredump
References: <alpine.DEB.1.10.0812260931490.11656@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0812260931490.11656@p34.internal.lan>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Alan Piszcz <ap@solarrain.com>, esandeen@redhat.com, xfs@oss.sgi.com

Justin Piszcz wrote:
> # xfs_db -V
> xfs_db version 2.9.8
> 
> p34:~# xfs_db -c frag -f /dev/sda1
> Segmentation fault (core dumped)
> p34:~# xfs_db -c frag -r /dev/sda1
> Segmentation fault (core dumped)
> 
> (It was working BEFORE I ran xfs_fsr on it, it was at 16% fragmentation).
> 
> Now it can no longer check it?
> 
> ===============================================================================
> 
> Program terminated with signal 11, Segmentation fault.
> [New process 11346]
> (gdb) bt
> #0  0x00007f6a67c8c3e0 in ?? () from /lib/libc.so.6
> #1  0x00007f6a67c8b43a in memmove () from /lib/libc.so.6
> #2  0x0000000000403f2e in ?? ()
> #3  0x0000000000412ff1 in ?? ()
> #4  0x00000000004129cb in ?? ()
> #5  0x0000000000413392 in ?? ()

please run against a debug binary so we can get useful info...

If this was on fedora, just install the matching xfsprogs-debuginfo package.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
