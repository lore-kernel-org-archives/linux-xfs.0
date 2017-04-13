Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:42534 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751196AbdDMCvk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 22:51:40 -0400
Date: Thu, 13 Apr 2017 12:51:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] mdrestore: warn about corruption if log is dirty
Message-ID: <20170413025105.GD12369@dastard>
References: <20170411141237.9274-1-jtulak@redhat.com>
 <20170411141237.9274-3-jtulak@redhat.com>
 <20170411223405.GC12369@dastard>
 <20170412110403.GB6834@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170412110403.GB6834@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Wed, Apr 12, 2017 at 07:04:04AM -0400, Brian Foster wrote:
> On Wed, Apr 12, 2017 at 08:34:05AM +1000, Dave Chinner wrote:
> > On Tue, Apr 11, 2017 at 04:12:37PM +0200, Jan Tulak wrote:
> > > A dirty log in an obfuscated dump means that a corruption can happen
> > > when replaying the log (which contains unobfuscated data). Warn the user
> > > about this possibility.
> > > 
> > > The xlog workaround is copy&paste solution from repair/phase2.c and
> > > other tools, because the function is not implemented in libxlog.
> > > 
> > > Signed-off-by: Jan Tulak <jtulak@redhat.com>
> > 
> > I think this is overkill. mdrestore is not the place
> > to be interpreting the state of the dumped image - it is a basic
> > "restore the image" program, not a "check the validity of the image"
> > program.
> > 
> 
> I think that's a reasonable argument for the mdrestore side. I'm less
> interested in seeing a warning on the restore side in general,
> personally. I was initially thinking it would have required less code
> and the whole obfuscation detection thing is getting into hackish
> territory, to be fair.
> 
> > Secondly, if people are having problems with running log recovery on
> > a restored obfuscated image and getting corruption and not knowing
> > why or what to do, then that is a /documentation and training/
> > problem, not a code problem.
> > 
> > i.e. the problem is that people who aren't developers are trying to
> > use tools that were written for developers to do forensic analysis
> > of failures. Don't dumb down the tool for clueless users - point the
> > users at the documentation that the tool requires to use correctly...
> > 
> 
> Put me in the clueless users bucket, then. This started with a customer
> with a corrupted filesystem that provided a metadump that exhibited
> filesystem corruption. A support person began the process of diagnosing
> the problem and it eventually got to me, who had to spend a nontrivial
> amount of time trying to identify what the problem was, see if I could
> reproduce it on my own to verify it was actually specific to the
> metadump, etc.
> 
> This is not an obvious "your metadump is broken" log recovery failure.
> It's a latent directory corruption that doesn't obviously have anything
> to do with log recovery in the first place. I'm sure I'll be able to
> spot it going forward for some time while it's fresh in my mind, but I
> expect to lose track of that eventually given the rarity (of debugging
> log recovery issues). It's not reasonable at all to expect regular users
> or support people to understand this enough to filter out bad images or
> know when to use or not use a certain combination of metadump options,
> because it otherwise requires a detailed understanding of XFS logging
> and directory internals.

Log recovery on an obfuscated directory is, to me, a known obvious
vector for directory corruption because we replay unobfuscated
dirents over obfuscated on-disk data. Buffer logging is done in
aligned 128 byte chunks, so it /should/ be obvious that the recovery
of directory data buffers will partially overwrite dirents on disk
even when they were not directly modified by the user.  And because
this causes an obfuscated/clear text mismatch in the dirent name,
the hash will not calculate to teh same as what the directory stored
for that dirent. Hence the corruption reports that repair will now
spew...

This was always considered a known problem for obfuscated metadump
restorations - the unobfuscated log will result in recovery issues
and name/data corruptions for dirs and xattrs.  In hindsight, this
should have been documented long ago so you didn't have to waste the
time to "rediscover" it like you did. It wasn't documented because
both developers and users were far more concerned about the data
exposure issues than they were about whether the log unobfuscated
log replayed correctly or not.

IMO - and as I said to Eric on IRC - we should not be trying to work
around institutional problems (i.e. inability to train or impart the
necessary knowledge on support engineers) with code changes.
Training support engineers properly requires documentation and
knowledge distribution processes; the code implementing the tools
they are being taught about is not the right instrument to perform
this knowledge transfer....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
