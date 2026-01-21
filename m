Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC39635E53A;
	Wed, 21 Jan 2026 07:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768979067; cv=none; b=hUoX62dMV1AJr8ByJrYmga1HrugIhOHvZWFaiVRwX9mPDixHH27u5LPdMWZEjh8G9t1NRf0IKLFcNeYA7Es3hYcBCDg7Guwn307pULt9psCR/rqqaujVFzD179pPEwiRcjwKNfBuYf302FHwDZAm2e0Zj/JmNP2QrLjYSed1O04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768979067; c=relaxed/simple;
	bh=172qC2M2WdtS/QOMqodnJea9J2jwpKMDdyVFuBgURa8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XRsDWP+DbEUmRXePYWz8gqLra8ecU7bDQfsGKCtR9sOzfZMizHW/ZskTUCK+jp0PSBchKl9dxOD4/xHuwQeAkYDtdChyyXEbvGmXdRKhAEuWdShuL1vuDeO43EKNlBzmd99x7rO1IGnJYdgzKL8sauRepVNv1ac0T2LTIJqH4Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B2CB0227AAC; Wed, 21 Jan 2026 08:04:21 +0100 (CET)
Date: Wed, 21 Jan 2026 08:04:21 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, r772577952@gmail.com, stable@vger.kernel.org,
	hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: fix UAF in xchk_btree_check_block_owner
Message-ID: <20260121070420.GC11640@lst.de>
References: <176897723519.207608.4983293162799232099.stgit@frogsfrogsfrogs> <176897723630.207608.15659392786155037540.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176897723630.207608.15659392786155037540.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 20, 2026 at 10:41:10PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We cannot dereference bs->cur when trying to determine if bs->cur
> aliases bs->sc->sa.{bno,rmap}_cur after the latter has been freed.
> Fix this by sampling before type before any freeing could happen.
> The correct temporal ordering was broken when we removed xfs_btnum_t.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

