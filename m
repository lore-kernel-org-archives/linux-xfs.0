Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AE93CF40
	for <linux-xfs@vger.kernel.org>; Sun, 21 Apr 2024 23:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713741899; cv=none; b=Qa27ZZSD9wwjwfb5Tfpqtq6s1bU7BNVeSvYjP86tEksWaANmr9cMvRNDwNnb5kiFkeQE7Qrdn6aKRHE5FLPEogVRd8Q/GX2iuqgAAAdmNCa7o3wIrRmsvKGt1wgg4mHtJtj/plo9I/HKriFby+HWaVJlMbSg6boyrh4HGuCfSls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713741899; c=relaxed/simple;
	bh=stzyQbPCvW41vBOOdKf6MOMnKUO/Ci6yh18Wqxf2jqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dTHlSbI7I4pz57gIJ6avXMn5lTAPs1VYb4fyzXxp3m3DqojXtuNTdf8gprjnvq4SvevO/a24q7stIjHCgmJHxh0xVHKNDK542kUEAKFca1T404l2e+/rLYSGzxfctkvhr5NiuxJUuxE1KeHZ6GUH1dXQRvN8v1csEQqd7f7OAFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=nJzEhLFS; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="nJzEhLFS"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2a87bd53dc3so3061766a91.2
        for <linux-xfs@vger.kernel.org>; Sun, 21 Apr 2024 16:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1713741897; x=1714346697; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rBt5D80bdpRZmFA4sfWYoN65OvXd7gwmhoDVLF1qURU=;
        b=nJzEhLFS8EcfTuxod2CzE3Da8K9jVL3DL2/skivVhuLYGfpZJF5QFA1uijaF8Wc6Ed
         MINAR10HT7KssehgHl8PJ1xAFqYjKxDv6S76RFXs5Lca/xVvgN5phS8BwBDMoTS3q7gU
         2Xh515FHXoAnlgmReINErxMA5VQnTyELUlhxSEjwcZVHtDB3VJh7vW+Eb3TtQTA9sKrB
         YvZz0k+ukoivUjAeX8lfaqSaSYH66i9Pkbatbp9DlNFjJV0fHDw/zoXAWXcC8Ud/0BvA
         2c8ijlU8PRKm/JMFgEaruDU7JtYZaUZ0ZowbQIsVBQKPopIFaDxdITY9Hlr01hZPidS1
         lEnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713741897; x=1714346697;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rBt5D80bdpRZmFA4sfWYoN65OvXd7gwmhoDVLF1qURU=;
        b=ETAMp/hw6d7PwVosjS1dm1/0xeRGYLWdX5lN1w0hdt4GIjVwCzpQeSs9AGPaOQALjO
         nKndnhXbdle7wg9xzheSEuszoIauWr4vTxfV6zUUV4WA4kxt1lmcLdrhDebbctveRYHE
         1Tgm20FnoRIprIqOkWsXdCUXwXGv62nNH0erRho7ZUa9wAwt/fEuJsRvwPO9SSxnChmI
         gW9tC7G8uFOhBQ1hzRbOTJQcd2LdFvqeq63vfuYy+mKfBW3GsN/gxeZhqwAkrZiEt6Jk
         TpEjd0qdGTpDK4ml2WVutYLSornCtEY6T8pB+uIIMdj+eQUb45QjBEUNLCSOzpp/pcDQ
         mnyg==
X-Forwarded-Encrypted: i=1; AJvYcCXyV+Wgl39CXbkT5SGUvbYvEidhqZAhNOvYEjTjcS850Uw7lAiQnkiQEfBhxevN+NwNMyF7p8MI/gnIXBM6U8rjXydjdYnlJ0Oy
X-Gm-Message-State: AOJu0Yz0sJBsaVurRt5AKbvdGtkSaTBWfYw3Rbc5dlQC7VQuDKF9fwlA
	rVx9vOB865bxxaeB6T4e6QtO9lkUJtsGawriiuifRPJLIAwroGukoHDbLxLe6qs=
