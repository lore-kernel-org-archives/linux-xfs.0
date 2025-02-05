Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB651FFC4B
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 21:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738792444; cv=none; b=stajo8xtpL7VNKvJnZyrO8IAUOj+id6kfjd6TNvZzbUUr3uDpPwaCU99YKBZwhU+ZIX/kYWr+zJ4H3F17tHvD2H+Hi7RhkAqqQUZ90kqBzRiMf4Ksswo/8dyc+FfjkDYlwJ7R3wEVlkbrzWU/vMueHIrikK1bNv5h81Sg6klWP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738792444; c=relaxed/simple;
	bh=xSpWCXg1gxsh69WnGaEd3YqP02rfJq8z06M2q2JH/dI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DxQQdSwWMuCZw0wWfdOqQeGoKLDgk+z0RiflMVj13tYsT4YoXmuMV0KnGSbxdCxS6kdMBWmMtdHSd/YCgbyhdQNTBKe0GAAU0azcLU2Yjy80TlTpJm7a0MTEm1jXCfW9M1VokNiOCR54pHqoabr2Vmvye+nNvguSS66LAO0+HXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=U/X6bWnJ; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="U/X6bWnJ"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-21f05693a27so4107265ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 05 Feb 2025 13:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738792442; x=1739397242; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=62Js+QkOT8n0b9PfYDCbz0CHOgWvlarv83fUOjb4Qa8=;
        b=U/X6bWnJb4u+D2ug9Bvb5pygYrGEDqz/jeesBQ6Df5m1C39+l7+9yfARbcTJG2BK+z
         PzfNp7REvoDAlThaEDOMvQvfRa+RCxkSI15/C7Xp097N2+ibFKmE5hYb+JS9BjUbAeLN
         Tboxpf9RG+YGJEew4CBUOzhbgf753qiAvrjceqXrl+qI/i8qReMw+iu/gfG3ymVIH+JW
         ws48ivWDUrknaLINF7dFwT5Vit5GvngZ0XWa1d7Fm+Mhhxqgv+sE2GXCAlLrAPyQJat5
         x1DC+CBG7po6ekLIdZ3VD2FZp+176/55Myw79qizCSwBYCCQKb1i4t0f8TW2UEwl7aB3
         t+QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738792442; x=1739397242;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=62Js+QkOT8n0b9PfYDCbz0CHOgWvlarv83fUOjb4Qa8=;
        b=GRkf8onK0DzBFH+O6xm7E4TF7E62cm18yT6C+VgmuUdvgHMgR8k/5jN8fmsol45CmN
         N8/U0pt4qZ9riHSupWck43nQyAWvouG9PtyZQZbJlSHWwYwhr8l9GPUWTGrtfef+b85a
         T0focwqmhHFOlOL7u8KziRO8GKfVCiwd/JEYJB895Pkb2RfzVSPMC6eHOyNOByaVMl5K
         DoLCTSvoGzloguikkj8pSW6w418+oscti1Bu/Xwies2Vc5KDzRCf5Hp1Vv9rHpBaDjMm
         uynu2htsmeMvoMnfXy4SLxCdKyiMfwp/M3atFDWJVbs8bpYPpUVz4B9kijMo4lq3n0/5
         ppKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXSi08a6H5kZje4H8InM/JQ5gI75ljlqMS+b3xlwQymLFyNl60yT0+i0MDmzRijN4s6MJdpDYwsm3Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYCM1tNpffK3MoED5CQpqt1m+9TYCKsm4M/bYLFXaNt1g2Px1L
	b8yF+VpiaXwwoWRG2TAbLhYkLKPww4ZbseVZmYrVrsiTOYNpnRcJBdgh1VYWdxA=
X-Gm-Gg: ASbGncswrKWTLZMVqQem4N5YXJ+/Lx0xjjVQ05oMGPj1M18tTN5DuW+/wF6hRfMLxjO
	goKIPJPDaj7njVl4HdTHJSV5Gybo1e2pN9ILxoggkaElj/U54Ap3J6kgPPPUGFCqvmKxl2Rwu4A
	ADfH56Vj3QtkqO+fPfRAaeRXTSzaBM9xEn+A9U/3H6MiXioph1jSMyxigUTX0mrefk/42HryD5O
	RnToGnryjuIlTTxE0TF6XjR24Sqqle7ooQ3biQh4qnGn7Id+N4vlMhlfX3K+Jmhm4ErXANQ3lSL
	AJqC037PZKMu7hKI7EMIpBH6OszvQlEnFvtuu0HMyaiIw4PaZj0Ej0uG
X-Google-Smtp-Source: AGHT+IHRXhhl0Y25zoso4utbYu22pwdNDmGOT+g1Rk3921ii1ZV47GpREEWdWeY4/hBCNBFATdX/mQ==
X-Received: by 2002:a17:903:2988:b0:21f:515:d61 with SMTP id d9443c01a7336-21f17e024ebmr71010005ad.21.1738792442038;
        Wed, 05 Feb 2025 13:54:02 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de3308f72sm119666425ad.175.2025.02.05.13.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 13:54:01 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tfnLL-0000000F6WI-0w34;
	Thu, 06 Feb 2025 08:53:59 +1100
Date: Thu, 6 Feb 2025 08:53:59 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Zorro Lang <zlang@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: flush inodegc before swapon
Message-ID: <Z6Pd9wG2sqVZSKjQ@dread.disaster.area>
References: <20250205162813.2249154-1-hch@lst.de>
 <20250205162813.2249154-2-hch@lst.de>
 <Z6PTPoYfyn-1-hHr@dread.disaster.area>
 <20250205211659.GC21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205211659.GC21808@frogsfrogsfrogs>

