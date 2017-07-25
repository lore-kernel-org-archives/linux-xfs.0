Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:14706 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751210AbdGYXZk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jul 2017 19:25:40 -0400
Date: Wed, 26 Jul 2017 09:25:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] docs: record the metadump file format
Message-ID: <20170725232536.GJ17762@dastard>
References: <20170615220002.GB4530@birch.djwong.org>
 <20170725162054.GG18884@wotan.suse.de>
 <20170725163612.GD4369@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170725163612.GD4369@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Tue, Jul 25, 2017 at 09:36:12AM -0700, Darrick J. Wong wrote:
> [cc xfs]
> 
> On Tue, Jul 25, 2017 at 06:20:54PM +0200, Luis R. Rodriguez wrote:
> > On Thu, Jun 15, 2017 at 03:00:02PM -0700, Darrick J. Wong wrote:
> > > Document the metadump file format.
> > 
> > Thanks for all this! I have started wondering all this and was
> > curious if there are perhaps more docs about the format or more
> > practical docs which can help one go read the dumps and help
> > analyze through examples.
> > 
> > > --- /dev/null
> > > +++ b/design/XFS_Filesystem_Structure/metadump.asciidoc
> > > +== Dump Obfuscation
> > > +
> > > +Unless explicitly disabled, the +xfs_metadump+ tool obfuscates empty block
> > > +space and naming information to avoid leaking sensitive information into
> > > +the metadump file.  +xfs_metadump+ does not copy user data blocks.
> > > +
> > > +The obfuscation policy is as follows:
> > > +
> > > +* File and extended attribute names are both considered "names".
> > > +* Names longer than 8 characters are totally rewritten with a name that matches the hash of the old name.
> > > +* Names between 5 and 8 characters are partially rewritten to match the hash of the old name.
> > 
> > Any reason for this?
> 
> /me doesn't know.  Maybe it's too hard to generate a new name with the
> same hash?
>
> > > +* Names shorter than 5 characters are not obscured at all.
> > 
> > This does not seem like a good idea, do we have a record of why this was done
> > historically?

It was done because of mathematics. This is all "IIRC" off the top
of my head....

The hash we calculate is 4 bytes long, so we can't calculate a hash
collision from less than 5 bytes of input. i.e. 4 bytes + 1 byte
to cause collision is the shortest we can obfuscate, but one byte of
"name overwrite" isn't enough to find collisions if all 4 of the
first 4 bytes are randomly chosen.

Hence for names 5-8 bytes in length we are limited to 1 byte of
correction for each of the first 4 bytes that is randomised. Hence
it's not until filenames are longer than 8 bytes that we can
generate a truly random filename that causes a hash collision.

> > > +* Names that cross a block boundary are not obscured at all.
> > 
> > Likewise.
> 
> iirc we basically copy things a block at a time, which makes it harder
> to deal with multi-fsblock dirblocks (???)

Discontiguous multi-block directories should be handled
transparently for xfs_db via libxfs buffers now. Maybe metadump
doesn't use these for dumping directory blocks? Also, We shouldn't
be splitting names and values across da block boundaries - we leave
free space in the block and allocate a new one if it doesn't fit....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