X-Google-Smtp-Source: AGHT+IGWYEuQNzxC7wnyignXRUaCr0BcGSocgEdTMCaK6NMlEnLaUFRpn8o+qAV9gN85J+RI7xj0sg==
X-Received: by 2002:a17:90b:1b0e:b0:2a2:830a:89a4 with SMTP id nu14-20020a17090b1b0e00b002a2830a89a4mr5611163pjb.41.1713741896686;
        Sun, 21 Apr 2024 16:24:56 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id i14-20020a17090a7e0e00b002a78cad14a8sm6420534pjl.30.2024.04.21.16.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Apr 2024 16:24:55 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rygYG-006J2o-1O;
	Mon, 22 Apr 2024 09:24:52 +1000
Date: Mon, 22 Apr 2024 09:24:52 +1000
From: Dave Chinner <david@fromorbit.com>
To: Ye Bin <yebin10@huawei.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, chandan.babu@oracle.com,
	dchinner@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 1/2] xfs: fix potential create file failed
Message-ID: <ZiWgRGWVG4aK1165@dread.disaster.area>
References: <20240419061848.1032366-1-yebin10@huawei.com>
 <20240419061848.1032366-2-yebin10@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240419061848.1032366-2-yebin10@huawei.com>

On Fri, Apr 19, 2024 at 02:18:47PM +0800, Ye Bin wrote:
> In the file system expansion test and concurrent file creation and
> writing scenarios, file creation fails occasionally.
> The detailed test scheme is as follows:
> 1. If the remaining space is less than 128 MB, expand the space by 1 GB;
>    --xfs_growfs /$DEV -D $bc -m 100
> 2. 32 processes create a file every 0.5s and write 4 KB to 4 MB data randomly.
>    --filesize=$((RANDOM % 1024 + 1))
>    --dd if=/dev/zero oflag=direct of=$filename bs=4K count=$filesize

So this is racing growfs against a heap of concurrent file creates
and 4kB direct IO writes which are doing individual 4kb allocations?

And because of the way growfs works, after a while all the free
space ends up in the last AG? i.e. there is effectively only one AG
with free space that can be allocated out of?

> There is a possibility that the file fails to be created after the preceding
> steps are performed. However, when file creation fails, there are still
> hundreds of megabytes of free space.

Ok, but the problem with having transient ENOSPC conditions reported
to the application is ....? I mean, this is pretty much expected
behaviour when you are racing a highly concurrent create/write
workload against ENOSPC and growfs....


> The process of failing to create a file
> is as follows:
>       Direct write                            create file
> xfs_direct_write_iomap_begin
>  xfs_iomap_write_direct
>    ...
>   xfs_alloc_ag_vextent_near
>    xfs_alloc_cur_finish
>     xfs_alloc_fixup_trees
>      xfs_btree_delete
>       xfs_btree_delrec
>        xfs_allocbt_update_lastrec
>         case LASTREC_DELREC:
> 	 numrecs = xfs_btree_get_numrecs(block);
> 	 if (numrecs == 0)
> 	  len = 0;
> 	 pag->pagf_longest = be32_to_cpu(len);

At this point, the freespace tree is -empty-.

i.e. We just removed the last free space from the tree, and the
freespace code has no idea what the caller is going to do with that
free space it just removed from the tree. It may well be using all
of it, and so the AG must be marked as empty at this point as there
is no free space remaining in it.

Sure, xfs_alloc_fixup_trees() may well be about to insert the unused
part of that back into the tree (i.e. the size has changed), but the
btree tracking code has no way of knowing this, nor does
xfs_alloc_fixup_trees() have any way of knowing that this is
actually the last freespace extent in the btree that it is
manipulating....

So, yeah, the lastrec update code has to do this, even for transient
updates.

