Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34610 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752699AbeFSXwq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jun 2018 19:52:46 -0400
Date: Wed, 20 Jun 2018 01:52:44 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v2] mkfs: add mkfs config version specifier for the
 config file
Message-ID: <20180619235244.GA5527@wotan.suse.de>
References: <20180618180520.22146-1-mcgrof@kernel.org>
 <e09a067d-5412-e0c7-f854-a0c5af1c6828@sandeen.net>
 <20180619205710.GH7508@wotan.suse.de>
 <26e331b2-182b-d928-cb94-8bb9b836ae5c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26e331b2-182b-d928-cb94-8bb9b836ae5c@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com

On Tue, Jun 19, 2018 at 04:21:25PM -0500, Eric Sandeen wrote:
> On 6/19/18 3:57 PM, Luis R. Rodriguez wrote:
> > But from a generic file format point of view, a version typically does
> > make sense for a slew of reasons, but it is typically the not known, the
> > unexpected, for which it can be a life saver.
> > 
> > Things that I can mention other than what you mentioned (whether or not
> > they are good, this is just a list of crazy things):
> > 
> >  1) We move from using our own parser to e2fsprogs profile parser (recall
> >     that my studies revealed it was the smallest) or lib_iniconfig (more
> >     robust, and widely used, however a kitchen sink compared to e2fsprogs
> >     profile parser)
> > 
> >     Both however support the INI format we are using.
> > 
> >     The version however may help to make the old parser not barf if
> >     say we added some magic in the future which would make the old
> >     parser barf.
> 
> ... if the file format does not change, a parser change doesn't matter, and
> a version change would be pointless.

It can. Consider support for different comment styles.

> >  2) Data type change for an existing token. Say crc=2 was invented
> >     (again just an example), it would barf on the old parser, but with
> >     the version check it would immediately tell you a more meaningful
> >     message.
> 
> But how is that any different from what it would do on the command line for
> a similar change?

So long as we remain forward compatible its a non-issue. If we say decide
to make a unit not compatible with old values then surely that's a format
change which would break old configs.

We should keep the config file parser ompatible with old config files produced.
That means anything and everything we allow today should keep working in the
future, and one way to sanely break that compatibility would be a version bump.

> "Invalid value 2 for token crc=2 on line XYZ" is completely reasonable, and
> does not require any version information.
> 
> In fact, what you are suggesting here means we'd bump the version if and only
> if the config file contained "crc=2" which makes little sense.

For example, a config file in the future with format 2 with crc=2 would not
work with and older xfsprog which only supports format version 1. Saying
that your xfsprogs does not support version 2 is IMHO clearer what the
issue may be.

> > message for a set of supported features, starting with what we have today
> > reflected as parsed as version 1. This does differ from what we do with
> > the CLI, however as with the respecification simplifcation done on
> > config.c in contrast to the CLI respecification checks, I would see
> > this as a win for users, and yet keeps things simple.
> 
> See my earlier email for why versioning cannot depend on the presence or
> absence of any parseable tokens ... stating "token XYZ not supported"
> should suffice IMHO.

It can. And ultimately its up to you to pick and choose.

> (now, it's true that today we don't distinguish between unknown vs.
> unsupported tokens, I don't know if I should try to fix that before 4.17
> or not; again, though,

I don't think its worth to say something is unsupported vs unknown given
we don't know what options will be supported, as some config file entries
are expected to differ from CLI.

> that is on the parser side, not the config file side.)
> 
> > If this seems acceptable and reasonable, then version would be a reflection
> > of supporting the format and layout of the file, as well was indicative
> > of supporting only a specific feature set.
> 
> What is or is not a supported token is wholly a function of the mkfs/parser
> version, not the config file version, right?

Yes.

> So, not to be argumentative ... but I remain unconvinced of the need for
> config file versioning.

Your call :)

  Luis
