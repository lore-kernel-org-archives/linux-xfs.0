Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:26051
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751420AbeFNFIr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jun 2018 01:08:47 -0400
Date: Thu, 14 Jun 2018 15:08:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5] xfsprogs-4.17: mkfs config file enhancements
Message-ID: <20180614050844.GK10363@dastard>
References: <152891829964.3968.4760134019673731615.stgit@magnolia>
 <20180614040628.GJ10363@dastard>
 <c4ae2aaf-ee28-5c35-b3f5-ffe8a57d3c01@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4ae2aaf-ee28-5c35-b3f5-ffe8a57d3c01@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com, linux-xfs@vger.kernel.org

On Wed, Jun 13, 2018 at 11:23:09PM -0500, Eric Sandeen wrote:
> On 6/13/18 11:06 PM, Dave Chinner wrote:
> > With this change, we'll have code to maintain it to ensure that the
> > file gets updated properly, and it will probably take more time and
> > effort to validate that the generated file is correct (and debug if
> > it's not!) compared to the 30s it will take to hand edit the
> > template file to change or add a new default...
> 
> Well, yeah.  /if/ we need a template, as well as text in a man page,
> then this gets it down to editing 1 file instead of two, I guess.
> But it really seems like we need to rethink these structures to get it
> all tied together, not requiring 2 or 3 manual updates across several files.
> It's bound to get out of sync.  I guess that can wait, but right now this
> dispersal isn't good.

So let's get the basic conig file stuff in first, then cosolidate,
then add all the bells and whistles.

Too many cooks trying to add all their own bells and whistles before
the core behaviour, infrastructure and implementation was nailed
down was pretty much what lead all the tablised CLI option parsing
code. And we're doing it again with this config file stuff...

> > I'm also not convinced we should ship a "default.template" file,
> > either.  I'd much prefer we ship a real config file with all the
> > options defined but commented out as a "start here template".
> 
> As the code stands today, if a 100% commented-out config file
> exists, then mkfs will tell you that it's overriding built-in
> defaults with the config file which contains ... nothing.
> If we ship such a thing by default, that's what will happen by
> default.

Then that's a bug in the new parsing code and needs fixing. :)

> (Actually today it fails to parse and errors out but a patch
> to fix that is on the list).
> 
> I guess we could behave as if "no config file" if a config file
> contained no parseable tokens ... but that gets weird too.

Don't see why that is wierd, either - it's pretty common behaviour
for package shipped config files to have all options are present but
commented out.

> Putting a blank config file in place to be parsed by default
> is messy, so a .template approach seems reasonable to me, if we
> need such a thing at all.

If we really need a separate template, then perhaps it should be in
the mkfs config file man page where we document all the supported
options?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
