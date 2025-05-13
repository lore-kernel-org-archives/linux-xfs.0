Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2DB22EE5
	for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 05:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747113649; cv=none; b=swALJTYWsDOQPS5XbdYul2rxZ051AV41VdnTV3OvWfRXUoBTjbaIUGhqE3fNmGRk5bzf6t+embNOPVmzg3PmF/cqhMCvLaI3jz0XlPdEjNJNrppHq8QeRKKnjl70ysRrLJsSEQY5cU9duGdzqIBdsIdBFE8YRk6c4pYJhSQVCcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747113649; c=relaxed/simple;
	bh=K09eAFIGsJKuWQhDi822SBH11QOukaa2cxlEGZW2n9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zm8j62qFfSdpGeIyUMDIcDVn16cH3I+AMWn9fDZJxEw1xahn9Eftft6lLQwbRJcl4JQqYar4r4OtpFGiVqTi3qDJ3l9Kh5ODDU0DhAY+qYlDH4vrdVXu+TcPzDzx57Q40CTsb/Je2Xm0kxiOxAeXbCHQCDdyvqcQ0rDt2TLconA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 44BA568BEB; Tue, 13 May 2025 07:20:37 +0200 (CEST)
Date: Tue, 13 May 2025 07:20:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org, hans.holmberg@wdc.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix zoned GC data corruption due to wrong
 bv_offset
Message-ID: <20250513052036.GA32022@lst.de>
References: <20250512144306.647922-1-hch@lst.de> <20250512170400.GH2701446@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512170400.GH2701446@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 12, 2025 at 10:04:00AM -0700, Darrick J. Wong wrote:
> Hmm.  I started wondering why you can't reuse chunk->scratch->offset in
> the bio_add_folio_nofail call below.  I /think/ that's because
> xfs_zone_gc_start_chunk increments chunk->scratch->offset after adding
> the folio to the bio?

Exactly, it's a basically a circular buffer.

> And then we can attach the same scratch->folio to different read bios.
> Each bio gets a different offset within the folio, right?

Yes.

> So
> xfs_zone_gc_write_chunk really does need to find the offset_in_folio
> from the read bio.  And I guess that's why you use bvec_phys to figure
> that out (instead of, say, wasting space recording it again in the
> xfs_gc_bio), correct?

Yes.

