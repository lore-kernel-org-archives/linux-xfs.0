Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40602 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751944AbdFLMXI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Jun 2017 08:23:08 -0400
Date: Mon, 12 Jun 2017 08:23:06 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: free uncommitted transactions during log recovery
Message-ID: <20170612122304.GA10244@bfoster.bfoster>
References: <1497029889-12299-1-git-send-email-bfoster@redhat.com>
 <20170610211029.GM4530@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170610211029.GM4530@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Jun 10, 2017 at 02:10:29PM -0700, Darrick J. Wong wrote:
> On Fri, Jun 09, 2017 at 01:38:09PM -0400, Brian Foster wrote:
> > Log recovery allocates in-core transaction and member item data
> > structures on-demand as it processes the on-disk log. Transactions
> > are allocated on first encounter on-disk and stored in a hash table
> > structure where they are easily accessible for subsequent lookups.
> > Transaction items are also allocated on demand and are attached to
> > the associated transactions.
> > 
> > When a commit record is encountered in the log, the transaction is
> > committed to the fs and the in-core structures are freed. If a
> > filesystem crashes or shuts down before all in-core log buffers are
> > flushed to the log, however, not all transactions may have commit
> > records in the log. As expected, the modifications in such an
> > incomplete transaction are not replayed to the fs. The in-core data
> > structures for the partial transaction are never freed, however,
> > resulting in a memory leak.
> > 
> > Update xlog_do_recovery_pass() to walk the hash table of transaction
> > lists as the last step before it goes out of scope and free any
> > transactions that may remain on the lists. This prevents a memory
> > leak of partial transactions in the log.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> Looks ok, I think.
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Do the log intent items get freed properly too?  I /think/ the answer is
> yes, but that yes could use another set of eyes. :)
> 

Good question. Taking a quick look at the recovery lifecycle of an EFI,
we can see it is created in xlog_recover_efi_pass2() with 2 references.
This is called when we've hit a commit record for a transaction that
contains the on-disk EFI (so there's no potential leak before this
point). The first ref is immediately dropped after the EFI is inserted
into the AIL. The common expectation is that the other reference is
dropped when we process the commit record for the transaction that
contains the corresponding EFD (i.e., the case where the extent free
operation is captured by the log).

The alternative case (no EFD in the log) is the case where it is the
responsibility of the log recovery code to actually re-invoke the
operation. This occurs down in xlog_recover_process_intents() -> ... ->
xfs_efi_recover(), where we now allocate a corresponding EFD, perform
the free and commit the transaction. The EFD now owns the EFI, so at
this point I believe the same rules apply with respect to EFI/EFD memory
management as if log recovery weren't running. E.g., the modifications
eventually make it from the CIL to the on-disk log and ->iop_committed()
of the EFD drops the corresponding EFI reference and frees the EFD.

I think this will probably look the same for other intent types, so the
short of it is that I think the log intent items are not susceptible to
this problem. They are intentionally designed to handle the case where
the associated high-level transaction had not been completed by the time
the fs died. FWIW, if there was a problem here, I think the problem may
also be more obvious than a memory leak because the intent items sit in
the AIL and potentially pin the tail of the log.

Brian

> --D
> 
> > ---
> > 
> > FYI, I suspect this has been a problem for a while and and rare/harmless
> > enough that this can target 4.13.
> > 
> > Brian
> > 
> >  fs/xfs/xfs_log_recover.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 4a98762..37b34c5 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -5224,6 +5224,7 @@ xlog_do_recovery_pass(
> >  	int			error2 = 0;
> >  	int			bblks, split_bblks;
> >  	int			hblks, split_hblks, wrapped_hblks;
> > +	int			i;
> >  	struct hlist_head	rhash[XLOG_RHASH_SIZE];
> >  	LIST_HEAD		(buffer_list);
> >  
> > @@ -5466,6 +5467,19 @@ xlog_do_recovery_pass(
> >  	if (error && first_bad)
> >  		*first_bad = rhead_blk;
> >  
> > +	/*
> > +	 * Transactions are freed at commit time but transactions without commit
> > +	 * records on disk are never committed. Free any that may be left in the
> > +	 * hash table.
> > +	 */
> > +	for (i = 0; i < XLOG_RHASH_SIZE; i++) {
> > +		struct hlist_node	*tmp;
> > +		struct xlog_recover	*trans;
> > +
> > +		hlist_for_each_entry_safe(trans, tmp, &rhash[i], r_list)
> > +			xlog_recover_free_trans(trans);
> > +	}
> > +
> >  	return error ? error : error2;
> >  }
> >  
> > -- 
> > 2.7.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
