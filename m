Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793684966;
	b=4pVYQt1iGZFlHPNDUa7JUmfXT7DEdaWAtoa/joYpL1XYIFIpDVHhoQHaUydock34BlWO
	 9Zkpwb1l2E1ngRxbI+179khdzxDhjM2sqz45AiAOMA1/KUahHy0G2jJkQ4SVKVEYMVXq6
	 /T2wOr/Lu8Yn6TdFqHKPy0mwj6qfsnKu8dCcyV75xE7hSiz+d0SE0ToC3KxFtcoFe7wNY
	 y99hiMJtRTUN4AeXaVqtmY+/7xZaXpSrjvArwo3bZAty/uhf+AgfvN9EjpeRFDuBtcKl0
	 /Sp2NjMZFJ/yd5VWGTXMiXpEcj/FgIncbpibn9u3CPrz3hQWUquHSRfsH+wwKQ7BaSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793684966;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=bd6fkGaRBJH7OZId4JGBgWiNTZUGs+o/K6nHFnVDFa8=;
	b=xVMXpuBc0PlzsymGh1caJHs2VGFFC3q0XkqWUqhW2LWm3pA9orR92s2jalQNMdoyxu23
	 dmDf13u5aVM5Zjc9t0rvGvTJSIVPbjSAHWVGCZUN+UP0kvg+ctfa0sGdBBDt6c676aDZD
	 neofIBSdtzpfA2ZbPt6zfSq3W1ijhVcBxDKfWomZJJ1rUapaxupNEBFIF9aePpSfuq7Ql
	 7QCgyvDdJ4UPTZJ13N6IkOC+9zkyb7y50AZafQk6PIN3BdAkQDnt9jEHaaWcOsGgSFr9h
	 2geVdGAGXjpXWG2enxOoXLNX1K3GxvsMyhy5u+VLPjQyhNKEJyY6CpJdyIV9DGANSIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E855606A32C;
	Tue,  3 Nov 2026 05:49:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E855606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4E1CA68AFE; Tue,  3 Nov 2026 06:49:22 +0100 (CET)
Date: Tue, 3 Nov 2026 06:49:22 +0100
From: Christoph Hellwig <hch@lst.de>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dgc@kernel.org>, Pankaj Raghav <p.raghav@samsung.com>,
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v5 5/9] xfs: cap the block count of
 xfs_iomap_write_direct() at one extent
Message-ID: <20261103054922.GA1721@lst.de>
References: <20261029-xfs-pnfs-batch-v5-0-ef8d2eafb7fa@samsung.com> <20261029-xfs-pnfs-batch-v5-5-ef8d2eafb7fa@samsung.com>
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
In-Reply-To: <20261029-xfs-pnfs-batch-v5-5-ef8d2eafb7fa@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 29, 2026 at 11:23:02AM +0900, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> xfs_iomap_write_direct() reserves blocks for the whole count in an
> unsigned int. For a pNFS layout the client chooses that count, and an
> RW LAYOUTGET for 16 TiB wraps the reservation and shuts XFS down.
> 
> xfs_bmapi_write() maps at most XFS_MAX_BMBT_EXTLEN blocks here, so cap
> the count at that. nfsd asks again for the rest. The other callers get
> the same mapping as before.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Link: https://lore.kernel.org/r/20261008154017.GO2705364@frogsfrogsfrogs
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Link: https://lore.kernel.org/r/20261015060932.GD14035@lst.de
> Suggested-by: Pankaj Raghav <p.raghav@samsung.com>
> Link: https://lore.kernel.org/r/atoImJxtg70XcIjS@quentin

I think this is overdoing it a bit with the Link tags.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

