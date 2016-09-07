Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41305 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752169AbcIGWkD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Sep 2016 18:40:03 -0400
Subject: Re: [BUG] xfsprogs-4.7.0: issues cross-compiling for musl
References: <1473241376-10922-1-git-send-email-ralph.sennhauser@gmail.com>
 <20160907222753.GR30056@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e9241262-fdfa-d10c-3fa2-3c4ef752a8bc@sandeen.net>
Date: Wed, 7 Sep 2016 17:40:01 -0500
MIME-Version: 1.0
In-Reply-To: <20160907222753.GR30056@dastard>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Ralph Sennhauser <ralph.sennhauser@gmail.com>
Cc: linux-xfs@vger.kernel.org



On 9/7/16 5:27 PM, Dave Chinner wrote:
> On Wed, Sep 07, 2016 at 11:42:56AM +0200, Ralph Sennhauser wrote:
>> To get xfsprogs to cross-compile for musl some hacks were needed.
>>
>> 1) d_namlen isn't available with musl
> 
> musl problem. It needs to define _DIRENT_HAVE_D_RECLEN and friends
> to tell applications what the struct dirent it defines contains.
> 
> (Haven't we been through this before?)

(yes: http://www.openwall.com/lists/musl/2016/01/15/9)

what *does* it contain?

We do already have:

 #ifdef _DIRENT_HAVE_D_RECLEN
 		*total += dirent->d_reclen;
 #else
		*total += dirent->d_namlen + sizeof(*dirent);
 #endif

but you'd like:

 #ifdef _DIRENT_HAVE_D_RECLEN
 		*total += dirent->d_reclen;
 #else
-		*total += dirent->d_namlen + sizeof(*dirent);
+		*total += strlen(dirent->d_name) + sizeof(*dirent);
 #endif

but musl *does* have d_reclen:

http://git.musl-libc.org/cgit/musl/tree/include/dirent.h

so if it simply advertised that fact we'd be good...

Whatever happened to that request from January above?

That said, I suppose strlen is fine to use here, so I guess I don't
see a strong reason to object to this change.

>> 2) crc32selftest doesn't make sense in case of cross-compilation, the
>> same can be said if building for a different host with the native
>> toolchain. So maybe an --disable-crc32selftest configure option could
>> be used here.
>>
>> 3) The CFLAGS passed to BUILD_CC weren't understood by the native
>> compiler. Set BUILD_CFLAGS to CFLAGS if not cross-compiling or let it
>> blank anyway?
> 
> Ah, yes, we've definitely been through this before. Last time I said
> "send patches" and they never appeared.
> 
> As it is, I'm really hesitant to remove the crc32c sanity check,
> mainly because we've just been through a XFS corruption drill where
> one in 10^6 crc calculations would end up wrong because of a bug in
> a compiler.
> 
> Can we "auto detect" cross compilation in the makefile and avoid the
> check only in that situation? configure options are really only a
> last resort...

That sounds like the right path to me.

Or cross-compile it but don't run it, and let package managers run
it at install time?  ;)

>> 4) sys/ustat.h is missing in musl.
> 
> Yup, been reported before. I'm about to commit a fix for that,
> mainly because certain new arches don't even implement the ustat
> system call, and glibc completely fucks up the handling of that.
> i.e. programs that call ustat don't fail at build time, the syscall
> is stubbed to print "not supported, will fail" at runtime. Hence
> nobody noticed that the xfsprogs code calling ustat was actually
> broken until a week ago...

Partly because we only checked for success, not failure, but nobody
rationally expected -ENOSYS any more than they expected the
Spanish Inquisition...

-Eric

> Cheers,
> 
> Dave.
> 
