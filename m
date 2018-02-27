Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32841 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750941AbeB0ABY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Feb 2018 19:01:24 -0500
Date: Tue, 27 Feb 2018 00:01:22 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [RFC] mkfs config file bikeshed now!
Message-ID: <20180227000122.GR14069@wotan.suse.de>
References: <20180226224224.GE19312@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180226224224.GE19312@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Tso Ted <tytso@mit.edu>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, NeilBrown <neilb@suse.com>, Jeff Mahoney <jeffm@suse.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Feb 26, 2018 at 02:42:24PM -0800, Darrick J. Wong wrote:
> Note that a libconfig file (Dave suggested libconfig ages ago) might
> look more like this:

No, Dave *only hinted* towards libconfig ;)

I ran into grotesque issues with libconfig, and quickly moved to evaluate
libini_config (used for SSSD) as an alternative. IMHO it had the best
and up to date implementation, had great community traction, and I saw
support for it on a slew of old older distros.

I also evaluated Ted Tso's e2fprogs profile parser (based on MIT kerberos), and
it turns out that its 14.86% the size of libini_config.so.5.2.0, which is an
incredible bonus. It also supports to work with a slew of different OSes (which
we probably don't care for), but the gains in size are perhaps worth
considering. That and the fact that it will likely build on probably even
more ancient distros.  The e2fsprogs profile parser also lacks uint64_t support
but adding support is very trivial.  Another thing with e2fprogs's profile
parser is we'd have to come to an agreement with Ted and the e2fsprogs
community on sharing the library code. He seems to be open to that if we go
this route. To help I already did a lot of the work of extracting what we'd
need and also threw in a demo program:

https://gitlab.com/mcgrof/libekprofile

Similar review / demo is available with the other libraries:

https://gitlab.com/mcgrof/libconfig-int64-issues
https://gitlab.com/mcgrof/libini_config-demo

For boring details on further evaluation with other filesystems and what they
do and nitty gritty details of the above evaluation you can read my paper [0].
I even had evaluated NFS's configuration parser... at this point I was surprised
everyone keeps re-inventing the wheel...

One reason to consider sharing also is to help other filesystems as they
likely will run into similar requirements. Why does everyone keep re-inventing
this simple wheel on filesystem configuration parsers? Yes I suspect btrfs may
want something similar.

So in terms of bikeshedding -- its probably important also to at least zero down on
a library we want to work with. The rest I suspect will actually be pretty
trivial bikeshedding.

FWIW both libini_config and the e2fsprogs profile parser could cope with
namespaces on the configuration file as well. The syntax just varies
slightly. IIRC with e2fsprogs profile parsers we could end up with something
like:

[defaults]
foo=0
bar=0
[stuff]
	some_release =  {
		foo=1
		bar=2
	}
	new_release = {
		foo=2
	}

Meanwhile I think with libini_config it was something like:

[defaults]
foo=0
bar=0
[stuff/some_release]
foo=1
bar=2
[stuff/new_release]
foo=2

[0] https://gitlab.com/mcgrof/filesystem-configuration-paper/blob/master/paper.pdf

  Luis
