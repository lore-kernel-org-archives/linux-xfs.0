Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n064j9Qj010854 for <xfs@oss.sgi.com>; Mon, 5 Jan 2009 22:45:09 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E2CCD642A7
	for <xfs@oss.sgi.com>; Mon,  5 Jan 2009 20:45:08 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id thdEoSlqHdR3cA2X for
	<xfs@oss.sgi.com>; Mon, 05 Jan 2009 20:45:08 -0800 (PST)
References: <BAY123-W145701C4842C1B063295BDEAE10@phx.gbl>
	<20090106011014.GA9448@disturbed>
Message-Id: <CA02FD05-723D-4F8E-8DDC-E9AFC8AF790A@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20090106011014.GA9448@disturbed>
Mime-Version: 1.0 (iPod Mail 5G77)
Subject: Re: retrocompatibility XFS 2.10.1 with 2.8.1 ?
Date: Mon, 5 Jan 2009 22:44:51 -0600
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
Cc: Tritium Tritium <tritium_helium@hotmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>



On Jan 5, 2009, at 7:10 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Mon, Jan 05, 2009 at 07:04:30PM +0000, Tritium Tritium wrote:
>>
>> HI !
>>
>> In first, I 'm a french user and sorry for my very bad english ...
>> For an Adsl Box, I want to partitionning and format my external  
>> hard disk drive under XFS .What a good idea , isn't it ? ;o)
>> I get my Mandriva One (I know it isn't a "professionnal"  
>> distribution but you know the French search the simple thing !) and  
>> use fdisk -l , gparted and mkfs.xfs /dev/xxx .
>> With this, the adsl box reboot ! And of course it doesn't recognize  
>> the partition.
>> I tried with a Debian Etch XFS ... and this is a SUCCESS !
>> When I compare XFS versions I find a 2.10.1 for Mandriva and 2.8.1  
>> for Debian.
>
> The defaults mkfs.xfs uses in 2.10.1 are different to 2.8.1. The
> newer version enables features that are only availble in more recent
> kernels (since about 2.6.19, IIRC), so it would seem that your ADSL
> box has an old kernel on it that does not support the newer, faster,
> shinier features XFS has....
>
> The kernel version of your ADSL box, as well as the mkfs.xfs output
> from both distro's would help confirm this.

dmesg output after the failed mount would hopefully also offer some  
clues..

For what it's worth, you can just turn off the newer features when you  
mkfs with the newer version, too.

-Eric

>
> Cheers,
>
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
