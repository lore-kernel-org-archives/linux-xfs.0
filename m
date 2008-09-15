Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 14 Sep 2008 19:30:18 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8F2UDWW000318
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 19:30:14 -0700
Message-ID: <48CDCB04.1040402@sgi.com>
Date: Mon, 15 Sep 2008 12:40:04 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Fix use-after-free with log and quotas
References: <48CA2B23.4020405@sgi.com> <20080913040219.GA5811@disturbed>
In-Reply-To: <20080913040219.GA5811@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Fri, Sep 12, 2008 at 06:41:07PM +1000, Lachlan McIlroy wrote:
>> Destroying the quota stuff on unmount can access the log - ie XFS_QM_DONE()
>> ends up in xfs_dqunlock() which calls xfs_trans_unlocked_item() and then
>> xfs_log_move_tail().  By this time the log has already been destroyed.
>> Just move the cleanup of the quota code earlier in xfs_unmountfs() before
>> the call to xfs_log_unmount().  Moving XFS_QM_DONE() up near
>> XFS_QM_DQPURGEALL() seems like a good spot.
> 
> FWIW, has this been actually seen in the real world?
Yes.  And easy to reproduce too.

> 
> xfs_trans_unlocked_item() only does stuff if the log item is in the
> AIL. If we've already destroyed the log, then we should have already
> torn down the AIL and there should be no log items in the system
> that are in the AIL....
That should be the case but clearly not happening.  Pete is investigating
an issue right now where a dquot is not getting removed from the AIL when
it should.  Until we've got to the bottom of that problem I'd prefer to at
least avoid this use after free issue.
