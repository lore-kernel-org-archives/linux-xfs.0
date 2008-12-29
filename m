Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBT4nBVv027915 for <xfs@oss.sgi.com>; Sun, 28 Dec 2008 22:49:13 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5B1C44DB94
	for <xfs@oss.sgi.com>; Sun, 28 Dec 2008 20:49:10 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id eHOM8yQzWVLhE7io for
	<xfs@oss.sgi.com>; Sun, 28 Dec 2008 20:49:10 -0800 (PST)
Message-ID: <495856A7.6040608@sandeen.net>
Date: Sun, 28 Dec 2008 22:48:39 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_db 2.9.8: coredump
References: <alpine.DEB.1.10.0812260931490.11656@p34.internal.lan>	<49551073.5090704@redhat.com>	<alpine.DEB.1.10.0812261243550.18703@p34.internal.lan>	<alpine.DEB.1.10.0812261251520.18703@p34.internal.lan>
	<20081228223917.GC22525@disturbed>
In-Reply-To: <20081228223917.GC22525@disturbed>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>, Alan Piszcz <ap@solarrain.com>, xfs@oss.sgi.com

Dave Chinner wrote:
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

Ah, missed the part about doing it online.  Probably shouldn't segfault
though, I suppose.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
