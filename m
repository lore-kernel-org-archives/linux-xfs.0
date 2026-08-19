Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1303D5643;
	Wed, 19 Aug 2026 07:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787124548; cv=none; b=uhoNjmTH5fFRVv1GPgI00j5m7f5Crn87Vy6I7L9XE9eAABhzbWeIatFIEaSeIje526MnKLFgDjlpTfSLhMMW5lLrHszjb1k32/HEc5aKdt4Ckdu4gZW19TaZJRPPoz3BkOKJ6kh9oXOmyBMmajKK1kP2cu3CY3QveaTTf/gdQco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787124548; c=relaxed/simple;
	bh=J8ul3JEIKz3SR+YwPYMEpQrkUPJ/5KSHPaKJGeaTgfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lXsqQmBF3r47A+x3vNZQStLGoi7dzhilAgIyiiprIHyd25Gj9ly32HLHtHV2i6otBHJp2pv4380qrpVUBZs3rkHaTJPD77VxWGCUmZc41QmL4HGInpPAWvx26soO5GAGWx9CObIfoMFyYL9Shtqrw/kLmDv5FaLdT6mfOEWyWR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7610D68C7B; Wed, 19 Aug 2026 09:29:02 +0200 (CEST)
Date: Wed, 19 Aug 2026 09:29:02 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	jack@suse.cz, cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com
Subject: Re: [PATCH v4 5/6] xfs: write stream based AG placement
Message-ID: <20260819072902.GA2332@lst.de>
References: <20260717125538.508925-1-joshi.k@samsung.com> <CGME20260717125638epcas5p2fb7128170d2443be3cfe1a7687d0c5fd@epcas5p2.samsung.com> <20260717125538.508925-6-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717125538.508925-6-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 17, 2026 at 06:25:37PM +0530, Kanchan Joshi wrote:
> If AGs are fewer than write streams, write streams are distributed into
> available AGs in round robin fashion.

I think we should just limit the number of available write streams
to the number of AG, as otherwise we'll get into a bit of a mess.

And for the case of the hardware write streams query them in mkfs
to align the AG geometry to that.

> +	uint32_t		nr_streams = xfs_inode_max_write_streams(ip);
> +	uint32_t		stream_id = ip->i_write_stream;
> +	uint32_t		nr_ags = mp->m_sb.sb_agcount;
> +	xfs_agnumber_t		set_size;
> +
> +
> +	if (!nr_streams)

Double empty line.

