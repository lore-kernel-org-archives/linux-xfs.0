Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB239846F
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 02:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724725009; cv=none; b=GDLu4e1i45jbhflj1Q9k7Ll0eZKwEn5lZaucelObj7/7UXU8qDEkHFwY2YX0tlQS1GlUzrbcaXEPEKG1HM1W3u3+yWFmjGZAayOhrKQK7RozOsRSqirUVPHrkIvEJj4IYigu86Vm+VaiMNGRkFbtAsfQGBWD8CV8VrTk/8+Re2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724725009; c=relaxed/simple;
	bh=jnXabzpJ8icZTyyksDRXlpSvnWGWLv+47X14oQ5+xB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m2hEvlVI8gsZgfHl0km8mRJCkVihXM55yI3K3CU2QUsK1kO1UZopJ0ZpexI48cBfXyF/GyYl59pO5yjYkTnyOScmr5LJedBmIpcA9iuKvhdSShMaFrUNLZSkHX+j7rZ+t325zw7On2Lezkj4cdtl9L1Qn2zrvraiXsj5WlWwvew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Ao/dFuDy; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Ao/dFuDy"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7141feed424so4131504b3a.2
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 19:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724725007; x=1725329807; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=paqSjJ5rv8tM5ZPDgOYRMBSAOMDiQ2WBa/oigIjBkUA=;
        b=Ao/dFuDysqSGVa4PnDDwQyvLiV8uUHx+jHLRp8KAtHRfQ2BCc3tEzVM80zE/hLGIe5
         VNdvQsLRn5/UT7aF3toIiHSv+DIl5iBUK379iDQugehSSXLGdBuPYYTgml11KvKw72AB
         gGkmeyHTpXpyQl6WLhw8rE7HETPVAkHX7iQmPuOK1G7pAxOXCAsGZVbo1sQSCku/Cpyj
         V56iroaIn6JxLkc00oCBfmInDV0hiqLwF00RMMbs7Xr+FAsSqHDi9KkpWtVA/4SESCbz
         hdYD95rlzVXdr18hyztH4Vggy9S4Xnd4J3EB8iS9iBDZWF3U+KO/0hOapxim5YPrxCUG
         oT4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724725007; x=1725329807;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=paqSjJ5rv8tM5ZPDgOYRMBSAOMDiQ2WBa/oigIjBkUA=;
        b=YbXaD0MPjGJBoqoTYsWQVaOHg8lcoQDgfSucHKpFxyxDyZ4Imbcwwww7losh1O9cwe
         gq2epy2UXPMppWH0idQMiDS3pzll1bgeNjv+LcOBLF1OhfRFRzcQtTKdLKObHBXaLI9d
         GKB7p6huRMgJOLOC00i/x/vL3EOIGJJEyW4zWzX5cgQDv5b936nDmhYbSWU87AgCuTkE
         hX59hUdSE73JHADlNCLs/TkSKYyQwSomsuUobT7QNE1UI0cHT34YnCncEKKXOjqFPaTN
         0v6Y54xAWjn4Bg/9yXV6yNUHVzjMnE8l4rCKH3Tixw+6i2KhEkNx1x9VCRKZuzMayKJx
         +Qlg==
X-Forwarded-Encrypted: i=1; AJvYcCW/68ZqricAQAQT2gzY9w5D+C/+3REm9jHrLhcpBU3pa5+RX41ftctH2q5kj92Tvvl4ojwve0ejjz0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGsyCKhFJVrzH0R4Y/KUhF1+p6uiZpVR3PdkRxTwWbZqQsZHE7
	EORNX1BdN0RXSAfxS2NaqX2I6PuDIXOGRL1gykaGSGZzWlEF9I90C5xrf5f1lI4=
X-Google-Smtp-Source: AGHT+IHuuo+7JRIYAAlfqBQgVs9+kt0cvK912zhUKuBx9aJHLm6EmnBfKVLamltNlIYaZgOPjgU7Cw==
X-Received: by 2002:a05:6a00:9144:b0:714:28c7:245f with SMTP id d2e1a72fcca58-71445e77f56mr11858330b3a.20.1724725006959;
        Mon, 26 Aug 2024 19:16:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71434255635sm7633473b3a.72.2024.08.26.19.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 19:16:46 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sillD-00E2SW-2D;
	Tue, 27 Aug 2024 12:16:43 +1000
Date: Tue, 27 Aug 2024 12:16:43 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: update sb field checks when metadir is turned on
Message-ID: <Zs03C0CurF8bmDZr@dread.disaster.area>
References: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
 <172437089450.61495.17228908896759675474.stgit@frogsfrogsfrogs>
 <ZsxQa3xvdkrwvN48@dread.disaster.area>
 <20240826180747.GY865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826180747.GY865349@frogsfrogsfrogs>

