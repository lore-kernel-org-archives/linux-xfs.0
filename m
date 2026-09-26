Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DD535F5ED
	for <linux-xfs@vger.kernel.org>; Sat, 26 Sep 2026 18:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790446811; cv=none; b=YcHd+QuUWEO8HqLC8mTc40/Y3hlCvkfnvZWGRLsd7mxNM4uDDrPe7dBmLcBYpqE2fSQMWZUy0Oy2klsFVlC3Y4GF7pau7zeWgjWPnqFgoBD8EgpBjnFP4076PBjwK/1A+XpRxhFhNcygyaq2zaiiTlFKFDTc+mGQQjofYzkHgtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790446811; c=relaxed/simple;
	bh=QFDpj8V9u8qPHhE2OOCjRdy/Gppm7xRyy4WXAzam+K0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l/ofMkljaauSkuS0ZBjAgxYLBowE90y2DG2b0Qb6OX9HCm3OcCIpSa9ODxrBFktqGCBcnDa4mCv9YPARx9DTc6+ZWUuXJxwzQVhIVWyVfoqhM3IJwGBdpAYuBwBfYtCPxrYWbuPY88ojea2s/fh6k1Wrz2lGy+YYjibOxzBepA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S1sWtbTn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S1sWtbTn"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5356F1F000FF;
	Sat, 26 Sep 2026 18:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790446809;
	bh=OwJ9AQn64nMpFG2mh/QRsVBYcKGq57BPKQHok1DGdDk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S1sWtbTngpIlReNziatG+gr6C3/ie1pvQi8PkpsP9spBOBXhITG26z/QMb17bSFJK
	 krvnQZPC/2FaAlYr7LAMQ+bnN+hvE8q+1J3txQjdXWuNjWgNytPgAxjSpIljvAnrfS
	 2NYOndJOyDueG3/qyq4Oa18TTHK4YoFNImgLB1Vo7BK5QluuW8/mbu8pnVMCvkSnbz
	 ZQHLIXvYr8oe47HfPqAqgL/jyXQVCFDXeLBmEVfXdrLxZQ9QbkCuc3p5ZsUi40rQRg
	 xavISn7LEmwrKU2K++Hct2owjHa4DywpwHqQsWWF/iEu+7QPdrk0b4iZhpbu9QsrE+
	 +yts3E2fUFt2w==
Date: Sat, 26 Sep 2026 11:20:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/32] xfs_db: support RT data checksum
Message-ID: <20260926182008.GK6283@frogsfrogsfrogs>
References: <20260924100512.2733748-1-hch@lst.de>
 <20260924100512.2733748-31-hch@lst.de>
 <20260925234358.GP2705364@frogsfrogsfrogs>
 <20260926062115.GL20636@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926062115.GL20636@lst.de>

On Sat, Sep 26, 2026 at 08:21:15AM +0200, Christoph Hellwig wrote:
> On Fri, Sep 25, 2026 at 04:43:58PM -0700, Darrick J. Wong wrote:
> > > +	{ "csums", FLDT_SUMINFO, OI(bitize(sizeof(struct xfs_rtbuf_blkinfo))),
> > 
> > FLDT_SUMINFO is 4 bytes, this won't work for crc64.
> 
> Ouch, yes.
> 
> > You might want to add a FLDT_CRC32C and FLDT_CRC64 so that the sizes can
> > be correct, db can convert them from big-endian to host for display, and
> > the display can be '0x%x' instead of decimal.
> 
> The values are little endian, just like the xfs metadata csum.

Oh, right, I forgot that :)

> Do you remember how to dynamically switch between different
> interpretations of a field in xfs_db code?

The stupid way is to declare both FLDT types and counting functions
that return nonzero if that checksum type is enabled, and 0 otherwise:

static int
rtcrc32c_count(
       void                    *obj,
       int                     startoff)
{
	if (mp->m_sb.sb_rtcsum_type != XFS_CSUM_TYPE_CRC32C)
		return 0;
	return xfs_rtcsum_payload_size(mp) >> mp->m_rtcsum_shift;
}

static int
rtcrc64_count(
       void                    *obj,
       int                     startoff)
{
	if (mp->m_sb.sb_rtcsum_type != XFS_CSUM_TYPE_CRC64)
		return 0;
	return xfs_rtcsum_payload_size(mp) >> mp->m_rtcsum_shift;
}


       { "crc", FLDT_CRC, OI(bitize(sizeof(struct xfs_rtbuf_blkinfo))),
	rtcrc32c_count, FLD_ARRAY | FLD_COUNT, TYP_DATA },
       { "crc64", FLDT_CRC64, OI(bitize(sizeof(struct xfs_rtbuf_blkinfo))),
	rtcrc64_count, FLD_ARRAY | FLD_COUNT, TYP_DATA },

FLDT_CRC already exists, so I guess you just have to copy-pasta
FLDT_CRC64 into field.c:

	{ FLDT_CRC64, "crc64", fp_crc, "%#x (%s)", SI(bitsz(uint64_t)),
	  0, NULL, NULL },

Though the iocur_crc_valid() call in fp_crc might cause problems here.

--D
