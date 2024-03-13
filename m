Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720A14CB35;
	Wed, 13 Mar 2024 20:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710360396; cv=none; b=Tyhu1K6WYcex/3YlvTXPC0i1y/SLIvj4AVDY4iKfHhlVMof0pkgJjkfJHTbcaWkvAgEGHGJ27tMPmv4dpN6vP7fhJRv0+b7K29tKT/2IwnMGCPwYL/+SUJ+W8mUIMxM0RnY0c7s/DJin9ZV8UbdCOYSZ1cf85tXRxj/AmydOk1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710360396; c=relaxed/simple;
	bh=ZkgjoMoc3S6LgQtCL2GT/1/gcjMlouhYoYOfBoCoGR0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b5Lqnrvd4gvQRsw6OfdqGsNYUXxQ0o2z2/gSqe5KTxi0yw85ntbe1oaRrDhPg07t8CamtdiSseb31R39pY2ZBG9VqFD2FclWo9dDRJci4ZqpJ0tOhANvz3+UTmMbMgwCkuvKYynHU1KBVRbsIQ+1CjFlQJIonz2cANa/mLqhlmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 69DE568C7B; Wed, 13 Mar 2024 21:06:22 +0100 (CET)
Date: Wed, 13 Mar 2024 21:06:21 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] block: move discard checks into the ioctl handler
Message-ID: <20240313200621.GA5756@lst.de>
References: <20240312144532.1044427-1-hch@lst.de> <20240312144532.1044427-2-hch@lst.de> <ZfHI5Vr7BOU6__rv@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfHI5Vr7BOU6__rv@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 13, 2024 at 09:40:21AM -0600, Keith Busch wrote:
> The incremental change I think you want atop this patch to keep the
> previous behavior:

Ah, yes, thanks.  Can you submit your reproducer to blktests or at
least throw a license on it that allows me to wire it up?

Also I'm going to wait for more comments on the approach in this
series before resending it, but we really should get a fix in in
the next days for this regression.

