Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Jul 2008 06:35:06 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6HDZ1xK014401
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2008 06:35:02 -0700
Received: from slurp.thebarn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E1C9B00783
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2008 06:36:08 -0700 (PDT)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202]) by cuda.sgi.com with ESMTP id dRBzPhDoQzCnFElQ for <xfs@oss.sgi.com>; Thu, 17 Jul 2008 06:36:08 -0700 (PDT)
Message-ID: <487F4AC5.3000806@thebarn.com>
Date: Thu, 17 Jul 2008 08:36:05 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: Power loss causes bad magic number??
References: <F46A887185FC6044A7FAC577E31118AE022316C0@rsbne01.RSBNE.LOCAL> <487D5F80.1050909@sandeen.net> <F46A887185FC6044A7FAC577E31118AE021E0623@rsbne01.RSBNE.LOCAL> <20080716073503.GE29319@disturbed> <F46A887185FC6044A7FAC577E31118AE021E0625@rsbne01.RSBNE.LOCAL>
In-Reply-To: <F46A887185FC6044A7FAC577E31118AE021E0625@rsbne01.RSBNE.LOCAL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephen Porter <stephenp@r-s.com.au>
Cc: xfs@oss.sgi.com

Stephen Porter wrote:
>
> -----Original Message-----
> From: Dave Chinner [mailto:david@fromorbit.com]
>
>   
>> That looks like a boot loader.
>>     
>
> That's what I thought, but again, this isn't a boot volume, could running xfs_repair without the -n have done this?
>
>   
>> And at 0x200 I'd expect to see an AGF header, not zeros. To
>> me, that says that either XFS is inside a partition on the drive
>> or someone ran a partitioning tool on /dev/sdc and overwrote the
>> XFS filesystem headers...
>>     
>
> relevant line from /etc/fstab:
>
> /dev/sdc	/home/username/Data	xfs	defaults	0	2
>
> the raid management tool is reporting everythings ok... any idea what could have caused this?  
>
> ....
>
> Ok, my apologies, I've just done an ls of /dev/sd* and the devices have been remapped (any idea what would have caused that?), sdc is no longer sdc, it is now sda, the boot devices are now detected as sdb and sdc (2 mirrored physical disks, used to be sda and sdb).  How was the machine able to boot?  I'm more confused than ever now, but the data is all there.
>   
Heh welcome to the world of linux's poor device name handling.
Did you make some sort of change to the hardware? added drives, moved 
cards around, etc?
Anything that changes the order that drives are discovered will affect 
the sd[a-...] naming.


Mount by label or mount by uuid may be your friend in this case.

> Sorry for wasting everyones time.
>
> Regards,
>
> Stephen.
>
>
>
>
> [[HTML alternate version deleted]]
>
>   
