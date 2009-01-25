Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0PLGBLX156337 for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 15:16:11 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2040D185BB9D
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 13:15:27 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id DhNpxPu0PFgrN3gv for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 13:15:27 -0800 (PST)
Date: Sun, 25 Jan 2009 16:14:56 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Switching from (deprecated) IDE driver -> SATA (PATA support)
In-Reply-To: <497CD5F3.8030901@tmr.com>
Message-ID: <alpine.DEB.1.10.0901251614160.16676@p34.internal.lan>
References: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan>
	<20090125110742.4ba54c0b@lxorguk.ukuu.org.uk>
	<alpine.DEB.1.10.0901250705300.6888@p34.internal.lan>
	<alpine.DEB.1.10.0901250715030.10379@p34.internal.lan>
	<alpine.DEB.1.10.0901250726530.10805__44823.8515914001$1232890466$gmane$org@p34.internal.lan>
	<497CD5F3.8030901@tmr.com>
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
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, xfs@oss.sgi.com



On Sun, 25 Jan 2009, Bill Davidsen wrote:

> Justin Piszcz wrote:
>> 
>> 
>> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>> 
>>> 
>>> 
>>> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>>> 
>>>> 
>>>> 
>>>> On Sun, 25 Jan 2009, Alan Cox wrote:
>>>> 
>>>>> Easiest is to use labels. Old ide will keep hda,b,c,d constant
>>>>> providing you have interfaces using the legacy IDE port mappings (0x1f0
>>>>> and 0x170). Libata doesn't do that as pretty much every distribution had
>>>>> already switched to volume labels, and the user space can do the job far
>>>>> better than the kernel - especially as the newer devices with modern
>>>>> interfaces don't have the old BIOS/DOS legacy ideas any more.
>>>>> 
>>>>> Mount by label also means you can flip back and forth between the
>>>>> different drivers and kernel revisions.
>>>>> 
>>>>> Alan
>>>>> 
>>> It comes with one :)
>>> # xfs_admin -u  /dev/sdd2
>>> UUID = 77ae4251-631f-4656-a365-c5723f5c5da8
>>> 
>>> Will try to use this to boot; however, I'd prefer the labels over the 
>>> UUID, wish there was an easy way to set it.
>>> 
>>> Justin.
>>> 
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs
>>> 
>> 
>> One final question, without udev, how does one determine the UUID of a 
>> non-XFS
>> partition, e.g., swap?
>> 
> One uses blkid. Which suggests that you can solve your name problem by not 
> using names and switching to UUID.

This will fix the /etc/fstab issue but not LILO/boot one, per the earlier 
poster, need an initrd/etc for that.

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
