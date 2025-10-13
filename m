Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A322DEA78
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 06:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760336997; cv=none; b=SfBSVj8aTmFmOBTywQXi48z6MqeXb7WWQaj5kqAL7eJuY/9Ril9iatR3Mzv841yqKQ4MnryN92QPNIw0VJpBWXPBMWJkcluYRtUA5qs70GDoFp7VHkcj2kU6VYSwsBXWgN6kYCOYEkGAY8QFiFWBc5C8UID9Pn+HVTK0/cFV3fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760336997; c=relaxed/simple;
	bh=SxFrgOWyyDfZU2+vGPsWsf/M0Gr4RPfwTTol8p/ikJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E81tD1pLcYYj7qKOnqggC9YWUVzxLPDmjhH45ol/Z9Mlrm4Hm9lhZ4gae1mYoxnAaXNcE2U46MT8g6o6Nll9x2aa0iFQ/wqzOjAkeJxTxMwPwLm9a8/Gn1VwecBGc9tGXYJZUnrDyin8xXyLO5AjSpfQ3mO7TbBqIAdNg0U6emo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E29E3227A87; Mon, 13 Oct 2025 08:29:42 +0200 (CEST)
Date: Mon, 13 Oct 2025 08:29:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: track the number of blocks in each buftarg
Message-ID: <20251013062942.GA1886@lst.de>
References: <20250919131222.802840-1-hch@lst.de> <20250919131222.802840-2-hch@lst.de> <20250919175246.GQ8096@frogsfrogsfrogs> <20251013054647.GI6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013054647.GI6188@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Oct 12, 2025 at 10:46:47PM -0700, Darrick J. Wong wrote:
> I just pulled 6.18-rc1 and noticed that the rmapbt repair now dumps a
> bunch of warnings about daddr 0 being "beyond" EOFS in the xfbtree that
> holds the in-memory rmap data.
> 
> I think the reason for this is that xfs_daddr_t is actually a s64 value,
> so the comparison in xfs_buf_map_verify
> 
> 	if (map->bm_bn < 0 || map->bm_bn >= btp->bt_nr_sectors) {
> 
> is actually comparing 0 against -1, so the second part of the if test is
> actually true.  I'm not sure what a good fix here would be?  Maybe
> 
> #define XFS_DADDR_MAX	((xfs_daddr_t)S64_MAX)
> 
> and then
> 
> 	/* The maximum size of the buftarg is only known once the sb is read. */
> 	btp->bt_nr_sectors = XFS_DADDR_MAX;
> 
> Hm?

Oh, right the switch to use a xfs_daddr_t means the value is signed
now, and the -1 cast won't get the max value.  Your idea sounds good
to me, do you want to send a patch or should I?

