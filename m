Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Oct 2006 21:26:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9K4QVaG003063
	for <xfs@oss.sgi.com>; Thu, 19 Oct 2006 21:26:32 -0700
Message-ID: <45384FC6.5040000@ah.jp.nec.com>
Date: Fri, 20 Oct 2006 13:25:42 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
MIME-Version: 1.0
Subject: Re: [patch] Fix xfs_iunpin() sets I_DIRTY_SYNC after clear_inode().
References: <45237CCE.4010007@ah.jp.nec.com> <20061006032617.GC11034@melbourne.sgi.com> <20061011064357.GN19345@melbourne.sgi.com> <452E32FF.8010109@ah.jp.nec.com> <20061013014651.GC19345@melbourne.sgi.com> <452F83BD.8050501@ah.jp.nec.com> <20061017020218.GE8394166@melbourne.sgi.com> <20061018023325.GL8394166@melbourne.sgi.com> <20061018090701.GU11034@melbourne.sgi.com> <4536E186.5040301@ah.jp.nec.com> <20061019045851.GZ11034@melbourne.sgi.com>
In-Reply-To: <20061019045851.GZ11034@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

Hi,

David Chinner wrote:
> I don't think so - in the lookup code where we find an existing
> inode, we don't destroy the inode if XFS_IRECLAIMABLE is set.
> Instead we do a log force and repeat the lookup. We only destroy
> the inode in xfs_iget_core() if we raced with another thread
> reading the inode in off disk after the cache lookup has
> failed. In this case, we free the inode we read off disk which,
> by definition, cannot be dirty or pinned at this point so we
> don't need to wait for anything to be unpinned.
> 
> In the case of reclaim, when we flush a dirty inode we already
> do a xfs_iunpin_wait() (xfs_finish_reclaim()->xfs_iflush()->wait)
> so we should never get to the point of xfs_idestroy with an inode
> that is still pinned.
> 
> Hence I don't think this is patch is necessary. Did I miss something
> that I shouldn't have, Takenori?

Sorry, you are right. I forgot xfs_iget_core() was modified that it don't reuse
xfs_inode while i_pincount > 0.

> 
> FYI, the three patches have survived my testing for almost a day now,
> so if they pass your testing I think we have a viable fix. I'll
> sned out a set of updated patches later this afternoon.

Your patches have been working well for 20 hours. I intend to continue
testing your patches until next Monday, and I'll report the result.

Best Regards,
-- 
Takenori Nagano
<t-nagano@ah.jp.nec.com>
