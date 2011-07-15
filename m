Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6FKwh9P219683 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 15:58:44 -0500
Subject: Re: [PATCH] xfs_repair: add printf format checking and fix the fallout
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110630201628.GA20239@infradead.org>
References: <20110630201628.GA20239@infradead.org>
Date: Fri, 15 Jul 2011 15:50:33 -0500
Message-ID: <1310763033.2921.94.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, 2011-06-30 at 16:16 -0400, Christoph Hellwig wrote:
> Add the gcc printf like attribute to the xfs_repair-internal logging helpers,
> and fix the massive fallout.  A large part of it is dealing with the correct
> format for fixed size 64-bit types, but there were a lot of real bug in there,
> including some that lead to crashed when repairing certain corrupted
> filesystems on ARM based systems.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Anisse Astier <anisse@astier.eu>

Eric did the first hunk of this patch in March of 2010,
although he also added __attribute__((noreturn)) to
the abort and error functions.  Thank you for completing
the rest of it...

In any case, I have built xfsprogs using this in
x86_64 and i386 environments and don't get warnings
due to printf compatibility issues.  So because
of that I'm fine with your patch.

However when I build on ia64 I still get a bunch of
warnings.  Some of them are just additional fallout
from adding the printf attribute.  Others are similar
problems found in actual printf() calls.

I will create a patch on top of yours and will
send it to you.  It think it will be best to
just merge the two together; but I'll leave it
up to you to do as you see fit.


Below I describe why we get some of these warnings,
and how using the PRI* format specifiers isn't
always the right fix.

This whole thing is complicated by inconsistent use
of types for defining 64-bit values--or really, by
the way the Linux kernel is inconsistent.


In xfsprogs, an xfs_ino_t is __uint64_t, which is
u_int64_t, which is defined via <sys/types.h> as:
    i386:	typedef unsigned long long int u_int64_t;
    x86_64:	typedef unsigned long int u_int64_t;
    ia64:	typedef unsigned long int u_int64_t;

The various format specifier macros are defined in
in <inttypes.h> based on __PRI64_PREFIX, which is:
    i386:	"ll"
    x86_64:	"l"
    ia64:	"l"

So in user space, any inode number defined using
xfs_ino_t (and more generally, anything defined
using u_int64_t) can be formatted using (for
example) PRIu64 and it comes out fine.


In the Linux kernel xfs has xfs_ino_t defined as
__u64, which is defined via <linux/types.h> as:
    typedef         __u64           u_int64_t;
and __u64 is then defined via inclusion of
<asm/types.h>.  For ia64, <asm/types.h> includes
<asm-generic/int-l64.h>, which defines __u64 this
way:
    typedef unsigned long __u64;

But for x86_64, <asm_types.h> includes
<asm-generic/int-ll64.h>, meaning __u64 is:
    typedef unsigned long long __u64;

(My i386 ends up with the same definition as
x86_64, but through a slightly different route.)


Anyway, in the kernel, the specific type defined
for an xfs_ino_t (because it's based on __u64)
is either unsigned long or unsigned long long.
Which one you get depends on the architecture.

On native 64-bit systems both are likely to be
the same size, but whether long or long long is
used is still architecture dependent.

Also note that all the byte swap macros (like
be64_to_cpu()) are defined using __u64 the type.


Now __u64 is also a type visible in user
space, and it's one we make use of.  But
because of the inconsistency described above,
if you use __u64 to define a 64-bit type,
you can't use things like PRIu64 to determine
the right format specifier to use, because
it's not predictable whether it will match
the underlying type.  (On ia64 it works, but
on x86_64 it will not.)  And of course you
can't just use %llu either.


So whenever you want to format something
defined as __u64 (or, which is the result
of a byte swap macro), the best you can do
is use %llu in the format string, then cast
the value being printed to (unsigned long long).

Kind of a mess.

					-Alex

>  			mp->m_sb.sb_rootino,
>  			(mp->m_sb.sb_rootino == NULLFSINO ? "(NULLFSINO) ":""),
>  			first_prealloc_ino);
>  
>  		if (!no_modify)
>  			do_warn(
> -		_("resetting superblock root inode pointer to %lu\n"),
> +		_("resetting superblock root inode pointer to %u\n"),
>  				first_prealloc_ino);

. . .


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
