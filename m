Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47BB32D0D4;
	Tue, 30 Jun 2026 05:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782796399; cv=none; b=klTllaEi6Hv8MjMSZILEcWjn3Jid6AZSvv1wcnDNyo8fDtTUMfGO0VCB9dpmBttulp1i8stWGQdW4Nsz8B1hrlYANyJ41K7fy71fVtqJ4qyygx18LO40oiIb4F6yMeEgRfnmQt+CgZjtr2AV+pmb/J+qAjC9Rkvy58rD2oQKh5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782796399; c=relaxed/simple;
	bh=ol1Oh59aA3Z2wl/cI03NkWWDLBxmZvgspaj9yva4YG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oe0FuufHW13RdvyUqobjn2j56k3swore5q501kK1mX7ETxxO5DXqL2J+LjKSo0VNv00L987woUswdf17XgyGz+ZYMnpa9KrGmjPqf1t05zy3yFWluqBc5ZZsbr/eqBCvY9S4bWSkZVFioEYC19G/yVdW9ejJpsMvqRf9YQ83OvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0659D68C4E; Tue, 30 Jun 2026 07:13:15 +0200 (CEST)
Date: Tue, 30 Jun 2026 07:13:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Lukas Herbolt <lukas@herbolt.com>,
	Eric Sandeen <sandeen@sandeen.net>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/216: disable all concurrency scaling
Message-ID: <20260630051314.GB20771@lst.de>
References: <20260619050937.444488-1-hch@lst.de> <20260619050937.444488-3-hch@lst.de> <20260626045353.GA8735@lst.de> <akKye7hMwSw3Vc8L@zlang-mailbox> <20260629225857.GH6095@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629225857.GH6095@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 29, 2026 at 03:58:57PM -0700, Darrick J. Wong wrote:
> > Let me make sure I have the current status mapped out correctly. So we
> > should apply/merge the following patches:
> > 
> > [PATCH 1/2] common/xfs: fix _scratch_mkfs_xfs_supports_concurrency
> > [PATCH 2/2] xfs/21[67]: fix mkfs log concurrency detection
> > [PATCH 1/2] xfs/078: disable all concurrency scaling
> > 
> > And revert:
> > [PATCH 2/2] xfs/216: disable all concurrency scaling
> > 
> > Is that correct?
> 
> Sounds fine to me.

Same here.
