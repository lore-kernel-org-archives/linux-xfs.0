Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:44189 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965001AbeFNXpH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jun 2018 19:45:07 -0400
Date: Fri, 15 Jun 2018 09:42:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] mkfs: remove notion of config "type"
Message-ID: <20180614234239.GO10363@dastard>
References: <7a30c780-d69a-71d4-d0e6-a5fcefda08e6@sandeen.net>
 <8c2a5a07-5d47-48a1-1593-e93eb0fb883a@sandeen.net>
 <20180614164121.GC6825@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180614164121.GC6825@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Jun 14, 2018 at 09:41:21AM -0700, Darrick J. Wong wrote:
> On Wed, Jun 13, 2018 at 02:37:01PM -0500, Eric Sandeen wrote:
> > @@ -3796,19 +3795,18 @@ _("respecification of configuration not allowed\n"));
> >  		ret = parse_defaults_file(fd, &dft, config_file);
> >  		if (ret) {
> >  			fprintf(stderr,
> > -_("Error parsing %s config file: %s : %s\n"),
> > -				default_type_str(dft.type),
> > +_("Error parsing config file: %s : %s\n"),
> >  				config_file, strerror(errno));
> >  			free(config_file);
> >  			close(fd);
> >  			exit(1);
> >  		}
> > +		printf(_("Configuration file used for defaults: %s\n"),
> 
> _("EXPERIMENTAL configuration file used for defaults: %s\n")

I don't see a reason for this to be experimental - we're not
screwing with on-disk formats and there's no potential for data
corruption or loss, so why do we need to mark this as "don't use
this because it might screw up your data"?  I'd much prefer we spend
the time now to get it right before before shipping it...

Which then makes me ask: why don't we have a config file version
identifier in the config file?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