On Mon, Aug 26, 2024 at 11:07:47AM -0700, Darrick J. Wong wrote:
> On Mon, Aug 26, 2024 at 07:52:43PM +1000, Dave Chinner wrote:
> > On Thu, Aug 22, 2024 at 05:29:15PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > When metadir is enabled, we want to check the two new rtgroups fields,
> > > and we don't want to check the old inumbers that are now in the metadir.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/scrub/agheader.c |   36 ++++++++++++++++++++++++------------
> > >  1 file changed, 24 insertions(+), 12 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> > > index cad997f38a424..0d22d70950a5c 100644
> > > --- a/fs/xfs/scrub/agheader.c
> > > +++ b/fs/xfs/scrub/agheader.c
> > > @@ -147,14 +147,14 @@ xchk_superblock(
> > >  	if (xfs_has_metadir(sc->mp)) {
> > >  		if (sb->sb_metadirino != cpu_to_be64(mp->m_sb.sb_metadirino))
> > >  			xchk_block_set_preen(sc, bp);
> > > +	} else {
> > > +		if (sb->sb_rbmino != cpu_to_be64(mp->m_sb.sb_rbmino))
> > > +			xchk_block_set_preen(sc, bp);
> > > +
> > > +		if (sb->sb_rsumino != cpu_to_be64(mp->m_sb.sb_rsumino))
> > > +			xchk_block_set_preen(sc, bp);
> > >  	}
> > >  
> > > -	if (sb->sb_rbmino != cpu_to_be64(mp->m_sb.sb_rbmino))
> > > -		xchk_block_set_preen(sc, bp);
> > > -
> > > -	if (sb->sb_rsumino != cpu_to_be64(mp->m_sb.sb_rsumino))
> > > -		xchk_block_set_preen(sc, bp);
> > > -
> > 
> > If metadir is enabled, then shouldn't sb->sb_rbmino/sb_rsumino both
> > be NULLFSINO to indicate they aren't valid?
> 
> The ondisk sb values aren't defined anymore and we set the incore values
> to NULLFSINO (and never write that back out) so there's not much to
> check anymore.  I guess we could check that they're all zero or
> something, which is what mkfs writes out, though my intent here was to
> leave them as undefined bits, figuring that if we ever want to reuse
> those fields we're going to define a new incompat bit anyway.
> 
> OTOH now would be the time to define what the field contents are
> supposed to be -- zero or NULLFSINO?

Yeah, I think it's best to give them a solid definition, that way we
don't bump up against "we can't tell if it has never been used
before" problems.

> 
> > Given the rt inodes should have a well defined value even when
> > metadir is enabled, I would say the current code that is validating
> > the values are consistent with the primary across all secondary
> > superblocks is correct and this change is unnecessary....
> > 
> > 
> > > @@ -229,11 +229,13 @@ xchk_superblock(
> > >  	 * sb_icount, sb_ifree, sb_fdblocks, sb_frexents
> > >  	 */
> > >  
> > > -	if (sb->sb_uquotino != cpu_to_be64(mp->m_sb.sb_uquotino))
> > > -		xchk_block_set_preen(sc, bp);
> > > +	if (!xfs_has_metadir(mp)) {
> > > +		if (sb->sb_uquotino != cpu_to_be64(mp->m_sb.sb_uquotino))
> > > +			xchk_block_set_preen(sc, bp);
> > >  
> > > -	if (sb->sb_gquotino != cpu_to_be64(mp->m_sb.sb_gquotino))
> > > -		xchk_block_set_preen(sc, bp);
> > > +		if (sb->sb_gquotino != cpu_to_be64(mp->m_sb.sb_gquotino))
> > > +			xchk_block_set_preen(sc, bp);
> > > +	}
> > 
> > Same - if metadir is in use and quota inodes are in the metadir,
> > then the superblock quota inodes should be NULLFSINO....
> 
> Ok, I'll go with NULLFSINO ondisk and in memory.

OK.

Just to add to that (because I looked), mkfs.xfs does this to
initialise rtino numbers before they are allocated:

$ git grep NULLFSINO mkfs
mkfs/xfs_mkfs.c:        sbp->sb_rootino = sbp->sb_rbmino = sbp->sb_rsumino = NULLFSINO;
$

and repair does this for quota inodes when clearing the superblock
inode fields:

$ git grep NULLFSINO repair/dinode.c
repair/dinode.c:                        mp->m_sb.sb_uquotino = NULLFSINO;
repair/dinode.c:                        mp->m_sb.sb_gquotino = NULLFSINO;
repair/dinode.c:                        mp->m_sb.sb_pquotino = NULLFSINO;
$

So the current code is typically using NULLFSINO instead of zero on
disk for "inode does not exist".

-Dave.
-- 
Dave Chinner
david@fromorbit.com
