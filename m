Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793204002;
	b=em6Hni9asYYWamgXMbthfA2Vv8DWW35uQ3eMNqD1XpHFALaNalHGrHhPtfOtfKDknvtc
	 kwW0Kk+qdSvQzVh09ugcEI4U9RySfaD+qZ3GO5AIWGRJFct/JjZr4SNiKcQU1C3kFO/qW
	 WdPHK5NcBIFoucBJKG3XZeOy24SLByCVSAVi8TOtIE1agCWpdYyL/1YegSLFf1VrsU2ls
	 QkcJT9uEFQCrygojYa/8uvjDK1IqagJailcdDG3WR5MTuaOa48D88HsRlc1D9E9T2pAeQ
	 LKGEhvpaoZo7O8iCiTpqbd5dEwOTFhdRwiregD0YZ2+G42A/9IiYZe+a4Pn7/7cppjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793204002;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=+U9vQAqOD+d9gs99Jw3uJHoXyUBM0l0cltyCq9fNPzg=;
	b=dPNNHL8iqTDgnAC4yUQLfyTsuHbxMO8H1PjkTGK09ADLrV0iIkFqMv97HqoKGIK8ex9o
	 eO7U1+Ioextyo+6kw8Wpc+cW7NwpZRgHKWLRFmROXaoar1OmGURzkiTQmwJpmXzhmRnn2
	 tzL5wOJnys7wUKxYx1cYsEQqcgQF/FGfJvPTGJ07HQbq4CDJjb+hRoOKbVQOrUWK6Mzxo
	 b+FbcR0tcORgVw0HL6eDunE6n6qvDaUMATikiUw9abGqzmuMuiTDyMHmigtBTfv85AwUa
	 ZOgimw+FrGWIibJgY3jOUNz/ABESBvZ5sdgE9qP1T34oGFc4NHdmFTBqr5gcCAOlxlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8F6606A31E;
	Wed, 28 Oct 2026 16:13:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB8F6606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0AD6C68AFE; Wed, 28 Oct 2026 17:13:18 +0100 (CET)
Date: Wed, 28 Oct 2026 17:13:17 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: Daejun Park <daejun7.park@samsung.com>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4 5/9] xfs: limit the count of a pNFS write allocation
 to one extent
Message-ID: <20261028161317.GC20998@lst.de>
References: <20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com> <20261020-xfs-pnfs-batch-v4-5-9230fa2ca4a4@samsung.com> <atoImJxtg70XcIjS@quentin>
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
In-Reply-To: <atoImJxtg70XcIjS@quentin>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 22, 2026 at 03:02:30PM +0200, Pankaj Raghav (Samsung) wrote:
> > +		/*
> > +		 * xfs_bmapi_write() maps at most XFS_MAX_BMBT_EXTLEN blocks
> > +		 * in one mapping, so don't reserve blocks for more. The
> > +		 * range comes from a client, and its block count may not
> > +		 * even fit the 32-bit reservation. The rest of the range
> > +		 * is mapped by a later call.
> > +		 */
> > +		end_fsb = min(end_fsb, offset_fsb + XFS_MAX_BMBT_EXTLEN);
> 
> Isn't it better we add this in xfs_direct_write_iomap_begin() instead of
> adding it in pnfs?

Yes, that's what I tried to suggest in the last round.
> 
