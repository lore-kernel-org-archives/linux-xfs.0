Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D50933858F
	for <linux-xfs@vger.kernel.org>; Tue, 17 Feb 2026 15:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771340816; cv=none; b=s/uVTagbBAsS/7pnff+8qIKmpEzdfPZjotw6SH1c+ztjxB70vyKZVuixoZaSzw2oXOThaNWaGyd3qrKIBBKyUyLdaeVi73cRpTy92i/1HmVJ/wbOSpKme8csOA6NVYhycv5Ro+q6JhdFJBRFap+pudpGwSgXoEfDxExLrD5hEVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771340816; c=relaxed/simple;
	bh=2iRreTJmR3+8Y7w+IPkUtFAxQUsbKylqqeQQVGJVvb4=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=k86lJNWAULZEeJqDyzw96SIl8NglheuY/S5hsrkaR+P5+mP8htB3HWfOC/6Gu3X4kkzyORh8INYVeVUz5x+z7Y8uvWLO2v03rJe40ViWPDhcTNJSILdx3umAeVpP3z36mbHhOsrNHJlOb2mMDErEniT26WHN/gGsT/QkfAaLIvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jt4WOkuu; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jt4WOkuu"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a9296b3926so29226455ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 17 Feb 2026 07:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771340815; x=1771945615; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XVYan2GOph5iGkuloXlUEbn2xG2E+s4UQDb2f5z5l3w=;
        b=jt4WOkuuuzj3NPAC9rnyl07KkbylL6bV5x6h2taAQrIgR3iKwCay3Q8i2sIvgMHUGD
         1NEKsU8j6oihHSonXyeAr4HalVWpuo8XlP/V8PYeIRncWRng+WLtxnZhz6gOsgjzBOMk
         nAOO0vEV1WMYvvE5JlqWe9twPQ3UlcEbgpo3hnEWIRE71VuZrErBiscG7MKYTnQhUNfc
         4ADhMpwg2lMbKYl5VFuwoDpUW6bWmID+3xGEJOSoVP88+WW9qripQShBbJ1rVe96iMdw
         pM4QgAgvdHcGQzYKLnRCpkOLm4StzAILOHMtsh0qjfKuSgnRXZOenhBKo8NU+csowZfq
         Dq/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771340815; x=1771945615;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XVYan2GOph5iGkuloXlUEbn2xG2E+s4UQDb2f5z5l3w=;
        b=BFUs8ex1bfoSvjwbW97PGMsLo6xzy92xadAz+5WDJZqFFKxzTgcjiEcQQS/KgM3R/y
         S5L9m2lE9uMS82AfOBP7Wi3SNFymKz1sHv+AOPljxNQZGQmb1VymQhmSpp+t/jZFzIgj
         XmVHVqbnl96cShAJaNZ2gIqX0F4PjW+Euw7Zepd8kUGnS8s0HWaf/FH5UnPuiuTxnvUD
         KOnsQPaBeKLVyXndSzRtrpxU+bp68LLvo4EWMYBk8cfROIGUPhIfseJZVnAK71kUOoQ9
         4IGWiaaFnzKDfgsMUWjEYnIGCGWx38ffVo4z0U4Fn/uV+dLELDydL3gYo5GLmKIauEsp
         tAHA==
X-Forwarded-Encrypted: i=1; AJvYcCVy40hvV1Om2128+6DdlbxxNi0kixIdtI4fz08M6tQ4nGf9U87hMrRs60Dqo1GnYY/ik8CmRWTJrhc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAFZuzQnd8D1/bAQpIJgsRWG8G8SqNhD241hQHx3gRET6E8GqA
	LMDeZCfxyYQZNR749uopIsqFJ2mx2+gIjmxTbtRCGRiYt2VSxRJSgCta
X-Gm-Gg: AZuq6aIzujAVAH/qbSVVM26M3gSccjbYOm/17sptnGgynEoA0N/jY9cHj96BlOmLou4
	zxOrbdc1VRNfLeNAuPho8P1E42Mb5U2HYszWkCAf6rzN3I8/Ws/lk1Vp/amEIsRbV4j//QAAweT
	8ZrEfV06MDuaWrSKGpIr55zBm8N4zUMrQTFPQ9btJsmRu2z7iuqQqXJnoNV2SIEHj1fPf1nmWR4
	Zu6fZWEZ4AYcMQrsce7t90fUZkD4+fXHoG3apACEcS0II5Uanc0p3U5S/sRPEW58YUvZnr9HCO7
	eoNI2HBd5RbXX2OKR+HLz9gM4eikeMuFtU2+7+YLbqNFYe+pUDSTJ5e1pQvCKWaSLIyjXercShC
	oohcchaEyyW1pXNmmFWYJswlaqHkeNNoIW5GE5ZZH8tVo7ZFdhsPhaKPDX1MdZRjWpBG1UDGArA
	M98lj+tBPyI0Mzm8bK+JjADdtaQkHXgKZL8Jg7TcblWjsy79z1SGQ9Cb7raPcCtKhYSXqeDXbJx
	rD+uzwP
