Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8FBAC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 19:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A359460C41
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 18:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbhGVSSa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 14:18:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhGVSS3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Jul 2021 14:18:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64E1A60C41;
        Thu, 22 Jul 2021 18:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626980344;
        bh=0KXVMRY8yUyYij/glrV2jdsgnQLi0CDoCsxjgAGmh7s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pQ9Bl3KJVmUN0cZIgqSBfISZTLkQzPomK+MK9lTRNRZaMZgYl4dLfyJ0fhl9MSOaE
         3QDx5u/YDP7jasW92QZ3vN+MVGJvIJ0/9euCgyvv84pJ4hWu4tc5MjGjJjyCYCjKkS
         b4QWSdwzJft8j8WPYnOF0XoukoaOdBMTzH/j6y4F8lywmEJpFQmV9J3cEcmfi8iKXD
         z0tVe71Epvl/EDstfLr0mMxMFiEKtX1uW1RPrHtiCxKNi6nvnnQ9J9PdRTsX8IlraZ
         cJxWUr79mjCVt1tpn2qRT8xeK1FZqxKluuAj0EdKjGFjwkGEizLl2JbmhGt/JHjTJM
         g42VjwjKopdCg==
Date:   Thu, 22 Jul 2021 11:59:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: logging the on disk inode LSN can make it go
 backwards
Message-ID: <20210722185903.GF559212@magnolia>
References: <20210722110247.3086929-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722110247.3086929-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 22, 2021 at 09:02:47PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we log an inode, we format the "log inode" core and set an LSN
> in that inode core. We do that via xfs_inode_item_format_core(),
> which calls:
> 
> 	xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);
> 
> to format the log inode. It writes the LSN from the inode item into
> the log inode, and if recovery decides the inode item needs to be
> replayed, it recovers the log inode LSN field and writes it into the
> on disk inode LSN field.
> 
> Now this might seem like a reasonable thing to do, but it is wrong
> on multiple levels. Firstly, if the item is not yet in the AIL,
> item->li_lsn is zero. i.e. the first time the inode it is logged and
> formatted, the LSN we write into the log inode will be zero. If we
> only log it once, recovery will run and can write this zero LSN into
> the inode.

In the case where we don't crash, the AIL calls xfs_inode_item_push ->
xfs_iflush_cluster -> xfs_iflush, which will set the ondisk di_lsn to
iip->ili_item.li_lsn.  Presumably, the LSN won't be zero at this point,
right?  And it will accurately reflect the age of the ondisk inode?

IOWs, does the low-inode-LSN problem only happen if we log an inode,
force the log, and crash before the AIL gets to flushing the inode?

> This means that the next time the inode is logged and log recovery
> runs, it will *always* replay changes to the inode regardless of
> whether the inode is newer on disk than the version in the log and
> that violates the entire purpose of recording the LSN in the inode
> at writeback time (i.e. to stop it going backwards in time on disk
> during recovery).
> 
> Secondly, if we commit the CIL to the journal so the inode item
> moves to the AIL, and then relog the inode, the LSN that gets
> stamped into the log inode will be the LSN of the inode's current
> location in the AIL, not it's age on disk. And it's not the LSN that
> will be associated with the current change. That means when log
> recovery replays this inode item, the LSN that ends up on disk is
> the LSN for the previous changes in the log, not the current
> changes being replayed. IOWs, after recovery the LSN on disk is not
> in sync with the LSN of the modifications that were replayed into
> the inode. This, again, violates the recovery ordering semantics
> that on-disk writeback LSNs provide.

Yikes.

> Hence the inode LSN in the log dinode is -always- invalid.

In that case, I think the final version of this patch should amend the
structure definition of xfs_log_dinode should note that di_lsn is never
correct.

> Thirdly, recovery actually has the LSN of the log transaction it is
> replaying right at hand - it uses it to determine if it should
> replay the inode by comparing it to the on-disk inode's LSN. But it
> doesn't use that LSN to stamp the LSN into the inode which will be
> written back when the transaction is fully replayed. It uses the one
> in the log dinode, which we know is always going to be incorrect.
> 
> Looking back at the change history, the inode logging was broken by
> commit 93f958f9c41f ("xfs: cull unnecessary icdinode fields") way
> back in 2016 by a stupid idiot who thought he knew how this code
> worked. i.e. me. That commit replaced an in memory di_lsn field that
> was updated only at inode writeback time from the inode item.li_lsn
> value - and hence always contained the same LSN that appeared in the
> on-disk inode - with a read of the inode item LSN at inode format
> time. CLearly these are not the same thing.
> 
> Before 93f958f9c41f, the log recovery behaviour was irrelevant,
> because the LSN in the log inode always matched the on-disk LSN at
> the time the inode was logged, hence recovery of the transaction
> would never make the on-disk LSN in the inode go backwards or get
> out of sync.
> 
> A symptom of the problem is this, caught from a failure of
> generic/482. Before log recovery, the inode has been allocated but
> never used:
> 
> xfs_db> inode 393388
> xfs_db> p
> core.magic = 0x494e
> core.mode = 0
> ....
> v3.crc = 0x99126961 (correct)
> v3.change_count = 0
> v3.lsn = 0
> v3.flags2 = 0
> v3.cowextsize = 0
> v3.crtime.sec = Thu Jan  1 10:00:00 1970
> v3.crtime.nsec = 0
> 
> After log recovery:
> 
> xfs_db> p
> core.magic = 0x494e
> core.mode = 020444
> ....
> v3.crc = 0x23e68f23 (correct)
> v3.change_count = 2
> v3.lsn = 0
> v3.flags2 = 0
> v3.cowextsize = 0
> v3.crtime.sec = Thu Jul 22 17:03:03 2021
> v3.crtime.nsec = 751000000
> ...
> 
> You can see that the LSN of the on-disk inode is 0, even though it
> clearly has been written to disk. I point out this inode, because

