Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 Feb 2007 10:28:59 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l15ISn3c029766
	for <linux-xfs@oss.sgi.com>; Mon, 5 Feb 2007 10:28:50 -0800
Message-ID: <45C7775F.9070408@sandeen.net>
Date: Mon, 05 Feb 2007 12:28:47 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS "no space left" problem
References: <20070203183723.GA1652@dunno.espix.org> <20070203233828.GD44411608@melbourne.sgi.com> <eq7r7c$b1n$1@sea.gmane.org>
In-Reply-To: <eq7r7c$b1n$1@sea.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bernd Schubert <bernd-schubert@gmx.de>
Cc: linux-xfs@oss.sgi.com

Bernd Schubert wrote:
> David Chinner wrote:
> 
>> Or get a 64bit machine and use inode64. ;)
> 
> David, can you tell more in detail what you mean with "use inode64"?
> 
> We also just migrated our server to xfs, the largest partition has a size of
> 4TB. Lets say in the future a problem occurs and we could solve this by a
> 64-bit system? Migrating to 64-bit wouldn't be difficult, since the server
> systems are already opterons. Only since we never bothered to migrate the
> installation to x86_64 its not 64-bit yet. Would we need to tell xfs
> somehow that it update its internal values to 64-bit integers or will it do
> that automatically? 

xfs is generally fully 64 bit, even on a 32 bit machine.  see more below...

> Btw, if you need 64-bit integers, why don't you use long long, or even
> better with C99 int64_t?

32-bit machines can only do 32-bit inodes (vfs limitation) (at least 
'til recently), so by default xfs doesn't let inode numbers go above 32 
bits - even though -internally- it -does-  use a 64-bit container.

The xfs inode number encodes its location on disk, so this restriction 
also restricts which blocks can be allocated as inodes.

xfs tries to reserve enough of these low blocks that you won't run out 
of potential inode blocks, but i've seen that get sideways.  The 
original poster probably ran into trouble because he started with a 100G 
filesystem & grew it 10 or so times.

if you mount with inode64 you'll allow inodes to be allocated with more 
  than 32 bits set.  But this can only work on a 64 bit machine.

and then you have to be sure your userspace can cope w/ 64 bit inode 
numbers too.

-Eric
