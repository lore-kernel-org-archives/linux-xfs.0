Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Oct 2007 01:43:11 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l928h7iC021081
	for <xfs@oss.sgi.com>; Tue, 2 Oct 2007 01:43:08 -0700
Date: Tue, 2 Oct 2007 04:43:07 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [GIT PULL] XFS update for 2.6.23 - revert a commit
In-Reply-To: <4701ED51.8050706@sgi.com>
Message-ID: <Pine.LNX.4.64.0710020442540.24427@p34.internal.lan>
References: <20071001072350.DF61C58C4C0A@chook.melbourne.sgi.com>
 <4700EE2A.1020304@sandeen.net> <4701A1D0.5010709@sgi.com> <4701ED51.8050706@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Timothy Shimmin <tes@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com



On Tue, 2 Oct 2007, Lachlan McIlroy wrote:

> Timothy Shimmin wrote:
>> Eric Sandeen wrote:
>>> Tim Shimmin wrote:
>>>> Hi Linus,
>>>> 
>>>> A problem has been found for the XFS commit 
>>>> b394e43e995d08821588a22561c6a71a63b4ff27
>>>> and it needs to be reverted.
>>>> It has the potential for worse corruption than what it is meant to fix.
>>> 
>>> 
>>> Whoops... that's what I get for picking it up too soon for fedora I guess!
>>> 
>>> Any background on the newly-found problem, for those of us in the peanut
>>> gallery?
>>> 
>>> Thanks,
>>> 
>>> -Eric
>> 
>> Hi Eric,
>> 
>> Lachlan worked this problem so he can probably provide more details.
>> My understanding is that we were having a problem with the log replay
>> replaying newly allocated inodes (inodes from buffer items) over the top
>> of buffers which were actually more up-to-date than what was logged.
>> The code used a heuristic to determine if the buffer had been written
>> to for the inode (by checking on magic#, mode and gen# - not going to
>> comment on this).
>> Anyway, it comes down to either copying over the inode buf data or not
>> copying it over (doing or not doing the log replay).
>> The change could cause the buffer to be not overwritten in replay
>> where previously it would be.
>> We want this to not happen as part of the fix and doing the right thing
>> and not by mistake and failing to replay when we need it to be replayed.
>> I presume the latter is what is happening.
>> The symptoms of this is what Lachlan has discovered in QA on a debug
>> kernel and he can provide the details.
>> 
>> I believe this started from not logging the inode size changes
>> (as is consistent with the logging model) for performance reasons,
>> and so we can't rely on inode log items coming up on log replay
>> to fix things up.
>> 
>> BTW, we currently have 3 ways of logging an inode:
>> 1. in an item buffer and marked as an inode
>> 2. in an item buffer and not marked as an inode
>> 3. in an inode item
>> 
>> and 3 places where they get replayed:
>> 1. xlog_recover_do_inode_buffer - for di_next_unlinked pointer recovery
>> 2. xlog_recover_do_reg_buffer - for newly allocated inode recovery
>> 3. xlog_recover_do_inode_trans - for general inode recovery
>> 
>> The fix was in #2.
>> 
>> 
>> Ughh.
>
> Yeah that about sums it up.  In an attempt to prevent log replay of inodes
> in cases when we shouldn't replay we also prevented log replay of inodes in
> cases when we should replay.  We end up with directories that refer to inodes
> that were not replayed and we read existing data off disk.  That existing
> data is usually previous instances of inodes.  We had cases of regular files
> turning into directories and inode version mismatches.
>
> Lachlan
>
In 2.6.23-rc8?
