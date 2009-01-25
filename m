Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0PCTgp0123678 for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 06:29:44 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 155D31BAB58D
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 04:28:59 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id owpQBEowPKRVcaVD for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 04:28:59 -0800 (PST)
Date: Sun, 25 Jan 2009 07:28:28 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Switching from (deprecated) IDE driver -> SATA (PATA support)
In-Reply-To: <alpine.DEB.1.10.0901250715030.10379@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0901250726530.10805@p34.internal.lan>
References: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan>
	<20090125110742.4ba54c0b@lxorguk.ukuu.org.uk>
	<alpine.DEB.1.10.0901250705300.6888@p34.internal.lan>
	<alpine.DEB.1.10.0901250715030.10379@p34.internal.lan>
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
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Sun, 25 Jan 2009, Justin Piszcz wrote:

>
>
> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>
>> 
>> 
>> On Sun, 25 Jan 2009, Alan Cox wrote:
>> 
>>> Easiest is to use labels. Old ide will keep hda,b,c,d constant
>>> providing you have interfaces using the legacy IDE port mappings (0x1f0
>>> and 0x170). Libata doesn't do that as pretty much every distribution had
>>> already switched to volume labels, and the user space can do the job far
>>> better than the kernel - especially as the newer devices with modern
>>> interfaces don't have the old BIOS/DOS legacy ideas any more.
>>> 
>>> Mount by label also means you can flip back and forth between the
>>> different drivers and kernel revisions.
>>> 
>>> Alan
>>> 
> It comes with one :)
> # xfs_admin -u  /dev/sdd2
> UUID = 77ae4251-631f-4656-a365-c5723f5c5da8
>
> Will try to use this to boot; however, I'd prefer the labels over the UUID, 
> wish there was an easy way to set it.
>
> Justin.
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

One final question, without udev, how does one determine the UUID of a non-XFS
partition, e.g., swap?

$ ls -l
total 0
lrwxrwxrwx 1 root root  9 2009-01-25 01:54 203fcd30-4e56-40e9-a8e5-93ddc8eb536a -> ../../md0
lrwxrwxrwx 1 root root 10 2009-01-25 01:54 2ef862e1-cf78-4065-a205-d1784716d633 -> ../../sdd1
lrwxrwxrwx 1 root root 10 2009-01-25 01:54 77ae4251-631f-4656-a365-c5723f5c5da8 -> ../../sdd2

p254:~# find /proc/|grep -i uuid
/proc/sys/kernel/random/uuid
p254:~# find /sys/|grep -i uuid 
p254:~#

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
