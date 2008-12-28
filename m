Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBSMiotc003341 for <xfs@oss.sgi.com>; Sun, 28 Dec 2008 16:44:50 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7537B4D429
	for <xfs@oss.sgi.com>; Sun, 28 Dec 2008 14:44:48 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id FlP7O4KuC8rIPvIU for
	<xfs@oss.sgi.com>; Sun, 28 Dec 2008 14:44:48 -0800 (PST)
Date: Sun, 28 Dec 2008 17:44:48 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: xfs_db 2.9.8: coredump
In-Reply-To: <20081228223917.GC22525@disturbed>
Message-ID: <alpine.DEB.1.10.0812281744210.28053@p34.internal.lan>
References: <alpine.DEB.1.10.0812260931490.11656@p34.internal.lan>
	<49551073.5090704@redhat.com>
	<alpine.DEB.1.10.0812261243550.18703@p34.internal.lan>
	<alpine.DEB.1.10.0812261251520.18703@p34.internal.lan>
	<20081228223917.GC22525@disturbed>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Alan Piszcz <ap@solarrain.com>, esandeen@redhat.com, xfs@oss.sgi.com



On Mon, 29 Dec 2008, Dave Chinner wrote:

> On Fri, Dec 26, 2008 at 12:52:10PM -0500, Justin Piszcz wrote:
>> On Fri, 26 Dec 2008, Justin Piszcz wrote:
>>> On Fri, 26 Dec 2008, Eric Sandeen wrote:
>>>> Justin Piszcz wrote:
>>>>> # xfs_db -V
>>>>> xfs_db version 2.9.8
>>>>>
>>>>> p34:~# xfs_db -c frag -f /dev/sda1
>>>>> Segmentation fault (core dumped)
>>>>> p34:~# xfs_db -c frag -r /dev/sda1
>>>>> Segmentation fault (core dumped)
>>>>>
>>>>> (It was working BEFORE I ran xfs_fsr on it, it was at 16% fragmentation).
>>>>>
>>>>> Now it can no longer check it?
>
> xfs_db works on the block device under the filesystem, not the
> filesystem. Also, the block device on linux caches blocks, so
> after running xfs_fsr the filesystem layout has changed but the
> underlying block device now has a stale cache. hence xfs_db is
> probably being pointed off into la-la land by the stale block
> device cache.
>
> # echo 3 > /proc/sys/vm/drop_caches
Thanks Dave, I will have to add this to my scripts whenever an xfs_fsr is 
performed to avoid the problem in the future.

>
> Is your friend whenever you want to use xfs_db on a mounted
> filesystem.
>
>> p34:~# umount /r1
>> p34:~# sync
>
> And now the block device is coherent....
>
>> p34:~# xfs_db -c frag -r /dev/sda1
>> actual 365758, ideal 358711, fragmentation factor 1.93%
>
>> p34:~# mount -a
>> p34:~# xfs_db -c frag -r /dev/sda1
>> actual 365758, ideal 358711, fragmentation factor 1.93%
>> p34:~# mount -a ; dmesg | tail -n 2
>> p34:~# xfs_fsr /dev/sda1
>> /r1 start inode=0
>> p34:~# xfs_db -c frag -r /dev/sda1
>> actual 365751, ideal 358711, fragmentation factor 1.92%
>> p34:~#
>
> And this resulted in very little change  so the block device
> cache wasn't completely wacked....
>
> Cheers,
>
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
