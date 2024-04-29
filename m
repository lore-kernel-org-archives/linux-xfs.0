Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200381805E;
	Mon, 29 Apr 2024 09:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714384411; cv=none; b=BU68LcgKUgde1tYe5q1gODmM7OBcsG8sITNqvHA7Q/LZbz6BIx9Slsq7uO8JrDVlFqw4jsWc3iPTBN1mBkX4e2Y609GQFExfEpNGN3FcveAwFBjf+WLErXSI1Z120P5puxLSkB9OFqoUPA4NupFP04c3qiMuEFZ9BWc0kYvClXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714384411; c=relaxed/simple;
	bh=Zx5MPIWUCGYSdAfTxC/qgCU/bCkw04IOLsZih1ovLck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N4xlTA4H0ZIAJgzcIC0ztKnwwuosatyZyLAHzDfo/uw0KoDsazdUnNuFhFFBeOkA+XjK1BMgzD16a8isGdzb2II6Hyz6ovrxQL2D5YaRizeRPpufDckGtZTzv9LYInDx1CGx/GZsTqVtvTTzoa7Hv5dwQBCzHr7yuOKmdyf3UbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 164F9227A87; Mon, 29 Apr 2024 11:53:25 +0200 (CEST)
Date: Mon, 29 Apr 2024 11:53:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: remove support for tools and kernels with v5
 support
Message-ID: <20240429095324.GA15697@lst.de>
References: <20240408133243.694134-1-hch@lst.de> <20240408133243.694134-2-hch@lst.de> <871q6oqzik.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871q6oqzik.fsf@debian-BULLSEYE-live-builder-AMD64>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 29, 2024 at 03:04:51PM +0530, Chandan Babu R wrote:
> On Mon, Apr 08, 2024 at 03:32:38 PM +0200, Christoph Hellwig wrote:
> > v5 file systems have been the default for more than 10 years.  Drop
> > support for non-v5 enabled kernels and xfsprogs.
> >
> 
> Hi,
> 
> This patch is causing xfs/077 to fail as shown below,

That's not a failure, but it isn't run.  AFAICS it is because
_require_meta_uuid expects to work on a scratch fs, but none is
generated beforehand as the _require_xfs_mkfs_crc that did that under
the hood now went away.

The fix is to probably just nuke _require_meta_uuid and explicitly
create a CRC-enabled fs.  I'll look into that.

