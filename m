Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 23:26:49 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8G6QkHC008705
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 23:26:46 -0700
Message-ID: <48CF53F9.7060102@sgi.com>
Date: Tue, 16 Sep 2008 16:36:41 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Fix use-after-free with log and quotas
References: <48CA2B23.4020405@sgi.com> <20080913040219.GA5811@disturbed> <48CDCB04.1040402@sgi.com> <20080916040825.GO5811@disturbed>
In-Reply-To: <20080916040825.GO5811@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Mon, Sep 15, 2008 at 12:40:04PM +1000, Lachlan McIlroy wrote:
>> Dave Chinner wrote:
>>> On Fri, Sep 12, 2008 at 06:41:07PM +1000, Lachlan McIlroy wrote:
>>>> Destroying the quota stuff on unmount can access the log - ie XFS_QM_DONE()
>>>> ends up in xfs_dqunlock() which calls xfs_trans_unlocked_item() and then
>>>> xfs_log_move_tail().  By this time the log has already been destroyed.
>>>> Just move the cleanup of the quota code earlier in xfs_unmountfs() before
>>>> the call to xfs_log_unmount().  Moving XFS_QM_DONE() up near
>>>> XFS_QM_DQPURGEALL() seems like a good spot.
>>> FWIW, has this been actually seen in the real world?
>> Yes.  And easy to reproduce too.
> 
> Care to provide details about the test case, then? I can't help if
> you keep me in the dark....
XFSQA test 083 hits this almost every run when quotas are enabled.

> 
>>> torn down the AIL and there should be no log items in the system
>>> that are in the AIL....
>> That should be the case but clearly not happening.  Pete is investigating
>> an issue right now where a dquot is not getting removed from the AIL when
>> it should.  Until we've got to the bottom of that problem I'd prefer to at
>> least avoid this use after free issue.
> 
> No point in putting a bandaid in if you're already in the process of
> trying to find the real cause....
It's not a band-aid - it's a perfectly valid change to make.  We don't
know if this other problem is related nor do we know if it will fix this
use-after-free either.  There's no reason to let other people hit this
panic if we can avoid it.
