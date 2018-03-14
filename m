Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58387 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751000AbeCNSlT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Mar 2018 14:41:19 -0400
Date: Wed, 14 Mar 2018 18:41:17 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH] mkfs.xfs: add configuration file parsing support using
 our own parser
Message-ID: <20180314184117.GA5740@wotan.suse.de>
References: <20180313205911.26082-1-mcgrof@kernel.org>
 <44fa85af-7d59-9909-20e4-c8351f630fb4@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44fa85af-7d59-9909-20e4-c8351f630fb4@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, darrick.wong@oracle.com
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com, tytso@mit.edu

On Tue, Mar 13, 2018 at 11:21:48PM -0400, Eric Sandeen wrote:
> On 3/13/18 4:59 PM, Luis R. Rodriguez wrote:
> > You may want to stick to specific set of configuration options when
> > creating filesystems with mkfs.xfs -- sometimes due to pure technical
> > reasons, but some other times to ensure systems remain compatible as
> > new features are introduced with older kernels, or if you always want
> > to take advantage of some new feature which would otherwise typically
> > be disruptive.
> > 
> > This adds support for parsing a configuration file to override defaults
> > parameters to be used for mkfs.xfs.
> > 
> > We define an XFS configuration directory, /etc/mkfs.xfs.d/ and allow for
> > different types of configuration files, if none is specified we look for
> > the default type, /etc/mkfs.xfs.d/default, and you can override with -T.
> > For instance, if you specify:
> > 
> > 	mkfs.xfs -T experimental -f /dev/loop0
> 
> Ok, since you have to fix it all anyway, can we please use "-c" for config
> instead of "-T" for type?

Sure. Its what I had originally used and I followed Darrick's bike-shed
email to use -t, and then -T after. I guess I'll revert back.

> Can we just call them 'configs'?)

My pleasure.

> > The file /etc/mkfs.xfs.d/experimental will be used as your configuration
> > file. If you really need to override the full path of the configuration
> > file you may use the MKFS_XFS_CONFIG environment variable.
> > 
> > To use /etc/ be sure to configure xfsprogs with:
> > 
> >  ./configure --sysconfdir=/etc/
> 
> surely this should be made default?

As you wish.

> > To verify what configuration file is used on a system use the typical:
> > 
> >   mkfs.xfs -N
> 
> Nitpick: -N by itself is not valid, it's treated as an error.
> When it does get a config file, IMHO it should give its name, not just
> "custom configuration file"

Sure, will amend.

> > There is only a subset of options allowed to be set on the configuration
> > file, 
> 
> I think this is problematic - allowing only booleans is pretty
> arbitrary.

I was trying to simplify things considering how limited the number of
uints were on struct mkfs_default_params, and instead how most were just
bools. But sure, we can go ahead and parse the uints out of struct mkfs_default_params
as well.

> > We have floated around enough bike shedding emails to have at least reached
> > a consensus on the fact that we'd be only supporting a mimimum set of default
> > parameters and would strive to simplify our parser as much as possible.
> 
> See above - sorry for not chiming in sooner, but I don't think an arbitrary
> restriction to the boolean options will be sufficient in the long run.

Sure.

> > --- /dev/null
> > +++ b/man/man5/mkfs.xfs.d.5
> > @@ -0,0 +1,121 @@
> > +.TH mkfs.xfs.d 5
> > +.SH NAME
> > +mkfs.xfs.d \- mkfs.xfs configuration directory
> 
> IMHO this is all far too wordy, will put my editor hat on later.

Thanks, I appreciate the editorial feedback.

> > Alternatively
> > +you can set and use the MKFS_XFS_CONFIG environment variable to override
> > +the default full path of the first file
> > +.B mkfs.xfs (8)
> > +looks for.
> 
> (How do you envision this env var being used?  How is this better than
> simply allowing -t to specify a full path?)

-c can specify the full path if we want, its up to us if we want to allow
for that. Its simpler to support it, so fine by me to only accept that
and remove the environment variable.

> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 1ca6a2d148c4..e66330a50b68 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -21,7 +21,11 @@
> >  #include "xfs_multidisk.h"
> >  #include "libxcmd.h"
> >  
> > -
> > +#define MKFS_XFS_CONF_DIR	ROOT_SYSCONFDIR "/mkfs.xfs.d/"
> > +#define CONFIG_MAX_KEY		1024
> > +#define CONFIG_MAX_VALUE	PATH_MAX
> > +#define CONFIG_MAX_BUFFER	CONFIG_MAX_KEY + CONFIG_MAX_VALUE + 3
> > +#define PARAM_OPTS		"T:b:d:i:l:L:m:n:KNp:qr:s:CfV"
> 
> what dave said ;)
> 
> also re: what dave said - functioning properly only if -t/-T/-c is given
> first on the commandline is a little odd, though it makes some semantic
> sense to specify a config file first then additional options so I can
> live with it, I think.
> 
> But it really must then fail, as opposed to silently ignoring it,
> if the option comes later.

I'll just enable -c to be parsed via the command line interface options
so it can be defined anywhere.

> <snip wow a whole lot of lines to parse the configfile>
> 
> Ok, so my configfile-containing-actual-commandlines was shot down,
> but I'm a bit dismayed at the LOC required to re-parse the configfile,
> especially when it's not even handling all options....

Adding uint shouldn't be too much extra code, it just means the callbacks
will be passing a uint and each option will have also implement a boundary
check. With the way Dave is suggesting this to be on its own file and set
of data structures or range checks, this shouldn't be too hard to do, its
just yet-more code.

> I'll have to take more time to review the bulk of the code, but the
> behavioral issues above need to be addressed I think.

Makes sense, thanks for the review.

  Luis
