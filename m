Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:17980 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725926AbeJaFGk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Oct 2018 01:06:40 -0400
Date: Wed, 31 Oct 2018 07:11:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/7] Revert "xfs_repair: treat zero da btree pointers as
 corruption"
Message-ID: <20181030201140.GM19305@dastard>
References: <20181030112043.6034-1-david@fromorbit.com>
 <20181030112043.6034-2-david@fromorbit.com>
 <20181030172039.GG4135@magnolia>
 <3781527d-4691-1c74-8e18-43bae49f44ff@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3781527d-4691-1c74-8e18-43bae49f44ff@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Tue, Oct 30, 2018 at 02:35:29PM -0500, Eric Sandeen wrote:
> 
> 
> On 10/30/18 12:20 PM, Darrick J. Wong wrote:
> > On Tue, Oct 30, 2018 at 10:20:37PM +1100, Dave Chinner wrote:
> >> This reverts commit 67a79e2cc9320aaf269cd00e9c8d16892931886d.
> >>
> >> A root LEAFN block can exist in a directory. When we convert from
> >> leaf format (LEAF1 - internal free list) to node format (LEAFN -
> >> external free list) the only change to the single root leaf block is
> >> that it's magic number is changed from LEAF1 to LEAFN.
> >>
> >> We don't actually end up with DA nodes in the tree until the LEAFN
> >> node is split, and that requires a couple more dirents to be added
> >> to the directory to fill the LEAFN block up completely. Then it will
> >> split and create a DA node root block pointing to multiple LEAFN
> >> leaf blocks.
> >>
> >> Hence restore the old behaviour where we skip the DA node tree
> >> rebuild if there is a LEAFN root block found as there is no tree to
> >> rebuild.
> > 
> > The trouble with reverting the patch is that xfs_repair goes back to
> > tripping over an assertion in release_da_cursor_int if the reason why
> > we got bno == 0 is that the directory has a da btree block with
> > nbtree[0].before pointing to zero.
> > 
> > Will post a better fix + regression tests for both issues shortly.
> 
> Well let's discuss pros/cons & risks/rewards on that, I'm semi-inclined
> to just revert it for 4.19 and fix it properly in 4.20, because I don't think
> it's ever been seen in the wild...?

I'd prefer a revert if we are closing on a release.

A fix is essentially going to have to first revert the change
anyway, so if the replacement fix is simple and tesed then it can
just go straight in on top of the revert...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
