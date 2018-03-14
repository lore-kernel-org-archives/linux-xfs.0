Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:53206 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750852AbeCNEMw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Mar 2018 00:12:52 -0400
Date: Wed, 14 Mar 2018 14:55:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs.xfs: add configuration file parsing support using
 our own parser
Message-ID: <20180314035531.GF18129@dastard>
References: <20180313205911.26082-1-mcgrof@kernel.org>
 <20180313213916.GD18129@dastard>
 <20180313235227.GH4449@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313235227.GH4449@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: sandeen@sandeen.net, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com, tytso@mit.edu

On Tue, Mar 13, 2018 at 11:52:27PM +0000, Luis R. Rodriguez wrote:
> On Wed, Mar 14, 2018 at 08:39:16AM +1100, Dave Chinner wrote:
> > Just one obvious comment from a brief glance - you changed this from
> > "-t" to "-T", but ....
> > > +directory by using the -t parameter and secifying the type. Alternatively
> > 
> > Not here, or ....
> >
> > > +If you use -t the type configuration file must be present under
> > 
> > here, or ....
> > 
> > > +#define MKFS_XFS_CONF_DIR	ROOT_SYSCONFDIR "/mkfs.xfs.d/"
> > > +#define CONFIG_MAX_KEY		1024
> > > +#define CONFIG_MAX_VALUE	PATH_MAX
> > > +#define CONFIG_MAX_BUFFER	CONFIG_MAX_KEY + CONFIG_MAX_VALUE + 3
> > > +#define PARAM_OPTS		"T:b:d:i:l:L:m:n:KNp:qr:s:CfV"
> > 
> > [ Please don't obfuscate parsing options like this ]
> 
> The reason was we use them twice.

Which is not necessary. You don't need to change the option parsing
loop at all - the default config file can be parsed at any time as
a normal option. The default structure is not used for calculations
until after all the CLI options are parsed, so it can just be
treated as another CLI option in any location on the CLI.

> > I'll spend some more time looking at it, but my initial impression
> > is that there's a bit of work to be done yet...
> 
> You're right, we should decide if we want to allow for -T to be used
> only in the beginning or if we want to allow for it anywhere on the
> command line.

That's not what I meant. I meant the code needs a lot of work, not
that we needed to decide where on the CLI the config file option
should be placed.

Basically:

1. the default file parsing code needs to go into it's own file.
xfs_mkfs.c is too large and needs to be split into smaller files, so
lets not make it worse by shovelling another 500 lines of code into
it...

2. The default option should not share option table parsing with the
CLI options, because all that means is you add extra code to convert
config file sections to CLI sections before using the common parsing
code.

3. it needs to support more than just boolean options e.g. for
setting a default log size

4. it needs default values to be range checked for sanity. These
values can be different to the min/max values the can be specified
on CLI as defaults need to be more forgiving when combined with
other random options.

There will be other things when I look at the code, but those are
the first ones that come to mind....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
