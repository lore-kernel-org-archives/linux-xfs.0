Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54884 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfECVtf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 May 2019 17:49:35 -0400
Date: Fri, 3 May 2019 14:49:13 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] mkfs: enable reflink and rmap by default
Message-ID: <20190503214913.GR5207@magnolia>
References: <20190503005717.GO5207@magnolia>
 <b406bac9-1899-1714-a14f-472fb4bbaffd@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b406bac9-1899-1714-a14f-472fb4bbaffd@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, May 03, 2019 at 10:55:05AM -0500, Eric Sandeen wrote:
> On 5/2/19 7:57 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Enable reflink and reverse mapping by default.
> 
> Soooo until now, I thought I had understood that rmap was unlikely
> to be default ever, due to performance impacts.  Is this no longer the case?

No, it's still the case.

> Of course I can't find any emails or IRC logs to indicate I didn't
> just dream this up...
> 
> Also, at this point, remind me again what uses rmap and why it should
> be enabled now?

TBH it's most useful for enhancing xfs_scrub's powers, so there's no
reason to enable it by default until at least 5.2 when we finally land
the last of the scrubbers.  Probably.  One could make a solid argument
that we ought to wait until the scrub/health code has been stable for
~6mo before even thinking about rmap by default.

Anyway I'll break this into separate pieces and resend the reflink part
for 5.1.

--D

> 
> -Eric
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  mkfs/xfs_mkfs.c |    8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 0862621a..3874f7dd 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -2021,14 +2021,14 @@ _("sparse inodes not supported without CRC support\n"));
> >  		}
> >  		cli->sb_feat.spinodes = false;
> >  
> > -		if (cli->sb_feat.rmapbt) {
> > +		if (cli->sb_feat.rmapbt && cli_opt_set(&mopts, M_RMAPBT)) {
> >  			fprintf(stderr,
> >  _("rmapbt not supported without CRC support\n"));
> >  			usage();
> >  		}
> >  		cli->sb_feat.rmapbt = false;
> >  
> > -		if (cli->sb_feat.reflink) {
> > +		if (cli->sb_feat.reflink && cli_opt_set(&mopts, M_REFLINK)) {
> >  			fprintf(stderr,
> >  _("reflink not supported without CRC support\n"));
> >  			usage();
> > @@ -3934,8 +3934,8 @@ main(
> >  			.dirftype = true,
> >  			.finobt = true,
> >  			.spinodes = true,
> > -			.rmapbt = false,
> > -			.reflink = false,
> > +			.rmapbt = true,
> > +			.reflink = true,
> >  			.parent_pointers = false,
> >  			.nodalign = false,
> >  			.nortalign = false,
> > 
