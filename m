Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0ELp2mH001761 for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 15:51:02 -0600
Message-ID: <496E5DB8.1030007@sandeen.net>
Date: Wed, 14 Jan 2009 15:48:40 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [linux-dvb] compiling on 2.6.28 broken?
References: <20090112190420.51f75853@pedra.chehab.org>	<20090112132130.6c932b85.akpm@linux-foundation.org>	<20090112220624.4fbfee34@pedra.chehab.org>	<20090112162337.318dd61d.akpm@linux-foundation.org>	<20090113184755.87720@gmx.net>	<20090113105947.9e774b69.akpm@linux-foundation.org>	<20090113191757.74290@gmx.net>	<20090113113700.776a94b5.akpm@linux-foundation.org>	<20090113203843.GJ29283@parisc-linux.org>	<1231957750.8269.28.camel@think.oraclecorp.com>	<496E56EB.2030301@gmx.de>	<1231968240.8269.48.camel@think.oraclecorp.com>	<496E5AB2.7040507@sandeen.net>
	<20090114134417.e6b29b52.akpm@linux-foundation.org>
In-Reply-To: <20090114134417.e6b29b52.akpm@linux-foundation.org>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: handygewinnspiel@gmx.de, matthew@wil.cx, linux-kernel@vger.kernel.org, mchehab@infradead.org, rjw@sisk.pl, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, HWerner4@gmx.de, xfs mailing list <xfs@oss.sgi.com>, Christoph Hellwig <hch@lst.de>, stable@kernel.org, chris.mason@oracle.com

Andrew Morton wrote:
> On Wed, 14 Jan 2009 15:35:46 -0600
> Eric Sandeen <sandeen@sandeen.net> wrote:
> 
>> Chris Mason wrote:
>>> On Wed, 2009-01-14 at 22:19 +0100, wk wrote:
>> ...
>>>> I cannot fully understand what strace -v outputs (see attachment), but 
>>>> what i see is that 'find' stops after finding a file with d_off = 4294967295
>>>> 4294967295  =  0xFFFFFFFF, adding any number greater that zero will be 
>>>> greater that 32bits, so this could be the reason for the message "value 
>>>> too large".
>>>>
>>>>
>>>>
>>>> I also noticed that i cannot access these files through samba if i boot 
>>>> from 2.6.28 - really strange.
>>>> If i reboot older kernels these are visible in samba again and fully 
>>>> accessible.
>>>>
>>>> Attached the log from stracing the command which was ivoked by the 
>>>> Makefile from v4l-dvb.
>>>> I guess this is all i could contribute to that problem. Thats stuff for 
>>>> xfs filesystem experts now..
>>> Seems suspect indeed.  Could you please attach the strace for the run
>>> that works on the older kernel?
>> Chris got my attention on this one; you probably want this fix from hch:
>>
>> http://oss.sgi.com/archives/xfs/2009-01/msg00158.html
>>
> 
> Looks likely.  It is below, for anyone who would like to test it.
> 
> 
> It is in linux-next.  Guys, do we plan to merge this into 2.6.29?

It should be merged there, yes.  Was hoping that sgi would request that
soon....

> (cc's stable@kernel.org)
> 
> This patch applies OK to 2.6.27 and 2.6.28.  Is it also needed there? 
> If so, it should have had "Cc: <stable@kernel.org>" in the changelog so
> that it doesn't get lost.
> 

It is needed for .28, but should not be needed for .27 AFAIK.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
