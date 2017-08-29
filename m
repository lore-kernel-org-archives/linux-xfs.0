Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57665 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750822AbdH2Riv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Aug 2017 13:38:51 -0400
Date: Tue, 29 Aug 2017 19:38:49 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH] mkfs: rename defaultval to flagval in opts
Message-ID: <20170829173849.GJ27873@wotan.suse.de>
References: <20170818103932.24607-1-jtulak@redhat.com>
 <20170819010300.GM10621@dastard>
 <CACj3i72XgoXfNuSQPHn4ireQBRTiuhH4ngSdzhHgzW5uNWLVng@mail.gmail.com>
 <20170820015624.GP10621@dastard>
 <20170824191502.GT27873@wotan.suse.de>
 <20170824235843.GH21024@dastard>
 <20170825003918.GX27873@wotan.suse.de>
 <20170828223653.GA10621@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170828223653.GA10621@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Jan Tulak <jtulak@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Dmitri Pal <dpal@redhat.com>

On Tue, Aug 29, 2017 at 08:36:53AM +1000, Dave Chinner wrote:
> On Fri, Aug 25, 2017 at 02:39:18AM +0200, Luis R. Rodriguez wrote:
> > On Fri, Aug 25, 2017 at 09:58:43AM +1000, Dave Chinner wrote:
> > > A clean design isolates the different functionality into
> > > self-contained modules and connects them with simple, easy to
> > > understand structures and minimal APIs.
> > > 
> > > The default behaviours we can modify are a much smaller subset of
> > > options than the CLI can modify. Hence if we define a structure that
> > > contains all the default options we can set, we also define the
> > > required config file contents.
> > 
> > I see, so the configuration file purpose is to be able to override
> > the smaller set of defaults, not supplement the CLI with all the
> > bells and whistles the CLI allows. I'll yield to you for this, it
> > sounds reasonable to me, however I suppose I should point out that
> > at least ext[2-4] do allow for CLI options, so its not clear to me
> > what that should implicate about mke2fs.conf.
> 
> I don't really care what mke2fs does with it's config file - it's
> got different constraints and behaviours, and likely different ways
> of setting defaults. If they have to set them via using CLI options
> in the confg file, then that's what they thought best.
> 
> I'm working on the model that if something can have a sane default
> defined, then it should be a known key/value pair in the config
> file which has a matching entry in the struct mkfs_default_params
> that is then used in the appropriate place in the code to apply that
> default. Using CLI option syntax for this just makes the config file
> format more complex and parsing it harder for no good reason.

Sounds good to me!

> > > IOWs, we have 4 clear modules and a set of data that is needed
> > > as inputs into each module:
> > > 
> > > Module				Connecting structure
> > > Setting defaults
> > > 				struct mkfs_default_params
> > > CLI parsing
> > > 				struct cli_params
> > > Validation + calculation
> > > 				struct mkfs_params
> > > On disk formatting
> > > 
> > > Note that there's nothing here that dictates how each module is
> > > implemented - all I've done is define modules and the data that
> > > needs to flow between the modules. I've simply applied a basic
> > > software engineering technique (SADT - structured analysis and
> > > design technique) and made a ruidmentary data flow diagram in my
> > > head to get to this.
> > 
> > Thanks, this helps. FWIW the way I split things out was
> > 
> > CLI  ------------
> >                   \
> >                    ---> params
> >                  /
> > config file ---
> > 
> > It would seem from what you are saying
> > 
> > 
> > CLI  ------------
> >                   \
> >                    ---> struct mkfs_default_params
> >                  /
> > config file ---
> > 
> > Is that right?
> 
> No. It's:
> 
> Build defaults --\
> 		  ---> mkfs_default_params -> CLI -> mkfs_params
> config file -----/

Perfect, thanks for the clarification. Full steam ahead!

  Luis
