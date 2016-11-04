Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31877 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932486AbcKDDOx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2016 23:14:53 -0400
Date: Thu, 3 Nov 2016 20:14:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: mount with corrupted inopblock in superblock
Message-ID: <20161104031445.GD32036@birch.djwong.org>
References: <1478166720-14354-1-git-send-email-eguan@redhat.com>
 <20161104005433.GF28177@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161104005433.GF28177@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, Nov 04, 2016 at 11:54:34AM +1100, Dave Chinner wrote:
> On Thu, Nov 03, 2016 at 05:52:00PM +0800, Eryu Guan wrote:
> > When sb_inopblock is corrupted (out of boundary in this case), XFS
> > should not crash and refuse to mount.
> > 
> > Kernel commit 392c6de98af1 ("xfs: sanitize sb_inopblock in
> > xfs_mount_validate_sb") addresses this issue.
> 
> Ok, seems like something addressed by the fuzzing tests, but we can
> ignore that for now.
> 
> > +_scratch_mkfs >>$seqres.full
> > +
> > +# corrupt sb_inopblock
> > +_scratch_xfs_db -x -c "sb 0" -c "write -c inopblock 512" >>$seqres.full
> > +
> > +# mount corrupted fs
> > +_scratch_mount >>$seqres.full 2>&1
> > +
> > +# no crash, and SCRATCH_DEV should not be mounted either
> > +_is_mounted $SCRATCH_DEV
> 
> Rather than test that we caught /one/ corrupt field, why not
> loop here corrupting each superblock field in turn and checking
> that the corruption is caught properly?
> 
> i.e. shouldn't we be proactively testing that we're catching all the
> obvious corruptions, rather than just testing the out-of-bounds
> issues that we've already found and fixed?

I've been working on xfstests that do exactly that for a while now and
am getting ready to do a big patch dump of online scrub/repair + more
dangerous_fuzzers tests to see how well the recovery tools work.

In the meantime I doubt it hurts to have this regression test while I
get my act together. :)

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
