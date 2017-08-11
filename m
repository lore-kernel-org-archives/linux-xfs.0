Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38053 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752959AbdHKQwG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 12:52:06 -0400
Date: Fri, 11 Aug 2017 09:51:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] xfs: evict all inodes involved with log redo item
 recovery
Message-ID: <20170811165136.GD24087@magnolia>
References: <150234262066.13754.6534116056866237943.stgit@magnolia>
 <150234263191.13754.5037661818451431724.stgit@magnolia>
 <20170810145126.GC3777@bfoster.bfoster>
 <20170810171851.GW24087@magnolia>
 <20170811112203.GC27964@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170811112203.GC27964@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Fri, Aug 11, 2017 at 04:22:03AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 10, 2017 at 10:18:51AM -0700, Darrick J. Wong wrote:
> > I felt there's less messing around with vfs internals by sticking to
> > igrab and iput (and letting them deal with the internal inode state)
> > since that's what xfs uses elsewhere to manage inode life cycles.
> 
> I'd feel much safer calling evict_inodes rather than reimplementing
> it poorly.  In fact we might want to just call it in the VFS after
> a failed mount?

I don't think we can call it in the vfs after a failed mount since by
that time we've pulled down all the fs-specific stuff by then, right?

In any case I think it's only xfs that needs this, since (afaict) the
ones I looked at don't set MS_ACTIVE in fill_super and have a small
set of inodes that they explicitly iget and iput.

> Either way please also add Al to the Cc for the next version.

Ok.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
