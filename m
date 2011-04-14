Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3EGBb9b004439 for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 11:11:38 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 63BAD15BF393
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 09:14:59 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id susrfFJdgeBejF3h for <xfs@oss.sgi.com>;
	Thu, 14 Apr 2011 09:14:59 -0700 (PDT)
Message-ID: <4DA71D83.5040601@sandeen.net>
Date: Thu, 14 Apr 2011 11:14:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
References: <20110414102608.GA1678@x4.trippels.de>
	<20110414120635.GB1678@x4.trippels.de>
	<20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net>
	<4DA7182B.8050409@draigBrady.com> <4DA71920.9@sandeen.net>
	<20110414160343.GA12787@x4.trippels.de>
In-Reply-To: <20110414160343.GA12787@x4.trippels.de>
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
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-ext4@vger.kernel.org, =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>, coreutils@gnu.org, xfs-oss <xfs@oss.sgi.com>

On 4/14/11 11:03 AM, Markus Trippelsdorf wrote:
> On 2011.04.14 at 10:56 -0500, Eric Sandeen wrote:

...

>> well, if I simply take the preallocation step out of the testcase, it works fine on xfs without a sync.
>>
>> So I still don't know what Markus hit...
> 
> Maybe it's delalloc:
> 
> x4 /tmp # dd count=10 if=/dev/urandom conv=notrunc iflag=fullblock of=k                                                                               
> 10+0 records in
> 10+0 records out
> 5120 bytes (5.1 kB) copied, 0.0021822 s, 2.3 MB/s
> x4 /tmp # filefrag -v k 
> Filesystem type is: 58465342
> File size of k is 5120 (2 blocks, blocksize 4096)
>  ext logical physical expected length flags
>    0       0        0              16 unknown,delalloc,eof
> k: 1 extent found
> x4 /tmp # sync
> x4 /tmp # filefrag -v k 
> Filesystem type is: 58465342
> File size of k is 5120 (2 blocks, blocksize 4096)
>  ext logical physical expected length flags
>    0       0 26960045              16 eof
> k: 1 extent found
> 

well filefrag still returns that it knows of a valid range from logical blocks 0 to 16, so cp should have something to copy...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
