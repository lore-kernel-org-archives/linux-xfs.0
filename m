Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:60472 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726934AbfFFWhH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jun 2019 18:37:07 -0400
Date: Fri, 7 Jun 2019 08:36:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs_restore: detect rtinherit on destination
Message-ID: <20190606223607.GE14308@dread.disaster.area>
References: <e6968aa2-a5ad-4964-2966-589486e4a251@sandeen.net>
 <20190606195724.2975689-1-sheenobu@fb.com>
 <f89a09b5-8a91-51e0-d869-039dbe9a7349@sandeen.net>
 <20190606215008.GA14308@dread.disaster.area>
 <4a03b347-1a71-857d-af9d-1d7eca00056a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a03b347-1a71-857d-af9d-1d7eca00056a@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Sheena Artrip <sheenobu@fb.com>, sheena.artrip@gmail.com, linux-xfs@vger.kernel.org

On Thu, Jun 06, 2019 at 05:08:12PM -0500, Eric Sandeen wrote:
> On 6/6/19 4:50 PM, Dave Chinner wrote:
> > My take on this is that we need to decide which allocation policy to
> > use - the kernel policy or the dump file policy - in the different
> > situations. It's a simple, easy to document and understand solution.
> > 
> > At minimum, if there's a mismatch between rtdev/non-rtdev between
> > dump and restore, then restore should not try to restore or clear rt
> > flags at all. i.e the rt flags in the dump image should be
> > considered invalid in this situation and masked out in the restore
> > process. This prevents errors from being reported during restore,
> > and it does "the right thing" according to how the user has
> > configured the destination directory. i.e.  if the destdir has the
> > rtinherit bit set and there's a rtdev present, the kernel policy
> > will cause all file data that is restored to be allocated on the
> > rtdev. Otherwise the kernel will place it (correctly) on the data
> > dev.
> > 
> > In the case where both have rtdevs, but you want to restore to
> > ignore the dump file rtdev policy, we really only need to add a CLI
> > option to say "ignore rt flags" and that then allows the kernel
> > policy to dictate how the restored files are placed in the same way
> > that having a rtdev mismatch does.
> > 
> > This is simple, consistent, fulfils the requirements and should have
> > no hidden surprises for users....
> 
> Sounds reasonable.  So the CLI flag would say "ignore RT info in the
> dump, and write files according to the destination fs policy?"
> I think that makes sense.

*nod*

> Now: do we need to do the same for all inheritable flags?  projid,
> extsize, etc?  I think we probably do.

I disagree. These things are all supported on all destination
filesystems, unlike the rtdev. They are also things that can be
changed after the fact, unlike rtdev allocation policy. i.e. rtdev
has to be set /before/ restore, just about everything else can be
set or reset after the fact....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
