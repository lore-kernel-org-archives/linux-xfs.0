Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30518 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966379AbdI0CbO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2017 22:31:14 -0400
Date: Tue, 26 Sep 2017 19:31:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] db: increase metadump's default overly long extent
 discard threshold
Message-ID: <20170927023110.GN5020@magnolia>
References: <20170927010234.GJ5020@magnolia>
 <aa933d89-e20b-f437-53ad-b17af47e3df3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa933d89-e20b-f437-53ad-b17af47e3df3@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Sep 26, 2017 at 09:21:37PM -0500, Eric Sandeen wrote:
> On 9/26/17 8:02 PM, Darrick J. Wong wrote:
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
> 
> This is documented in the manpage as being 1000, so that needs an update
> as well.  

Ok.

> And should the warning be made unconditional, if that's what burned
> you?

Nah, since most of the other warnings in metadump are about things that
look like bad metadata.

--D

> 
> -Eric
> 
> > ---
> >  db/metadump.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/db/metadump.c b/db/metadump.c
> > index c179480..c8eb8f0 100644
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
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