(I'd noticed this in a few crash metadumps...)

> the generic/482 failure occurred because several adjacent inodes in
> this specific inode cluster were not replayed correctly and still
> appeared to be zero on disk when all the other metadata (inobt,
> finobt, directories, etc) indicated they should be allocated and
> written back.
> 
> The Fix for this is two-fold. The first is that we need to either
> revert the LSN changes in 93f958f9c41f or stop logging the inode LSN
> altogether. If we do the former, log recovery does not need to
> change but we add 8 bytes of memory per inode to store what is
> largely a write-only inode field. If we do the latter, log recovery
> needs to stamp the on-disk inode in the same manner that inode
> writeback does.
> 
> I prefer the latter, because we shouldn't really be trying to log
> and replay changes to the on disk LSN as the on-disk value is the
> canonical source of the on-disk version of the inode. It also
> matches the way we recover buffer items - we create a buf_log_item
> that carries the current recovery transaction LSN that gets stamped
> into the buffer by the write verifier when it gets written back
> when the transaction is fully recovered.

That sounds like something to do the next time someone adds a new
*incompat feature...

> However, this might break log recovery on older kernels even more,
> so I'm going to simply ignore the logged value in recovery and stamp
> the on-disk inode with the LSN of the transaction being recovered
> that will trigger writeback on transaction recovery completion. This

Well, that's easily backportable. ;)

> will ensure that the on-disk inode LSN always reflects the LSN of
> the last change that was written to disk, regardless of whether it
> comes from log recovery or runtime writeback.
> 
> Fixes: 93f958f9c41f ("xfs: cull unnecessary icdinode fields")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_inode_item_recover.c | 33 ++++++++++++++++++++++++---------
>  1 file changed, 24 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index 7b79518b6c20..5747ef052b4e 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -145,7 +145,8 @@ xfs_log_dinode_to_disk_ts(
>  STATIC void
>  xfs_log_dinode_to_disk(
>  	struct xfs_log_dinode	*from,
> -	struct xfs_dinode	*to)
> +	struct xfs_dinode	*to,
> +	xfs_lsn_t		lsn)
>  {
>  	to->di_magic = cpu_to_be16(from->di_magic);
>  	to->di_mode = cpu_to_be16(from->di_mode);
> @@ -182,7 +183,7 @@ xfs_log_dinode_to_disk(
>  		to->di_flags2 = cpu_to_be64(from->di_flags2);
>  		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
>  		to->di_ino = cpu_to_be64(from->di_ino);
> -		to->di_lsn = cpu_to_be64(from->di_lsn);
> +		to->di_lsn = cpu_to_be64(lsn);
>  		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
>  		uuid_copy(&to->di_uuid, &from->di_uuid);
>  		to->di_flushiter = 0;
> @@ -261,12 +262,17 @@ xlog_recover_inode_commit_pass2(
>  	}
>  
>  	/*
> -	 * If the inode has an LSN in it, recover the inode only if it's less
> -	 * than the lsn of the transaction we are replaying. Note: we still
> -	 * need to replay an owner change even though the inode is more recent
> -	 * than the transaction as there is no guarantee that all the btree
> -	 * blocks are more recent than this transaction, too.
> +	 * If the inode has an LSN in it, recover the inode only if the on-disk
> +	 * inode's LSN is older than the lsn of the transaction we are
> +	 * replaying. We must check the current_lsn against the on-disk inode
> +	 * here because the we can't trust the log dinode to contain a valid LSN
> +	 * (see comment below before replaying the log dinode for details).
> +	 *
> +	 * Note: we still need to replay an owner change even though the inode
> +	 * is more recent than the transaction as there is no guarantee that all
> +	 * the btree blocks are more recent than this transaction, too.
>  	 */
> +
>  	if (dip->di_version >= 3) {
>  		xfs_lsn_t	lsn = be64_to_cpu(dip->di_lsn);
>  
> @@ -368,8 +374,17 @@ xlog_recover_inode_commit_pass2(
>  		goto out_release;
>  	}
>  
> -	/* recover the log dinode inode into the on disk inode */
> -	xfs_log_dinode_to_disk(ldip, dip);
> +	/*
> +	 * Recover the log dinode inode into the on disk inode.
> +	 *
> +	 * The LSN in the log dinode is garbage - it can be zero or reflect
> +	 * stale in-memory runtime state that isn't coherent with the changes
> +	 * logged in this transaction or the changes written to the on-disk
> +	 * inode.  Hence we write the current lSN into the inode because that
> +	 * matches what xfs_iflush() would write inode the inode when flushing
> +	 * the changes in this transaction.
> +	 */
> +	xfs_log_dinode_to_disk(ldip, dip, current_lsn);
>  
>  	fields = in_f->ilf_fields;
>  	if (fields & XFS_ILOG_DEV)
> -- 
> 2.31.1
> 
