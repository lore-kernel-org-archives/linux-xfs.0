Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:53714 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726907AbfCTVjh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Mar 2019 17:39:37 -0400
Date: Thu, 21 Mar 2019 08:39:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: generic/475 deadlock?
Message-ID: <20190320213933.GT23020@dastard>
References: <20190320050408.GA24923@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320050408.GA24923@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Mar 19, 2019 at 10:04:08PM -0700, Darrick J. Wong wrote:
> Hmmm.
> 
> Every now and then I see a generic/475 deadlock that generates the
> hangcheck warning pasted below.
> 
> I /think/ this is ... the ail is processing an inode log item, for which
> it locked the cluster buffer and pushed the cil to unpin the buffer.
> However, the cil is cleaning up after the shut down and is trying to
> simulate an EIO completion, but tries grabs the buffer lock and hence
> the cil and ail deadlock.  Maybe the solution is to trylock in the
> (freed && remove) case of xfs_buf_item_unpin, since we're tearing the
> whole system down anyway?

Oh, that's looks like a bug in xfs_iflush() - we are forcing the log
to unpin a buffer we already own the lock on. It's the same problem
we had in the discard code fixed by commit 8c81dd46ef3c ("Force log
to disk before reading the AGF during a fstrim").

It also means that the log forces in the busy extent code have the
same potential problem, as does xfs_qm_dqflush().

I'll move further down the discussion now....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
