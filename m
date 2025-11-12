Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D98525F96D
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 12:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762951868; cv=none; b=MMKoZBhWNQe4jEIkXvolkF6hAhfgp62TOhYlOyJrwcg47U2Piw9XbShj0lJBbFZ6zKc89R134brWzlIFoS68TfHOpaRNN7kS46/ZW+vmqIOI+OuZ6yJBK0pqPsqPL8kl7mDSBSCtGt/qJ6GtXLnP3Bej3YrX9F0ynVPlr1Ttxp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762951868; c=relaxed/simple;
	bh=75XrmWbdVCmnkgl0FeVGlJJQbcpvrFaml6yy9JtFCuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NceYxxzfh2A9Crri3pcI2Ie5lbYGmf54wgBHi5Mw+75Lwc2URhYC4fatpWdPe1adZMg2dnplc515Dx/+kaODiQt5mnk4SCRWsxZcCR3kDrYRBAofmDT33M3ThTNaCWcZLsG5TNSQv3WrwBdBdUvz8enXsympkggaPbjBr35ZsaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 80059227A87; Wed, 12 Nov 2025 13:50:56 +0100 (CET)
Date: Wed, 12 Nov 2025 13:50:56 +0100
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: aalbersh@redhat.com, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH] mkfs: fix zone capacity check for sequential zones
Message-ID: <20251112125056.GA27028@lst.de>
References: <20251112123356.701593-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112123356.701593-1-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 12, 2025 at 01:33:16PM +0100, cem@kernel.org wrote:
> FWIS, writing the patch description I'm assuming that the conventional zones
> always come first and we can't have a zoned device starting with
> sequential zones followed by conventional zones.

XFS kinda assumes this by not counting counting conventional zones found
after sequential zones, so we'll error out due to the lack of conventional
space later unless a separate device is used.

> +static void
> +zone_validate_capacity(
> +	struct zone_info	*zi,
> +	__u64			capacity,
> +	bool			conventional)
> +{
> +	if (conventional && (zi->zone_capacity != zi->zone_size)) {

No need for the inner braces.

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Note that we should also verify that if a device is used purely as
RT device (aka no internal RT device), that there are either no
conventional zones, or zone capacity == zone_size.  I can look into
that as an incremental patch.
