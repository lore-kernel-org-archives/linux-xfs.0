Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEDD31F9A3
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2026 05:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780378630; cv=none; b=YdinXjoKeoRz1btIYtUUprPv3PjEKhsw/Iof038F9qt6GZ7WbxhxRPTCye1MEUTXi1WlwszU2s84BwlcLZ/z+Yu6nGLtQuu9utIvymMauK+UFSn2aQ7OKdKQFmVfMDP0hz3dGYqwIp00qCGqIy+0KeE5krunIK/LfRUMAWnpkdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780378630; c=relaxed/simple;
	bh=U89hHSWsVTCU7rqSBKHc/xuBmbTNPg554n4qR8jFshM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RrS+lrxLGnyJUKf/lkLZ78D13ddplSNKNyL+pbVO1idmF+sPXozsv1KsgZDdExBGtmzROjdrrf+La237NovA3qPXxCnEku9SO7NdejE6XvDNX1BmBZ6vFF2k49HcSpBhhSk+LLNhUiJcusbV82GZJaXaMrS2yQoZphn99fn+Niw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 395AA68B05; Tue,  2 Jun 2026 07:37:05 +0200 (CEST)
Date: Tue, 2 Jun 2026 07:37:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Nirjhar Roy <nirjhar.roy.lists@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: cleanup xfs_growfs_compute_deltas
Message-ID: <20260602053704.GB32429@lst.de>
References: <20260601110824.3392683-1-hch@lst.de> <20260601110824.3392683-3-hch@lst.de> <20260602044203.GN6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602044203.GN6078@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 01, 2026 at 09:42:03PM -0700, Darrick J. Wong wrote:
> AFAICT the logic is the same before and after, so
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> Though I half wonder if that XFS_MAX_AGNUMBER+1 comparison is really
> correct.  MAX_AGNUMBER is defined to be ((xfs_agnumber_t)-2) so we're
> checking if an unsigned 32-bit number is greater than 0xFFFFFFFF?
> Which is also NULLAGNUMBER?

Not this this is the count and the number.  This also is the only
use of MAX_AGNUMBER in the kernel and xfsprogs has a copy of it
defined in XFS_MAX_AGNUMBER.  I'll see if there is a cleaner way
to express this, and the fact that agnumber is now a 32-bit value
might also mess things up a bit.

