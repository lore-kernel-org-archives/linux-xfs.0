Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DE433F361
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 12:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773750033; cv=none; b=lxKXXSEFtRodOJOh5AGKVv1O5eLHddj9bRjSFYAp+ryTZYZAHlDrGipfLD0Csxyu3yPGKHsZ+NWGHHYPBw29821LXXhsOuZ14oycOSmi/KXkO2qvDZrFDBRoCg0DdZZQp/Wn2yMeXCTHH2MoqhJ54TP1/ZUmivuIdDrdzYXlbi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773750033; c=relaxed/simple;
	bh=aBu4XIAeWlJ54oYUjB0jUWV4DmiRWRuLItJU9SCxCao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EPMHkztM/P9wu3pEu0dA0SoGOL4K2XPUbvF/LPdNvRJH6mtCjjy6HlFeXoc/zuaaEqxxF7FSpVjbX6tWt4TpAQApAfplMC7hg6ZhPkAlT8LEAX+staCOMaYjRA/4X0UBi1m0uasBBjf07AVNtLMZmOk/NBbl0MiZWnhHHzIpeGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qmpsRNGr; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qmpsRNGr"
Date: Tue, 17 Mar 2026 12:20:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773750028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+GcZ/t9B7Wfy1h9138fRFPa16c+9h4buD6kRjajxqG8=;
	b=qmpsRNGroYp8ZLFoS14e3c+BHITIgAPV9w/UmSgXJrJD/UeLap+XHB6UaAlmV2D53cEl6L
	EOMgyS3haTgg6zHq9ctAU3oDIH0LSdTVeBaVvzbncKFjfMVhskajgoe2mG9Llp/BTwh2rr
	y476jlc7m2Oh1JtNpxmZaoeHVP/Lw98=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: Dave Chinner <dgc@kernel.org>, linux-xfs@vger.kernel.org, 
	cem@kernel.org, hch@infradead.org, djwong@kernel.org, p.raghav@samsung.com
Subject: Re: [PATCH v11 2/2] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <6i2jvzn3lyugjlbgmjzpped3gogzyqv5mpe2uqaifz4vjpaega@pomzoq7ley77>
References: <20260309181235.428151-2-lukas@herbolt.com>
 <abCzhDSVmFx4PtWI@dread>
 <f0ee82badefac989866339605b224cfc@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0ee82badefac989866339605b224cfc@herbolt.com>
X-Migadu-Flow: FLOW_OUT

> > 
> > Then xfs_iomap_write_unwritten() can be factored to a one-liner
> > (or replaced altogether), and this new fallocate op pretty much
> > becomes:
> > 
> > 	error = xfs_bmap_alloc_or_convert_range(ip, offset, len,
> > 			XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO,
> > 			new_size ? true : false);
> > 
> > The name of the function sucks but I can't think of anything better,
> > so if you've got a better idea then change it. :)
> > 
> > -Dave.
> 
> When I first start looking into it the xfs_iomap_write_unwritten() was first
> place I was exploring, but did not think of the the above. I started working
> on it but I will be travelling this week so after that you may
> expect v13.

@Lukas and @Dave:

I took a shot at this in the meantime. Simple tests seems to be passing
with this approach but I noticed I am getting a panic when I run
generic/127 with my xfstests patches to ltp [1]. I will keep digging on
the side. Let me know if something looks obviously wrong in the
implementation.

This is what I have for xfs_bmap_alloc_or_convert_range() [2]:

/*
 * This function is used to allocate written extents over holes
 * and/or convert unwritten extents to written extents based on the
 * @flags passed to it.
 *
 * If @flags is zero, if will allocate written extents for holes and
 * delalloc extents across the range.
 *
 * If XFS_BMAPI_CONVERT is specified in @flags, then it will also do
 * conversion of unwritten extents in the range to written extents.
 *
 * If XFS_BMAPI_ZERO is specified in @flags, then both newly
 * allocated extents and converted unwritten extents will be
 * initialised to contain zeroes.
 *
 * If @update_isize is true, then if the range we are operating on
 * extends beyond the current EOF, extend i_size to offset+len
 * incrementally as extents in the range are allocated/converted.
 */
