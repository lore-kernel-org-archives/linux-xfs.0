Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2FD3914FA
	for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2026 08:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772613105; cv=none; b=JuTsvHbmNGHlY7N/hViDIib0gPFFyj3c/M4f0JXpBgJXY277KcMIoP2cF1MebdnAWjbHQIn597fdbzE++o9PvP+N6l7PQfKyEOxuLMFtPle+kt9cEsD49dAY6fjHONzEFZe3MYnv5hjPpTIFwQQ8Eam3/eWzsIogr+tIuhK6u3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772613105; c=relaxed/simple;
	bh=tDucPjzG26Jiv3A/F1YxGR6ffcSMEmL7EiobttBWiMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VRicQZ8U1aPjtomZnT68cvP29gyMe/YxbdX4tMPbyEJ03B+SRo3Q3ta8cKJ3V/DS12XOK/tSzTwyL4lnIHGVPSSPX0Bv2txQp/4gZQlUkXsk2iNq1214/V+WwYngrxfbVVLVb0avSHDr2hz4WxSrYIksSE1srAYApU0tqv8NIiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AeNbNMjr; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AeNbNMjr"
Date: Wed, 4 Mar 2026 08:31:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772613100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tTq6GP58rC9SYmehCxV4HTxIVTO6b0BiRhGZ0fztv1I=;
	b=AeNbNMjri03KK38jUMq4XnDu3ToZ6ReWgfSMGdTum4+nJyDXpOcSAEeDR3TaB87aleasug
	vFDKayHcQGrHQkaYVPShkfDO98GBJEGJJBo8JoyzmnMFIK8zy10oqPWMosWirlKeVfX168
	b7sDhYoOZj/BJMl/zjwIAfdLTHq18Og=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Christoph Hellwig <hch@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>, linux-xfs@vger.kernel.org, 
	bfoster@redhat.com, dchinner@redhat.com, "Darrick J . Wong" <djwong@kernel.org>, 
	gost.dev@samsung.com, andres@anarazel.de, cem@kernel.org, lukas@herbolt.com
Subject: Re: [RFC 1/2] xfs: add flags field to xfs_alloc_file_space
Message-ID: <rtkkjncmfpe6gugnrfrxiqvhe5r4b5nuxil7h3mhnd234yqzbw@pbskbrircw6y>
References: <20260227140842.1437710-1-p.raghav@samsung.com>
 <20260227140842.1437710-2-p.raghav@samsung.com>
 <aab9Lgt-HUaNq-FL@infradead.org>
 <cz7xkvha3ka6cqilkeolypgbr7rttlxk24uiliqvaou527kjkr@6cx6q3kprtjt>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cz7xkvha3ka6cqilkeolypgbr7rttlxk24uiliqvaou527kjkr@6cx6q3kprtjt>
X-Migadu-Flow: FLOW_OUT

> > >  	struct xfs_inode	*ip,
> > >  	xfs_off_t		offset,
> > > -	xfs_off_t		len)
> > > +	xfs_off_t		len,
> > > +	uint32_t flags)
> > 
> > Messed up indentation.
> > 
> Oops.
> 
> > Given that we've been through this for a lot of iterations, what
> > about you just take Lukas' existing patch and help improving it?
> 
> I did review his patch[1]. The patches were broken when I tested it but I
> did not get a reply from him after I reported them. That is why I decided
> to send a new version.
> 
> [1] https://lore.kernel.org/linux-xfs/wmxdwtvahubdga73cgzprqtj7fxyjgx5kxvr4cobtl6ski2i6y@ic2g3bfymkwi/
> 

@Lukas, how do you want to move forward? Can I merge the changes I did
here into your patch?

--
Pankaj
