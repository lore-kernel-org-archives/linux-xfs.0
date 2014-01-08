Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E62757F3F
	for <xfs@oss.sgi.com>; Wed,  8 Jan 2014 12:13:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B0330304048
	for <xfs@oss.sgi.com>; Wed,  8 Jan 2014 10:13:37 -0800 (PST)
Received: from mail-wg0-f50.google.com (mail-wg0-f50.google.com
	[74.125.82.50]) by cuda.sgi.com with ESMTP id k0TifmNw4aUqEvQz
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 08 Jan 2014 10:13:36 -0800 (PST)
Received: by mail-wg0-f50.google.com with SMTP id l18so891962wgh.5
	for <xfs@oss.sgi.com>; Wed, 08 Jan 2014 10:13:35 -0800 (PST)
Message-ID: <A0A556BD24EC45CEADAA07870B3E6205@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
References: <AD612A564BB84E75B010AE37687DFC8E@alyakaslap>
	<20131218230615.GQ31386@dastard>
	<78FC295EC7FF48C987266DC48B183930@alyakaslap>
	<20131219105513.GZ31386@dastard>
	<8155F3F9D6094F40B4DA71BD561D2DE8@alyakaslap>
	<20131226230018.GJ20579@dastard>
In-Reply-To: <20131226230018.GJ20579@dastard>
Subject: Re: Questions about XFS discard and xfs_free_extent() code (newbie)
Date: Wed, 8 Jan 2014 20:13:38 +0200
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hello Dave,

Currently I am working on the following approach:

Basic idea: make each xfs_extent_busy struct carry potential information 
about a larger extent-for-discard, i.e., one that is a multiple of 
discard_granularity.

In detail this looks like this:
# xfs_free_ag_extent attempts to merge the freed extent into a larger 
free-extent in the by-bno btree.  When this function completes its work, we 
have [nbno, nlen], which is potentially a larger free-extent. At this point 
we also know that AGF is locked.
# We trim [nbno, nlen] to be a multiple-of and aligned-by 
discard_granularity (if possible), and we receive [dbno, dlen], which is a 
very nice extent to discard.
# When calling xfs_extent_busy_insert(), we add these two values to the 
xfs_extent_busy struct.
# When the extent-free operation is committed for this busy extent, we know 
that we can discard this [dbno, dlen] area, unless somebody have allocated 
an extent, which overlaps this area.

To address that, at the end of  xfs_alloc_fixup_trees() we do the following:
# We know that we are going to allocate [rbno, rlen] from appropriate AG. So 
at this point, we search the busy extents tree to check if there is a busy 
extent that holds [dbno, dlen] (this is a multiple-of and aligned-by discard 
granularity), which overlaps [rbno, rlen] fully or partially. If found, we 
shrink the [dbno, dlen] area to be still a multiple-of and aligned by 
discard-granularity, if possible. So we have a new smaller [dbno, dlen] that 
we still can discard, attached to the same busy extent. Or we discover that 
the new area is too small to discard, so we forget about it.
# The allocation flow anyways searches the busy extents tree, so we should 
be ok WRT to locking order, but adding some extra work.

This way, we basically track larger chunks, which are nice to discard.

I am aware that I need to handle additional issues like:
# A busy extent can be "unbusyied" or shrunk by 
xfs_extent_busy_update_extent(). We need to update [dbno, dlen] accordingly 
or delete it fully
# To be able to search for [dbno, dlen], we probably need another rbtree 
(under the same pag->pagb_lock), which tracks large extents for discard. 
xfs_extent_busy needs additional rbnode.
# If during xfs_alloc_fixup_trees() we discover that extent is already being 
discarded, we need to wait. Assuming we have asynchronous discard, this wait 
will be short - we only need the block device to queue the discard request, 
and then we are good to allocate from that area again.

One thing I am unsure about, is a scenario like this:
# assume discard-granularity=1MB
# we have a 1MB almost free, except two 4K blocks, somewhere in the free 
space
# Transaction t1 comes and frees 4K block A, but the 1MB extent is not fully 
free yet, so nothing to discard
# Transaction t2 frees the second 4K block B, now 1MB is free and we attach 
a [dbno, dlen] to the second busy extent

However, I think there is no guarantee that t1 will commit before t2; is 
that right? But we cannot discard the 1MB extent, before both transactions 
commit. (One approach to solve this, is to give a sequence number for each 
xfs_extent_busy extent, and have a background thread that does delayed 
discards, once all needed busy extents are committed. The delayed discards 
are also considered in the check that xfs_alloc_fixup_trees()  does).

What do you think overall about this approach? Is there something 
fundamental that prevents it from working?

Also (if you are still reading:),  can you kindly comment this question that 
I have:
# xfs_free_ag_extent() has a "isfl" parameter. If it is "true", then this 
extent is added as usual to the free-space btrees, but the caller doesn't 
add it as a busy extent. This means that such extent is suitable for 
allocation right away, without waiting for the log commit?

Thank you for helping,
Alex.



-----Original Message----- 
From: Dave Chinner
Sent: 27 December, 2013 1:00 AM
To: Alex Lyakas
Cc: xfs@oss.sgi.com
Subject: Re: Questions about XFS discard and xfs_free_extent() code (newbie)

On Tue, Dec 24, 2013 at 08:21:50PM +0200, Alex Lyakas wrote:
> Hi Dave,
> Reading through the code some more, I see that the extent that is
> freed through xfs_free_extent() can be an XFS metadata extent as
> well.
> For example, xfs_inobt_free_block() frees a block of the AG's
> free-inode btree. Also, xfs_bmbt_free_block() frees a generic btree
> block by putting it onto the cursor's "to-be-freed" list, which will
> be dropped into the free-space btree (by xfs_free_extent) in
> xfs_bmap_finish(). If we discard such metadata block before the
> transaction is committed to the log and we crash, we might not be
> able to properly mount after reboot, is that right?

Yes. The log stores a delta of the transactional changes, and so
requires th eprevious version of the block to be intact for revoery
to take place.

> I mean it's not
> that some file's data block will show 0s to the user instead of
> before-delete data, but some XFS btree node (for example) will be
> wiped in such case. Can this happen?

Yes, it could. That's what I meant by:

[snip]

> > IOWs, issuing the discard before the transaction that frees the
> > extent is on stable storage means we are discarding user data or
                                                                  ^^
> > metadata before we've guaranteed that the extent free transaction
    ^^^^^^^^
> > is permanent and that means we violate certain guarantees with
> > respect to crash recovery...

The "or metadata" part of the above sentence.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
