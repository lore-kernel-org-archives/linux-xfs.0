Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F020C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 23:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbiKQX6L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Nov 2022 18:58:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiKQX6J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2022 18:58:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5903F07A
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 15:58:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38FB161655
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 23:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFC9C433D6;
        Thu, 17 Nov 2022 23:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668729487;
        bh=fHtTWU6mV+GLEXuc3Nmz2lq5fsA00TLO6jLn0DrGDwk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZdONuZ0FwR9Du7AtCyFShX467mS4O8++AN4FpIOaL+ANGZZnMC+IIDtXtK7/EUToG
         j8DBSwBVjNdbZbQfeUmfHo1uMZYnDOB+5mH6kONwjDcbU6AYJXt4KIlIQZjQCsua8g
         o7VwLnp5qKr/Zn7Kz7P7Dft3kH3l6Z05uPcgj/drJ95XBrlQo2UgozogIQ8ghxqaZ0
         qZGGihNT+l3Mkr7TqiPS42hOReV/c4TxIzoJgwFkrWRUBq81VBZlzaDDWOLlaI8gR0
         XcGGK5gV7C79Y6Mi67nzKv56PRc1AOUDfxhhMUmKhWtmJn7IbvHV65sEUjNsUgJ4qc
         upRNP1d2u/PYA==
Date:   Thu, 17 Nov 2022 15:58:06 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1] xfs_spaceman: add fsuuid command
Message-ID: <Y3bKjm2vOwy/jV4Z@magnolia>
References: <20221109222335.84920-1-catherine.hoang@oracle.com>
 <Y3abjYmX//CF/ey0@magnolia>
 <20221117215125.GH3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221117215125.GH3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 18, 2022 at 08:51:25AM +1100, Dave Chinner wrote:
