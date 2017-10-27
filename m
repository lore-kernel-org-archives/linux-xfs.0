Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28410 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751489AbdJ0AMv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 20:12:51 -0400
Date: Thu, 26 Oct 2017 17:12:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/10] db: increase metadump's default overly long extent
 discard threshold
Message-ID: <20171027001244.GG5483@magnolia>
References: <150905608689.28563.9670731739870415773.stgit@magnolia>
 <150905609902.28563.7772086766206671184.stgit@magnolia>
 <8bee15b9-ada9-902c-e378-510f39f933e6@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bee15b9-ada9-902c-e378-510f39f933e6@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>

On Thu, Oct 26, 2017 at 07:03:15PM -0500, Eric Sandeen wrote:
> On 10/26/17 5:14 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Back in 88b8e1d6d7 ("Make xfs_metadump more robust against bad data"),
> > metadump grew the ability to ignore a directory extent if it was longer
> > than 20 blocks.  Presumably this was to protect metadump from dumping
> > absurdly long extents resulting from bmbt corruption, but it's certainly
> > possible to create a directory with an extent longer than 20 blocks.
> > Hilariously, the discards happen with no warning unless the caller
> > explicitly set -w.
> > 
> > This was raised to 1000 blocks in 7431d134fe8 ("Increase default maximum
> > extent size for xfs_metadump when copying..."), but it's still possible
> > to create a directory with an extent longer than 1000 blocks.
> > 
> > Increase the threshold to MAXEXTLEN blocks because it's totally valid
> > for the filesystem to create extents up to that length.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> Thanks, I'll pull this in.
> 
> Should we fix the noisiness so it doesn't require -w for 
> warnings as well?

Yeah.  Seeing as we can't have an extent that long anyway we could
possibly promote it to a flat out error message, at least if it's
set to 2097151.

--D

> -Eric
> 
> > ---
> >  db/metadump.c           |    2 +-
> >  man/man8/xfs_metadump.8 |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/db/metadump.c b/db/metadump.c
> > index 6dd06c3..8ffb90f 100644
> > --- a/db/metadump.c
> > +++ b/db/metadump.c
> > @@ -32,7 +32,7 @@
> >  #include "field.h"
> >  #include "dir2.h"
> >  
> > -#define DEFAULT_MAX_EXT_SIZE	1000
> > +#define DEFAULT_MAX_EXT_SIZE	MAXEXTLEN
> >  
> >  /*
> >   * It's possible that multiple files in a directory (or attributes
> > diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
> > index 3731d6a..7207c20 100644
> > --- a/man/man8/xfs_metadump.8
> > +++ b/man/man8/xfs_metadump.8
> > @@ -114,7 +114,7 @@ copied.
> >  .B \-m
> >  Set the maximum size of an allowed metadata extent.  Extremely large metadata
> >  extents are likely to be corrupt, and will be skipped if they exceed
> > -this value.  The default size is 1000 blocks.
> > +this value.  The default size is 2097151 blocks.
> >  .TP
> >  .B \-o
> >  Disables obfuscation of file names and extended attributes.
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
