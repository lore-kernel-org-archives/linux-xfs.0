Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 234AE7CA0
	for <xfs@oss.sgi.com>; Sun, 28 Aug 2016 20:16:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D9CA6304039
	for <xfs@oss.sgi.com>; Sun, 28 Aug 2016 18:16:37 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	iX34jNE7C8wEONr1 for <xfs@oss.sgi.com>;
	Sun, 28 Aug 2016 18:16:34 -0700 (PDT)
Date: Mon, 29 Aug 2016 11:16:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: rework log recovery to submit buffers on LSN
	boundaries
Message-ID: <20160829011631.GK19025@dastard>
References: <1470935467-52772-1-git-send-email-bfoster@redhat.com>
	<1470935467-52772-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1470935467-52772-2-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 11, 2016 at 01:11:03PM -0400, Brian Foster wrote:
> The fix to log recovery to update the metadata LSN in recovered buffers
> introduces the requirement that a buffer is submitted only once per
> current LSN. Log recovery currently submits buffers on transaction
> boundaries. This is not sufficient as the abstraction between log
> records and transactions allows for various scenarios where multiple
> transactions can share the same current LSN. If independent transactions
> share an LSN and both modify the same buffer, log recovery can
> incorrectly skip updates and leave the filesystem in an inconsisent
> state.
> 
> In preparation for proper metadata LSN updates during log recovery,
> update log recovery to submit buffers for write on LSN change boundaries
> rather than transaction boundaries. Explicitly track the current LSN in
> a new struct xlog field to handle the various corner cases of when the
> current LSN may or may not change.

.....

> @@ -4221,8 +4223,39 @@ xlog_recover_process_ophdr(
>  		return 0;
>  	}
>  
> +	/*
> +	 * Recovered buffers are submitted for I/O on current LSN change
> +	 * boundaries. This is necessary to accommodate metadata LSN ordering
> +	 * rules of v5 superblock filesystems.
> +	 *
> +	 * Store the new current LSN in l_recovery_lsn as we cannot rely on
> +	 * either record boundaries or transaction boundaries alone to track LSN
> +	 * changes. This has several contributing factors:
> +	 *
> +	 * - Metadata LSNs are updated at buffer submission time. Thus, buffers
> +	 *   can only be submitted safely once per current LSN value.
> +	 * - The current LSN is defined as the start cycle/block of the first
> +	 *   record in which a transaction appears.
> +	 * - A record can hold multiple transactions. Thus, a transaction change
> +	 *   does not guarantee a change in current LSN.
> +	 * - A transaction can span multiple records. Thus, a record change does
> +	 *   not guarantee a change in current LSN. Consider the case where a
> +	 *   record holds one small transaction and a subsequent that carries
> +	 *   over to the next record. Both transactions share the same LSN as
> +	 *   per the definition of the current LSN.
> +	 *
> +	 * In summary, this means we must track the current LSN independently
> +	 * and submit buffers for the previous LSN only when it has changed.
> +	 */
> +	if (log->l_recovery_lsn != trans->r_lsn) {
> +		error = xfs_buf_delwri_submit(buffer_list);
> +		if (error)
> +			return error;
> +		log->l_recovery_lsn = trans->r_lsn;
> +	}

I'm not sure this is the right place to be submitting buffers. We
can have multiple transactions open at once because the writing of
the transaction to the log is split into two parts: xlog_write()
which writes the changes to the log, and xfs_log_done() which writes
the commit record (via xlog_commit_record()) to close the
transaction.

Hence we can get the situation where we have multiple open
transactions such as:

                              CA CB                  CC CD
 +---------+--------+--------+--+--+--------+-------+--+--+
   trans A   trans B  trans C       trans C  trans D

where the changes in multiple transactions are written before the
ophdr that contains the commit record ("CA", "CB", ....) is written.
With the above code, we'd be doing writeback of A when we see B, not
when we see the commit record for A. Like wise B when we see C. And
worse, partial writeback of C when we see the commit record for A...

i.e. We are very careful to write commit records in the correct
order because that is what determines recovery order, but we don't
care what order we write the actual contents of the checkpoints or
whether they interleave with other checkpoints.  As such, ophdrs
change transactions and LSNs without having actually completed
recovery of a checkpoint. 

I think writeback should occur when all the transactions with a
given lsn have been committed. I'm not sure there's a simple way to
track and detect this, but using the ophdrs to detect a change of
lsn to trigger buffer writeback does not look correct to me at this
point in time.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
