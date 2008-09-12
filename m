Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 12 Sep 2008 01:42:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8C8gBVE008892
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 01:42:11 -0700
Date: Fri, 12 Sep 2008 04:43:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Fix use-after-free with log and quotas
Message-ID: <20080912084340.GA11098@infradead.org>
References: <48CA2B23.4020405@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48CA2B23.4020405@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Sep 12, 2008 at 06:41:07PM +1000, Lachlan McIlroy wrote:
> Destroying the quota stuff on unmount can access the log - ie XFS_QM_DONE()
> ends up in xfs_dqunlock() which calls xfs_trans_unlocked_item() and then
> xfs_log_move_tail().  By this time the log has already been destroyed.
> Just move the cleanup of the quota code earlier in xfs_unmountfs() before
> the call to xfs_log_unmount().  Moving XFS_QM_DONE() up near
> XFS_QM_DQPURGEALL() seems like a good spot.

Yeah, I have something like this in my large mount/unmount audit.

Looks good, and I have to rebase all the other changes anyway.
