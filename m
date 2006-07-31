Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Jul 2006 02:59:55 -0700 (PDT)
Received: from mail.mdlink.de (hydra.mdlink.de [213.211.192.38])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6V9xXDW000667
	for <xfs@oss.sgi.com>; Mon, 31 Jul 2006 02:59:35 -0700
Message-ID: <44CDD03D.3060809@mdlink.de>
Date: Mon, 31 Jul 2006 11:41:17 +0200
From: Frank Patzig <fp@mdlink.de>
MIME-Version: 1.0
Subject: Re: [xfs] quota project problem
References: <44CA1D89.3080104@mdlink.de> <20060731103133.G2280998@wobbly.melbourne.sgi.com>
In-Reply-To: <20060731103133.G2280998@wobbly.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: xfs@oss.sgi.com

Hallo,

thanks, work fine.

Frank

Nathan Scott schrieb:
> On Fri, Jul 28, 2006 at 04:22:01PM +0200, Frank Patzig wrote:
>> Hallo,
>>
>> i have a problem with project quota. Can i help you.
>>
>> combolix:~ # uname -a
>> Linux combolix 2.6.18_rc1-jen27-default #1 Thu Jul 13 01:34:23 CEST 2006 
>> i686
>> i686 i386 GNU/Linux
>>
>> combolix:~ # cat /etc/mtab
>> /dev/hdc2 / xfs rw,uquota,gquota,pquota 0 0
> 
> This isn't correct - you can have either gquota or pquota,
> not both.  You also need to set root flags via the kernel
> boot option "rootflags=" - not via mtab (chicken vs egg).
> 
>> Project quota state on / (/dev/hdc2)
>>    Accounting: OFF
>>    Enforcement: OFF
>>    Inode: #18446744073709551615 (0 blocks, 0 extents)
> 
> cheers.
> 
