Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51758 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751693AbdAMOZZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Jan 2017 09:25:25 -0500
Date: Fri, 13 Jan 2017 09:25:25 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix eofblocks race with file extending async dio
 writes
Message-ID: <20170113142524.GD22013@bfoster.bfoster>
References: <1484156571-65403-1-git-send-email-bfoster@redhat.com>
 <20170112135603.GD5756@infradead.org>
 <20170112140559.GD14085@bfoster.bfoster>
 <20170113073315.GA30685@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170113073315.GA30685@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 12, 2017 at 11:33:15PM -0800, Christoph Hellwig wrote:
> On Thu, Jan 12, 2017 at 09:05:59AM -0500, Brian Foster wrote:
> > !need_iolock means the iolock is already held. I guess the name is kind
> > of confusing. !need_iolock doesn't mean that the lock is unnecessary, it
> > just means that we're calling from a context where it's already held.
> > See the xfs_icache_free_eofblocks() call from
> > xfs_file_buffered_aio_write() for reference.
> > 
> > I suppose I could add an ASSERT(xfs_isilocked()) after that block to
> > better document that..
> 
> Yeah.  In fact I'd prefer to kill that parameter at all, it's horrible.
> Instead we should always expect the lock and assert that it's held,
> and have the two current need_iolock = false callers take it manually.
> 

I may have lied about iolock holders.. I don't think we have the iolock
in the xfs_inactive() case. That said, I don't think there's any harm in
doing so there. It may have just been that way since we're breaking down
the inode in that context.

I agree that this is ugly. I'll try to kill off that param as suggested.

> This will increase lock hold times a bit for the current need_iolock
> callers, but the most important one, xfs_release already does a
> previous unlocked xfs_can_free_eofblocks check, and
> xfs_inode_free_eofblocks is only called it the inode is tagged, so this
> should not be an issue (and if it is a xfs_can_free_eofblocks call
> comes to rescue).
> 

The need_iolock case is also currently a trylock, so I think we can
retain that logic in the release case without being disruptive.

> Btw, there is a comment incorrectly referring to xfs_free_eofblocks
> in xfs_inode_free_cowblocks while we're at it.

I would send that as a standalone patch because it's an entirely
separate feature (and causes unnecessary backport churn, even though
it's just a comment), so I'm not sure it's really worth fixing with this
series.

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
