Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:35419 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758111AbcK3TMJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Nov 2016 14:12:09 -0500
Received: by mail-pg0-f48.google.com with SMTP id p66so85092160pga.2
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2016 11:12:09 -0800 (PST)
Date: Wed, 30 Nov 2016 11:12:05 -0800
From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] Fix building xfsprogs on 32-bit platforms
Message-ID: <20161130191205.GA14029@google.com>
References: <1480372955-41315-1-git-send-email-ebiggers@google.com>
 <20161129214456.GE31101@dastard>
 <20161129222135.GA107713@google.com>
 <20161129232548.GF31101@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161129232548.GF31101@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Hi Dave,

On Wed, Nov 30, 2016 at 10:25:49AM +1100, Dave Chinner wrote:
> 
> So, builddefs.in should really detect if autoconf set a "large file
> required" flag, and in that case add the _FILE_OFFSET_BITS value
> that autoconf has generated to the PCFLAGS variable, right? (PCFLAGS
> are "Platform CFLAGS")
> 
> Or, if we are just going to unconditionally define
> -D_FILE_OFFSET_BITS=64 in CFLAGS, then the autoconf checks are
> completely useless and should be removed?
> 

I don't believe it's possible to use the results of AC_SYS_LARGEFILE without
using a config header that is included *first* in all .c files.

So the other option is to define _FILE_OFFSET_BITS=64 ourselves in CFLAGS.  (Or
PCFLAGS for just the platforms that need it; I know it's needed on 32-bit Linux,
but I don't know about other platforms.)  And yes, in that case the autoconf
macros are useless and should be removed.

Sorry for not explaining more in the commit message --- I hadn't looked into the
details of what was going on with the autoconf macros (or that they were
recently added, for that matter) until you pointed them out.

Eric

> > The reason AC_NEED_LFS still passes is that 'configure' includes a
> > temporary header confdefs.h rather than the final generated
> > header, and the temporary header includes the _FILE_OFFSET_BITS
> > definition.
> 
> IOWs, stupid code backed by ambiguous documentation means that
> developers that try to do the right thing still end up with broken
> builds.
> 
> Eric, to speed things up a bit next time, can you try to explain how
> something is broken in the commit message, not just say "it's
> broken, fix it". This avoids the need to go back and forth multiple
> times just so we can understand what the problem is that you are
> fixing....
> 
> Cheers,
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
