Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Sep 2008 23:20:42 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m826Kd0G016182
	for <xfs@oss.sgi.com>; Mon, 1 Sep 2008 23:20:39 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B5571BCD806
	for <xfs@oss.sgi.com>; Mon,  1 Sep 2008 23:22:04 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id y4IiHRZcm8Tttr7l for <xfs@oss.sgi.com>; Mon, 01 Sep 2008 23:22:04 -0700 (PDT)
Date: Tue, 2 Sep 2008 16:21:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Filesystem corruption writing out unlinked inodes
Message-ID: <20080902062155.GE15962@disturbed>
References: <48BCC5B1.7080300@sgi.com> <20080902051524.GC15962@disturbed> <48BCD622.1080406@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BCD622.1080406@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 02, 2008 at 03:58:58PM +1000, Lachlan McIlroy wrote:
> Dave Chinner wrote:
>> On Tue, Sep 02, 2008 at 02:48:49PM +1000, Lachlan McIlroy wrote:
>> This is supposed to catch all the inodes in memory and mark them
>> XFS_ISTALE to prevent them from being written back once the
>> transaction is committed. The question is - how are dirty inodes
>> slipping through this?
>>
>> If we are freeing the cluster buffer, then there can be no other
>> active references to any of the inodes, so if they are dirty it
>> has to be due to inactivation transactions and so should be in
>> the log and attached to the buffer due to removal from the
>> unlinked list.
>>
>> The question is - which bit of this is not working? i.e. what is the
>> race condition that is allowing dirty inodes to slip through the
>> locking here?
>>
>> Hmmm - I see that xfs_iflush() doesn't check for XFS_ISTALE when
>> flushing out inodes. Perhaps you could check to see if we are
>> writing an inode marked as such.....
>
> That's what I was suggesting. 

I'm not suggesting that as a fix. I'm suggesting that you determine
whether the inode being flushed has that flag set or not. If it is
not set, then we need to determine how it slipped through
xfs_ifree_cluster() without being marked XFS_ISTALE, and if it is
set, why it was not marked clean by xfs_istale_done() when the
buffer callbacks are made and the flush lock dropped....

> I'm just not sure about the assumption
> that if the flush lock cannot be acquired in xfs_ifree_cluster() then
> the inode must be in the process of being flushed. The flush could
> be aborted due to the inode being pinned or some other case and the
> inode never gets marked as stale.

Did that happen?

Basically I'm asking what the sequence of events is that leads up
to this problem - we need to identify the actual race condition
before speculating on potential fixes....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
