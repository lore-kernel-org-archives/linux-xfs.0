Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794418763;
	b=nfFwHr+62abhTWYT25pmFbDGNSuTXOiPqscYrsElSGGofKpz/V9YpcjaiumzemWQeorR
	 sfxvSxhNkRrbvOMXSevLgpVLHH2T0/Bax3Jqjf/S8mNU7WKfoXtSwHuSx0+GujvXnHaet
	 dGVUbEMSrbwokgvMfSaRPOHXTVhJDkhCX966OvjmLqNiBVebhP3tpbTk8u1NidgjZVYMO
	 1D+s46mj9FP9P5y7DQ6EptWHIL+edJ3HcZ/HGwouEyP2L38gCghWH7Lgx07xJ/wRjN5KM
	 +aAHg25nJDxnuApPGl6cKVVN0iWeRmEnfUS4kxayc6KtnhRB+Ifxby0i4rQR4YPRVlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794418763;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=vNOReXNlhc8SfNhdgY060OXI6+WQlGPtujEcbSsN0UY=;
	b=huNr0djQYdhQ7iZ1yzf2y+nfHbLDmBxmGqbLRg3OQ7UguzTB/9wHoM+d4l4gegAC38/6
	 x8vYZCs37d/R7kBnfWLQHnPDtaq0t3h/WXZVpQFIrWo61+q5LnIB0aBwyLGYUHagGNE+M
	 RFaAbblJoIDPw4ex+6ixppPmaRhurIltpwE6bHHDGmDRMViUWSE4kUE8zlqL09L0ERChH
	 1PdpCToAnoMzjp7WCaXoG7pldvf5S6S9aMXH++5EKsFQBv7vgBez35YENEbZNYJ6B23YU
	 ScvWHB9MoQNbcV5lgZ7CrLk5hcDdFX5X+fhNcYBxtB9GkoxnBkBf1HQvOqxhQiED7Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74087606A333;
	Wed, 11 Nov 2026 17:39:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74087606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 535DE68D17; Wed, 11 Nov 2026 18:39:20 +0100 (CET)
Date: Wed, 11 Nov 2026 18:39:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 20/25] xfs: verify data checksums during media
 verification
Message-ID: <20261111173919.GD20167@lst.de>
References: <20261104085929.317544-1-hch@lst.de> <20261104085929.317544-21-hch@lst.de> <avRUQnZqmuiQVC1h@quentin>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avRUQnZqmuiQVC1h@quentin>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 11, 2026 at 12:57:39PM +0100, Pankaj Raghav (Samsung) wrote:
> > +/*
> > + * Data checksums are per-FSB, so we can only validate FSB-aligned regions.
> > + *
> > + * When the alignment leads to an empty range, give up.
> > + */
> 
> A comment here would be helpful about the return values.
> 0 for success,
> 1 for media errors
> errno for other errors.

Ok, I'll add it.

> > +	unsigned int		bbcount;
> > +	xfs_filblks_t		len;
> > +	struct bio		bio;
> > +	struct bio_vec		bv;
> > +	int			error;
> > +
> > +	len = min3(end - bno, xfs_rtcsum_max_len(mp, bno),
> > +			XFS_B_TO_FSBT(mp, folio_size(folio)));
> 
> For large block size systems, if we allocate a single page in the folio
> due to fragmentation, len will always be zero (4096 >> (blocklog > 12)).
> 
> > +	if (!len) {
> > +		*daddr = me->me_end_daddr;
> > +		return 0;
> > +	}
> 
> And we skip those ranges without verifying anything with a success.
> 
> I think we should raise the iosize to a single FSB in
> xfs_verify_alloc_folio and should return ENOMEM if we cannot allocate
> one?

Yes, I'll do that.

