Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35103 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750953AbcIIRHz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Sep 2016 13:07:55 -0400
Received: by mail-wm0-f68.google.com with SMTP id a6so3597296wmc.2
        for <linux-xfs@vger.kernel.org>; Fri, 09 Sep 2016 10:07:54 -0700 (PDT)
Date: Fri, 9 Sep 2016 19:07:51 +0200
From: Ralph Sennhauser <ralph.sennhauser@gmail.com>
Subject: Re: [PATCH] xfs_io: fix building with musl
Message-ID: <20160909190751.40fb7e75@gmail.com>
In-Reply-To: <106faf8f-3b68-56b9-6188-af01601cc870@sandeen.net>
References: <1473241376-10922-1-git-send-email-ralph.sennhauser@gmail.com>
        <1473427942-10726-1-git-send-email-ralph.sennhauser@gmail.com>
        <106faf8f-3b68-56b9-6188-af01601cc870@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Fri, 9 Sep 2016 08:59:16 -0500
Eric Sandeen <sandeen@sandeen.net> wrote:

> On 9/9/16 8:32 AM, Ralph Sennhauser wrote:
> > The fallback in case the libc doesn't have or doesn't advertise the
> > existence of d_reclen in struct dirent uses d_namlen. Musl neither
> > advertises d_reclen nor does it have a d_namlen member.
> > 
> > Calculate the value for d_namlen from d_name in the fallback path.
> > 
> > Signed-off-by: Ralph Sennhauser <ralph.sennhauser@gmail.com>
> > ---
> > 
> > With ustat.h issue resolved in 4.8.0-rc1 this is the only musl
> > related one left.
> > 
> > An alternative could be some autoconf magic [1] or waiting for a
> > long time for musl to add _DIRENT_HAVE_D_RECLEN [2] and for it to
> > propagate to distributions.
> > 
> > [1] http://oss.sgi.com/archives/xfs/2016-01/msg00388.html
> > [2] http://www.openwall.com/lists/musl/2016/01/15/9  
> 
> eh, this is fine by me.  Even Linus has hated d_namlen for over
> a decade ;)  http://lkml.iu.edu/hypermail/linux/kernel/9506/0033.html
> 
> Last question, have you tested it beyond the build, i.e.
> with xfs_io -c "readdir -v" /some/dir ?  Works here but it'd be nice
> to know that it's working properly on musl as well.
> 

Kernel is 4.8-rc5, xfsprogs 4-8.0-rc1 plus fixups mentioned. An xfs
filesystem is mounted at /mnt/xfs.

# xfs_io -c "readdir -v" /mnt/xfs/test/
00000000: d_ino: 0x00000063 d_name: .
00000000: d_ino: 0x00000060 d_name: ..
00000000: d_ino: 0x00000064 d_name: file
read 847 bytes from offset 0
847.000000 bytes, 3 ops, 0.0000 sec (20 MiB/sec and 75000.0000 ops/sec)

> the d_reclen field doesn't exist in any xfstests output, so looks
> like its loss on some platforms won't affect any existing tests.
> 
> If you can verify that you did a runtime test as well, that'd
> be great, but in any case:
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 

Thanks for the review
Ralph

> Thanks,
> -Eric
> 
> > ---
> >  io/readdir.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/io/readdir.c b/io/readdir.c
> > index 151b72e..2b56dc8 100644
> > --- a/io/readdir.c
> > +++ b/io/readdir.c
> > @@ -24,6 +24,10 @@
> >  #include <sys/types.h>
> >  #include <dirent.h>
> >  
> > +#ifndef _DIRENT_HAVE_D_RECLEN
> > +#include <string.h>
> > +#endif
> > +
> >  static struct cmdinfo readdir_cmd;
> >  
> >  const char *d_type_str(unsigned int type)
> > @@ -106,7 +110,7 @@ read_directory(
> >  #ifdef _DIRENT_HAVE_D_RECLEN
> >  		*total += dirent->d_reclen;
> >  #else
> > -		*total += dirent->d_namlen + sizeof(*dirent);
> > +		*total += strlen(dirent->d_name) + sizeof(*dirent);
> >  #endif
> >  		count++;
> >  
> >   

