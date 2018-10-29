Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41610 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729546AbeJ3D7k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Oct 2018 23:59:40 -0400
Date: Mon, 29 Oct 2018 12:09:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_io: add crc32 self test
Message-ID: <20181029190928.GD4135@magnolia>
References: <20181029181107.GC4135@magnolia>
 <a9f99690-418e-9fcd-ecd0-bbed071b0a6f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9f99690-418e-9fcd-ecd0-bbed071b0a6f@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Mon, Oct 29, 2018 at 01:30:32PM -0500, Eric Sandeen wrote:
> On 10/29/18 1:11 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a self test for crc32 into xfs_io so that xfstests can check the
> > operation of the (potentially cross-compiled) package binaries by
> > isolating the self test code to a header file that can be included by
> > the build system self test and xfs_io.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  include/crc32selftest.h |  706 +++++++++++++++++++++++++++++++++++++++++++++++
> >  io/Makefile             |    8 -
> >  io/crc32selftest.c      |   51 +++
> >  io/init.c               |    1 
> >  io/io.h                 |    1 
> >  libfrog/crc32.c         |  669 ---------------------------------------------
> 
> needs a manpage change as well I think.

Dangit, I forgot to port that over when I moved the command.

> >  6 files changed, 764 insertions(+), 672 deletions(-)
> >  create mode 100644 include/crc32selftest.h
> >  create mode 100644 io/crc32selftest.c
> > 
> 
> ...
> 
> > diff --git a/io/crc32selftest.c b/io/crc32selftest.c
> > new file mode 100644
> > index 00000000..c0b4b2f4
> > --- /dev/null
> > +++ b/io/crc32selftest.c
> > @@ -0,0 +1,51 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2018 Oracle, Inc.
> > + * All Rights Reserved.
> > + */
> > +
> > +#include "platform_defs.h"
> > +#include "command.h"
> > +#include "init.h"
> > +#include "io.h"
> > +#include "crc32c.h"
> > +#include "crc32selftest.h"
> > +
> > +static int
> > +crc32selftest_f(
> > +	int		argc,
> > +	char		**argv)
> > +{
> > +	int		c;
> > +	int		errors;
> > +
> > +	while ((c = getopt(argc, argv, "")) != EOF) {
> > +		switch (c) {
> > +		default:
> > +			fprintf(stderr,
> > +_("Bad option for crc32selftest command.\n"));
> > +			return 0;
> > +		}
> > +	}
> 
> I think we can drop the getopt bits altogether because:
> 
> > +	errors = crc32c_test();
> > +	return errors == 0 ? 0 : 1;
> > +}
> > +
> > +static const cmdinfo_t	crc32selftest_cmd = {
> > +	.name		= "crc32selftest",
> > +	.cfunc		= crc32selftest_f,
> > +	.argmin		= 0,
> > +	.argmax		= 0,
> 
> This command structure doesn't even let us get there:
> 
> # io/xfs_io -c "crc32selftest foo"
> bad argument count 1 to crc32selftest, expected 0 arguments
> # io/xfs_io -c "crc32selftest -f"
> bad argument count 1 to crc32selftest, expected 0 arguments
> 
> and other "argmax" functions (freeze, thaw, close, munmap...) don't bother
> with getopt at all.

ok.

> > +	.canpush	= 0,
> > +	.args		= "",
> 
> drop this I think, otherwise we get a weird space in usage:
> 
> crc32selftest  -- crc32c self test
> 
> vs
> 
> crc32selftest -- crc32c self test
> 
> because
> 
>         if (ct->args)
>                 printf("%s ", ct->args);
>         printf("-- %s\n", ct->oneline);
> 

Aha, that's why it does that...

> > +	.flags		= CMD_FLAG_ONESHOT | CMD_FLAG_FOREIGN_OK |
> > +			  CMD_NOFILE_OK | CMD_NOMAP_OK,
> > +	.oneline	= N_("crc32c self test"),
> 
> > +};
> > +
> > +void
> > +crc32selftest_init(void)
> > +{
> > +	add_command(&crc32selftest_cmd);
> > +}
> 
> ok is it better to call this crc32c selftest or crc32 selftest?  Seems a little inconsistent in the naming.

crc32cselftest it is then.

--D

> > diff --git a/io/init.c b/io/init.c
> > index b5eade39..53b754e4 100644
> > --- a/io/init.c
> > +++ b/io/init.c
> > @@ -85,6 +85,7 @@ init_commands(void)
> >  	sync_range_init();
> >  	truncate_init();
> >  	utimes_init();
> > +	crc32selftest_init();
> >  }
> >  
> >  /*
> > diff --git a/io/io.h b/io/io.h
> > index 9278ad00..847b4759 100644
> > --- a/io/io.h
> > +++ b/io/io.h
> > @@ -182,3 +182,4 @@ extern void		log_writes_init(void);
> >  
> >  extern void		scrub_init(void);
> >  extern void		repair_init(void);
> > +extern void		crc32selftest_init(void);
> 
> 
