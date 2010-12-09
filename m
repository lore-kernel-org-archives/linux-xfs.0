Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB9DLlmc001433 for <xfs@oss.sgi.com>; Thu, 9 Dec 2010 07:21:47 -0600
Received: from kuber.nabble.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E9A791E974D8
	for <xfs@oss.sgi.com>; Thu,  9 Dec 2010 05:23:35 -0800 (PST)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158]) by
	cuda.sgi.com with ESMTP id 7CXP3s18Os9H1E4U for
	<xfs@oss.sgi.com>; Thu, 09 Dec 2010 05:23:35 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>) id 1PQgT9-0003nW-1s
	for xfs@oss.sgi.com; Thu, 09 Dec 2010 05:23:35 -0800
Message-ID: <30416451.post@talk.nabble.com>
Date: Thu, 9 Dec 2010 05:23:35 -0800 (PST)
From: blacknred <leo1783@hotmail.co.uk>
Subject: Re: kernel panic-xfs errors
In-Reply-To: <20101209005944.GD32766@dastard>
MIME-Version: 1.0
References: <30397503.post@talk.nabble.com> <20101207222558.GC29333@dastard>
	<30403823.post@talk.nabble.com> <20101209005944.GD32766@dastard>
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
To: xfs@oss.sgi.com


>Is the version 7.x firmware certified with such an old kernel?
Yes, it is...

It hung again today and dmesg said
XFS: bad magic number
XFS: SB validate failed

But when I do dd if=/dev/cciss/c0d0 bs=512 count=1 |od -c I get below which
suggests its a valid XFS superblock magic number as per your reply, correct?

I couldn't unmount the partition to do a xfs_repair -n

1+0 records in
1+0 records out
0000000    X   F   S   B  \0  \0 020  \0  \0  \0  \0  \0   + 251 262   ^
512 bytes (512 B) copied0000020   \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0 
\0  \0  \0  \0  \0
0000040  354   B  \b 277   ) 376   @ 333 267 232 304 326   *   L 344 322
0000060   \0  \0  \0  \0      \0  \0   @  \0  \0  \0  \0  \0  \0  \0 200
0000100   \0  \0  \0  \0  \0  \0  \0 201  \0  \0  \0  \0  \0  \0  \0 202
0000120   \0  \0  \0 001  \n 352   l 300  \0  \0  \0 004  \0  \0  \0  \0
, 0.000190895 seconds, 2.7 MB/s
0000140   \0  \0 200  \0 265 244 002  \0  \b  \0  \0 002  \0  \0  \0  \0
0000160   \0  \0  \0  \0  \0  \0  \0  \0  \b  \t  \v 001 034  \0  \0 005
0000200   \0  \0  \0  \0  \0  \0  \v  \0  \0  \0  \0  \0  \0  \0  \t   .
0000220   \0  \0  \0  \0 030 243 275 267  \0  \0  \0  \0  \0  \0  \0  \0
0000240   \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
0000260   \0  \0  \0  \0  \0  \0  \0 002  \0  \0  \0   @  \0  \0 001  \0
0000300   \0  \0  \0  \0  \0 004  \0  \0  \0  \0  \0  \b  \0  \0  \0  \b
0000320   \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
*
0001000


Dave Chinner wrote:
> 
> On Wed, Dec 08, 2010 at 01:39:10AM -0800, blacknred wrote:
>> 
>> 
>> >You've done a forced module load. No guarantee your kernel is in any
>> >sane shape if you've done that....
>> 
>> Agree, but I'm reasonably convinced that module isn't the issue, because
>> it
>> works fine with my other servers......
>> 
>> >Strange failure. Hmmm - i386 arch and fedora - are you running with
>> 4k stacks? If so, maybe it blew the stack...
>> 
>> i386 arch, rhel 5.0
> 
> Yup, 4k stacks. This is definitely smelling like a stack blowout.
> 
> XFS on 4k stacks is a ticking timebomb - it will explode and you've
> got no idea of when it will go boom. Recompile your kernel with 8k
> stacks or move to x86_64.
> 
>> ># dd if=<device> bs=512 count=1 | od -c
>> This is what i get now, but now server's been rebooted and running OK,
>> what
>> should i be expecting or rather what are we looking for in this output at
>> point of failure?
> 
> Well, what you see here:
> 
>> 0000000    X   F   S   B  \0  \0 020  \0  \0  \0  \0  \0 025 324 304  \0
>              ^^^^^^^^^^^^^
> Is a valid XFS superblock magic number.
> 
> If you are getting this error:
> 
>> >> XFS: bad magic number
>> >> XFS: SB validate failed 
> 
> Then I'd expect to see anything other than "XFSB" as the magic
> number. Of course, if you smashed the stack during mount, then there
> will most likely be nothing wrong with the value on disk...
> 
>> >why did I flash the controller
>> I was on 5.22 fw version which has a known 'lockup' issue which is fixed
>> in
>> 7.x ver.
>> This is a critical fix.
> 
> Is the version 7.x firmware certified with such an old kernel? It's
> not uncommon for different firmware versions to only be supported on
> specific releases/kernel versions.
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
> 

-- 
View this message in context: http://old.nabble.com/kernel-panic-xfs-errors-tp30397503p30416451.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
