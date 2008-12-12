Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBCKO60l014239 for <xfs@oss.sgi.com>; Fri, 12 Dec 2008 14:24:07 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0EBC9165E3
	for <xfs@oss.sgi.com>; Fri, 12 Dec 2008 12:23:51 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id mdwOy1JV07vs1Spn for
	<xfs@oss.sgi.com>; Fri, 12 Dec 2008 12:23:51 -0800 (PST)
Date: Fri, 12 Dec 2008 15:23:19 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Intel X25-E running Linux using XFS
In-Reply-To: <20081212185803.GE11974@elf.ucw.cz>
Message-ID: <alpine.DEB.1.10.0812121516190.17857@p34.internal.lan>
References: <alpine.DEB.1.10.0811271257470.2233@p34.internal.lan>
	<20081212185803.GE11974@elf.ucw.cz>
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
To: Pavel Machek <pavel@suse.cz>
Cc: smartmontools-support@lists.sourceforge.net, smartmontools-database-owner@lists.sourceforge.net, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, Alan Piszcz <ap@solarrain.com>



On Fri, 12 Dec 2008, Pavel Machek wrote:

>
> Hi!
>
>> Due to the 100k write cycle lifetime, I will not be performing any more
>> benchmarks on the SSD itself, such benchmarks are available on
>> techreport.com but just wanted to send out the smart data for the
>> smartmontools list and point out it is working with linux+ich7+xfs.
>>
>> Overall, whenever I do anything now its just like the entire machine is
>> sitting in a ramdisk (similar when you boot knoppix and load to ramdisk).
>>
>> The techreport benchmarks are here:
>> http://techreport.com/articles.x/15931
>
> Actually I'd like to know... how does it behave during powerfails
> while it is being written to?
>
> Flashes I seen (USB / SD) developed bad sectors in that case, and
> ext2/ext3 can't handle that. (And I don't think xfs can handle that
> either).

I have a UPS for all of my machines, so that will not be a problem in my 
case.  I do not wish to trash a $720 SSD or my current install, if someone 
else wants to try feel free though :)

With barriers, presumably it would be safe-- but as always, a UPS/and 
barriers and/or RAID, there is no excuse not to have regular backups 
incase of a failure at any time..

I do recall however one instance where there was an apt-get dist-upgrade 
going and the power was cut to a machine on purpose (before/not 
using barriers) and suffice to say-- it got mucked/suffered many corruptions
all over the place.

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
