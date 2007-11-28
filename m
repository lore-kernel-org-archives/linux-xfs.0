Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 27 Nov 2007 20:19:58 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAS4Jo7k014382
	for <xfs@oss.sgi.com>; Tue, 27 Nov 2007 20:19:51 -0800
Message-ID: <474CEC2E.8000206@sgi.com>
Date: Wed, 28 Nov 2007 15:18:54 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] Delayed logging of file sizes
References: <20071125225928.GE114266761@sgi.com> <474A112D.2040006@sgi.com> <20071126011044.GG114266761@sgi.com> <474A2180.7000605@sgi.com> <20071126021515.GH114266761@sgi.com> <474A3A92.2040200@sgi.com> <20071126050300.GI114266761@sgi.com> <474B8F51.5030102@sgi.com> <20071127105358.GG119954183@sgi.com> <474CB9AE.9020604@sgi.com> <20071128020135.GM119954183@sgi.com>
In-Reply-To: <20071128020135.GM119954183@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> On Wed, Nov 28, 2007 at 11:43:26AM +1100, Lachlan McIlroy wrote:
>> David Chinner wrote:
>>> On Tue, Nov 27, 2007 at 02:30:25PM +1100, Lachlan McIlroy wrote:
>>>> David Chinner wrote:
>>>>> Sorry, i wasn't particularly clear. What I mean was that i_update_core
>>>>> might disappear completely with the changes I'm making.
>>>>>
>>>>> Basically, we have three different methods of marking the inode dirty
>>>>> at the moment - on  the linux inode (mark_inode_dirty[_sync]()), the
>>>>> i_update_core = 1 for unlogged changes and logged changes are tracked 
>>>>> via the
>>>>> inode log item in the AIL.
>>>>>
>>>>> One top of that, we have three different methods of flushing them - one
>>>> >from the generic code for inodes dirtied by mark_inode_dirty(), one from
>>>>> xfssyncd for inodes that are only dirtied by setting i_update_core = 1
>>>>> and the other from the xfsaild when log tail pushing.
>>>>>
>>>>> Ideally we should only have a single method for pushing out inodes. The 
>>>>> first
>>>>> step to that is tracking the dirty state in a single tree (the inode 
>>>>> radix
>>>>> trees). That means we have to hook ->dirty_inode() to catch all dirtying 
>>>>> via
>>>>> mark_inode_dirty[_sync]() and mark the inodes dirty in the radix tree. 
>>>>> Then we
>>>>> need to use xfs_mark_inode_dirty_sync() everywhere that we dirty the 
>>>>> inode.
>>>> Don't we already call mark_inode_dirty[_sync]() everywhere we dirty the 
>>>> inode?
>>> Maybe. Maybe not. Tell me - does xfs_ichgtime() do the right thing?
>>>
>>> [ I do know the answer to this question and there's a day of kdb tracing
>>> behind the answer. I wrote a 15 line comment to explain what was going
>>> on in one of my patches. ]
>> Are you referring to the !(inode->i_state & I_LOCK) check?
> 
> Yup.
I've never liked that check, can we just get rid of it?

