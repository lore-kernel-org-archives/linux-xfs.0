Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB94gMZG178743 for <xfs@oss.sgi.com>; Wed, 8 Dec 2010 22:42:22 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D21B11CA8E2C
	for <xfs@oss.sgi.com>; Wed,  8 Dec 2010 20:44:10 -0800 (PST)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id sh9Gy0OVcseLZGzC for
	<xfs@oss.sgi.com>; Wed, 08 Dec 2010 20:44:10 -0800 (PST)
Message-ID: <4D005E99.2030400@sandeen.net>
Date: Wed, 08 Dec 2010 22:44:09 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: kernel panic-xfs errors
References: <30397503.post@talk.nabble.com>
	<20101207222558.GC29333@dastard>	<30403823.post@talk.nabble.com>
	<20101209005944.GD32766@dastard>
In-Reply-To: <20101209005944.GD32766@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: blacknred <leo1783@hotmail.co.uk>, xfs@oss.sgi.com

On 12/8/10 6:59 PM, Dave Chinner wrote:
> On Wed, Dec 08, 2010 at 01:39:10AM -0800, blacknred wrote:
>>
>>
>>> You've done a forced module load. No guarantee your kernel is in any
>>> sane shape if you've done that....
>>
>> Agree, but I'm reasonably convinced that module isn't the issue, because it
>> works fine with my other servers......
>>
>>> Strange failure. Hmmm - i386 arch and fedora - are you running with
>> 4k stacks? If so, maybe it blew the stack...
>>
>> i386 arch, rhel 5.0
> 
> Yup, 4k stacks. This is definitely smelling like a stack blowout.

well, hang on.  The oops said:

EIP:    0060:[<c0529da1>]    Tainted: GF     VLI
EFLAGS: 00010272   (2.6.33.3-85.fc13.x86_64 #1) 
EIP is at do_page_fault+0x245/0x617
eax: ec5ee000   ebx: 00000000   ecx: eb5de084   edx: 0000000e
esi: 00013103   edi: ec5de0b3   ebp: 00000023   esp: ec5de024
ds: 008b   es: 008b   ss: 0078

which is NOT a rhel 5.0 kernel, and it says x86_64.

But the addresses are all 32 bits?

So what's going on here?

> esi: 00013103   edi: ec5de0b3   ebp: 00000023   esp: ec5de024
> ds: 008b   es: 008b   ss: 0078
> Process bm (pid: 3210, ti=ec622000 task=ec5e3450 task.ti=ec6ee000)

end of the stack is ec6ee000, stack grows up, esp is at ec5de024,
well past it (i.e. yes, overrun) if I remember my stack math
right... but that's a pretty huge difference so either I have it
wrong, or things are really a huge mess here.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
