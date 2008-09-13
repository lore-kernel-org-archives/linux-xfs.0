Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 12 Sep 2008 21:00:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8D40qGh002601
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 21:00:53 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 89BFA8D6A3C
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 21:02:22 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id A3mqHVpGgyEEqhBx for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 21:02:22 -0700 (PDT)
Date: Sat, 13 Sep 2008 14:02:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Fix use-after-free with log and quotas
Message-ID: <20080913040219.GA5811@disturbed>
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

FWIW, has this been actually seen in the real world?

xfs_trans_unlocked_item() only does stuff if the log item is in the
AIL. If we've already destroyed the log, then we should have already
torn down the AIL and there should be no log items in the system
that are in the AIL....

What am I missing here?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
