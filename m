Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9ED597F4E
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 18:15:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8C27B8F8033
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 16:15:56 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	K82eneURCBX1SmtF for <xfs@oss.sgi.com>;
	Fri, 07 Aug 2015 16:15:51 -0700 (PDT)
Date: Sat, 8 Aug 2015 09:15:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Cross-compiling xfsprogs 3.2.x
Message-ID: <20150807231548.GH3902@dastard>
References: <55C4A3A4.5000306@vollmann.ch>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55C4A3A4.5000306@vollmann.ch>
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
To: Detlef Vollmann <dv@vollmann.ch>
Cc: xfs@oss.sgi.com

On Fri, Aug 07, 2015 at 02:25:08PM +0200, Detlef Vollmann wrote:
> Cross-compiling xfsprogs 3.2.4 gives an error:
> ./gen_crc32table: cannot execute binary file: Exec format error
> This makes sense as a binary built for the target can't run on
> the build host.
> Working around that isn't hard, however there's no way to run
> crc32selftest sensibly and I have no idea whether tables built
> on a little-endian 64-bit host will run on a big-endian 32-bit...

At this point, we have to trust the cross compiler not to have bugs.
Unfortuantely, this is a bad deal, because we know that various
cross-compilers (e.g. gcc 4.6/4.7 on intel host to arm target)
generate broken code that results in directory corruption....

As for it failing to execute and stopping the build, that should be
fixed in 4.2.0-rc1 (current head of the git tree here:
git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git).

> Also, I get nervous if I see all the warnings like:
> readdir.c:77:2: warning: format '%lx' expects argument of type 'long
> unsigned int', but argument 2 has type '__off64_t' [-Wformat=]
>   printf(" d_off: 0x%08lx", dirent->d_off);

Which is correct on 64 bit machines as glibc defines __off64_t to a
long int on 64 bit platforms. On 32 bit platforms it is "long long
int" and that's why we have those "PRIu64" formatting strings
throughout the code base. e.g. in xfs_repair:

$ git grep PRIu64 repair |wc -l
372

there are 372 instances of PRIu64 being used to handle this sort of
problem. There are always going to be new ones pop up as 32 bit
systems are not the primary development target. I'll happily take
patches to silence these warnings on your 32 bit builds (and any
other problems you find)...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
