Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2IHgk3u047638 for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 12:42:51 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7CFDD12AFF91
	for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 10:45:43 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id XHBh3pTrepLpGuRE for
	<xfs@oss.sgi.com>; Fri, 18 Mar 2011 10:45:43 -0700 (PDT)
Date: Fri, 18 Mar 2011 13:45:42 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.38: XFS/USB/HW issue, or failing USB stick?
In-Reply-To: <30463798-7ACB-4248-8CDC-CEFCB6ABC0BE@moocowproductions.org>
Message-ID: <alpine.DEB.2.02.1103181258370.21715@p34.internal.lan>
References: <alpine.DEB.2.02.1103181104020.30018@p34.internal.lan>
	<30463798-7ACB-4248-8CDC-CEFCB6ABC0BE@moocowproductions.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Tim Soderstrom <tim@moocowproductions.org>
Cc: Alan Piszcz <ap@solarrain.com>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Fri, 18 Mar 2011, Tim Soderstrom wrote:

>
> On Mar 18, 2011, at 10:08 AM, Justin Piszcz wrote:
>
>> Hi,
>>
>> I can write to just about the entire USB stick, with no errors:
>>
>> atom:~# df -h
>> Filesystem            Size  Used Avail Use% Mounted on
>> /dev/sda2             5.8G  1.5G  4.3G  26% /
>> tmpfs                 2.0G     0  2.0G   0% /lib/init/rw
>> udev                   10M  140K  9.9M   2% /dev
>> tmpfs                 2.0G     0  2.0G   0% /dev/shm
>> atom:~# cd /
>> atom:/# ls
>> bin   cdrom  etc   lib    media  nfs  proc  sbin     srv  tmp  var
>> boot  dev    home  lib64  mnt    opt  root  selinux  sys  usr
>> atom:/# dd if=/dev/zero of=bigfile bs=1M count=4000
>> 4000+0 records in
>> 4000+0 records out
>> 4194304000 bytes (4.2 GB) copied, 135.536 s, 30.9 MB/s
>> atom:/# df -h
>> Filesystem            Size  Used Avail Use% Mounted on
>> /dev/sda2             5.8G  5.4G  350M  95% /
>> tmpfs                 2.0G     0  2.0G   0% /lib/init/rw
>> udev                   10M  140K  9.9M   2% /dev
>> tmpfs                 2.0G     0  2.0G   0% /dev/shm
>> atom:/# rm bigfile
>>
>> However, after some amount of time, the errors occur below, is this USB
>> stick failing?  Since it has no SMART, is there any other way to verify
>> the 'health' of a USB stick?
>
> What prompted you to go with XFS over, say, ext2? The journal will generally cause quite a bit more writes onto your USB device. I use ext2 on my CF card in my NAS for that reason (the spinning media is on XFS of course). I know that's not an answer to your problem but thought I would add it as a suggestion :)
>

Hi,

Just habit I suppose.. (XFS).  Looks like EXT2 is the correct solution here,
or ext4 w/nojournal (if Google's patch is in the kernel).  I have to read
the lwn.net article though.

Justin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
