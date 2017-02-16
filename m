Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from special.m3.smtp.beget.ru ([5.101.158.90]:39363 "EHLO
        special.m3.smtp.beget.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751191AbdBPK4e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2017 05:56:34 -0500
Reply-To: apolyakov@beget.ru
Subject: Re: [Bug 192981] New: page allocation stalls
References: <bug-192981-27@https.bugzilla.kernel.org/>
 <20170123135111.13ac3e47110de10a4bd503ef@linux-foundation.org>
 <8f450abd-4e05-92d3-2533-72b05fea2012@beget.ru>
 <20170215160538.GA62565@bfoster.bfoster>
 <a055abbf-a471-d111-9491-dc5b00208228@beget.ru>
 <20170215180859.GB62565@bfoster.bfoster>
From: Alexander Polakov <apolyakov@beget.ru>
Message-ID: <07ee50bc-8220-dda8-07f9-369758603df9@beget.ru>
Date: Thu, 16 Feb 2017 13:56:30 +0300
MIME-Version: 1.0
In-Reply-To: <20170215180859.GB62565@bfoster.bfoster>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-mm@kvack.org, linux-xfs@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org

On 02/15/2017 09:09 PM, Brian Foster wrote:
> Ah, Ok. It sounds like this allows the reclaim thread to carry on into
> other shrinkers and free up memory that way, perhaps. This sounds kind
> of similar to the issue brought up previously here[1], but not quite the
> same in that instead of backing off of locking to allow other shrinkers
> to progress, we back off of memory allocations required to free up
> inodes (memory).
>
> In theory, I think something analogous to a trylock for inode to buffer
> mappings that are no longer cached (or more specifically, cannot
> currently be allocated) may work around this, but it's not immediately
> clear to me whether that's a proper fix (it's also probably not a
> trivial change either). I'm still kind of curious why we end up with
> dirty inodes with reclaimed buffers. If this problem repeats, is it
> always with a similar stack (i.e., reclaim -> xfs_iflush() ->
> xfs_imap_to_bp())?

Looks like it is.

> How many independent filesystems are you running this workload against?

storage9 : ~ [0] # mount|grep storage|grep xfs|wc -l
15
storage9 : ~ [0] # mount|grep storage|grep ext4|wc -l
44

> Can you describe the workload in more detail?

This is a backup server, we're running rsync. At night our production 
servers rsync their files to this server (a lot of small files).

> ...
>>> The bz shows you have non-default vm settings such as
>>> 'vm.vfs_cache_pressure = 200.' My understanding is that prefers
>>> aggressive inode reclaim, yet the code workaround here is to bypass XFS
>>> inode reclaim. Out of curiousity, have you reproduced this problem using
>>> the default vfs_cache_pressure value (or if so, possibly moving it in
>>> the other direction)?
>>
>> Yes, we've tried that, it had about 0 influence.
>>
>
> Which.. with what values? And by zero influence, do you simply mean the
> stall still occurred or you have some other measurement of slab sizes or
> some such that are unaffected?

Unfortunately I don't have slab statistics at hand. Stalls and following 
OOM situation still occured with this setting at 100.

-- 
Alexander Polakov | system software engineer | https://beget.com
