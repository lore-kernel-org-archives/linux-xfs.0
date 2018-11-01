Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51786 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728372AbeKBBf5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Nov 2018 21:35:57 -0400
Date: Thu, 1 Nov 2018 09:32:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_io: prevents the usage in FIFO files
Message-ID: <20181101163209.GQ4135@magnolia>
References: <20181016094343.21102-1-cmaiolino@redhat.com>
 <fa4344fc-31b1-8381-981c-d9c83daa981f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa4344fc-31b1-8381-981c-d9c83daa981f@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

On Thu, Nov 01, 2018 at 10:41:42AM -0500, Eric Sandeen wrote:
> On 10/16/18 4:43 AM, Carlos Maiolino wrote:
> > Recently we had a bug report of xfs_io frozen on a file, which ended up
> > being a pipe, and xfs_io was waiting for data on the other side of the
> > pipe.
> > 
> > Although xfs_io was not stuck due a bug itself, we can do better and
> > check the file type before opening the file. xfs_io has very limited
> > usage on pipes, so, just check and deny opening of FIFO files.
> 
> This seems a little too heavy-handed.  Operating on pipes is probably
> rare, but xfs_io is supposed to be a generic I/O tool.

Agreed.  Suppose I want to try reflinking a pipe in an xfstest? ;)

> Today I can do for example:
> 
> # mkfifo pipe
> 
> # xfs_io -c stat pipe
> fd.path = "pipe"
> fd.flags = non-sync,non-direct,read-write
> stat.ino = 102077957
> stat.type = fifo
> stat.size = 0
> stat.blocks = 0
> 
> What xfs_io command was stuck in particular?  These all seem to be handled uh, at least without a hang, if not correctly:
> 
> # xfs_io -c "pread 0 4096" pipe
> pread: Illegal seek
> # xfs_io -c "pwrite 0 4096" pipe
> pwrite: Illegal seek
> # xfs_io -c "bmap" pipe
> foreign file active, bmap command is for XFS filesystems only
> 
> (?!)
> 
> Oh, this one is interesting ;)
> 
> # xfs_io -c "fiemap" pipe
> pipe:
> xfs_io: ioctl(FS_IOC_FIEMAP) ["pipe"]: Structure needs cleaning
> 
> ...
> 
> [149881.306316] XFS (dm-0): Internal error xfs_bmapi_read at line 3817 of file fs/xfs/libxfs/xfs_bmap.c.  Caller xfs_file_iomap_begin+0x16c/0x9f0 [xfs]
> 
> 
> (eek?)

/me suspects we should change the vfs ioctl_fiemap() to return zero
records (or EOPNOTSUPP?) for non-file, non-dir fds...

--D

> Anyway, I wonder if we can be more targeted in denying pipes if necessary, maybe CMD_PIPE_OK or CMD_NO_PIPE if that makes sense?
> 
> -Eric
> 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> > 
> > I belive having a generic helper to check the file type may have other uses too,
> > so I opted to make it a generic helper.
> > 
> >  include/libfrog.h |  2 ++
> >  io/open.c         |  6 ++++++
> >  libfrog/util.c    | 12 ++++++++++++
> >  3 files changed, 20 insertions(+)
> > 
> > diff --git a/include/libfrog.h b/include/libfrog.h
> > index d33f0146..693d026d 100644
> > --- a/include/libfrog.h
> > +++ b/include/libfrog.h
> > @@ -5,7 +5,9 @@
> >   */
> >  #ifndef __LIBFROG_UTIL_H_
> >  #define __LIBFROG_UTIL_H_
> > +#include <sys/types.h>
> >  
> >  unsigned int	log2_roundup(unsigned int i);
> > +unsigned int	check_file_type(char *name, mode_t mode);
> >  
> >  #endif /* __LIBFROG_UTIL_H_ */
> > diff --git a/io/open.c b/io/open.c
> > index 6ea3e9a2..25f44b64 100644
> > --- a/io/open.c
> > +++ b/io/open.c
> > @@ -9,6 +9,7 @@
> >  #include "init.h"
> >  #include "io.h"
> >  #include "libxfs.h"
> > +#include "libfrog.h"
> >  
> >  #ifndef __O_TMPFILE
> >  #if defined __alpha__
> > @@ -59,6 +60,11 @@ openfile(
> >  	int		fd;
> >  	int		oflags;
> >  
> > +	if (check_file_type(path, S_IFIFO)) {
> > +		fprintf(stderr, _("xfs_io does not work on FIFO files\n"));
> > +		return -1;
> > +	}
> > +
> >  	oflags = flags & IO_READONLY ? O_RDONLY : O_RDWR;
> >  	if (flags & IO_APPEND)
> >  		oflags |= O_APPEND;
> > diff --git a/libfrog/util.c b/libfrog/util.c
> > index ff935184..de0b8542 100644
> > --- a/libfrog/util.c
> > +++ b/libfrog/util.c
> > @@ -5,6 +5,9 @@
> >   */
> >  #include "platform_defs.h"
> >  #include "libfrog.h"
> > +#include <sys/types.h>
> > +#include <sys/stat.h>
> > +#include <unistd.h>
> >  
> >  /*
> >   * libfrog is a collection of miscellaneous userspace utilities.
> > @@ -22,3 +25,12 @@ log2_roundup(unsigned int i)
> >  	}
> >  	return rval;
> >  }
> > +
> > +unsigned int
> > +check_file_type(char *name, mode_t mode)
> > +{
> > +	struct stat sb;
> > +
> > +	lstat(name, &sb);
> > +	return (sb.st_mode & mode);
> > +}
> > 
