Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDC145BE3
	for <linux-xfs@vger.kernel.org>; Wed, 18 Jun 2025 05:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750223715; cv=none; b=aWP1e/2pDtxM6cF0IVzAhSMYhn/Yfw13FPc56s/c+1Tr3a/OELkvvLdj7siEpJozIGplt6STnZh3uOI9vo2eFhLEH86bKy99R4P3fmbJoifhJPlZlyawIi/Txx1pkOHL/qoXwBElEceEhVlyytpjd7KM8SjdFouDGQ1m4Batkjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750223715; c=relaxed/simple;
	bh=j7mZbLwDV7FOp8gvn9r+2F64fJfBIvuV+kvfFAT4Q9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gd/BfOvZ3W0KpLnQfhR13ScYSPdebz7hZl+hMjSFqc65GeMlaRBjLRBHGeDqNIThUcN1AqL04C5mpXmrD0AU/W7Vf4dD/AvcY42Rekplmx3zsUkLzvt/9h21L88ssA75H1kGstxMYXAPReeXVizGSGJD2sbYyddFdr1kt7I3Jj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 75C7068D0E; Wed, 18 Jun 2025 07:15:09 +0200 (CEST)
Date: Wed, 18 Jun 2025 07:15:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: remove the bt_meta_sectorsize field in struct
 buftarg
Message-ID: <20250618051509.GF28260@lst.de>
References: <20250617105238.3393499-1-hch@lst.de> <20250617105238.3393499-8-hch@lst.de> <aFH_bpJrowjwTeV_@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFH_bpJrowjwTeV_@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 18, 2025 at 09:51:10AM +1000, Dave Chinner wrote:
> On Tue, Jun 17, 2025 at 12:52:05PM +0200, Christoph Hellwig wrote:
> > The file system only has a single file system sector size.
> 
> The external log device can have a different sector size to
> the rest of the filesystem. This series looks like it removes the
> ability to validate that the log device sector size in teh
> superblock is valid for the backing device....

I don't follow.  Do you mean it remove the future possibility to do this?
Even then it would be better to do this directly based off the superblock
and not use a field in the buftarg currently only used for cached buffers
(which aren't used on anything but the main device).
