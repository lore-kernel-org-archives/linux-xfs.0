Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22359 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752498AbdJTXee (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 19:34:34 -0400
Date: Fri, 20 Oct 2017 16:34:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 14/30] xfs: scrub the secondary superblocks
Message-ID: <20171020233432.GA4755@magnolia>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777253648.1724.14074690877454400591.stgit@magnolia>
 <20171016051644.GH3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171016051644.GH3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 16, 2017 at 04:16:44PM +1100, Dave Chinner wrote:
> On Wed, Oct 11, 2017 at 06:42:16PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Ensure that the geometry presented in the backup superblocks matches
> > the primary superblock so that repair can recover the filesystem if
> > that primary gets corrupted.
> 
> I've noticed that scrub on certain fstests will report PREEN for
> secondary superblocks and repair thinks there is nothing wrong and
> doesn't fix them. I'm not sure which field it's complaining about,
> but at this point I don't see this as a blocker. Follow up patches
> would be fine.

These are the sb fields that currently trigger preen reports:

rootino rbmino rsumino imax_pct uquotino gquotino pquotino unit width
uuid fname

rootino: This will always be the first inode in the first possible
inode cluster in the filesystem, right?  mkfs copies rootino to the last
and the middle superblock, though if the location is fixed then we don't
strictly need to propagate it, do we?

rbmino/rsumino: have fixed ino numbers (rootino + 1 and + 2,
respectively) and are always rebuilt by repair.

uquotino/gquotino/pquotino can be totally rebuilt by quotacheck, right?
So if repair zaps these (and it does) either as part of a secondary ->
primary rebuild or for any other reason then it doesn't matter.

imax_pct: only set by mkfs and copied to all the other sb's.   This
might be mislabeled as a preen.

uuid/fname: seems to be set in all sb copies by xfs_db.  Maybe this one
is mislabeled?

unit/width: will be copied into sb 0 from mount options.  We only lose
information if repair recovers the primary sb and the mount options
don't include unit/width information.

Now for sb_versionnum, sb_version2, and the v5 feature bits:

versionnum: quotabit is turned on any time we mount with quota, and
quota has to be activated with mount options, right?

nlinkbit is always turned on at mount time...

versionnum attrbit: turned on any time we set an attr, and nothing much
(other than setting attr/attr2 bits in the sb) seem to depend on whether
or not this is set.

features2 attr2bit: I think the attr2 bit can be controlled by mounting
with 'attr2' and 'noattr2', right?  So, similar to unit/width we only
lose information if repair recovers a superblock and the mount options
don't include attr2 information, and even then XFS seems to like to turn
it on except in the noattr2 case.

So I get the impression that I might be able to turn uuid/fname/imax_pct
into regular _corrupt checks since (AFAICT) xfsprogs actually updates
them correctly, and simply drop the other fields from checking.

--D

> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
