Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0ELisIJ001190 for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 15:44:54 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 778268B9B8
	for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 13:44:39 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id FZ9nZiKT1ZSC2VZl for <xfs@oss.sgi.com>;
	Wed, 14 Jan 2009 13:44:39 -0800 (PST)
Message-ID: <496E5C20.6070507@sandeen.net>
Date: Wed, 14 Jan 2009 15:41:52 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [linux-dvb] compiling on 2.6.28 broken?
References: <20090112190420.51f75853@pedra.chehab.org>	
	<20090112132130.6c932b85.akpm@linux-foundation.org>	
	<20090112220624.4fbfee34@pedra.chehab.org>	
	<20090112162337.318dd61d.akpm@linux-foundation.org>	
	<20090113184755.87720@gmx.net>	
	<20090113105947.9e774b69.akpm@linux-foundation.org>	
	<20090113191757.74290@gmx.net>	
	<20090113113700.776a94b5.akpm@linux-foundation.org>	
	<20090113203843.GJ29283@parisc-linux.org>	
	<1231957750.8269.28.camel@think.oraclecorp.com>
	<496E56EB.2030301@gmx.de>
	<1231968240.8269.48.camel@think.oraclecorp.com>
	<496E5AB2.7040507@sandeen.net>
In-Reply-To: <496E5AB2.7040507@sandeen.net>
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
To: Chris Mason <chris.mason@oracle.com>
Cc: wk <handygewinnspiel@gmx.de>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, mchehab@infradead.org, rjw@sisk.pl, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, HWerner4@gmx.de, Andrew Morton <akpm@linux-foundation.org>, xfs mailing list <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Chris Mason wrote:
>> On Wed, 2009-01-14 at 22:19 +0100, wk wrote:
> ...
>>> I cannot fully understand what strace -v outputs (see attachment), but 
>>> what i see is that 'find' stops after finding a file with d_off = 4294967295
>>> 4294967295  =  0xFFFFFFFF, adding any number greater that zero will be 
>>> greater that 32bits, so this could be the reason for the message "value 
>>> too large".
>>>
>>>
>>>
>>> I also noticed that i cannot access these files through samba if i boot 
>>> from 2.6.28 - really strange.
>>> If i reboot older kernels these are visible in samba again and fully 
>>> accessible.
>>>
>>> Attached the log from stracing the command which was ivoked by the 
>>> Makefile from v4l-dvb.
>>> I guess this is all i could contribute to that problem. Thats stuff for 
>>> xfs filesystem experts now..
>> Seems suspect indeed.  Could you please attach the strace for the run
>> that works on the older kernel?
> 
> Chris got my attention on this one; you probably want this fix from hch:
> 
> http://oss.sgi.com/archives/xfs/2009-01/msg00158.html

I should have referenced the sgi git tree commit:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs.git;a=commitdiff;h=15440319767942a363f282d6585303d3d75088ba

and should have also cc'd the xfs list, doing so now.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
