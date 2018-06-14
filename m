Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:51437 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965025AbeFNXdx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jun 2018 19:33:53 -0400
Date: Fri, 15 Jun 2018 09:33:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5] xfsprogs-4.17: mkfs config file enhancements
Message-ID: <20180614233350.GM10363@dastard>
References: <152891829964.3968.4760134019673731615.stgit@magnolia>
 <20180614040628.GJ10363@dastard>
 <c4ae2aaf-ee28-5c35-b3f5-ffe8a57d3c01@sandeen.net>
 <20180614050844.GK10363@dastard>
 <20180614062949.GA6825@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180614062949.GA6825@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, sandeen@redhat.com, linux-xfs@vger.kernel.org

On Wed, Jun 13, 2018 at 11:29:49PM -0700, Darrick J. Wong wrote:
> On Thu, Jun 14, 2018 at 03:08:44PM +1000, Dave Chinner wrote:
> > On Wed, Jun 13, 2018 at 11:23:09PM -0500, Eric Sandeen wrote:
> > > On 6/13/18 11:06 PM, Dave Chinner wrote:
> > > > With this change, we'll have code to maintain it to ensure that the
> > > > file gets updated properly, and it will probably take more time and
> > > > effort to validate that the generated file is correct (and debug if
> > > > it's not!) compared to the 30s it will take to hand edit the
> > > > template file to change or add a new default...
> 
> Counterpoint: the mkfs config file template in mkfs.xfs.8 is already
> incorrect; sparse inodes was enabled by default in 4.16 but the manpage
> cfg file says it isn't.  This is exactly what happens when we rely on
> ourselves to hand edit the template file.
> 
> Put the defaults in *one* place in the source code tree and generate
> everything else off of that, instead of keeping multiple copies that
> will then get out of sync.  We clearly suck at this maintenance.

Then you need to explain the grander picture in your patch
description. The only thing that stuck out at me was "autogenerate
a template file" - none of the maintenance issues that get solved,
etc were in the description.

> > > Well, yeah.  /if/ we need a template, as well as text in a man page,
> > > then this gets it down to editing 1 file instead of two, I guess.
> > > But it really seems like we need to rethink these structures to get it
> > > all tied together, not requiring 2 or 3 manual updates across several files.
> > > It's bound to get out of sync.  I guess that can wait, but right now this
> > > dispersal isn't good.
> > 
> > So let's get the basic conig file stuff in first, then cosolidate,
> > then add all the bells and whistles.
> 
> That's where I started from -- fix the existing mess with the manpage,
> then fix the problems in the parsing code, then move all the CLI parsing and
> validation code out of xfs_mkfs.c because it's just too long.
> 
> Granted, I haven't gotten all the way there yet, so perhaps it was a bad
> idea to post just the first of those three parts.

More that there was no indication that this was anything more than
"more code we'll have to wade through later". i.e. it was presented
without the necessary context to understand what direction you were
heading.

That comes back to my "too many cooks" comment. Everyone seems to
have a different "killer feature" they want, but there has been no
discussion or co-ordination of how to deliver it all in a sane,
maintainable fashion.

If nothing else, my comments have prompted people to talk about what
they are trying to do rather than assuming everyone else knows what
everyone else wants.

> > Too many cooks trying to add all their own bells and whistles before
> > the core behaviour, infrastructure and implementation was nailed
> > down was pretty much what lead all the tablised CLI option parsing
> > code. And we're doing it again with this config file stuff...
> 
> Yeah.  TBH I feel at a loss for what exactly your vision is for how mkfs
> option parsing is supposed to work in the end.  How close is this:
> 
> 1. First we have the mkfs_default_params, which are the builtin
> defaults.
> 
> 2. Configuration file parameters are supposed to change the
> mkfs_default_params, yes?
> 
> 3. The mkfs_default_params are used to seed the cli_params.
> 
> 4. The getopt loop pulls the CLI option data into the cli_params.
> 
> 5. At this point we've melded together the builtin options
> with whatever the config file told us about, then folded in the CLI
> options, right?
> 
> 6. Now we start calling the validate_* and calculate_* functions.  These
> functions check the full set of configuration data and copy them into
> the mkfs_params; and they calculate whatever other bits are needed to
> finish the mkfs_params.
> 
> 7. Finally the validated mkfs_params are fed to the initialisation
> functions to set up the actual filesystem.

Pretty much spot on. It's set up as a data flow through specific
structures and actors that manipulate the data in those structures.
It's about as simple and concise as I could think of, and the fact
you've nailed it in one go tells me it's about as obvious as I could
of hoped for.

> So AFAICT what we have now is a big collection of ops_params that
> contain all the cli parsing options and a bunch of functions that take
> the cli strings and fill out the appropriate parts of cli_params.
> 
> Luis built a confopts_tab(le) that mapped cfgfile options to parsing
> functions that know how to take the cfgfile strings and fill out the
> appropriate parts of mkfs_default_params.

Right - what I want is for all the functionality to land, the
config file formats to stabilise and how we package/test/ship it all
to be settled /before/ we tried to consolidate everything back into
a common set of infrastructure and then expand it to do more things
for us.

> I understand now that from
> these first five patches it sure looks like I'm building yet a third
> structure, but this isn't the endgame -- I want a data structure that
> maps cfgfile options directly to the mkfs default params.  I'm doing
> this by building the new direct-mapped structure on the side and
> migrating the parser code to use that.

Ok, so you needed to explain this bigger picture up front, but I
knew nothing of it until now.  I'm happy for us to build new stuff,
but I really want to get things that are difficult to change or have
significant user impact if we change them right first.  IOWs, I
really don't want to have config file support ship with an
"experimental" tag as an excuse for not thinking though all the
issues before shipping it.

> Ås for "how do I check that the distro provided default template even
> works?", I'm working on building an xfstest to make sure that the
> default templates we ship (and whatever might be in
> /etc/xfs/mkfs/default) actually produce a functioning filesystem.

Which also wasn't explained :P

> > > > I'm also not convinced we should ship a "default.template" file,
> > > > either.  I'd much prefer we ship a real config file with all the
> > > > options defined but commented out as a "start here template".
> > > 
> > > As the code stands today, if a 100% commented-out config file
> > > exists, then mkfs will tell you that it's overriding built-in
> > > defaults with the config file which contains ... nothing.
> > > If we ship such a thing by default, that's what will happen by
> > > default.
> > 
> > Then that's a bug in the new parsing code and needs fixing. :)
> > 
> > > (Actually today it fails to parse and errors out but a patch
> > > to fix that is on the list).
> > > 
> > > I guess we could behave as if "no config file" if a config file
> > > contained no parseable tokens ... but that gets weird too.
> > 
> > Don't see why that is wierd, either - it's pretty common behaviour
> > for package shipped config files to have all options are present but
> > commented out.
> 
> Agreed, but I think Eric wanted to be cautious and not have mkfs parsing
> the default config file until this settles a little more, so I designed
> it to spit out a default.template file.  For now users will continue to
> use the same old code paths unless they explicitly light up the new
> ones by providing /etc/xfs/mkfs/default or -c on their own.

Sure.

But my point remains that separate config templates in /etc/ are
strange and unusual.  e.g. on debian, example config files usually
end up in /usr/share/doc/<pkg>/examples/, and lots of packages have
them:

$ ls /usr/share/doc/*/ |grep example |wc -l
186
$

Picking one a random:

$ ls /usr/share/doc/wpasupplicant/examples
ieee8021x.conf
openCryptoki.conf
plaintext.conf
udhcpd-p2p.conf
wep.conf
wpa2-eap-ccmp.conf
wpa-psk-tkip.conf
wpa-roam.conf
wpa_supplicant.conf.gz
$

Now, let's compare that to template config files
in /etc on the same system:

# find /etc/ |grep template |wc -l
28

Most of those a for wireless encryption setup for WICD. What
remains:

# find /etc/ |grep template |grep -v wicd
/etc/gimp/2.0/templaterc
/etc/lvm/profile/command_profile_template.profile
/etc/lvm/profile/metadata_profile_template.profile
/etc/exim4/exim4.conf.template
#

Yup: four packages of the 2547 packages installed on this machine
ship template config files. And the exim template was a Debian
package Maintainer decision to allow either split or global config
files to be used.

That's kinda what I'm getting at here - shipping config templates
in /etc seems to be quite unusual, and the location for example
config files is largely a distro packaging choice. i.e. the distro
package mantainer decides on whether a template is shipped and where
it is located, and that usually follows distro packaging guidelines.

IOWs, for the debian package build we should probably be putting
mkfs config template file into
/usr/share/doc/xfsprogs/examples/mkfs.conf, not /etc/xfs/....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
