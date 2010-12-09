Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB9Et1RR020314 for <xfs@oss.sgi.com>; Thu, 9 Dec 2010 08:55:03 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56E221E97C4F
	for <xfs@oss.sgi.com>; Thu,  9 Dec 2010 06:56:49 -0800 (PST)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id q0SbsOPDLLkNEB4r for
	<xfs@oss.sgi.com>; Thu, 09 Dec 2010 06:56:49 -0800 (PST)
Message-ID: <4D00EE30.2000408@sandeen.net>
Date: Thu, 09 Dec 2010 08:56:48 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: kernel panic-xfs errors
References: <30397503.post@talk.nabble.com>
	<20101207222558.GC29333@dastard>	<30403823.post@talk.nabble.com>	<20101209005944.GD32766@dastard>
	<4D005E99.2030400@sandeen.net> <30416394.post@talk.nabble.com>
In-Reply-To: <30416394.post@talk.nabble.com>
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
To: blacknred <leo1783@hotmail.co.uk>
Cc: xfs@oss.sgi.com

On 12/9/10 7:17 AM, blacknred wrote:
> 
>> which is NOT a rhel 5.0 kernel, and it says x86_64.
>> But the addresses are all 32 bits?
> 
> My apologies there, somehow it all got jumbled up, pasting it again:
> 
> BUG: unable to handle kernel NULL pointer dereference at virtual address
> 00000098
>  printing eip:                                                                  
> *pde = 2c621001                                                                 
> Oops: 0000 [#1]                                                                 
> SMP                                                                             
> CPU:    2                                                                      
> EIP:    0060:[<c0619da1>]    Tainted: GF     VLI
> EFLAGS: 00010282   (2.6.18-164.11.1.el5PAE #1) 
> EIP is at do_page_fault+0x205/0x607
> eax: ec6de000   ebx: 00000000   ecx: ec6de074   edx: 0000000d
> esi: 00014005   edi: ec6de0a4   ebp: 00000014   esp: ec6de054
> ds: 007b   es: 007b   ss: 0068
> Process bm (pid: 2910, ti=ec6dd000 task=ec6e3550 task.ti=ec6dd000)
> Stack: 00000000 00000000 ec6de0a4 00000014 00000098 f7180000 00000001
> 00000000 
>        ec6de0a4 c0639439 00000000 0000000e 0000000b 00000000 00000000
> 00000000 
>        00014005 c0619b9c 00000014 c0405a89 00000000 ec6de0f8 0000000d
> 00014005 

ok, same task.ti and esp though, so same massive stack overflow.

Is this really RHEL, or CentOS?  RHEL doesn't ship xfs for i386,
and using the xfs-kmod is a very unsupported/unmaintained solution.
If it is "real RHEL" you could try requesting actual i386 support,
but these stack issues are one of the reasons it's unlikely.

CentOS would do well to ship the same xfs code as is in the x86_64
kernel and drop the kmod-xfs altogether.  Some stack issues have
been resolved since then, but probably not as much as we see here.

I also am suspicious of whatever "moddw_ioctl" is in mod_dw;
I assume that's the proprietary kernel module.  It may have a really
bad stack footprint, although the callchain below looks bad enough.

What does:

# objdump -d /path/to/mod_dw.ko | grep -A30 "<moddw_ioctl>:" | grep sub

say?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
