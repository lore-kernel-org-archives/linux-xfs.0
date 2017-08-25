Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51265 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753456AbdHYAjT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 20:39:19 -0400
Date: Fri, 25 Aug 2017 02:39:18 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH] mkfs: rename defaultval to flagval in opts
Message-ID: <20170825003918.GX27873@wotan.suse.de>
References: <20170818103932.24607-1-jtulak@redhat.com>
 <20170819010300.GM10621@dastard>
 <CACj3i72XgoXfNuSQPHn4ireQBRTiuhH4ngSdzhHgzW5uNWLVng@mail.gmail.com>
 <20170820015624.GP10621@dastard>
 <20170824191502.GT27873@wotan.suse.de>
 <20170824235843.GH21024@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170824235843.GH21024@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Jan Tulak <jtulak@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Dmitri Pal <dpal@redhat.com>

On Fri, Aug 25, 2017 at 09:58:43AM +1000, Dave Chinner wrote:
> On Thu, Aug 24, 2017 at 09:15:02PM +0200, Luis R. Rodriguez wrote:
> > On Sun, Aug 20, 2017 at 11:56:24AM +1000, Dave Chinner wrote:
> > > Let me finish factoring all the code into a set of usable
> > > structures, then we can start looking at the option table and config
> > > files from a fresh perspective. This time, we need to come up with a
> > > clean design and clear direction before any patches are written...
> > 
> > While you're on it, I should mention I ran across a nice feature as part of one
> > of the libraries I evaluated when considering configuration file parsing. The
> > library libini_config has a rules checker which allows one to build rules from
> > yet-another file, it uses ini_rules_read_from_file() to let you pass your
> > rules, you then use ini_rules_check() to check if the configuration file
> > applies to rules previously loaded. An example INI file for rules is that
> > of the upstream SSSD:
> > 
> > https://github.com/SSSD/sssd/blob/master/src/config/cfg_rules.ini
> > 
> > I haven't yet dove too much into this but from what I gather the
> > validator can be a built-in one or a local one.
> > 
> > A curious thing about our use is we'd want a validator for both configuration
> > file and command line parameters. But such language above may allow us to
> > easily specify and handle both.
> > 
> > Food for thought as we're trying to come up with a clean design now.
> 
> Conflating config files to change defaults with command line parsing
> is what got us into this mess in the first place. It's not a clean
> design - it's like trying to fit a square peg into a round hole.
> The result is stupidly complicated and needlessly bleeds config file
> implementation all through the rest of the mkfs code.

I'm not connecting defaults with CLI. I realize these are separate.
The above relationship was for CLI and configuration file given there
is a 1-1 mapping. If the configuration file was not to allow to specify
each and every CLI argument, then surely there was a disconnect from
the start.

I think breaking things down into modules as you did below however is
important and agree that it could be split up nicely.

> A clean design isolates the different functionality into
> self-contained modules and connects them with simple, easy to
> understand structures and minimal APIs.
> 
> The default behaviours we can modify are a much smaller subset of
> options than the CLI can modify. Hence if we define a structure that
> contains all the default options we can set, we also define the
> required config file contents.

I see, so the configuration file purpose is to be able to override
the smaller set of defaults, not supplement the CLI with all the
bells and whistles the CLI allows. I'll yield to you for this, it
sounds reasonable to me, however I suppose I should point out that
at least ext[2-4] do allow for CLI options, so its not clear to me
what that should implicate about mke2fs.conf.

> And it also defines the interface
> between built in defaults, config file defaults and how that feeds
> into command line parsing.  The command line parsing can remain
> entirely unchanged from where it is now, except for the structure it
> stores the configured options in.

Sure. This was expected.

> And, finally, we have a set of validated and configured values that
> mkfs uses to create the on-disk structures - the mkfs configuration
> if you like. This is currently splayed across single variables used
> to hold the defaults, cli options and validated mkfs values at
> different points in time. So we need to separate these out into a
> set of validated "mkfs parameters" structure that we can feed to the
> on disk formatting.

Great!

> IOWs, we have 4 clear modules and a set of data that is needed
> as inputs into each module:
> 
> Module				Connecting structure
> Setting defaults
> 				struct mkfs_default_params
> CLI parsing
> 				struct cli_params
> Validation + calculation
> 				struct mkfs_params
> On disk formatting
> 
> Note that there's nothing here that dictates how each module is
> implemented - all I've done is define modules and the data that
> needs to flow between the modules. I've simply applied a basic
> software engineering technique (SADT - structured analysis and
> design technique) and made a ruidmentary data flow diagram in my
> head to get to this.

Thanks, this helps. FWIW the way I split things out was

CLI  ------------
                  \
                   ---> params
                 /
config file ---

It would seem from what you are saying


CLI  ------------
                  \
                   ---> struct mkfs_default_params
                 /
config file ---

Is that right?

> We have a nasty habit of engineering software around here, and a key
> engineering process is understanding why something we tried to build
> failed catastrophically. And once a failure has been understood, we
> put in place processes that make sure that mistake doesn't happen
> again.
> 
> The last 3 modules in the above list were what I originally intended
> to do with mkfs - the CLI options table was simply an implementation
> detail inside the CLI parsing module. Then we got feature creep in
> the middle of all this - config file based defaults, json config
> input/output, etc.
> 
> We tried to factor that into the *CLI parsing module
> implementation*, rather than stepping back and looking at the
> overall design.  That's where it all went wrong and that's the
> reason we need to reset: we made a mistake at the design level and
> no amount of implementation complexity was going to fix that.
> 
> We failed and had to reset here because I didn't sufficiently
> communicate the original goals, design, etc, to the people who took
> up the work. And to make matters worse, I then allowed feature creep
> to take hold without really considering how those features should
> fit into the bigger picture.
> 
> A year ago I was pretty much beyond caring about this work because I
> was >this< close to burning out so I just let it all go. That's not
> a problem for me anymore, so now I'm cleaning up the mess I let
> happen on my watch. And that means I need to make sure everyone
> understands:
> 
> 	1. the reasons we have to reset this work,
> 	2. the design of the new code and the reasons for it; and
> 	3. make damn sure that feature creep doesn't derail this
> 	   work again
> 
> So, once the refactoring is done and I've added the stubs to allow
> config files to be used to override build time defaults, we can
> bikeshed about the config file format used in the "setting defaults"
> module all we want because it won't affect the design or
> implementation of any other part of mkfs.

Alrighty.

> This is a lot longer and a *lot* stronger than I was originally
> intending to write, but it comes down to one fundamental principle:
> 
> 	Never make the same mistake twice.

The details helped, thanks.

 Luis