int
xfs_bmap_alloc_or_convert_range(
        struct xfs_inode        *ip,
        xfs_off_t               offset,
        xfs_off_t               count,
        uint32_t                flags,
        bool                    update_isize)
{
        xfs_mount_t     *mp = ip->i_mount;
        xfs_fileoff_t   offset_fsb;
        xfs_filblks_t   count_fsb;
        xfs_filblks_t   numblks_fsb;
        int             nimaps;
        xfs_trans_t     *tp;
        xfs_bmbt_irec_t imap;
        struct inode    *inode = VFS_I(ip);
        xfs_fsize_t     i_size;
        int             error;

        ASSERT((flags & ~(XFS_BMAPI_ZERO | XFS_BMAPI_CONVERT)) == 0);

        offset_fsb = XFS_B_TO_FSBT(mp, offset);
        count_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
        count_fsb = (xfs_filblks_t)(count_fsb - offset_fsb);

        /* Attach dquots so that bmbt splits are accounted correctly. */
        error = xfs_qm_dqattach(ip);
        if (error)
                return error;

        do {

                uint    resblks, dblocks;
                /*
                 * The transaction reservation is limited to a 32-bit block
                 * count, hence we need to limit the number of blocks we are
                 * trying to reserve to avoid an overflow.
                 */
                resblks = XFS_FILBLKS_MIN(count_fsb, XFS_MAX_BMBT_EXTLEN);
                /*
                 * The blocks either need to be allocated or converted from
                 * unwritten to written. Consider the allocation case to
                 * cover both scenarios.
                 */
                dblocks = XFS_DIOSTRAT_SPACE_RES(mp, resblks);

                /*
                 * Set up a transaction to convert the range of extents
                 * based on the flags. Do allocations in a loop until
                 * we have covered the range passed in.
                 *
                 * Note that we can't risk to recursing back into the filesystem
                 * here as we might be asked to write out the same inode that we
                 * complete here and might deadlock on the iolock.
                 */
                error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, dblocks,
                                0, true, &tp);
                if (error)
                        return error;

                error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
                                XFS_IEXT_WRITE_UNWRITTEN_CNT);

                if (error)
                        goto error_on_bmapi_transaction;

                nimaps = 1;
                error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
                                        flags, 0, &imap, &nimaps);
                /*
                 * TODO: should we try if we get ENOSR?
                 */
                if (error)
                        goto error_on_bmapi_transaction;

                /*
                 * Log the updated inode size as we go.  We have to be careful
                 * to only log it up to the actual write offset if it is
                 * halfway into a block.
                 */
                i_size = XFS_FSB_TO_B(mp, offset_fsb + count_fsb);
                if (i_size > offset + count)
                        i_size = offset + count;
                if (update_isize && i_size > i_size_read(inode))
                        i_size_write(inode, i_size);
                i_size = xfs_new_eof(ip, i_size);
                if (i_size) {
                        ip->i_disk_size = i_size;
                        xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
                }

                error = xfs_trans_commit(tp);
                xfs_iunlock(ip, XFS_ILOCK_EXCL);
                if (error)
                        return error;

                if (unlikely(!xfs_valid_startblock(ip, imap.br_startblock))) {
                        xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
                        return xfs_alert_fsblock_zero(ip, &imap);
                }

                if ((numblks_fsb = imap.br_blockcount) == 0) {
                        /*
                         * The numblks_fsb value should always get
                         * smaller, otherwise the loop is stuck.
                         */
                        ASSERT(imap.br_blockcount);
                        break;
                }
                offset_fsb += numblks_fsb;
                count_fsb -= numblks_fsb;
        } while (count_fsb > 0);

        return 0;

error_on_bmapi_transaction:
        xfs_trans_cancel(tp);
        xfs_iunlock(ip, XFS_ILOCK_EXCL);
        return error;
}

[1] https://lore.kernel.org/linux-xfs/20260312195308.738189-1-p.raghav@samsung.com/
[2] https://github.com/Panky-codes/linux/tree/xfs-falloc-write-zeroes-dave
--
Pankaj
