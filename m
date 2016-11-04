Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:57565 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754319AbcKDAyv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2016 20:54:51 -0400
Date: Fri, 4 Nov 2016 11:54:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: mount with corrupted inopblock in superblock
Message-ID: <20161104005433.GF28177@dastard>
References: <1478166720-14354-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1478166720-14354-1-git-send-email-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Nov 03, 2016 at 05:52:00PM +0800, Eryu Guan wrote:
> When sb_inopblock is corrupted (out of boundary in this case), XFS
> should not crash and refuse to mount.
> 
> Kernel commit 392c6de98af1 ("xfs: sanitize sb_inopblock in
> xfs_mount_validate_sb") addresses this issue.

Ok, seems like something addressed by the fuzzing tests, but we can
ignore that for now.

> +_scratch_mkfs >>$seqres.full
> +
> +# corrupt sb_inopblock
> +_scratch_xfs_db -x -c "sb 0" -c "write -c inopblock 512" >>$seqres.full
> +
> +# mount corrupted fs
> +_scratch_mount >>$seqres.full 2>&1
> +
> +# no crash, and SCRATCH_DEV should not be mounted either
> +_is_mounted $SCRATCH_DEV

Rather than test that we caught /one/ corrupt field, why not
loop here corrupting each superblock field in turn and checking
that the corruption is caught properly?

i.e. shouldn't we be proactively testing that we're catching all the
obvious corruptions, rather than just testing the out-of-bounds
issues that we've already found and fixed?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
