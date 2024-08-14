Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654F77346D
	for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 21:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723672224; cv=none; b=XuUJ6iqRf0RvgHNvj9vK1DEE29Pwlb2zjja1PP0mfgUSHgmcnUzKatwdL2A9CxcqYzkzz3Ioyn1Qn0dtlqZ01nztzPEgbOIXlIJUKbC0AeiO1x6GXhSRqeYBuazS+QDJWsT0YC2v6ppyjBthnCfj12QxIJMrR8UYJB6aWzMKbeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723672224; c=relaxed/simple;
	bh=8OALDjpMpl1dJiePTzB/P/6ENqMCdVZZw33qtSHE+F8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hzz4ju5SRp/56jU+zeZ6AI2HRdKJTvAwHZFMEq+SUqpjQ3mjLjKLQF49hDNn9PCdb/EHNxyKSyF7SBCR3Jff5RrXi3lT0G9kH6pebyF9RAcmVlgE77423zH1v4rfma0EqhyRiettffmzCzv7tMr1rgPYgBl0iR/VJXvq3rQPvvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=HEpMj4F1; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="HEpMj4F1"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1fc65329979so3373805ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 14:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1723672220; x=1724277020; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=95RKT+2SQppOQr1VgjziPVzGf4MIch8NH88huMWpwBU=;
        b=HEpMj4F1takq8Dj0KR1Ozr/k766txag292AxJqR6cwWX9V2kIogn2gSZS6U50cK1E0
         rK1oKjnZbLk3t2rGkYaQjxQNzcaPsqqene6WYz12lBwX4lnF5/UzhPIldvSdqS2c4vCv
         9BOEgkCRgcDO/F9Z0yc29ok5eiveJleRQY6/w8LIUfHsNQTF4sqSTRDup3zX8gkS+6jW
         JOm/F2bkFvOg9QV+dSdJE+iqmhUTd1PA+dep3jJKT5RitSMV5WdTfbVHJ3Pg2JSo30ae
         n5tJTRi9GARtb7yDDWNzWd2QwL8Q0fajUxyHbodjwH/XfwRCzZDPEajITCCfhmu7ZD61
         3Uwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723672220; x=1724277020;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=95RKT+2SQppOQr1VgjziPVzGf4MIch8NH88huMWpwBU=;
        b=bsMrtQoQcKv45pK/VxhFrfK18Ro/w/Qz5hdbgRhK+wfJK85sBKmkQ6KBr9DtdRX7qW
         +FtF5NJwVEWgaDoik+027fBCAV1qMeoyNuRkPFIHwiyzVISO+LZOODogpDaK27gcNTQF
         apa0DdGyNxYkrV0RrL0aG24YyaoWOdy1ydYNC4q/3GzQCkpsUq7ZJuvJSIWrlkwFb3bs
         5gD8oBx4T+/1vtQMnstDuDnIPAPYcZss+ka8iLewb9+OUryPcfcwL1GQhz0ZUlFmKxRj
         ycTmVDJ6XTn/X8f13+xeGrByguqOeehqMdvQDJ8qhX4UVomxqBsBKP3p8gA89wUjPOe4
         SC3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVCyAZfkUmRpyc/i582iLNKdnWd0l27AMnga+aAWThlEAymga9oGEO+kfEcMJzqHRe9VQdQdta9vWm09sAZ0SDInS3jcFh8MS6B
X-Gm-Message-State: AOJu0YybNyjWQIUUg8KmBgmFE1IJiZP4vlROGAED7TpNB07mvmHYJB4N
	5+F/EZFuGZK1MXhCqrTSTklOfkJxRhS+aU1WyLAulUatcBEJpLX4gZkizEv+79I=
X-Google-Smtp-Source: AGHT+IHrOw7qud/Ve7kmOhAaRR1eCibYydMEkfvT+CbZpYhPoQmQ+0vI/ZEbD0x7OrghckBIyxFS7w==
X-Received: by 2002:a17:903:18b:b0:1ff:3c4f:e93d with SMTP id d9443c01a7336-201d65c09f4mr53110405ad.55.1723672220527;
        Wed, 14 Aug 2024 14:50:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f02faa2dsm955045ad.36.2024.08.14.14.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 14:50:20 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1seLsn-00HFlM-33;
	Thu, 15 Aug 2024 07:50:17 +1000
Date: Thu, 15 Aug 2024 07:50:17 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: fix handling of RCU freed inodes from other AGs
 in xfs_icwalk_ag