> 
>> Anyway, since you know the answer why don't you enlighten me?
> 
> When allocating a new inode, we mark the inode dirty when first
> setting the timestamps in xfs_dir_ialloc(). At the time this happens
> the inode is I_LOCK|I_NEW and hence mark_inode_dirty_sync() would just
> mark the inode dirty and *not* move it to the dirty list.
> 
> Because unlock_new_inode() does not check the dirty state when
> removing the I_LOCK state, the inode is never moved to the dirty list
> if it is already dirty (unlike __sync_single_inode()).
> 
> Further calls to mark_inode_dirty_sync() see the inode as dirty and
> don't move it to the dirty list, either. Hence the inode would never
> get flushed out by the generic code if we called
> mark_inode_dirty_sync() in that location.
> 
> Why is it wrong? It should be checking I_NEW, not I_LOCK because all
> other cases where I_LOCK might be set are covered by the code that
> unlocks the inode.
> 
>>>>> Once we have all the dirty state in the radix trees we can now get rid of
>>>>> i_update_core and i_update_size - all they do is mark the inode dirty and
>>>>> we don't really care about the difference between them(*) - and just use
>>>>> the dirty bit in the radix tree when necessary.
>>>> If we want to check if an inode is dirty do we have to look up the dirty
>>>> bit in the tree or is there some easy way to get it from the inode?
>>> xfs_inode_clean(ip) is my preferred interface. How that is finally
>>> implemented will be determined by how this all cleans up and what
>>> performs the best. If lockless tree lookups don't cause performance
>>> problems, then there is little reason to keep redundant information
>>> around.
>> I can't imagine that a tree lookup (lockless or not) would be faster
>> than dereferencing fields from the inode.  If keeping the inode's dirty
>> flags and the ones in the radix tree in sync is an issue then maybe
>> tree lookups are a performance hit we can live with.
> 
> I'm hoping to avoid this problem altogether by removing as many
> "is the inode dirty" checks as possible. If inode writeback is
> driven exclusively by the radix tree dirty bit via a traversal
> and we only write back logged changes, then I don't think we need
> to be checking if the inode is clean very often.
> 
> That is, if we see the inode in xfs_flush_inode() then it is
> dirty at the linux level, so we log the inode. That makes the
> inode clean at the linux layer and dirty at the XFS level, and
> we know that as long as the inode remains in the AIL it is dirty. 
> 
> We only ever flush inodes based on a AIL push (which doesn't
> require dirty bits) or via the syncd, which looks up dirty
> inodes via the radix tree tag, and hence most of the dirty
> checks on the inode can go away because we don't need to
> check it during writeback now.
> 
>>>> By consolidating the different ways of dirtying an inode we lose the 
>>>> ability
>>>> to know why it is dirty and what action needs to be done to undirty it.
>>> The only way to undirty an inode is to write it to disk.
>> True.  I was thinking about what may need to be done before we write it
>> to disk such as flushing the log but that would just be dependent on
>> whether the inode is pinned?
> 
> Right, flushing the log is only needed if it is pinned.
> 
>>>> For example if the inode log item has bits set then we know we have to 
>>>> flush
>>>> the log otherwise there is no need.  With a general purpose dirty bit we 
>>> No, if the log item is present and dirty (i.e. inode is in the AIL),
>>> all it means is that we need to attach a callback to the buffer
>>> (xfs_iflush_done) when dispatching the I/O to do processing of the
>>> log item on I/O completion. Whether i_update_core is set or not
>>> in this case is irrelevant - the log item state overrides that.
>>>
>>>> will
>>>> have to flush regardless.  And my recent attempt to fix the log replay 
>>>> issue
>>>> relies on i_update_core to indicate there are unlogged changes - I don't 
>>>> see
>>>> how that will work with these changes.
>>> But your changes could not be implemented, either. You can't log the inode
>>> to clean it - it merely transfers the writeback from one list to
>>> another.
>> Could not be implemented?  What was that patch I sent around then? 
> 
> Sorry, I missed an important work there - could not be implemented
> _efficiently_.
> 
> Basically, you are logging the inode, then call xfs_iflush, which
> immediately sees it pinned and forces the log. That's an extra
> transaction *and* log I/O for every inode we write. That defeats all
> inode clustering and and will seriously harm performance.
I didn't see another way around it.  We only need to force the log for
pinned inodes if it is a sync writeback, otherwise we can just try again
later.

> 
> Also, the change fails to log changes to inodes in the same
> cluster that get written out because they are dirty.
That's where it all sort of falls apart.  I didn't want to log the inode
in xfs_iflush_int() because we have the flush lock held and I was pretty
sure logging a transaction with the flush lock held would be a bad idea.
That's why I specifically removed the code that resets i_update_core in
xfs_iflush_int() - so that other inodes in the same cluster will still be
flagged as having unlogged changes even after the inodes have been synced
to disk.  But as I said it was an idea that needed some polishing.

> 
>>> So, the cleaner fix is to do this - change the xfs_inode_flush()
>>> just to unconditionally log the inode and don't do inode writeback *at
>>> all* from there. That will catch all cases of unlogged changes and leave
>>> inode writeback to tail-pushing or xfssyncd which can be driven by
>>> the radix tree.
>> Huh?  Aren't we trying to minimize the number of transactions we do?  My
>> changes introduce new transactions but only when we have to.  You're saying
>> here that we log the inode unconditionally - how is that better?  I'm not
>> trying to defend my changes here (I don't care how the problem gets fixed)
>> - I'm just trying to understand why your suggestions are a good idea.
> 
> Because we can log entire inode cluster's worth of changes in a single
> transaction. One transaction vs one I/O - it's a decent tradeoff to
> avoid this problem, esp. as we'll get improved inode writeback clustering
> if we flush from the radix tree (i.e. clusters get flushed in ascending
> inode number order).....
That should help a lot but it will use even more space in the log - quite a
lot more if just one inode in the cluster needs to be logged.  Do you plan
to do this in the write_inode path?  If so we'll have inodes that have been
logged (with a previous cluster) that still have I_DIRTY set.  When these
inodes go through the write_inode path we'll need to skip the transaction.

> 
>> I do like the way it simplifies inode writeback though - a sync would
>> optionally log all the inodes and then just flush the log and that's it
>> (I think).
> 
> Yup, pretty much.
> 
> Cheers,
> 
> Dave.
