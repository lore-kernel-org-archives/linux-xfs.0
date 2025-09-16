Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81263221FD2
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 21:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758058339; cv=none; b=RsT46i1aJKe6qt7G4B48NrsgeWJ8YY56tCWiOicZ9XsS8ItrO7fqm9SKn6NntY3+b2ZB2w+SbRLBIH96XfTrCWnbhhhm+JVUmLF/+3oB8OP834Jt0o0ktmIudjL5o9kvEFZ0Arvk65Fw137itx6pXtNhQrIvblD2etwOWJUV3uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758058339; c=relaxed/simple;
	bh=k+aUrd1kEPrJBeV9I0/ofba77+wQL32EqlR+WVJ6gAI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DmeeF6ZQU3EF4OxU77jDOnT4gs2I2GyigbTLI6YI2v2hOEL2XPPV6uSK9fi/BZWyIQU9MMAYEBitrbuR0sCe76FrurUHWY4uU2MOLTHnd/OHsPQOKeDEK40VHzHWCvjbNXK7bLDxup8lYBiGAUasBiUW5jMQyDaOnd4OCKT20sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=cO+TVm+G; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="cO+TVm+G"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7741991159bso7496128b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 14:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1758058335; x=1758663135; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w+pSjNeLsJZL3i/7Lq0dITzGdkUuDJxIaNQ0qSX52ac=;
        b=cO+TVm+GqAzLaSI/VhNPnFFJBtBG1gNcykpLLpkUcumGmEYWMLO+PWYEJJHRxAzrPL
         VN0QQHh1h2pO9SFlSFRJcxqSSY3DIXctT8uYghV2li7yecHXs0qLEh5x2hiSpGgiofr3
         gkXW/p3Z4gl15DHDTQe+aXeErfuAs6cjo1FiK74dGN2nhPOjQpsg+07glGbPYPJmAZOg
         IllpJfbaLeMUYa/TAV1ZMO8av8HV4ZEr7AFgtWe2z0q/XzUsVY1jm6QrcMeM5/aNlctq
         xniMA1EB7+yQKNF/++zO8VYS+Zc/YkcNcICueGx79S3vQqAfdYWiXFaL1LSH2QDDJBuE
         Py2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758058335; x=1758663135;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w+pSjNeLsJZL3i/7Lq0dITzGdkUuDJxIaNQ0qSX52ac=;
        b=ms+ffPW4i5V12g6SmEoIAkEewU+7qlxg+qM8tFSktLySECgh/qyuNgKxRgKWv/fQ3n
         Rn9Kn4rOpPJwQp+MRB7J5GdIOxcBchkCf2Yb3gWe8REz+ssR9Jgwcvzz2FmbmOryAfLc
         oytb/AtnPfqgNncCtUm1mSLYoalCpikUtqZc5tS7N4fr5qzDCMb0XMrtbJ71zSHvugmK
         Fm2MF3JO+KoKxhyjml42yxh3rcWK+UdRxvZiQ+82Q+p4pOfhKxvY1kdJkyFu/irWJxXV
         aD1DRFJgCdRguKl9joEYuPbLYeiqk/8mynKHYnVzjjUGvkKyKb/8PXd0joFJhkZDhcow
         NNhg==
X-Gm-Message-State: AOJu0YxC4IDyDdYskUo3xTcx/JXuzJSPIHTRsdhgrUhMrAvSaTpGtuoo
	QTMptP+a5frbkb28zpOqABS8yD/WBgQAcIMauvzaJwGfOnENM7oabfYRSFfK98l67GcguRqJFeV
	J6rCO
X-Gm-Gg: ASbGncslGSFmrItwThdNp/UGNl7qM3MYcKdyMCA2xMeWIERO4bQ6/i80Vc/tfmeirvW
	/IKBCfE4Yvhzu0+Hd9R05TYxpq1lcSdQfX0if+5kV+Zh2BOz460Ut88Wt2PTN/plns9Qs44vOqq
	TA8Yd1hc4jzdvo3wYMk+4/G1yIKPBs/2/x6ToPK0FEmTJoBBDcNoNRU7uLGJ/eCJ7AkpbR/jvO5
	1LU21ZkC5xWJyvHTy8SAZ1juo5ZwpCmLHmMlhW18t/0rpkKNFq46fD4XBaNOBwNI13eUYeHnF9f
	7Vw6Uud9QrjI5D1hm8G8oU9BLW/l4Lw8APXf5csqv4en7lcoQEciU0/45h5ljDVpc/xQNPdUVE5
	6Y68IkZVo45myznGGXjT9WbTj1YtAdUKXnHcVmw8qbRgQXucKW1HN1e5odBELVFCBFRVltUP8Gp
	ocS1TYwK6P
