Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51968 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752251AbeGDSlP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jul 2018 14:41:15 -0400
Date: Wed, 4 Jul 2018 11:40:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/21] xfs: repair the rmapbt
Message-ID: <20180704184059.GF32415@magnolia>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986827881.3155.10096839660329617215.stgit@magnolia>
 <20180703053200.GH2234@dastard>
 <20180703235901.GY32415@magnolia>
 <20180704084438.lfxk22xg52vkzzqd@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180704084438.lfxk22xg52vkzzqd@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: cmaiolino@redhat.com

On Wed, Jul 04, 2018 at 10:44:38AM +0200, Carlos Maiolino wrote:
> > [some of this Dave and I discussed on IRC, so I'll summarize for
> > everyone else here...]
> > 
> > For this initial v0 iteration of the rmap repair code, yes, we have to
> > freeze the fs and iterate everything.  However, unless your computer and
> > storage are particularly untrustworthy, rmapbt reconstruction should be
> > a very infrequent thing.  Now that we have a FREEZE_OK flag, userspace
> > has to opt-in to slow repairs, and presumably it could choose instead to
> > unmount and run xfs_repair if that's too dear or there are too many
> > broken AGs, etc.  More on that later.
> > 
> > In the long run I don't see a need to freeze the filesystem to scan
> > every inode for bmbt entries in the damaged AG.  In fact, we can improve
> > the performance of all the AG repair functions in general with the
> > scheme I'm about to outline:
> > 
> > Create a "shut down this AG" primitive.  Once set, block and inode
> > allocation routines will bypass this AG.  Unlinked inodes are moved to
> > the unlinked list to avoid touching as much of the AGI as we practically
> > can.  Unmapped/freed blocks can be moved to a hidden inode (in another
> > AG) to be freed later.  Growfs operation in that AG can be rejected.
> > 
> 
> Does it mean that new block allocation requestsvfor inodes already existing in
> the frozen AG will block until the AG is thawed, or these block allocations
> will be redirected to another AG? I'm just asking because in either case, we
> should document it well. The repair case is certainly (or should be) a rare
> case, but if there is any heavy workload going on on the frozen AG, and we
> redirect it to another AG, it can end up heavily fragmenting the files on the
> frozen AG.
> So, I wonder if any operation to the AG under repair should actually be blocked
> too?

I don't think that will be possible for rmapbt repair -- we need to be
able to take locks in the wrong order (agf -> inodes) without
deadlocking with a regular operation that's blocked on the AG (inodes ->
agf).  The freezer mechanism eliminates the deadlock possibility by
eliminating the regular IO paths, so this proposed AG shutdown would
also have to protect against that by absorbing operations.

--D

> Cheers
> 
> 
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
