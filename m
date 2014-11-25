Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3A4DA7F3F
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 09:55:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F08B28F8066
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 07:55:26 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id vFSUCA1dvSXPaF6D (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2014 07:55:24 -0800 (PST)
Date: Tue, 25 Nov 2014 10:55:22 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH-v3 3/6] vfs: don't let the dirty time inodes get more
	than a day stale
Message-ID: <20141125155522.GH31339@thunk.org>
References: <1416893674-419-1-git-send-email-tytso@mit.edu>
	<1416893674-419-4-git-send-email-tytso@mit.edu>
	<87ioi3iayu.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87ioi3iayu.fsf@rasmusvillemoes.dk>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>

On Tue, Nov 25, 2014 at 03:58:01PM +0100, Rasmus Villemoes wrote:
> 
> I think days_since_boot was a lot clearer than daycode. In any case,
> please make the comment and the code consistent.

Yeah, I was going back and forth between days since the epoch and days
since boot, but found it was more efficient to calculate the days
since boot.  Sure, I'll go back to days_since_boot.

> You should probably divide by the number of seconds in a day, not the
> number of jiffies in a day.

Right, brain hiccup on my part, will fix.

> Isn't div_u64 mostly for when the divisor is not known at compile time?
> Technically, "(u64)uptime.tv_sec / 86400" is of course a u64/u64 division,
> but the compiler should see that the divisor is only 32 bits and hence
> should be able to generate code which is at least as efficient as
> whatever inline asm the arch provides for u64/u32 divisions.

The problem with doing u64/u64 divisions is that the compiler will
call out to a (non-existent) library function on some architectures.
For example, try compiling the following using: with "gcc -S -m32
foo.c"

int main(int argc, char **argv)
{
	unsigned long long t = time(0);

	printf("%llu\n", t / 86400);
}

You will find in the .S file the following:

	...
	pushl	$0
	pushl	$86400
	pushl	%edx
	pushl	%eax
	call	__udivdi3
	...

It will work finn compiling for x86_64, but if you do this and push
out a git branch, you will soon get a very nice e-mail from the ktest
bot explaining how you've broken the build on the i386 architecture
since the kernel doesn't provide __udivdi3.
	
Hence if you are doing any kind of divisions involving u64, you have
to use the functions in include/linux/math64.h, and div_u64 is, per
math64.h:

/**
 * div_u64 - unsigned 64bit divide with 32bit divisor
 *
 * This is the most common 64bit divide and should be used if possible,
 * as many 32bit archs can optimize this variant better than a full 64bit
 * divide.
 */

Cheers,

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