X-Google-Smtp-Source: AGHT+IForYNV/GbgR+492hTD/zs9/EahBTuJ5RZi077YIhKDEPOAIj7YjWB8nTFXO7GvTQGjuLey8A==
X-Received: by 2002:a17:902:eb8b:b0:264:7bf5:c520 with SMTP id d9443c01a7336-2647bf5cad1mr140827455ad.44.1758058334644;
        Tue, 16 Sep 2025 14:32:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-267ee642acasm15658515ad.15.2025.09.16.14.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 14:32:14 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uydHX-00000002qZZ-0A0x;
	Wed, 17 Sep 2025 07:32:11 +1000
Date: Wed, 17 Sep 2025 07:32:11 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: Don't hold XFS_ILOCK_SHARED over log force
 during fsync
Message-ID: <aMnXW_sEk_wTPnvB@dread.disaster.area>
References: <20250908151248.1290-2-jack@suse.cz>
 <aL9yc4WJLdqtCFOK@dread.disaster.area>
 <hzjznua7gqp32yc36b5uef6acy4nssfdy42jtlpaxcdzfi5ddy@kcveowwcwltb>
 <aMIe43ZYUtcQ9cZv@dread.disaster.area>
 <aMkAhMrKO8bE8Eba@dread.disaster.area>
 <vpsyvzbupclvb76axyzytms5rh5yzubcyj5l5h2iwpk3d7xf6a@dw6pemmdfcka>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vpsyvzbupclvb76axyzytms5rh5yzubcyj5l5h2iwpk3d7xf6a@dw6pemmdfcka>

On Tue, Sep 16, 2025 at 03:32:42PM +0200, Jan Kara wrote:
> On Tue 16-09-25 16:15:32, Dave Chinner wrote:
> > On Thu, Sep 11, 2025 at 10:59:15AM +1000, Dave Chinner wrote:
> > > i.e. if we clear the commit sequences on last unpin (i.e. in
> > > xfs_inode_item_unpin) then an item that is not in the CIL (and so
> > > doesn't have dirty metadata) will have no associated commit
> > > sequence number set.
> > > 
> > > Hence if ili_datasync_commit_seq is non-zero, then by definition the
> > > inode must be pinned and has been dirtied for datasync purposes.
> > > That means we can simply query ili_datasync_commit_seq in
> > > xfs_bmbt_to_iomap() to set IOMAP_F_DIRTY.
> > > 
> > > I suspect that the above fsync code can then become:
> > > 
> > > 	spin_lock(&iip->ili_lock);
> > > 	if (datasync)
> > > 		seq = iip->ili_datasync_commit_seq;
> > > 	else
> > > 		seq = iip->ili_commit_seq;
> > > 	spin_unlock(&iip->ili_lock);
> > > 
> > > 	if (!seq)
> > > 		return 0;
> > > 	return xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC, log_flushed);
> > > 
> > > For the same reason. i.e. a non-zero sequence number implies the
> > > inode log item is dirty in the CIL and pinned.
> > > 
> > > At this point, we really don't care about races with transaction
> > > commits. f(data)sync should only wait for modifications that have
> > > been fully completed. If they haven't set the commit sequence in the
> > > log item, they haven't fully completed. If the commit sequence is
> > > already set, the the CIL push will co-ordinate appropriately with
> > > commits to ensure correct data integrity behaviour occurs.
> > > 
> > > Hence I think that if we tie the sequence number clearing to the
> > > inode being removed from the CIL (i.e. last unpin) we can drop all
> > > the pin checks and use the commit sequence numbers directly to
> > > determine what the correct behaviour should be...
> > 
> > Here's a patch that implements this. It appears to pass fstests
> > without any regressions on my test VMs. Can you test it and check
> > that it retains the expected performance improvement for
> > O_DSYNC+DIO on fallocate()d space?
> 
> Heh, I just wanted to send my version of the patch after all the tests
> passed :). Anyway, I've given your patch a spin with the test I have and
> its performance looks good. So feel free to add:
> 
> Tested-by: Jan Kara <jack@suse.cz>