Message-ID: <Zr0mmZmoHNLReTi/@dread.disaster.area>
References: <20240812052352.3786445-1-hch@lst.de>
 <20240812052352.3786445-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812052352.3786445-2-hch@lst.de>

On Mon, Aug 12, 2024 at 07:23:00AM +0200, Christoph Hellwig wrote:
> When xfs_icwalk_ag skips an inode because it was RCU freed from another
> AG, the slot for the inode in the batch array needs to be zeroed.  We
> also really shouldn't try to grab the inode in that case (or at very
> least undo the grab), so move the call to xfs_icwalk_ag after this sanity
> check.

I think this change is invalid and needs to be reworked. It moves
the actual "has the inode been RCU freed in this grace period"
checks to after some other check on the inode is performed. From
that perspective, this is a bad change to make.

From another perspective, this is a poor change to make because....

> Fixes: 1a3e8f3da09c ("xfs: convert inode cache lookups to use RCU locking")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

... that commit and the current code isn't actually broken.

In commit 1a3e8f3da09c, xfs_inode_ag_walk_grab() added explicit
checks against using RCU freed inodes, and that nulls out the inode
in the batch array:

       /*
        * check for stale RCU freed inode
        *
        * If the inode has been reallocated, it doesn't matter if it's not in
        * the AG we are walking - we are walking for writeback, so if it
        * passes all the "valid inode" checks and is dirty, then we'll write
        * it back anyway.  If it has been reallocated and still being
        * initialised, the XFS_INEW check below will catch it.
        */
       spin_lock(&ip->i_flags_lock);
       if (!ip->i_ino)
               goto out_unlock_noent;


Indeed, xfs_icwalk_igrab() -> xfs_blockgc_igrab() still has this
check:

	/* Check for stale RCU freed inode */
        spin_lock(&ip->i_flags_lock);
        if (!ip->i_ino)
                goto out_unlock_noent;

However, that commit used a different check for reclaimable inodes;
it uses XFS_IRECLAIM to indicate that the inode is either being
reclaimed or has been RCU freed and so reclaim should not touch it.
xfs_reclaim_igrab() still retains that check:

	spin_lock(&ip->i_flags_lock);
        if (!__xfs_iflags_test(ip, XFS_IRECLAIMABLE) ||
            __xfs_iflags_test(ip, XFS_IRECLAIM)) {
                /* not a reclaim candidate. */
                spin_unlock(&ip->i_flags_lock);
                return false;
        }

XFS_IRECLAIM is always set on RCU freed inodes (it's set at the same
time ip->i_ino is set to zero in xfs_reclaim_inode()) before the
inode is rcu freed, and so neither of these grab functions will
allow RCU freed inodes to be grabbed.

Hence:

> ---
>  fs/xfs/xfs_icache.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index ae3c049fd3a216..3ee92d3d1770db 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1701,9 +1701,6 @@ xfs_icwalk_ag(
>  		for (i = 0; i < nr_found; i++) {
>  			struct xfs_inode *ip = batch[i];
>  
> -			if (done || !xfs_icwalk_igrab(goal, ip, icw))
> -				batch[i] = NULL;
> -

The existing code here -always- catches RCU freed inodes that have
not yet been freed due to the grace period still running. This
code replaces RCU freed inodes with NULL in the batch
array, and so after this point the inode is guaranteed to be valid.

>  			/*
>  			 * Update the index for the next lookup. Catch
>  			 * overflows into the next AG range which can occur if
> @@ -1716,8 +1713,14 @@ xfs_icwalk_ag(
>  			 * us to see this inode, so another lookup from the
>  			 * same index will not find it again.
>  			 */
> -			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno)
> +			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno) {
> +				batch[i] = NULL;
>  				continue;

This check is not checking for RCU freed inodes - it was checking
for indoes that are both freed and reallocated within a single RCU
grace period.  I added this check in 1a3e8f3da09c (backin 2010)
because I wasn't 100% certain of the RCU existence guarantees and
those interacted with read side critical sections.  It was
defensive, "just in case" code.

Looking at this code now - with another 14 years of RCU algorithms
experience under my belt - it is obvious that this code is
unnecessary and always has been.

From RCU first principles, we cannot see a new inode
with a different inode number magically appear at this memory
address during a rcu_read_lock() side critical period.

Such behaviour would require the inode to be removed from the radix
tree, freed and then reallocated and reinitialised to a different
identity within a single RCU grace period. That is impossible
because the object we found during the lookup won't get freed until
the RCU grace period ends sometime after we drop the
rcu_read_lock()....

Hence the right thing to do here is to remove this check completely
and leave the rest of the code alone....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
