Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:26556
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751656AbeB0WOK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Feb 2018 17:14:10 -0500
Date: Wed, 28 Feb 2018 09:14:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] mkfs config file bikeshed now!
Message-ID: <20180227221408.GJ30854@dastard>
References: <20180226224224.GE19312@magnolia>
 <20180227000122.GR14069@wotan.suse.de>
 <3e239e61-bc79-c594-c1fd-44fa3efe779d@sandeen.net>
 <CAB=NE6U+7hmRhrkkd1v=rEKrcY+NNf61jL9B4nm=kDbTPvy--w@mail.gmail.com>
 <20180227002550.GH19312@magnolia>
 <20180227031757.GB24294@thunk.org>
 <20180227034545.GC24294@thunk.org>
 <CACj3i72YvAhVfqT-oVkFdrEfBjKOXqtbedMQS2uydBuX_WXhjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i72YvAhVfqT-oVkFdrEfBjKOXqtbedMQS2uydBuX_WXhjQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, NeilBrown <neilb@suse.com>, Jeff Mahoney <jeffm@suse.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Feb 27, 2018 at 02:43:44PM +0100, Jan Tulak wrote:
> On Tue, Feb 27, 2018 at 4:45 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> > One other thing I'll mention is that it was really important to me
> > that it was very easy to look up values from the config file.  So for
> > me it was a lot more than just the parser.  So I can fetch a read a
> > config parameter from the config file like this:
> >
> >         profile_get_boolean(ctx->profile, "options", "no_optimize_extents",
> >                             0, 0, &c);


That's not the way we've set up mkfs to deal with config file
defaults.

i.e. the config file creates a "default values" structure that gets
used when no CLI parameter was specified. IOWs, all we need the
config file to do is to be parsed into a pre-defined structure and
the rest of mkfs will already DTRT.

i.e. We don't need (or want) mkfs to be directly pulling random
values from config files depending on the current option context.

> > That's because I use this for a lot more than just file system tuning
> > parametres, but also for changing how e2fsck / mke2fs behaves.  So
> > trying to parse all of the config file at startup time and having to
> > stash that in some global context structure is just lot of extra work
> > that isn't necessary with the profile library compared with other
> > libraries which are focused exclusively on the parsing aspect of
> > things (which is actually pretty trivial).
> >
> > Maybe this doesn't matter for XFS, but other file system utilities may
> > find this issue to be something worthy of consideration when trying to
> > pick a config file library.
> 
> Neat. But yeah, I don't think the nesting would be useful for xfs.
> Especially as I prefer the /etc/mkfs.xfs.d/ idea. It might make sense
> to use something like this, instead of foo.bar style prefixing,
> though.
> 
> /etc/mkfs.xfs.d/default:
> 
> [metadata]
> crc = 0
> 
> [naming]
> ftype = 0

Yup, I like the simplicity of this approach. One config per file,
with simple config groups that mirror the CLI grouping and options.
Simple for admins, simple for developers, simple to implement and
test.

We really don't need any more complexity than this, so lets not make
it any more complex than it needs to be - that mistake has already
been made in recent times with mkfs.xfs modifications, and I don't
want to dig us out of that hole again...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