On Wed, Feb 05, 2025 at 01:16:59PM -0800, Darrick J. Wong wrote:
> On Thu, Feb 06, 2025 at 08:08:14AM +1100, Dave Chinner wrote:
> > On Wed, Feb 05, 2025 at 05:28:00PM +0100, Christoph Hellwig wrote:
> > > Fix the brand new xfstest that tries to swapon on a recently unshared
> > > file and use the chance to document the other bit of magic in this
> > > function.
> > 
> > You haven't documented the magic at all - I have no clue what the
> > bug being fixed is nor how adding an inodegc flush fixes anything
> > to do with swap file activation....
> > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  fs/xfs/xfs_aops.c | 18 +++++++++++++++++-
> > >  1 file changed, 17 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > > index 69b8c2d1937d..c792297aa0a3 100644
> > > --- a/fs/xfs/xfs_aops.c
> > > +++ b/fs/xfs/xfs_aops.c
> > > @@ -21,6 +21,7 @@
> > >  #include "xfs_error.h"
> > >  #include "xfs_zone_alloc.h"
> > >  #include "xfs_rtgroup.h"
> > > +#include "xfs_icache.h"
> > >  
> > >  struct xfs_writepage_ctx {
> > >  	struct iomap_writepage_ctx ctx;
> > > @@ -685,7 +686,22 @@ xfs_iomap_swapfile_activate(
> > >  	struct file			*swap_file,
> > >  	sector_t			*span)
> > >  {
> > > -	sis->bdev = xfs_inode_buftarg(XFS_I(file_inode(swap_file)))->bt_bdev;
> > > +	struct xfs_inode		*ip = XFS_I(file_inode(swap_file));
> > > +
> > > +	/*
> > > +	 * Ensure inode GC has finished to remove unmapped extents, as the
> > > +	 * reflink bit is only cleared once all previously shared extents
> > > +	 * are unmapped.  Otherwise swapon could incorrectly fail on a
> > > +	 * very recently unshare file.
> > > +	 */
> > > +	xfs_inodegc_flush(ip->i_mount);
> > 
> > The comment doesn't explains what this actually fixes. Inodes that
> > are processed by inodegc *must* be unreferenced by the VFS, so it
> > is not clear exactly what this is actually doing.
> > 
> > I'm guessing that the test in question is doing something like this:
> > 
> > 	file2 = clone(file1)
> > 	unlink(file1)
> > 	swapon(file2)
> > 
> > and so the swap file activation is racing with the background
> > inactivation and extent removal of file1?
> 
> Yes, I think hch is referring to this:
> https://lore.kernel.org/fstests/2c9ff99c2bcaec4412b0903e03949d5a3ad0d817.1736783467.git.fdmanana@suse.com/
> 
> > But in that case, the extents are being removed from file1, and at
> > no time does that remove the reflink bit on file2. i.e. even if the
> > inactivation of file1 results in all the extents in file2 no longer
> > being shared, that only results in refcountbt updates and it does
> > not get propagated back to file2's inode. i.e. file2 will still be
> > marked as a reflink file containing shared extents.
> 
> Right, but the (iomap) swapfile activation code only errors out if the
> filesystem gives it a mapping that is marked as shared.  So the reflink
> flag isn't relevant here.
> 
> How about this for a better comment:
> 
> "Ensure inode GC has finished so that unlinked clones of this file have
> been truncated and inactivated fully.  This is to ensure that walking
> the swap file does not find any shared extents."

Even talking about it in terms on "inodegc" seems like
misdirection to me. Now I understand what this flush is working
around, it is clear to me that swapon could race the same way with
any other operation that removes extents from cloned files (e.g.
hole punch, truncate, etc).

however, from a user perspective, the only one that matters -right
now- is unlink because of the deferred processing of extent removal.

But even that isn't a guarantee - if something else has that cloned
file open, then the unlinked inode won't be queued for inodegc
and so swapon will still fail regardless of the inodegc flush.

Hence I think this needs to explain the race with extent removal and
cloned files, then explain that the inodegc flush is a workaround
that applies only to a specific corner case w.r.t. unlinking clones
before swapon is run. 

Something like:

/*
 * Swap file activation is can race against concurrent shared extent
 * removal in files that have been cloned. If this happens,
 * iomap_swapfile_iter() can fail because it encountered a shared
 * extent even though an operation is in progress to remove those
 * shared extents.
 *
 * This race becomes problematic when we defer extent removal
 * operations beyond the end of a syscall (i.e. use async background
 * processing algorithms). Users think the extents are no longer
 * shared, but iomap_swapfile_iter() still sees them as shared
 * because the refcountbt entries for the extents being removed have
 * not yet been updated. Hence the swapon call fails unexpectedly.
 *
 * The race condition is currently most obvious from the unlink()
 * operation as extent removal is deferred until after the last
 * reference to the inode goes away. We then process the extent
 * removal asynchronously, hence triggers the "syscall completed but
 * work not done" condition mentioned above. To close this race
 * window, we need to flush any pending inodegc operations to ensure
 * they have updated the refcountbt records before we try to map the
 * swapfile.
 */

This explains the race condition we are working around, and it gives
enough information to document that any other refcountbt updates we
defer to background processing (either removals or inserts!) are
going to need to be synchronised here.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
