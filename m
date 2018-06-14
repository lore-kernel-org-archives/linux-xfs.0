Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:50628 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752689AbeFNGaI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jun 2018 02:30:08 -0400
Date: Wed, 13 Jun 2018 23:29:49 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/5] xfsprogs-4.17: mkfs config file enhancements
Message-ID: <20180614062949.GA6825@magnolia>
References: <152891829964.3968.4760134019673731615.stgit@magnolia>
 <20180614040628.GJ10363@dastard>
 <c4ae2aaf-ee28-5c35-b3f5-ffe8a57d3c01@sandeen.net>
 <20180614050844.GK10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180614050844.GK10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Jun 14, 2018 at 03:08:44PM +1000, Dave Chinner wrote:
> On Wed, Jun 13, 2018 at 11:23:09PM -0500, Eric Sandeen wrote:
> > On 6/13/18 11:06 PM, Dave Chinner wrote:
> > > With this change, we'll have code to maintain it to ensure that the
> > > file gets updated properly, and it will probably take more time and
> > > effort to validate that the generated file is correct (and debug if
> > > it's not!) compared to the 30s it will take to hand edit the
> > > template file to change or add a new default...

Counterpoint: the mkfs config file template in mkfs.xfs.8 is already
incorrect; sparse inodes was enabled by default in 4.16 but the manpage
cfg file says it isn't.  This is exactly what happens when we rely on
ourselves to hand edit the template file.

Put the defaults in *one* place in the source code tree and generate
everything else off of that, instead of keeping multiple copies that
will then get out of sync.  We clearly suck at this maintenance.

> > Well, yeah.  /if/ we need a template, as well as text in a man page,
> > then this gets it down to editing 1 file instead of two, I guess.
> > But it really seems like we need to rethink these structures to get it
> > all tied together, not requiring 2 or 3 manual updates across several files.
> > It's bound to get out of sync.  I guess that can wait, but right now this
> > dispersal isn't good.
> 
> So let's get the basic conig file stuff in first, then cosolidate,
> then add all the bells and whistles.

That's where I started from -- fix the existing mess with the manpage,
then fix the problems in the parsing code, then move all the CLI parsing and
validation code out of xfs_mkfs.c because it's just too long.

Granted, I haven't gotten all the way there yet, so perhaps it was a bad
idea to post just the first of those three parts.

> Too many cooks trying to add all their own bells and whistles before
> the core behaviour, infrastructure and implementation was nailed
> down was pretty much what lead all the tablised CLI option parsing
> code. And we're doing it again with this config file stuff...

Yeah.  TBH I feel at a loss for what exactly your vision is for how mkfs
option parsing is supposed to work in the end.  How close is this:

1. First we have the mkfs_default_params, which are the builtin
defaults.

2. Configuration file parameters are supposed to change the
mkfs_default_params, yes?

3. The mkfs_default_params are used to seed the cli_params.

4. The getopt loop pulls the CLI option data into the cli_params.

5. At this point we've melded together the builtin options
with whatever the config file told us about, then folded in the CLI
options, right?

6. Now we start calling the validate_* and calculate_* functions.  These
functions check the full set of configuration data and copy them into
the mkfs_params; and they calculate whatever other bits are needed to
finish the mkfs_params.

7. Finally the validated mkfs_params are fed to the initialisation
functions to set up the actual filesystem.

So AFAICT what we have now is a big collection of ops_params that
contain all the cli parsing options and a bunch of functions that take
the cli strings and fill out the appropriate parts of cli_params.

Luis built a confopts_tab(le) that mapped cfgfile options to parsing
functions that know how to take the cfgfile strings and fill out the
appropriate parts of mkfs_default_params.  I understand now that from
these first five patches it sure looks like I'm building yet a third
structure, but this isn't the endgame -- I want a data structure that
maps cfgfile options directly to the mkfs default params.  I'm doing
this by building the new direct-mapped structure on the side and
migrating the parser code to use that.

Ås for "how do I check that the distro provided default template even
works?", I'm working on building an xfstest to make sure that the
default templates we ship (and whatever might be in
/etc/xfs/mkfs/default) actually produce a functioning filesystem.

> > > I'm also not convinced we should ship a "default.template" file,
> > > either.  I'd much prefer we ship a real config file with all the
> > > options defined but commented out as a "start here template".
> > 
> > As the code stands today, if a 100% commented-out config file
> > exists, then mkfs will tell you that it's overriding built-in
> > defaults with the config file which contains ... nothing.
> > If we ship such a thing by default, that's what will happen by
> > default.
> 
> Then that's a bug in the new parsing code and needs fixing. :)
> 
> > (Actually today it fails to parse and errors out but a patch
> > to fix that is on the list).
> > 
> > I guess we could behave as if "no config file" if a config file
> > contained no parseable tokens ... but that gets weird too.
> 
> Don't see why that is wierd, either - it's pretty common behaviour
> for package shipped config files to have all options are present but
> commented out.

Agreed, but I think Eric wanted to be cautious and not have mkfs parsing
the default config file until this settles a little more, so I designed
it to spit out a default.template file.  For now users will continue to
use the same old code paths unless they explicitly light up the new
ones by providing /etc/xfs/mkfs/default or -c on their own.

--D

> > Putting a blank config file in place to be parsed by default
> > is messy, so a .template approach seems reasonable to me, if we
> > need such a thing at all.
> 
> If we really need a separate template, then perhaps it should be in
> the mkfs config file man page where we document all the supported
> options?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