X-Received: by 2002:a17:903:3545:b0:29d:a26c:34b6 with SMTP id d9443c01a7336-2ab506145ffmr130164015ad.50.1771340814705;
        Tue, 17 Feb 2026 07:06:54 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.205.118])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a738220sm106548725ad.37.2026.02.17.07.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 07:06:54 -0800 (PST)
Message-ID: <37206076c486da01efe90b95f5dc61049cb2d141.camel@gmail.com>
Subject: Re: [PATCH v2 4/5] xfs: only flush when COW fork blocks overlap
 data fork holes
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Brian Foster <bfoster@redhat.com>, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Date: Tue, 17 Feb 2026 20:36:50 +0530
In-Reply-To: <20260129155028.141110-5-bfoster@redhat.com>
References: <20260129155028.141110-1-bfoster@redhat.com>
	 <20260129155028.141110-5-bfoster@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2026-01-29 at 10:50 -0500, Brian Foster wrote:
> The zero range hole mapping flush case has been lifted from iomap
> into XFS. Now that we have more mapping context available from the
> ->iomap_begin() handler, we can isolate the flush further to when we
> know a hole is fronted by COW blocks.
> 
> Rather than purely rely on pagecache dirty state, explicitly check
> for the case where a range is a hole in both forks. Otherwise trim
> to the range where there does happen to be overlap and use that for
> the pagecache writeback check. This might prevent some spurious
> zeroing, but more importantly makes it easier to remove the flush
> entirely.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_iomap.c | 36 ++++++++++++++++++++++++++++++------
>  1 file changed, 30 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 0edab7af4a10..0e82b4ec8264 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1760,10 +1760,12 @@ xfs_buffered_write_iomap_begin(
>  {
>  	struct iomap_iter	*iter = container_of(iomap, struct iomap_iter,
>  						     iomap);
> +	struct address_space	*mapping = inode->i_mapping;
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
>  	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, count);
> +	xfs_fileoff_t		cow_fsb = NULLFILEOFF;
>  	struct xfs_bmbt_irec	imap, cmap;
>  	struct xfs_iext_cursor	icur, ccur;
>  	xfs_fsblock_t		prealloc_blocks = 0;
> @@ -1831,6 +1833,8 @@ xfs_buffered_write_iomap_begin(
>  		}
>  		cow_eof = !xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb,
>  				&ccur, &cmap);
> +		if (!cow_eof)
> +			cow_fsb = cmap.br_startoff;
>  	}
>  
>  	/* We never need to allocate blocks for unsharing a hole. */
> @@ -1845,17 +1849,37 @@ xfs_buffered_write_iomap_begin(
>  	 * writeback to remap pending blocks and restart the lookup.
>  	 */
>  	if ((flags & IOMAP_ZERO) && imap.br_startoff > offset_fsb) {
> -		if (filemap_range_needs_writeback(inode->i_mapping, offset,
> -						  offset + count - 1)) {
> +		loff_t start, end;

Nit: Tab between data type and identifier?

> +
> +		imap.br_blockcount = imap.br_startoff - offset_fsb;
> +		imap.br_startoff = offset_fsb;
> +		imap.br_startblock = HOLESTARTBLOCK;
> +		imap.br_state = XFS_EXT_NORM;
> +
> +		if (cow_fsb == NULLFILEOFF) {
> +			goto found_imap;
> +		} else if (cow_fsb > offset_fsb) {
> +			xfs_trim_extent(&imap, offset_fsb,
> +					cow_fsb - offset_fsb);
> +			goto found_imap;
> +		}
> +
> +		/* COW fork blocks overlap the hole */
> +		xfs_trim_extent(&imap, offset_fsb,
> +			    cmap.br_startoff + cmap.br_blockcount - offset_fsb);
> +		start = XFS_FSB_TO_B(mp, imap.br_startoff);
> +		end = XFS_FSB_TO_B(mp,
> +				   imap.br_startoff + imap.br_blockcount) - 1;

So, we are including the bytes in the block number (imap.br_startoff + imap.br_blockcount - 1)th,
right? That is why a -1 after XFS_FSB_TO_B()? 
--NR
> +		if (filemap_range_needs_writeback(mapping, start, end)) {
>  			xfs_iunlock(ip, lockmode);
> -			error = filemap_write_and_wait_range(inode->i_mapping,
> -						offset, offset + count - 1);
> +			error = filemap_write_and_wait_range(mapping, start,
> +							     end);
>  			if (error)
>  				return error;
>  			goto restart;
>  		}
> -		xfs_hole_to_iomap(ip, iomap, offset_fsb, imap.br_startoff);
> -		goto out_unlock;
> +
> +		goto found_imap;
>  	}
>  
>  	/*

