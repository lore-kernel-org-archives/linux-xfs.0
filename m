Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 26 Nov 2007 19:31:31 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAR3VMrZ016411
	for <xfs@oss.sgi.com>; Mon, 26 Nov 2007 19:31:26 -0800
Message-ID: <474B8F51.5030102@sgi.com>
Date: Tue, 27 Nov 2007 14:30:25 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] Delayed logging of file sizes
References: <47467B87.2000000@sgi.com> <20071125225928.GE114266761@sgi.com> <474A112D.2040006@sgi.com> <20071126011044.GG114266761@sgi.com> <474A2180.7000605@sgi.com> <20071126021515.GH114266761@sgi.com> <474A3A92.2040200@sgi.com> <20071126050300.GI114266761@sgi.com>
In-Reply-To: <20071126050300.GI114266761@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> On Mon, Nov 26, 2007 at 02:16:34PM +1100, Lachlan McIlroy wrote:
>> David Chinner wrote:
>>> On Mon, Nov 26, 2007 at 12:29:36PM +1100, Lachlan McIlroy wrote:
>>>> David Chinner wrote:
>>>>> On Mon, Nov 26, 2007 at 11:19:57AM +1100, Lachlan McIlroy wrote:
>>>>>> David Chinner wrote:
>>>>>>> On Fri, Nov 23, 2007 at 06:04:39PM +1100, Lachlan McIlroy wrote:
>>>>>>>> The easy solution is to log everything so that log replay doesn't need
>>>>>>>> to check if the on-disk version is newer - it can just replay the log.
>>>>>>>> But logging everything would cause too much log traffic so this patch
>>>>>>>> is a compromise and it logs a transaction before we flush an inode to
>>>>>>>> disk only if it has changes that have not yet been logged.
>>>>>>> The problem with this is that the inode will be marked dirty during the
>>>>>>> transaction, so we'll never be able to clean an inode if we issue a
>>>>>>> transaction during inode writeback.
>>>>>> Ah, yeah, good point.  I wrote this patch back before that "dirty inode
>>>>>> on transaction" patch went in.
>>>>> Wouldn't have made aany difference - the inode woul dbe marked dirty
>>>>> at transaction completion...
>>>>>
>>>>>> For this transaction though the changes
>>>>>> to the inode have already been made (ie when we set i_update_core and
>>>>>> called mark_inode_dirty_sync()) so there is no need to dirty it in this
>>>>>> transaction.  I'll keep digging.  Thanks.
>>>>> I wouldn't worry too much about this problem right now - I'm working
>>>>> on moving the dirty state into the inode radix trees so i_update_core
>>>>> might even go away completely soon....
>>>>>
>>>> Which problem?  Just the bit about dirtying the inode or will your changes
>>>> allow us to log all inode changes?
>>> Trying to change XFS to logging all updates.
>> That would be great.  But what about the increase in log traffic that has
>> deterred us from doing this in the past?
> 
> Sorry, i wasn't particularly clear. What I mean was that i_update_core
> might disappear completely with the changes I'm making.
> 
> Basically, we have three different methods of marking the inode dirty
> at the moment - on  the linux inode (mark_inode_dirty[_sync]()), the
> i_update_core = 1 for unlogged changes and logged changes are tracked via the
> inode log item in the AIL.
> 
> One top of that, we have three different methods of flushing them - one
> from the generic code for inodes dirtied by mark_inode_dirty(), one from
> xfssyncd for inodes that are only dirtied by setting i_update_core = 1
> and the other from the xfsaild when log tail pushing.
> 
> Ideally we should only have a single method for pushing out inodes. The first
> step to that is tracking the dirty state in a single tree (the inode radix
> trees). That means we have to hook ->dirty_inode() to catch all dirtying via
> mark_inode_dirty[_sync]() and mark the inodes dirty in the radix tree. Then we
> need to use xfs_mark_inode_dirty_sync() everywhere that we dirty the inode.
Don't we already call mark_inode_dirty[_sync]() everywhere we dirty the inode?

> 
> Once we have all the dirty state in the radix trees we can now get rid of
> i_update_core and i_update_size - all they do is mark the inode dirty and
> we don't really care about the difference between them(*) - and just use
> the dirty bit in the radix tree when necessary.
If we want to check if an inode is dirty do we have to look up the dirty
bit in the tree or is there some easy way to get it from the inode?

By consolidating the different ways of dirtying an inode we lose the ability
to know why it is dirty and what action needs to be done to undirty it.
For example if the inode log item has bits set then we know we have to flush
the log otherwise there is no need.  With a general purpose dirty bit we will
have to flush regardless.  And my recent attempt to fix the log replay issue
relies on i_update_core to indicate there are unlogged changes - I don't see
how that will work with these changes.

> 
> To flush the dirty inodes we just do radix_tree_gang_lookup_tag_range()
> calls to do ascending cluster order writeback. This will replace the
> mount inode list walking in xfs_sync_inodes() and other places to find
> dirty inodes.
> 
> /me puts on flame-proof suite
> 
> I'd even like to go as far as a two pass writeback algorithm; pass
> one only writes data, and pass two only writes inodes. The second pass
> for XFS needs to be delayed until data writeback is complete because of
> delalloc and inode size updates redirtying the inode. The current
> mechanism means we often do two inode writes for the one data write...
> 
> Basically, our writeback code is a mess and I want to clean it up
> before we try to deal with the unlogged changes....
> 
> Cheers,
> 
> Dave.
> 
> (*) Even for FDATASYNC we should always force the log out because we may
> have delayed allocation transactions still sitting in iclog buffers. This,
> AFAICT, is a bug in the current implementation.
