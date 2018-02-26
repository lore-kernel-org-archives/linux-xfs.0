Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33888 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751165AbeBZXmQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Feb 2018 18:42:16 -0500
Subject: Re: [RFC] mkfs config file bikeshed now!
References: <20180226224224.GE19312@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <71515062-0ca8-3dbd-88d0-26c9d10b2c9d@sandeen.net>
Date: Mon, 26 Feb 2018 17:42:15 -0600
MIME-Version: 1.0
In-Reply-To: <20180226224224.GE19312@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>



On 2/26/18 4:42 PM, Darrick J. Wong wrote:
> On Thu, Feb 22, 2018 at 05:59:09PM -0800, Darrick J. Wong wrote:
> 
>>> Clearly. Its still a nice sensible feature to address any defaults,
>>> and now that I see chinner/mkfs-refactor is merged I'll go work
>>> off of that and post patches again soon.
> 
> I'll help you start the config file format bikeshedding:
> 
> So here at $employer we have to support a bunch of different base system
> and kernel configurations.  Some of our customers run heterogeneous
> environments where they have to be able to go back and forth between
> recent and old systems (stock OL6.9 <-> OL7 + UEK4) whereas others only
> care about formatting to whatever runs on the deployed system.  Right
> now we ship xfsprogs 4.5 with very conservative defaults, but this has
> become a hassle to keep patching mkfs, to remember which option sets
> correspond with which config, and to communicate that whole mess to
> customers.  Shipping multiple xfsprogs packages seems gross.
> 
> What we'd prefer to do is ship a single up to date xfsprogs package
> along with a mkfs config file containing distro-supported filesystem
> profiles.  As a side note, if there's no config file then we'd use
> whatever defaults are coded into xfs_mkfs.c.

I think that is an extremely important note, and the only sane behavior.  :)
 
> For example, say we had a /etc/xfs.conf file shipping with xfsprogs:

/etc/mkfs.xfs.conf please, this configures mkfs and nothing else, right?

> 
> [defaults]
> metadata.crc = false
> naming.ftype = false
> 
> [rhel7]
> metadata.crc = true
> 
> [uek3]
> naming.ftype = true
> 
> [uek4]
> metadata.crc = true
> naming.ftype = true
> metdata.finobt = true
> 
> [experimental]
> metadata.rmapbt = true
> metadata.reflink = true
> inode.sparse = true
> data.agcount = 32
> 
> The "defaults" section enables the distro vendor to patch in whatever
> default config they want to support.  In the example above the distro is
> not yet ready to support ftype or v5 filesystems everywhere because they
> want maximum compatibility, even though xfsprogs (by this point in the
> future) enables them by default.

Do the subsequent sections each independently specify the behavior or do they
build on the defaults?  I'd prefer the former (do not build on [defaults]),
I think.

> # mkfs.xfs /dev/sda <-- formats a boring v4 filesystem

IIRC Dave had a patch that emitted what was being used for defaults if
not the code - also IIRC I removed it but we should put that back
in with any config file parsing, I think.

"Using defaults from config file [defaults]" or somesuch.

I had also asked whether upstream would ship a config file at all.  I'd suggest
that we should not, because we wouldn't do anything other than restate
code defaults, and I'm not interested in keeping that consistent.

(OTOH a mkfs.xfs --config-file-defaults to spit out a code-defaults
configfile for editing might be neato) ;)

-Eric
