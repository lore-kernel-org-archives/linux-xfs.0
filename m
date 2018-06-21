Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52012 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932940AbeFUUXr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jun 2018 16:23:47 -0400
Date: Thu, 21 Jun 2018 13:23:31 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_io: clarify -c from documentation
Message-ID: <20180621202331.GJ4838@magnolia>
References: <20180621201404.GI4838@magnolia>
 <44478702-cca5-2356-ab4c-3bfa1e70103e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44478702-cca5-2356-ab4c-3bfa1e70103e@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Thu, Jun 21, 2018 at 03:21:51PM -0500, Eric Sandeen wrote:
> On 6/21/18 3:14 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The -c parameter displays the cow fork information for a file if the
> > kernel was built with CONFIG_XFS_DEBUG=y.  Since xfs_bmap doesn't
> > support it and it doesn't work generally, remove it from the manpages.
> > However, xfstests relies on the -c command to be documented in the help
> > screen so leave it there with a warning about its use.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> I'm not sure xfstests actually cares (xfs/293?) but anyway, this
> works for me, thanks.

xfs/243 does:
_require_xfs_io_command "bmap" "-c"

which in turn greps the xfs_io -c 'help bmap' output for:

/^ -c --/

--D

> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> > ---
> >  io/bmap.c         |    1 +
> >  man/man8/xfs_io.8 |    2 +-
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/io/bmap.c b/io/bmap.c
> > index 2e4ff7b2..345f276e 100644
> > --- a/io/bmap.c
> > +++ b/io/bmap.c
> > @@ -43,6 +43,7 @@ bmap_help(void)
> >  " All the file offsets and disk blocks are in units of 512-byte blocks.\n"
> >  " -a -- prints the attribute fork map instead of the data fork.\n"
> >  " -c -- prints the copy-on-write fork map instead of the data fork.\n"
> > +"       This works only if the kernel was compiled in debug mode.\n"
> >  " -d -- suppresses a DMAPI read event, offline portions shown as holes.\n"
> >  " -e -- print delayed allocation extents.\n"
> >  " -l -- also displays the length of each extent in 512-byte blocks.\n"
> > diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> > index 2bd77ee8..eb2b862e 100644
> > --- a/man/man8/xfs_io.8
> > +++ b/man/man8/xfs_io.8
> > @@ -315,7 +315,7 @@ See the
> >  .B pwrite
> >  command.
> >  .TP
> > -.BI "bmap [ \-acdelpv ] [ \-n " nx " ]"
> > +.BI "bmap [ \-adelpv ] [ \-n " nx " ]"
> >  Prints the block mapping for the current open file. Refer to the
> >  .BR xfs_bmap (8)
> >  manual page for complete documentation.
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
