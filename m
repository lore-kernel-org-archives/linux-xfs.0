Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:50286 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751379AbeCNVCk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Mar 2018 17:02:40 -0400
Date: Thu, 15 Mar 2018 08:01:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs.xfs: add configuration file parsing support using
 our own parser
Message-ID: <20180314210145.GH18129@dastard>
References: <20180313205911.26082-1-mcgrof@kernel.org>
 <20180313213916.GD18129@dastard>
 <20180313235227.GH4449@wotan.suse.de>
 <20180314035531.GF18129@dastard>
 <20180314171901.GI4449@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180314171901.GI4449@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: sandeen@sandeen.net, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com, tytso@mit.edu

On Wed, Mar 14, 2018 at 05:19:01PM +0000, Luis R. Rodriguez wrote:
> On Wed, Mar 14, 2018 at 02:55:31PM +1100, Dave Chinner wrote:
> > On Tue, Mar 13, 2018 at 11:52:27PM +0000, Luis R. Rodriguez wrote:
> > > On Wed, Mar 14, 2018 at 08:39:16AM +1100, Dave Chinner wrote:
> > > > Just one obvious comment from a brief glance - you changed this from
> > > > "-t" to "-T", but ....
> > > > > +directory by using the -t parameter and secifying the type. Alternatively
> > > > 
> > > > Not here, or ....
> > > >
> > > > > +If you use -t the type configuration file must be present under
> > > > 
> > > > here, or ....
> > > > 
> > > > > +#define MKFS_XFS_CONF_DIR	ROOT_SYSCONFDIR "/mkfs.xfs.d/"
> > > > > +#define CONFIG_MAX_KEY		1024
> > > > > +#define CONFIG_MAX_VALUE	PATH_MAX
> > > > > +#define CONFIG_MAX_BUFFER	CONFIG_MAX_KEY + CONFIG_MAX_VALUE + 3
> > > > > +#define PARAM_OPTS		"T:b:d:i:l:L:m:n:KNp:qr:s:CfV"
> > > > 
> > > > [ Please don't obfuscate parsing options like this ]
> > > 
> > > The reason was we use them twice.
> > 
> > Which is not necessary. You don't need to change the option parsing
> > loop at all - the default config file can be parsed at any time as
> > a normal option. The default structure is not used for calculations
> > until after all the CLI options are parsed, so it can just be
> > treated as another CLI option in any location on the CLI.
> 
> Alright.
> 
> > > > I'll spend some more time looking at it, but my initial impression
> > > > is that there's a bit of work to be done yet...
> > > 
> > > You're right, we should decide if we want to allow for -T to be used
> > > only in the beginning or if we want to allow for it anywhere on the
> > > command line.
> > 
> > That's not what I meant. I meant the code needs a lot of work, not
> > that we needed to decide where on the CLI the config file option
> > should be placed.
> > 
> > Basically:
> > 
> > 1. the default file parsing code needs to go into it's own file.
> > xfs_mkfs.c is too large and needs to be split into smaller files, so
> > lets not make it worse by shovelling another 500 lines of code into
> > it...
> 
> Sure.
> 
> > 2. The default option should not share option table parsing with the
> > CLI options, because all that means is you add extra code to convert
> > config file sections to CLI sections before using the common parsing
> > code.
> 
> Sure.
> 
> > 3. it needs to support more than just boolean options e.g. for
> > setting a default log size
> 
> Log size is not part of struct mkfs_default_params, do we reaally
> want to be able to set that via the configuration file?

I think you're over-complicating/over-thinking this. setting a
default log size is an /example/, not something we /must do/. I
could have said "default directory blocksize", which is another
thing that is not currently in the defaults structure but is also
something we should also consider as a configurable default because
there are classes of users that want to use a different default
value.

> sectorsize and blocksize are though.
> Then struct mkfs_default_params has a struct sb_feat_args, of
> which non-bools are (and their corresponding mapping):
> 
> 	int log_version L_VERSION
> 	int attr_version I_ATTR
> 	int dir_version N_VERSION
> 
> So sure, I can add support for these, and sectorsize and blocksize.  It just
> didn't seem worth it given most of the others were bool, so if we restrict the
> parser to bool its much simpler.

Again, you're only looking at the current implementation to support
what it implements rather than implementing what we need to
arbitrary config file parameters.

e.g. Look at validate_dirblocksize() - it's default value is hard
coded into the function, rather than getting it from the defaults
structure.  Same goes for validate_inodesize(), and so on. Those are
going to need to be pulled up into the default value structure,
because they are things we're going to want to support changing
default values for.

Start by looking at all the types we parse on the CLI (bool, flag,
int, int64, unit suffices, etc) and implementing those, because they
are all going to be needed to set the value of some default
parameter....

> BTW I see we have bool parent_pointers, and that maps to setting
> XFS_SB_VERSION2_PARENTBIT, but we have no respective specific CLI
> param, so of these:

Again, you're looking at implementation, and asking questions about
a function that *isn't yet implemented* and so has no valid value
other than 0. When it's actually implemented, then we'll add it to
the CLI options and the default parsing into the appropriate
section. It's not the job of a "introduce config files for defaults"
patch to implement CLI/default parsing support for features that
aren't currently implemented.

> > There will be other things when I look at the code, but those are
> > the first ones that come to mind....
> 
> I can address most of what you describe rather easily, the biggest
> issue is ensuring that our goal here is only to modify struct
> mkfs_default_params values, inclusive of what is in struct sb_feat_args.
> 
> Note that struct mkfs_default_params also has a struct fsxattr... do we
> want to modify all those (this struct is defined per OS), for Linux we have:
> 
> struct fsxattr {                                                                
>         __u32           fsx_xflags;     /* xflags field value (get/set) */      
>         __u32           fsx_extsize;    /* extsize field value (get/set)*/      
>         __u32           fsx_nextents;   /* nextents field value (get)   */      
>         __u32           fsx_projid;     /* project identifier (get/set) */      
>         __u32           fsx_cowextsize; /* cow extsize field value (get/set) */ 
>         unsigned char   fsx_pad[8];                                             
> };
> 
> I didn't enable parsing support for these, do we want to parse each of these
> as well?

They are set by parsing existing CLI options, so if you enable those
options in the config file parsing, then this structure will need to
be updated, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
