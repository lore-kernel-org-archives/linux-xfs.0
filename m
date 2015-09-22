Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 663F47F50
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 02:54:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 275EC8F8035
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 00:54:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1oHzKCQBpSSwkSa9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Sep 2015 00:54:36 -0700 (PDT)
Date: Tue, 22 Sep 2015 09:54:32 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs_io: Implement inodes64 command
Message-ID: <20150922075432.GC26699@redhat.com>
References: <1442825768-5793-1-git-send-email-cmaiolino@redhat.com>
	<20150921220832.GB19114@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150921220832.GB19114@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 22, 2015 at 08:08:32AM +1000, Dave Chinner wrote:
> On Mon, Sep 21, 2015 at 10:56:08AM +0200, Carlos Maiolino wrote:
> > Implement an easy way to check a filesystem for the existence of 64bit inodes.
> > 
> > Based on XFS_IOC_FSINUMBERS, and starting with a lastip of XFS_MAXINUMBER_32, it
> > returns a string saying if there is or there isn't 64bit inodes in the
> > filesystem.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  io/open.c | 39 +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 39 insertions(+)
> > 
> > diff --git a/io/open.c b/io/open.c
> > index ac5a5e0..b25b09d 100644
> > --- a/io/open.c
> > +++ b/io/open.c
> > @@ -20,6 +20,7 @@
> >  #include "input.h"
> >  #include "init.h"
> >  #include "io.h"
> > +#include "libxfs.h"
> >  
> >  #ifndef __O_TMPFILE
> >  #if defined __alpha__
> > @@ -44,6 +45,7 @@ static cmdinfo_t statfs_cmd;
> >  static cmdinfo_t chproj_cmd;
> >  static cmdinfo_t lsproj_cmd;
> >  static cmdinfo_t extsize_cmd;
> > +static cmdinfo_t inodes64_cmd;
> >  static prid_t prid;
> >  static long extsize;
> >  
> > @@ -750,6 +752,36 @@ statfs_f(
> >  	return 0;
> >  }
> >  
> > +static int
> > +inodes64_f(
> > +	  int			argc,
> > +	  char			**argv)
> > +{
> > +	int			i;
> > +	__s32			count;
> > +	__u64			last = XFS_MAXINUMBER_32;
> > +	xfs_inogrp_t		igroup;
> > +	xfs_fsop_bulkreq_t	bulkreq;
> 
> Please don't use typedefs.
> 
Ok.

> > +
> > +	bulkreq.lastip = &last;
> > +	bulkreq.icount = 1;
> > +	bulkreq.ubuffer = &igroup;
> > +	bulkreq.ocount = &count;
> > +
> > +	if (!xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS, &bulkreq)) {
> > +		if (count > 0) {
> > +			printf("Filesystem does have 64bit inodes\n");
> > +			return 0;
> > +		} else {
> > +			printf("Filesystem does not have 64bit inodes\n");
> > +			return 0;
> > +		}
> > +	}
> > +	perror("xfsctl(XFS_IOC_FSINUMBERS)");
> 
> I'd do this the other way around:
> 
> 	if (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS, &bulkreq)) {
> 		perror("XFS_IOC_FSINUMBERS");
> 		exitcode = 1;
> 		return 0;
> 	}
> 
> 	if (count > 0)
> 		printf("Filesystem does have 64bit inodes\n");
> 	else
> 		printf("Filesystem does not have 64bit inodes\n");
> 	return 0;
> 
> is sufficient, xfsctl is a one line wrapper around ioctl().
>

Ok, I'll change this, but, just a matter of curiosity, what are the technical
reasons to write the conditional this way, instead of the way I wrote first?
Just to avoid entering the conditional?

 
> > @@ -815,6 +847,12 @@ open_init(void)
> >  		_("get/set preferred extent size (in bytes) for the open file");
> >  	extsize_cmd.help = extsize_help;
> >  
> > +	inodes64_cmd.name = "inodes64";
> > +	inodes64_cmd.cfunc = inodes64_f;
> > +	inodes64_cmd.flags = CMD_NOMAP_OK;
> > +	inodes64_cmd.oneline =
> > +		_("Checks if filesyste contais 64bit inodes");
>                                     ^^^     ^^ 64 bit
> 
> "inodes64" could be improved as a command name. e.g:
> 
> oneline = _("Query inode number usage in the filesystem")
> 
> And could do a little more to help users work out what the
> problematic inode is. e.g:
> 
> Long help:
> 
> Inode_numbers [-s|-l] [num]
> 
> 	[-s]	returns the physical size of the largest inode
> 		number in the filesystem (32 bit of 64 bit)
> 	[-l]	returns the largest inode number in the filesystem
> 	[-n]	returns the next inode number after [num]
> 	[num]	returns whether the inode number exists
> 
> i.e. if you want 32 bit inodes in the fs, you can use [-n num] to
> iterate all the inode numbers above 32 bits in size...
> 

Ok, np

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
