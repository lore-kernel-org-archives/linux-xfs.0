Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:59262 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751543AbeERAxT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 May 2018 20:53:19 -0400
Date: Fri, 18 May 2018 10:53:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 3/5] mkfs: replace defaults source with an enum
Message-ID: <20180518005316.GH23861@dastard>
References: <20180517192700.23457-1-mcgrof@kernel.org>
 <20180517192700.23457-4-mcgrof@kernel.org>
 <20180517224849.GD23861@dastard>
 <20180517230918.GA24680@garbanzo.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180517230918.GA24680@garbanzo.do-not-panic.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Thu, May 17, 2018 at 04:09:18PM -0700, Luis R. Rodriguez wrote:
> On Fri, May 18, 2018 at 08:48:49AM +1000, Dave Chinner wrote:
> > On Thu, May 17, 2018 at 12:26:58PM -0700, Luis R. Rodriguez wrote:
> > > Using an enum will let us later just use a switch statement to print
> > > out the source, this makes sources easier to document, update and
> > > manage.
> > > 
> > > Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> > 
> > This is incomplete. :(
> 
> It builds, the comment was intentional.

That doesn't make it complete. Usually when introducing new code one
part at a time, the entire functionality of that part is separated
out so it can be reviewed whole, not split across multilple patches
and intermingled with other new functionality....

> > >  /*
> > >   * Default filesystem features and configuration values
> > >   *
> > > @@ -49,7 +60,7 @@ struct sb_feat_args {
> > >   * calculations.
> > >   */
> > >  struct mkfs_default_params {
> > > -	char	*source;	/* where the defaults came from */
> > > +	enum default_params_type type; /* where the defaults came from */
> > >  
> > >  	int	sectorsize;
> > >  	int	blocksize;
> > 
> > As it is, I don't see why this change it necessary - you can just
> > store the appropriate string (as the code currently does) into the
> > structure once the source is known. Why do we need infrastructure to
> > abstract printing a string when we set it directly, anyway?
> 
> Using an enum we get to document the different sources clearly, and we
> also get to have an enum to compare against for conditionals later,
> instead of having to strcmp().

See my comments in later patches, where I suggest all that gets
removed because i don't think it works. :P

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
