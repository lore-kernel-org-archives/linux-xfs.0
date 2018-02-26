Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49116 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751628AbeBZWmw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Feb 2018 17:42:52 -0500
Date: Mon, 26 Feb 2018 14:42:24 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC] mkfs config file bikeshed now!
Message-ID: <20180226224224.GE19312@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Feb 22, 2018 at 05:59:09PM -0800, Darrick J. Wong wrote:

> > Clearly. Its still a nice sensible feature to address any defaults,
> > and now that I see chinner/mkfs-refactor is merged I'll go work
> > off of that and post patches again soon.

I'll help you start the config file format bikeshedding:

So here at $employer we have to support a bunch of different base system
and kernel configurations.  Some of our customers run heterogeneous
environments where they have to be able to go back and forth between
recent and old systems (stock OL6.9 <-> OL7 + UEK4) whereas others only
care about formatting to whatever runs on the deployed system.  Right
now we ship xfsprogs 4.5 with very conservative defaults, but this has
become a hassle to keep patching mkfs, to remember which option sets
correspond with which config, and to communicate that whole mess to
customers.  Shipping multiple xfsprogs packages seems gross.

What we'd prefer to do is ship a single up to date xfsprogs package
along with a mkfs config file containing distro-supported filesystem
profiles.  As a side note, if there's no config file then we'd use
whatever defaults are coded into xfs_mkfs.c.

For example, say we had a /etc/xfs.conf file shipping with xfsprogs:

[defaults]
metadata.crc = false
naming.ftype = false

[rhel7]
metadata.crc = true

[uek3]
naming.ftype = true

[uek4]
metadata.crc = true
naming.ftype = true
metdata.finobt = true

[experimental]
metadata.rmapbt = true
metadata.reflink = true
inode.sparse = true
data.agcount = 32

The "defaults" section enables the distro vendor to patch in whatever
default config they want to support.  In the example above the distro is
not yet ready to support ftype or v5 filesystems everywhere because they
want maximum compatibility, even though xfsprogs (by this point in the
future) enables them by default.

# mkfs.xfs /dev/sda <-- formats a boring v4 filesystem

However, if a customer only runs "uek4" on their infrastructure, they
might want to take advantage of the superior performance of ftype and
finobt.  They can elect to trade compatibility for speed:

# mkfs.xfs -t uek4 /dev/sda <-- v5 fs with ftype and finobt

The truly crazy can set their warranty cards on fire:

# mkfs.xfs -t experimental /dev/sda

Under this scheme, we take the suboption names directly from the command
line parser and expand the section names in some fashion:

b -> block
d -> data
i -> inode
l -> log
m -> metadata
n -> naming
r -> realtime
s -> sector

And throw in "label" and "protofile" for -L and -p.

Note that a libconfig file (Dave suggested libconfig ages ago) might
look more like this:

defaults {
	metadata {
		crc = false
	}
	naming {
		ftype = false
	}
}

rhel7 {
	metadata {
		crc = true
	}
}

uek4 {
	metadata {
		crc = true
		finobt = true
	}
	naming {
		ftype = true
	}
}

experimental {
	metadata {
		rmapbt = true
		reflink = true
	}
	inode {
		sparse = true
	}
	data {
		agcount = 32
	}
}

One downside of the libconfig API unfortunately is that we'd have to
manually iterate every option group/line to detect garbage / unknown key
values like:

broken {
	metadata {
		klsldgasldgjslgdajldsjgaldsgs = 98272352
	}
}

since there's no way to give the parser a higher level schema that
constricts the allowable keywords.  But that's (easily/clumsily) worked
around.

Ok, what does everyone else think?

--D
