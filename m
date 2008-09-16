Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 21:07:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8G4703D030453
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 21:07:00 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A29A212755AA
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 21:08:31 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id jGeIPc3xgNdCjLGC for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 21:08:31 -0700 (PDT)
Date: Tue, 16 Sep 2008 14:08:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Fix use-after-free with log and quotas
Message-ID: <20080916040825.GO5811@disturbed>
References: <48CA2B23.4020405@sgi.com> <20080913040219.GA5811@disturbed> <48CDCB04.1040402@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48CDCB04.1040402@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Sep 15, 2008 at 12:40:04PM +1000, Lachlan McIlroy wrote:
> Dave Chinner wrote:
>> On Fri, Sep 12, 2008 at 06:41:07PM +1000, Lachlan McIlroy wrote:
>>> Destroying the quota stuff on unmount can access the log - ie XFS_QM_DONE()
>>> ends up in xfs_dqunlock() which calls xfs_trans_unlocked_item() and then
>>> xfs_log_move_tail().  By this time the log has already been destroyed.
>>> Just move the cleanup of the quota code earlier in xfs_unmountfs() before
>>> the call to xfs_log_unmount().  Moving XFS_QM_DONE() up near
>>> XFS_QM_DQPURGEALL() seems like a good spot.
>>
>> FWIW, has this been actually seen in the real world?
> Yes.  And easy to reproduce too.

Care to provide details about the test case, then? I can't help if
you keep me in the dark....

>> torn down the AIL and there should be no log items in the system
>> that are in the AIL....
> That should be the case but clearly not happening.  Pete is investigating
> an issue right now where a dquot is not getting removed from the AIL when
> it should.  Until we've got to the bottom of that problem I'd prefer to at
> least avoid this use after free issue.

No point in putting a bandaid in if you're already in the process of
trying to find the real cause....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
