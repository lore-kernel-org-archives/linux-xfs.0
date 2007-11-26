Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 Nov 2007 19:24:21 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAQ3OEw6021859
	for <xfs@oss.sgi.com>; Sun, 25 Nov 2007 19:24:16 -0800
Message-ID: <474A3A92.2040200@sgi.com>
Date: Mon, 26 Nov 2007 14:16:34 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] Delayed logging of file sizes
References: <47467B87.2000000@sgi.com> <20071125225928.GE114266761@sgi.com> <474A112D.2040006@sgi.com> <20071126011044.GG114266761@sgi.com> <474A2180.7000605@sgi.com> <20071126021515.GH114266761@sgi.com>
In-Reply-To: <20071126021515.GH114266761@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> On Mon, Nov 26, 2007 at 12:29:36PM +1100, Lachlan McIlroy wrote:
>> David Chinner wrote:
>>> On Mon, Nov 26, 2007 at 11:19:57AM +1100, Lachlan McIlroy wrote:
>>>> David Chinner wrote:
>>>>> On Fri, Nov 23, 2007 at 06:04:39PM +1100, Lachlan McIlroy wrote:
>>>>>> The easy solution is to log everything so that log replay doesn't need
>>>>>> to check if the on-disk version is newer - it can just replay the log.
>>>>>> But logging everything would cause too much log traffic so this patch
>>>>>> is a compromise and it logs a transaction before we flush an inode to
>>>>>> disk only if it has changes that have not yet been logged.
>>>>> The problem with this is that the inode will be marked dirty during the
>>>>> transaction, so we'll never be able to clean an inode if we issue a
>>>>> transaction during inode writeback.
>>>> Ah, yeah, good point.  I wrote this patch back before that "dirty inode
>>>> on transaction" patch went in.
>>> Wouldn't have made aany difference - the inode woul dbe marked dirty
>>> at transaction completion...
>>>
>>>> For this transaction though the changes
>>>> to the inode have already been made (ie when we set i_update_core and
>>>> called mark_inode_dirty_sync()) so there is no need to dirty it in this
>>>> transaction.  I'll keep digging.  Thanks.
>>> I wouldn't worry too much about this problem right now - I'm working
>>> on moving the dirty state into the inode radix trees so i_update_core
>>> might even go away completely soon....
>>>
>> Which problem?  Just the bit about dirtying the inode or will your changes
>> allow us to log all inode changes?
> 
> Trying to change XFS to logging all updates.

That would be great.  But what about the increase in log traffic that has
deterred us from doing this in the past?

> 
>> What's the motivation for moving the dirty state?
> 
> Better inode writeback clustering. i.e. it's easy to find all the dirty
> inodes and then we can write them in larger contiguous chunks. The first
> "hack" at this I did tracked only inodes in the AIL. Sequential create
> of small files improved by about 20% with better clustering during
> tail pushing operations. I'm trying to make it track all dirty inodes
> at this point (via ->dirty_inode). This may mean that i_update_core
> is not needed to track whether an inode needs writeback or not.

Okay, I'm interested to see what you come up with.

> 
> Not to mention all that horrible IPOINTER crap can get removed from 
> xfs_sync_inodes() because finding dirty inodes is now a lockless radix
> tree traverse based on a dirty tag lookup.

Oh good, that macro hackery is ugly.

> 
> That also means the global mount inodes list can be replaced by a lockless radix
> tree traverse, so we can lose another 2 pointers in the xfs_inode_t and lock
> operations out of the inode get and reclaim paths.
> 
