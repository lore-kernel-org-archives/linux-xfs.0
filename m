Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:58122 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965502AbdEXD0g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2017 23:26:36 -0400
Date: Wed, 24 May 2017 13:26:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_metadump: tag metadump image with attribute flags
Message-ID: <20170524032632.GA17542@dastard>
References: <402504cb-1632-85b6-a745-1334ccf0ee8f@redhat.com>
 <20170523154603.GR4519@birch.djwong.org>
 <41c04794-5aef-5e2e-17ad-9ccf8aac488c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41c04794-5aef-5e2e-17ad-9ccf8aac488c@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, May 23, 2017 at 10:47:50AM -0500, Eric Sandeen wrote:
> On 5/23/17 10:46 AM, Darrick J. Wong wrote:
> > On Mon, May 22, 2017 at 07:33:35PM -0500, Eric Sandeen wrote:
> >> After the long discussion about warning the user and/or consumer
> >> of xfs_metadumps about dirty logs, it crossed my mind that we
> >> could use the reserved slot in the metadump header to tag the
> >> file with attributes, so the consumer of the metadump knows how
> >> it was created.
> >>
> >> This patch adds 3 flags to describe the metadump: dirty log,
> >> obfuscated, and full blocks (unused portions of metadata blocks
> >> are not zeroed out).
> >>
> >> It then adds a new option to xfs_mdrestore, "-i" to show info,
> >> which can be used with or without a target file:
> 
> 
> >> +/* mb_flags */
> >> +#define XFS_METADUMP_OBFUSCATED	(1 << 0)
> >> +#define XFS_METADUMP_FULLBLOCKS	(1 << 1)
> >> +#define XFS_METADUMP_DIRTYLOG	(1 << 2)
> > 
> > If we always wrote zero for mb_reserved previously, how do we
> > distinguish between a non-obfuscated partial-block clean-log metadump
> > and an old metadump?  Do we care?
> 
> Oh right.  ;)
> 
> > I imagine metadumps are fairly transitory in nature, so it might not be
> > a big deal, and probably not worth burning 1/8 of our flag-space over
> > since AFAICT we don't use the(se) flags for any serious behavioral
> > changes.
> 
> OTOH, how many flags would we possibly have?  I'm ok with adding a
> "we have flags" flag, too.

We can't extend the metadump header in a backwards compatible way
unless mdrestore already rejects metadumps with non-zero mb_reserved
fields....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
