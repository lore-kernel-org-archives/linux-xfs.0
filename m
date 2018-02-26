Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52250 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750941AbeBZX5J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Feb 2018 18:57:09 -0500
Date: Mon, 26 Feb 2018 15:56:49 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC] mkfs config file bikeshed now!
Message-ID: <20180226235649.GG19312@magnolia>
References: <20180226224224.GE19312@magnolia>
 <71515062-0ca8-3dbd-88d0-26c9d10b2c9d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71515062-0ca8-3dbd-88d0-26c9d10b2c9d@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Feb 26, 2018 at 05:42:15PM -0600, Eric Sandeen wrote:
> 
> 
> On 2/26/18 4:42 PM, Darrick J. Wong wrote:
> > On Thu, Feb 22, 2018 at 05:59:09PM -0800, Darrick J. Wong wrote:
> > 
> >>> Clearly. Its still a nice sensible feature to address any defaults,
> >>> and now that I see chinner/mkfs-refactor is merged I'll go work
> >>> off of that and post patches again soon.
> > 
> > I'll help you start the config file format bikeshedding:
> > 
> > So here at $employer we have to support a bunch of different base system
> > and kernel configurations.  Some of our customers run heterogeneous
> > environments where they have to be able to go back and forth between
> > recent and old systems (stock OL6.9 <-> OL7 + UEK4) whereas others only
> > care about formatting to whatever runs on the deployed system.  Right
> > now we ship xfsprogs 4.5 with very conservative defaults, but this has
> > become a hassle to keep patching mkfs, to remember which option sets
> > correspond with which config, and to communicate that whole mess to
> > customers.  Shipping multiple xfsprogs packages seems gross.
> > 
> > What we'd prefer to do is ship a single up to date xfsprogs package
> > along with a mkfs config file containing distro-supported filesystem
> > profiles.  As a side note, if there's no config file then we'd use
> > whatever defaults are coded into xfs_mkfs.c.
> 
> I think that is an extremely important note, and the only sane behavior.  :)
>  
> > For example, say we had a /etc/xfs.conf file shipping with xfsprogs:
> 
> /etc/mkfs.xfs.conf please, this configures mkfs and nothing else, right?

Ok.  I mean, I might let that be $sysconfdir/mkfs.xfs.conf or something,
but I agree about the filename component of the path.

> > 
> > [defaults]
> > metadata.crc = false
> > naming.ftype = false
> > 
> > [rhel7]
> > metadata.crc = true
>
> Oh, one more thing.  Let's not arbitrarily decide that the commandline
> uses 1/0 but the configfile uses true/false.  I'd really like as much 
> 1:1 consistency here as possible.

Oops.  I of course meant 0 / 1 here, since the goal is to use the
existing mkfs parsing system here.

> > [uek3]
> > naming.ftype = true
> > 
> > [uek4]
> > metadata.crc = true
> > naming.ftype = true
> > metdata.finobt = true
> > 
> > [experimental]
> > metadata.rmapbt = true
> > metadata.reflink = true
> > inode.sparse = true
> > data.agcount = 32
> > 
> > The "defaults" section enables the distro vendor to patch in whatever
> > default config they want to support.  In the example above the distro is
> > not yet ready to support ftype or v5 filesystems everywhere because they
> > want maximum compatibility, even though xfsprogs (by this point in the
> > future) enables them by default.
> 
> Do the subsequent sections each independently specify the behavior or do they
> build on the defaults?  I'd prefer the former (do not build on [defaults]),
> I think.

Not sure either.  It would be useful to let the non-defaults profile
inherit off of the defaults profile, but otoh to an administrator it's a
lot clearer what they're getting with a profile if we force the config
file writer to specify the entire configuration.

Hmmm, I am drifting towards "do not build on defaults".

> > # mkfs.xfs /dev/sda <-- formats a boring v4 filesystem
> 
> IIRC Dave had a patch that emitted what was being used for defaults if
> not the code - also IIRC I removed it but we should put that back
> in with any config file parsing, I think.
> 
> "Using defaults from config file [defaults]" or somesuch.

Yes.  How about:

"Using profile 'rhel7' from /etc/mkfs.xfs.conf."

> I had also asked whether upstream would ship a config file at all.  I'd suggest
> that we should not, because we wouldn't do anything other than restate
> code defaults, and I'm not interested in keeping that consistent.

I don't see much of a point since we'd be shipping

# mkfs.xfs --config-file-defaults > /etc/mkfs.xfs.conf

> (OTOH a mkfs.xfs --config-file-defaults to spit out a code-defaults
> configfile for editing might be neato) ;)

--generate-config-file?

--D

> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
