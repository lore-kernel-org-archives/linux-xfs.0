Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F40F3246EC;
	Thu, 23 Jul 2026 05:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783235; cv=none; b=lhg6efCmJtpoBg+gAlD/HmY1cTygi8kVKeuKPdl9eLOhV/Mqgd29kN1awA9Ah3BIGx2cD+h6pcO8qWGqNZpiXc9u5ETFdL0Z6acbwq7nOcD9RD9VSC/q1QFc78NS8+ZyaHs/V+ErTF1HKGHBMm+hhoLp5igbzQcUuBspzHWCoKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783235; c=relaxed/simple;
	bh=6AU1yAOfsIsDqJsn35s2vIC+vGD7c69U9s4x6UXqLvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qpklC2ZdmAsv6bBdPmnv5PfUkA1nLzKywxhn04SIQBtW7GrdhhPVKNT2Z+s5z/ECBxHP2C4dklwxkKmrBvKs9MyMMfqel8J37VDI202uWQKT0ayBo5ZTticUAyCQDWxVhpRfktwiiI/U9QzPEGoObF5Xzt4sdOjHyEDrQ43l2x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3591968AFE; Thu, 23 Jul 2026 07:07:11 +0200 (CEST)
Date: Thu, 23 Jul 2026 07:07:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: pass runtime errors from
 xrep_iunlink_mark_ondisk_rec up to callers
Message-ID: <20260723050711.GC7121@lst.de>
References: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs> <178460419595.830862.11183226779231035029.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178460419595.830862.11183226779231035029.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 20, 2026 at 08:26:06PM -0700, Darrick J. Wong wrote:
> +	/*
> +	 * Don't proceed if we couldn't set a bit in the bitmap.  All other
> +	 * errors we ignore because we haven't actually checked the inobt yet.
> +	 */
> +	if (error == -ENOMEM)
> +		return -ENOMEM;
> +	return 0;

To me this would feel a bit more natural as

	if (error != -ENOMEM)
		return 0;
	return error;

but either way will work perfectly fine.

Reviewed-by: Christoph Hellwig <hch@lst.de>
