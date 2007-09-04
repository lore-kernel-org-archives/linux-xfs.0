Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 03 Sep 2007 17:49:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l840nO4p024507
	for <xfs@oss.sgi.com>; Mon, 3 Sep 2007 17:49:26 -0700
Message-ID: <46DCAC20.9080002@sgi.com>
Date: Tue, 04 Sep 2007 10:51:44 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: lockdep annotations?
References: <alpine.DEB.0.999.0709012300030.6640@sheep.housecafe.de> <46DB7586.7040309@sgi.com> <20070903090103.GG734179@sgi.com>
In-Reply-To: <20070903090103.GG734179@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christian Kujau <lists@nerdbynature.de>, xfs@oss.sgi.com

David Chinner wrote:
> On Mon, Sep 03, 2007 at 12:46:30PM +1000, Lachlan McIlroy wrote:
>> This is a locking inversion between the iolock and iprune_mutex.  I
>> hadn't seen this one before.  Was your system running low on memory
>> at the time?
>>
>> We can't drop the iolock in the write path so we'll have to avoid
>> acquiring the iolock in xfs_ireclaim() which means we'll need another
>> way to synchronise with xfs_sync_inodes().
> 
> I don't think a deadlock exists here - we have to be going through
> memory reclaim to hit this inversion, so the only place that we
> can deadlock is if we are holding the iprune_mutex across a memory
> allocation. I don't think we do that....
> 
> Not to mention that the inode we hold the iolock on won't be on the
> inode free list so we won't ever try to lock it during reclaim, either.
> 
Yep.  This is just another case where we've confused lockdep.
