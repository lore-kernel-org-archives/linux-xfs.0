Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54613 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754713AbeFNSQD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jun 2018 14:16:03 -0400
Date: Thu, 14 Jun 2018 20:16:02 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 0/5] xfsprogs-4.17: mkfs config file enhancements
Message-ID: <20180614181602.GL5527@wotan.suse.de>
References: <152891829964.3968.4760134019673731615.stgit@magnolia>
 <20180614040628.GJ10363@dastard>
 <c4ae2aaf-ee28-5c35-b3f5-ffe8a57d3c01@sandeen.net>
 <20180614050844.GK10363@dastard>
 <20180614062949.GA6825@magnolia>
 <20180614174640.GE7508@wotan.suse.de>
 <20180614175909.GB8128@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180614175909.GB8128@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>, sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Jun 14, 2018 at 10:59:09AM -0700, Darrick J. Wong wrote:
> On Thu, Jun 14, 2018 at 07:46:40PM +0200, Luis R. Rodriguez wrote:
> > a) a set of config files we know should work and ensure they produce the
> >    same filesystem as if we had used CLI params. We can use xfs_db -c version
> >    against both filesystems and check that each differences. Since this would
> >    use the same xfsprogs for the results of a config based filesystem and
> >    the CLI based filesystem the diff would only generate if there really
> >    was a change between both runs, and you can use any xfsprogs version
> >    for it.
> 
> Hmm, just out of curiosity, are there any mkfs cli/config options that
> do /not/ show up in the output of mkfs and/or 'xfs_db -c info'?

A good question indeed. But more importantly, how could we verify that in
the future automatically?

> >    It does however leave actual expected results on the filesystem up to
> >    a separate test, it assumes that xfs/191-input-validation is doing its
> >    job, but word is that needs some love.
> > 
> > b) a set of invalid config files and ensure they never work
> 
> Agreed, I have some twisty ones of my own, 

Great!

> though fixing them requires some amount of sscanf format string tweaking. :)

Oh fun, so we can have the test fail for the get go. Note that at one point
of parser evolution we may get to the point of actually reaching a point of
it being more better to just embrace a library. But in terms of size and
maintenance due to the simplicity of what we need to parse we were just not
there yet.

Let's recall that sharing the profile parser from e2fsprogs was the smallest,
but libini_config the more generic one.

If you want to experiment with them:

https://gitlab.com/mcgrof/libini_config-demo.git
https://gitlab.com/mcgrof/libekprofile.git

> > c) test to ensure cli can override config params
> 
> <nod>
> 
> > To test that a self generated config file works would be a next step (d),
> > and I think we can validate it by also making sure it yields the same
> > filesystem as if we just ran mkfs.xfs with no options, so same strategy
> > as in a).
> 
> Ok, good.  I'd also argue for a test that tries every file in
> /etc/xfs/mkfs/* to see if mkfs will format the filesystem described in
> the config file, that way we can pick up all the distro-packaged files.

Works with me, so we have 3 tests in mind already.

> > With proper testing in place for regular configs stuff (the tests
> > I have to write) and this I see your changes as desirable but I'm
> > wondering if this should just wait until the next cycle so we at
> > least have some effort on the testing started already?
> 
> Agreed.  I'm scurrying back under the rocks so that Eric can get
> xfsprogs 4.17 out the door.

OK cool, I'll try to finish the discussed test soon.

> (I'm actually going to go debug some hardware and see if I can get
> fscounter scrub working.)

:)

  Luis