> 	                                xfs_generic_create
> 					 xfs_create
>                                           xfs_dialloc
> 					   for_each_perag_wrap_at
> 					    xfs_dialloc_good_ag

Did you check what this code does? It samples pag->pagf_longest
to determine if the AG has enough space for the inode chunk
allocation. So this check here ran before the last free space record
was removed from the AG and said "there's enough space here!".

This is how we scan AGs to find an allocation target - we do
unlocked peeks at the freespace state and determine the best AG to
allocate from. If this doesn't find an AG with enough space, then
we'll declare ENOSPC here without even getting to the allocation
code that takes AGF locks. We most certainly don't want this code
taking locks here to avoid transient values....

> 					     xfs_dialloc_try_ag  ->The last AG to alloc inode
> 					      xfs_ialloc_ag_alloc
> 					       ...
> 					       xfs_alloc_vextent_prepare_ag
> 					        xfs_alloc_fix_freelist
> 						 xfs_alloc_space_available
> 						  longest = xfs_alloc_longest_free_extent()
> 	                                           ->As pag->pagf_longest is equal to zero
> 						     longest is equal 1
> 	                                          if (longest < alloc_len)
> 	 						return false;
> 						  -> will return false, no space to
> 						     allocate for inode

But at this point where we sample the AG freespace we find that it
is at ENOSPC, so the allocation is failed and returned back to the
for_each_perag_wrap_at() loop for it to try a different AG. If no
AGs can be allocated from, then ENOSPC is returned to the user.

Essentially, the test case is resulting in a single freespace extent
remaining in the very last AG with space available.  This is a large
extent because of the fact grwofs is adding contiguous 1GB freespace
extents one at a time, and this ends up being the only free space
available for allocation from. This is purely caused by the repeated
growfs component of the workload, and hence when any allocation
from the last AG fails, there is no fallback and userspace gets
ENOSPC.

> As there isn't hold AGF buffer's lock when call xfs_alloc_space_available()
> first time in xfs_alloc_fix_freelist(). If remove the last right leaf record
> of CNT btree will update 'pag->pagf_longest' with zero. This process is hold
> AGF buffer's lock.
>
> Above test case constructs repeatedly allocate space within
> the same AG, increasing the concurrency between the two processes.
> To solve above issue, there's need to hold AGF buffer's lock before call
> xfs_alloc_space_available() to judge space is available for request.

Please think a little more carefully about what the code you are
changing actually does. xfs_alloc_space_available() uses a
"check-lock-check again" algorithm, and so moving the locking so it
is a "lock-check-check again" makes the second set of checks
redundant.....

----

Regardless, as I implied above about the AG selection scanning, I
don't think this is the right way to fix this issue.  We don't want
AGs at ENOSPC to require scanners to take the AGF lock to determine
if they really are at ENOSPC or not.  This adds significant overhead
and latency to the allocation algorithm, especially as AG count
climbs into the thousands and allocations may have to scan hundreds
to thousands of AGs as we near ENOSPC to find the best candidate to
allocate from.

What we actually want is for pag->pagf_longest not to change
transiently to zero in xfs_alloc_fixup_trees(). If the delrec that
zeroes the pagf_longest field is going to follow it up with an
insrec that will set it back to a valid value, we really should not
be doing the zeroing in the first place.

Further, the only btree that tracks the right edge of the btree is
the by-count allocbt. This isn't "generic" functionality, even
though it is implemented through the generic btree code. If we lift
->update_lastrec from the generic code and do it directly in
xfs_alloc.c whenever we are finished with a by-count tree update
and the cursor points to a record in the right-most leaf of the
tree, then we run the lastrec update directly at that point. 
By decoupling the lastrec updates from the individual record
manipulations, we can make the transients disappear completely.

This means all the unlocked AG scanning and the
the check-lock-check again algorithm in xfs_alloc_space_available()
would never see transients and so work reliably in these rare
post-growfs-from-total-ENOSPC situations...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
