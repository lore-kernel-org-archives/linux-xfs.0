Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 Feb 2007 14:26:37 -0800 (PST)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l15MQV3c012456
	for <linux-xfs@oss.sgi.com>; Mon, 5 Feb 2007 14:26:33 -0800
From: Bernd Schubert <bernd-schubert@gmx.de>
Subject: Re: XFS "no space left" problem
Date: Mon, 5 Feb 2007 22:59:47 +0100
References: <20070203183723.GA1652@dunno.espix.org> <eq7r7c$b1n$1@sea.gmane.org> <45C7775F.9070408@sandeen.net>
In-Reply-To: <45C7775F.9070408@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200702052259.48018.bernd-schubert@gmx.de>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@oss.sgi.com

On Monday 05 February 2007 19:28, you wrote:
> Bernd Schubert wrote:
> > David Chinner wrote:
> xfs is generally fully 64 bit, even on a 32 bit machine.  see more below...
>
> > Btw, if you need 64-bit integers, why don't you use long long, or even
> > better with C99 int64_t?
>
> 32-bit machines can only do 32-bit inodes (vfs limitation) (at least
> 'til recently), so by default xfs doesn't let inode numbers go above 32
> bits - even though -internally- it -does-  use a 64-bit container.

Ah, I see, linux vfs limitation.

>
> The xfs inode number encodes its location on disk, so this restriction
> also restricts which blocks can be allocated as inodes.
>
> xfs tries to reserve enough of these low blocks that you won't run out
> of potential inode blocks, but i've seen that get sideways.  The
> original poster probably ran into trouble because he started with a 100G
> filesystem & grew it 10 or so times.

Well, we just also switched to a new raid device and before we bought it, we 
also made sure its possible to do an online expansion. So a migration from 6 
TB to 12 TB will come... I guess in two or three years. 
 
>
> if you mount with inode64 you'll allow inodes to be allocated with more
>   than 32 bits set.  But this can only work on a 64 bit machine.

Ah, its a mount option! And even undocumented in "man 8 mount". Thanks will 
add this to our wiki and write a debian bugreport.

>
> and then you have to be sure your userspace can cope w/ 64 bit inode
> numbers too.

Hmm, sizeof(ino_t) is 4 on x86_32, that will be a problem. We do have quite a 
lot of programs, not written very well and not compilable with recent 
compilers. On the other side, the linux nfs client converts inode numbers to 
32 bit, if it would cause an overflow. However, it doesn't do that on x86_64 
for 32bit programs. I know that quite well, due to another problem.


Thanks a lot for your insights,
Bernd


-- 
Bernd Schubert
PCI / Theoretische Chemie
Universität Heidelberg
INF 229
69120 Heidelberg
