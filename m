Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0U0BJa1244147 for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 18:11:20 -0600
Received: from partygirl.tmr.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EEB0D1889668
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 16:10:37 -0800 (PST)
Received: from partygirl.tmr.com (mail.tmr.com [64.65.253.246]) by
	cuda.sgi.com with ESMTP id C68603XNwFURW6gT for
	<xfs@oss.sgi.com>; Thu, 29 Jan 2009 16:10:37 -0800 (PST)
Message-ID: <49823F49.4000407@tmr.com>
Date: Thu, 29 Jan 2009 18:44:09 -0500
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
Subject: Re: Switching from (deprecated) IDE driver -> SATA (PATA support)
References: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan>
	<20090125110742.4ba54c0b@lxorguk.ukuu.org.uk>
	<alpine.DEB.1.10.0901250705300.6888@p34.internal.lan>
	<alpine.DEB.1.10.0901250715030.10379@p34.internal.lan>
	<alpine.DEB.1.10.0901250726530.10805__44823.8515914001$1232890466$gmane$org@p34.internal.lan>
	<497CD5F3.8030901@tmr.com>
	<alpine.DEB.1.10.0901251614160.16676@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0901251614160.16676@p34.internal.lan>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, xfs@oss.sgi.com

Justin Piszcz wrote:
> 
> 
> On Sun, 25 Jan 2009, Bill Davidsen wrote:
> 
>> Justin Piszcz wrote:
>>>
>>>
>>> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>>>
>>>>
>>>>
>>>> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>>>>
>>>>>
>>>>>
>>>>> On Sun, 25 Jan 2009, Alan Cox wrote:
>>>>>
>>>>>> Easiest is to use labels. Old ide will keep hda,b,c,d constant
>>>>>> providing you have interfaces using the legacy IDE port mappings 
>>>>>> (0x1f0
>>>>>> and 0x170). Libata doesn't do that as pretty much every 
>>>>>> distribution had
>>>>>> already switched to volume labels, and the user space can do the 
>>>>>> job far
>>>>>> better than the kernel - especially as the newer devices with modern
>>>>>> interfaces don't have the old BIOS/DOS legacy ideas any more.
>>>>>>
>>>>>> Mount by label also means you can flip back and forth between the
>>>>>> different drivers and kernel revisions.
>>>>>>
>>>>>> Alan
>>>>>>
>>>> It comes with one :)
>>>> # xfs_admin -u  /dev/sdd2
>>>> UUID = 77ae4251-631f-4656-a365-c5723f5c5da8
>>>>
>>>> Will try to use this to boot; however, I'd prefer the labels over 
>>>> the UUID, wish there was an easy way to set it.
>>>>
>>>> Justin.
>>>>
>>>> _______________________________________________
>>>> xfs mailing list
>>>> xfs@oss.sgi.com
>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>>
>>>
>>> One final question, without udev, how does one determine the UUID of 
>>> a non-XFS
>>> partition, e.g., swap?
>>>
>> One uses blkid. Which suggests that you can solve your name problem by 
>> not using names and switching to UUID.
> 
> This will fix the /etc/fstab issue but not LILO/boot one, per the 
> earlier poster, need an initrd/etc for that.
> 
Good point, I have not used LILO since about Slackware 8.1, or any system w/o 
initrd in ages. I suppose there is a benefit to running without initrd, but I 
confess that I can't remember what it is. So I don't immediately consider the 
issues and limitations if you run without initrd.

Well I answered how to GET the UUID, he didn't ask me how to USE it. And I 
certainly didn't think of it, even though the info was there. :-(

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
