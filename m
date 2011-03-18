Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2IFGBoW041031 for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 10:16:16 -0500
Received: from mail.moocowproductions.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 3BC4D360EBE
	for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 08:19:07 -0700 (PDT)
Received: from mail.moocowproductions.org (mail.moocowproductions.org
	[50.56.82.78]) by cuda.sgi.com with SMTP id NQkmkBc07wKCjq17
	for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 08:19:07 -0700 (PDT)
Subject: Re: 2.6.38: XFS/USB/HW issue, or failing USB stick?
Mime-Version: 1.0 (Apple Message framework v1082)
From: Tim Soderstrom <tim@moocowproductions.org>
In-Reply-To: <alpine.DEB.2.02.1103181104020.30018@p34.internal.lan>
Date: Fri, 18 Mar 2011 10:19:05 -0500
Message-Id: <30463798-7ACB-4248-8CDC-CEFCB6ABC0BE@moocowproductions.org>
References: <alpine.DEB.2.02.1103181104020.30018@p34.internal.lan>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Alan Piszcz <ap@solarrain.com>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com


On Mar 18, 2011, at 10:08 AM, Justin Piszcz wrote:

> Hi,
> 
> I can write to just about the entire USB stick, with no errors:
> 
> atom:~# df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sda2             5.8G  1.5G  4.3G  26% /
> tmpfs                 2.0G     0  2.0G   0% /lib/init/rw
> udev                   10M  140K  9.9M   2% /dev
> tmpfs                 2.0G     0  2.0G   0% /dev/shm
> atom:~# cd /
> atom:/# ls
> bin   cdrom  etc   lib    media  nfs  proc  sbin     srv  tmp  var
> boot  dev    home  lib64  mnt    opt  root  selinux  sys  usr
> atom:/# dd if=/dev/zero of=bigfile bs=1M count=4000
> 4000+0 records in
> 4000+0 records out
> 4194304000 bytes (4.2 GB) copied, 135.536 s, 30.9 MB/s
> atom:/# df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sda2             5.8G  5.4G  350M  95% /
> tmpfs                 2.0G     0  2.0G   0% /lib/init/rw
> udev                   10M  140K  9.9M   2% /dev
> tmpfs                 2.0G     0  2.0G   0% /dev/shm
> atom:/# rm bigfile
> 
> However, after some amount of time, the errors occur below, is this USB
> stick failing?  Since it has no SMART, is there any other way to verify
> the 'health' of a USB stick?

What prompted you to go with XFS over, say, ext2? The journal will generally cause quite a bit more writes onto your USB device. I use ext2 on my CF card in my NAS for that reason (the spinning media is on XFS of course). I know that's not an answer to your problem but thought I would add it as a suggestion :)

Tim

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
