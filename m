Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Sep 2008 22:53:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m825rjvi012505
	for <xfs@oss.sgi.com>; Mon, 1 Sep 2008 22:53:46 -0700
Message-ID: <48BCD707.206@sgi.com>
Date: Tue, 02 Sep 2008 16:02:47 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Fix use-after-free with buffers
References: <48ABA9EC.5040902@sgi.com> <20080820125033.GA29680@infradead.org>
In-Reply-To: <20080820125033.GA29680@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Wed, Aug 20, 2008 at 03:21:48PM +1000, Lachlan McIlroy wrote:
>> 	XB_TRACE(bp, "rele", bp->b_relse);
>>
>> +	ASSERT(atomic_read(&bp->b_hold) > 0);
>> +
>> 	if (unlikely(!hash)) {
>> 		ASSERT(!bp->b_relse);
>> 		if (atomic_dec_and_test(&bp->b_hold))
>> @@ -838,7 +840,6 @@ xfs_buf_rele(
>> 		return;
>> 	}
>>
>> -	ASSERT(atomic_read(&bp->b_hold) > 0);
> 
> Makes sense, but how is this related to the other bits of the
> patch?  All but log and iozero buffers should always be hashed.
Okay, not specifically related.  I'll split it out of this change.

> 
>> @@ -732,6 +732,7 @@ xfs_buf_item_init(
>> 	bip->bli_item.li_ops = &xfs_buf_item_ops;
>> 	bip->bli_item.li_mountp = mp;
>> 	bip->bli_buf = bp;
>> +	xfs_buf_hold(bp);
> 
> These refcount changes look good to me.
> 
>> +void
>> +xfs_buf_item_free(
>> +	xfs_buf_log_item_t	*bip)
>> +{
>> +#ifdef XFS_TRANS_DEBUG
>> +	kmem_free(bip->bli_orig);
>> +	bip->bli_orig = NULL;
>> +	kmem_free(bip->bli_logged);
>> +	bip->bli_logged = NULL;
>> +#endif /* XFS_TRANS_DEBUG */
>> +
>> +#ifdef XFS_BLI_TRACE
>> +	ktrace_free(bip->bli_trace);
>> +#endif
>> +	kmem_zone_free(xfs_buf_item_zone, bip);
>> +}
> 
> Faktoring this out makes sense, although you might want to remove the
> zeroing of bip->bli_orig and bip->bli_logged while you're at it, so that
> slab poisoning can do it's work.
Okay, thanks, I'll post a V2.
