Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBB9IBrd032296 for <xfs@oss.sgi.com>; Thu, 11 Dec 2008 03:18:11 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F05CB170F7CC
	for <xfs@oss.sgi.com>; Thu, 11 Dec 2008 01:18:09 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id FyHsCKoxYLlwMZjb for
	<xfs@oss.sgi.com>; Thu, 11 Dec 2008 01:18:09 -0800 (PST)
Date: Thu, 11 Dec 2008 04:18:09 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers
 [xfs]
In-Reply-To: <49405CD5.4070704@tmr.com>
Message-ID: <alpine.DEB.1.10.0812110416550.14590@p34.internal.lan>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
	<49405CD5.4070704@tmr.com>
MIME-Version: 1.0
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
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>, xfs@oss.sgi.com



On Wed, 10 Dec 2008, Bill Davidsen wrote:

> Justin Piszcz wrote:
>> Someone should write a document with XFS and barrier support, if I recall,
>> in the past, they never worked right on raid1 or raid5 devices, but it
>> appears now they they work on RAID1, which slows down performance ~12 
>> times!!
>> 
> I would expect you, as an experienced tester, to have done this measurement 
> more rigorously!
> I don't think it means much if this is what you did.
>
>> l1:~# /usr/bin/time tar xf linux-2.6.27.7.tar 0.15user 1.54system 
>> 0:13.18elapsed 12%CPU (0avgtext+0avgdata 0maxresident)k
>> 0inputs+0outputs (0major+325minor)pagefaults 0swaps
>> l1:~#
>> 
>> l1:~# /usr/bin/time tar xf linux-2.6.27.7.tar
>> 0.14user 1.66system 2:39.68elapsed 1%CPU (0avgtext+0avgdata 0maxresident)k
>> 0inputs+0outputs (0major+324minor)pagefaults 0swaps
>> l1:~#
>> 
> Before doing any disk test you need to start by dropping cache, to be sure 
> the appropriate reproducible things happen. And in doing a timing test, you 
> need to end with a sync for the same reason.
>
> So:
> echo 1 >/proc/sys/vm/drop_caches
> time bash -c "YOUR TEST; sync"
>
> This will give you a fair shot at being able to reproduce the results, done 
> on an otherwise unloaded system.
>
> -- 
> Bill Davidsen <davidsen@tmr.com>
> "Woe unto the statesman who makes war without a reason that will still
> be valid when the war is over..." Otto von Bismark 
>

Roughly the same for non-barriers:
# bash -c '/usr/bin/time tar xf linux-2.6.27.7.tar' 
0.15user 1.51system 0:12.95elapsed 12%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (4major+320minor)pagefaults 0swaps

For barriers I cannot test that right now but it most likely will be around the
same as well.

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
