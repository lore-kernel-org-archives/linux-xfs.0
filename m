Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F020B334C0B
	for <linux-xfs@vger.kernel.org>; Thu,  4 Dec 2025 09:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764840826; cv=none; b=lZ8h5rj9OrNu0skxfAw3uO3nhJrnLYLx2ZYQe/ZWtAgkIoE1F07tEc1LFH/ZIkeM482uxfkaYgNATbnB8Cq7+GyYeoMPxKwJtsTIAWhZq7DibTxeygH4HLjIBKxr3LQ/7sA15IKT/H5hGk0IeLCeO5rwhn/dhLt/mkk9CGwduLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764840826; c=relaxed/simple;
	bh=Ht/vlwV/Ey+a/L7idRGuYaUDPNdtdqrCNS2UcPT0TpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ovJtnXUo6Rja3DOWdnFVxaqXFq34s28N+FZOk1zwCaVVCNXDWG6UcDFtm3Wm2mEDtqTyegBgzPXarGpRVw34WavBJr+cz8P/AmelRsDa8WSlE98M8HhkmrojlVmSrr/MfLFPIXm//F7oShYmaB/MWsC2TTaTuG0/MM9pQg1SP6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3C93E227AAC; Thu,  4 Dec 2025 10:23:41 +0100 (CET)
Date: Thu, 4 Dec 2025 10:23:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH, RFC] rename xfs.h
Message-ID: <20251204092340.GA19866@lst.de>
References: <20251202133723.1928059-1-hch@lst.de> <aTFOsmgaPOhtaDeL@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTFOsmgaPOhtaDeL@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 04, 2025 at 08:04:50PM +1100, Dave Chinner wrote:
> fs/xfs/xfs.h is just a thin shim around fs/xfs/xfs_linux.h. Rather
> than rename it, why not get rid of it and include xfs_linux.h
> directly instead?  I don't think userspace has a xfs_linux.h header
> file anywhere...

Fine with me if that name is ok for shared code.

