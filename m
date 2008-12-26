Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBQI1OF3006249 for <xfs@oss.sgi.com>; Fri, 26 Dec 2008 12:01:24 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A21CA4AB77
	for <xfs@oss.sgi.com>; Fri, 26 Dec 2008 10:01:22 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id gAlVgDFrQoWW6UN4 for
	<xfs@oss.sgi.com>; Fri, 26 Dec 2008 10:01:22 -0800 (PST)
Date: Fri, 26 Dec 2008 12:52:10 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: xfs_db 2.9.8: coredump
In-Reply-To: <alpine.DEB.1.10.0812261243550.18703@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0812261251520.18703@p34.internal.lan>
References: <alpine.DEB.1.10.0812260931490.11656@p34.internal.lan>
	<49551073.5090704@redhat.com>
	<alpine.DEB.1.10.0812261243550.18703@p34.internal.lan>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Alan Piszcz <ap@solarrain.com>, esandeen@redhat.com, xfs@oss.sgi.com



On Fri, 26 Dec 2008, Justin Piszcz wrote:

>
>
> On Fri, 26 Dec 2008, Eric Sandeen wrote:
>
>> Justin Piszcz wrote:
>>> # xfs_db -V
>>> xfs_db version 2.9.8
>>> 
>>> p34:~# xfs_db -c frag -f /dev/sda1
>>> Segmentation fault (core dumped)
>>> p34:~# xfs_db -c frag -r /dev/sda1
>>> Segmentation fault (core dumped)
>>> 
>>> (It was working BEFORE I ran xfs_fsr on it, it was at 16% fragmentation).
>>> 
>>> Now it can no longer check it?
>>> 
>> 
>> Or, get an xfs_metadump of the fs and see if db segfaults on that too.
>> 
>> I'd be curious  to know if xfs_repair -n flaggs any problems, as well.
>> 
>> -Eric
>>

p34:~# umount /r1
p34:~# sync
p34:~# xfs_db -c frag -r /dev/sda1
actual 365758, ideal 358711, fragmentation factor 1.93%
p34:~# mount -a
p34:~# xfs_db -c frag -r /dev/sda1
actual 365758, ideal 358711, fragmentation factor 1.93%
p34:~# mount -a ; dmesg | tail -n 2
p34:~# xfs_fsr /dev/sda1
/r1 start inode=0
p34:~# xfs_db -c frag -r /dev/sda1
actual 365751, ideal 358711, fragmentation factor 1.92%
p34:~#

Now it is working?  I do not understand.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
