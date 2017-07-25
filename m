Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41139 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752425AbdGYQgR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jul 2017 12:36:17 -0400
Date: Tue, 25 Jul 2017 09:36:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] docs: record the metadump file format
Message-ID: <20170725163612.GD4369@magnolia>
References: <20170615220002.GB4530@birch.djwong.org>
 <20170725162054.GG18884@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170725162054.GG18884@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>

[cc xfs]

On Tue, Jul 25, 2017 at 06:20:54PM +0200, Luis R. Rodriguez wrote:
> On Thu, Jun 15, 2017 at 03:00:02PM -0700, Darrick J. Wong wrote:
> > Document the metadump file format.
> 
> Thanks for all this! I have started wondering all this and was
> curious if there are perhaps more docs about the format or more
> practical docs which can help one go read the dumps and help
> analyze through examples.
> 
> > --- /dev/null
> > +++ b/design/XFS_Filesystem_Structure/metadump.asciidoc
> > +== Dump Obfuscation
> > +
> > +Unless explicitly disabled, the +xfs_metadump+ tool obfuscates empty block
> > +space and naming information to avoid leaking sensitive information into
> > +the metadump file.  +xfs_metadump+ does not copy user data blocks.
> > +
> > +The obfuscation policy is as follows:
> > +
> > +* File and extended attribute names are both considered "names".
> > +* Names longer than 8 characters are totally rewritten with a name that matches the hash of the old name.
> > +* Names between 5 and 8 characters are partially rewritten to match the hash of the old name.
> 
> Any reason for this?

/me doesn't know.  Maybe it's too hard to generate a new name with the
same hash?

> > +* Names shorter than 5 characters are not obscured at all.
> 
> This does not seem like a good idea, do we have a record of why this was done
> historically?
> 
> > +* Names that cross a block boundary are not obscured at all.
> 
> Likewise.

iirc we basically copy things a block at a time, which makes it harder
to deal with multi-fsblock dirblocks (???)

I don't really know, let's see if the list remembers. :)

--D

> 
>   Luis