> On Thu, Nov 17, 2022 at 12:37:33PM -0800, Darrick J. Wong wrote:
> > On Wed, Nov 09, 2022 at 02:23:35PM -0800, Catherine Hoang wrote:
> > > Add support for the fsuuid command to retrieve the UUID of a mounted
> > > filesystem.
> > > 
> > > Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> > > ---
> > >  spaceman/Makefile |  4 +--
> > >  spaceman/fsuuid.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++
> > >  spaceman/init.c   |  1 +
> > >  spaceman/space.h  |  1 +
> > >  4 files changed, 67 insertions(+), 2 deletions(-)
> > >  create mode 100644 spaceman/fsuuid.c
> > > 
> > > diff --git a/spaceman/Makefile b/spaceman/Makefile
> > > index 1f048d54..901e4e6d 100644
> > > --- a/spaceman/Makefile
> > > +++ b/spaceman/Makefile
> > > @@ -7,10 +7,10 @@ include $(TOPDIR)/include/builddefs
> > >  
> > >  LTCOMMAND = xfs_spaceman
> > >  HFILES = init.h space.h
> > > -CFILES = info.c init.c file.c health.c prealloc.c trim.c
> > > +CFILES = info.c init.c file.c health.c prealloc.c trim.c fsuuid.c
> > >  LSRCFILES = xfs_info.sh
> > >  
> > > -LLDLIBS = $(LIBXCMD) $(LIBFROG)
> > > +LLDLIBS = $(LIBXCMD) $(LIBFROG) $(LIBUUID)
> > >  LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
> > >  LLDFLAGS = -static
> > >  
> > > diff --git a/spaceman/fsuuid.c b/spaceman/fsuuid.c
> > > new file mode 100644
> > > index 00000000..be12c1ad
> > > --- /dev/null
> > > +++ b/spaceman/fsuuid.c
> > > @@ -0,0 +1,63 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * Copyright (c) 2022 Oracle.
> > > + * All Rights Reserved.
> > > + */
> > > +
> > > +#include "libxfs.h"
> > > +#include "libfrog/fsgeom.h"
> > > +#include "libfrog/paths.h"
> > > +#include "command.h"
> > > +#include "init.h"
> > > +#include "space.h"
> > > +#include <sys/ioctl.h>
> > > +
> > > +#ifndef FS_IOC_GETFSUUID
> > > +#define FS_IOC_GETFSUUID	_IOR('f', 44, struct fsuuid)
> > > +#define UUID_SIZE 16
> > > +struct fsuuid {
> > > +    __u32   fsu_len;
> > > +    __u32   fsu_flags;
> > > +    __u8    fsu_uuid[];
> > 
> > This is a flex array   ^^ which has no size.  struct fsuuid therefore
> > has a size of 8 bytes (i.e. enough to cover the two u32 fields) and no
> > more.  It's assumed that the caller will allocate the memory for
> > fsu_uuid...
> > 
> > > +};
> > > +#endif
> > > +
> > > +static cmdinfo_t fsuuid_cmd;
> > > +
> > > +static int
> > > +fsuuid_f(
> > > +	int		argc,
> > > +	char		**argv)
> > > +{
> > > +	struct fsuuid	fsuuid;
> > > +	int		error;
> > 
> > ...which makes this usage a problem, because we've not reserved any
> > space on the stack to hold the UUID.  The kernel will blindly assume
> > that there are fsuuid.fsu_len bytes after fsuuid and write to them,
> > which will clobber something on the stack.
> > 
> > If you're really unlucky, the C compiler will put the fsuuid right
> > before the call frame, which is how stack smashing attacks work.  It
> > might also lay out bp[] immediately afterwards, which will give you
> > weird results as the unparse function overwrites its source buffer.  The
> > C compiler controls the stack layout, which means this can go bad in
> > subtle ways.
> > 
> > Either way, gcc complains about this (albeit in an opaque manner)...
> > 
> > In file included from ../include/xfs.h:9,
> >                  from ../include/libxfs.h:15,
> >                  from fsuuid.c:7:
> > In function ‘platform_uuid_unparse’,
> >     inlined from ‘fsuuid_f’ at fsuuid.c:45:3:
> > ../include/xfs/linux.h:100:9: error: ‘uuid_unparse’ reading 16 bytes from a region of size 0 [-Werror=stringop-overread]
> >   100 |         uuid_unparse(*uu, buffer);
> >       |         ^~~~~~~~~~~~~~~~~~~~~~~~~
> > ../include/xfs/linux.h: In function ‘fsuuid_f’:
> > ../include/xfs/linux.h:100:9: note: referencing argument 1 of type ‘const unsigned char *’
> > In file included from ../include/xfs/linux.h:13,
> >                  from ../include/xfs.h:9,
> >                  from ../include/libxfs.h:15,
> >                  from fsuuid.c:7:
> > /usr/include/uuid/uuid.h:107:13: note: in a call to function ‘uuid_unparse’
> >   107 | extern void uuid_unparse(const uuid_t uu, char *out);
> >       |             ^~~~~~~~~~~~
> > cc1: all warnings being treated as errors
> > 
> > ...so please allocate the struct fsuuid object dynamically.
> 
> So, follow common convention and you'll get it wrong, eh? That a
> score of -4 on Rusty's API Design scale.
> 
> http://sweng.the-davies.net/Home/rustys-api-design-manifesto
> 
> Flex arrays in user APIs like this just look plain dangerous to me.
> 
> Really, this says that the FSUUID API should have a fixed length
> buffer size defined in the API and the length used can be anything
> up to the maximum.
> 
> We already have this being added for the ioctl API:
> 
> #define UUID_SIZE 16
> 
> So why isn't the API definition this:
> 
> struct fsuuid {
>     __u32   fsu_len;
>     __u32   fsu_flags;
>     __u8    fsu_uuid[UUID_SIZE];
> };
> 
> Or if we want to support larger ID structures:
> 
> #define MAX_FSUUID_SIZE 256
> 
> struct fsuuid {
>     __u32   fsu_len;
>     __u32   fsu_flags;
>     __u8    fsu_uuid[MAX_FSUUID_SIZE];
> };
> 
> Then the structure can be safely placed on the stack, which means
> "the obvious use is (probably) the correct one" (a score of 7 on
> Rusty's API Design scale). It also gives the kernel a fixed upper
> bound that it can use to validate the incoming fsu_len variable
> against...

Too late now, this already shipped in 6.0.  Changing the struct size
would change the ioctl number, which is a totally new API.  This was
already discussed back in July on fsdevel/api.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
