Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:41187 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750859AbcIGW15 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Sep 2016 18:27:57 -0400
Date: Thu, 8 Sep 2016 08:27:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [BUG] xfsprogs-4.7.0: issues cross-compiling for musl
Message-ID: <20160907222753.GR30056@dastard>
References: <1473241376-10922-1-git-send-email-ralph.sennhauser@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1473241376-10922-1-git-send-email-ralph.sennhauser@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ralph Sennhauser <ralph.sennhauser@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Sep 07, 2016 at 11:42:56AM +0200, Ralph Sennhauser wrote:
> To get xfsprogs to cross-compile for musl some hacks were needed.
> 
> 1) d_namlen isn't available with musl

musl problem. It needs to define _DIRENT_HAVE_D_RECLEN and friends
to tell applications what the struct dirent it defines contains.

(Haven't we been through this before?)

> 2) crc32selftest doesn't make sense in case of cross-compilation, the
> same can be said if building for a different host with the native
> toolchain. So maybe an --disable-crc32selftest configure option could
> be used here.
> 
> 3) The CFLAGS passed to BUILD_CC weren't understood by the native
> compiler. Set BUILD_CFLAGS to CFLAGS if not cross-compiling or let it
> blank anyway?

Ah, yes, we've definitely been through this before. Last time I said
"send patches" and they never appeared.

As it is, I'm really hesitant to remove the crc32c sanity check,
mainly because we've just been through a XFS corruption drill where
one in 10^6 crc calculations would end up wrong because of a bug in
a compiler.

Can we "auto detect" cross compilation in the makefile and avoid the
check only in that situation? configure options are really only a
last resort...

> 4) sys/ustat.h is missing in musl.

Yup, been reported before. I'm about to commit a fix for that,
mainly because certain new arches don't even implement the ustat
system call, and glibc completely fucks up the handling of that.
i.e. programs that call ustat don't fail at build time, the syscall
is stubbed to print "not supported, will fail" at runtime. Hence
nobody noticed that the xfsprogs code calling ustat was actually
broken until a week ago...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