Thanks!

> BTW I don't have customer setup with DB2 available where the huge
> difference is visible (I'll send them backport of the patch to their SUSE
> kernel once we settle on it) but I have written a tool that replays the
> same set of pwrites from same set of threads I've captured from syscall
> trace. It reproduces only about 20% difference between good & bad kernels
> on my test machine but it was good enough for the bisection and analysis
> and the customer confirmed that the revert of what I've bisected to
> actually fixes their issue (rwsem reader lockstealing logic).

It was also recently bisected on RHEL 8.x to the introduction of
rwsem spin-on-owner changes from back in 2019. Might be the same
commit you are talking about, but either way it's an indication of
rwsem lock contention rather than a problem with the rwsems
themselves.

> So I'm
> reasonably confident I'm really reproducing their issue.

Ok, that's good to know. I was thinking that maybe a fio recipe
might show it up, too, but I'm not sure about that nor do I have the
time to investigate it...

> BTW, your patch seems to be about 2% slower on average than what I have
> written and somewhat more variable. It may be just a bad luck but
> I suspect it may be related to the fact that I ended up using READ_ONCE for
> reads of ili_commit_seq and ili_datasync_commit_seq while you use ili_lock.

Possibly....

> So I just wanted to suggest that as a possible optimization (my patch
> attached for reference). But regardless of whether you do the change or not
> I think the patch is good to go.

I was on the fence about using READ_ONCE/WRITE_ONCE.

However, xfs_csn_t is 64 bit and READ_ONCE/WRITE_ONCE doesn't
prevent torn reads of 64 bit variables on 32 bit platforms. A torn
read of a commit sequence number will result in a transient data
integrity guarantee failure, and so I decided to err on the side of
caution....

.....

> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 829675700fcd..2a90e156b072 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -145,18 +145,7 @@ xfs_inode_item_precommit(
>  		flags |= XFS_ILOG_CORE;
>  	}
>  
> -	/*
> -	 * Record the specific change for fdatasync optimisation. This allows
> -	 * fdatasync to skip log forces for inodes that are only timestamp
> -	 * dirty. Once we've processed the XFS_ILOG_IVERSION flag, convert it
> -	 * to XFS_ILOG_CORE so that the actual on-disk dirty tracking
> -	 * (ili_fields) correctly tracks that the version has changed.
> -	 */
>  	spin_lock(&iip->ili_lock);
> -	iip->ili_fsync_fields |= (flags & ~XFS_ILOG_IVERSION);
> -	if (flags & XFS_ILOG_IVERSION)
> -		flags = ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CORE);
> -
>  	/*
>  	 * Inode verifiers do not check that the CoW extent size hint is an
>  	 * integer multiple of the rt extent size on a directory with both
> @@ -204,6 +193,23 @@ xfs_inode_item_precommit(
>  		xfs_trans_brelse(tp, bp);
>  	}
>  
> +	/*
> +	 * Set the transaction dirty state we've created back in inode item
> +	 * before mangling flags for storing on disk. We use the value later in
> +	 * xfs_inode_item_committing() to determine whether the transaction is
> +	 * relevant for fdatasync or not. ili_dirty_flags gets cleared in
> +	 * xfs_trans_ijoin() before adding inode to the next transaction.
> +	 */
> +	iip->ili_dirty_flags = flags;
> +
> +	/*
> +	 * Now convert XFS_ILOG_IVERSION flag to XFS_ILOG_CORE so that the
> +	 * actual on-disk dirty tracking (ili_fields) correctly tracks that the
> +	 * version has changed.
> +	 */
> +	if (flags & XFS_ILOG_IVERSION)
> +		flags = ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CORE);
> +

OK, I think I might have missed this. I'll check/fix it, and send an
updated version for inclusion.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
