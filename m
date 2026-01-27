Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EE5283FE3
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 16:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769532193; cv=none; b=PlIWFL0jxrainIhS8i0vKl8+5mNOzLJcSI4aCPuBi1Ng67cMe7Q3aRAJiVAp/a3cN4PkZNYsUO74wvS2xzfmWVGmP03iBuQnCAdsVnK/Q2hqVnib5Iy3gi7A95ykOLku2x/Vr+Q9EL3EhH61VOLJq7I2g8DaADAbrVqMQqVh6gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769532193; c=relaxed/simple;
	bh=UQTOFmHSaBKRdc4PLhFhJsdal711fUqTE81lZajQ5/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DwEP+sykba6KSFxtDdnSkOirButHZwlhjaiYLbIfS1VZeInvk5Sl0x7ZxyhTlumz3iyO0GRyh1v4pOjCmd8njbswMIiQ8GEVNtozgVfXSp2hrkMaoSLjo3h/Oly1BkIdFfzQyyBxnEe9OG/D+4flCUWqf0ubiPmvgC2ruKBprRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7F6F76732A; Tue, 27 Jan 2026 17:43:09 +0100 (CET)
Date: Tue, 27 Jan 2026 17:43:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org, dlemoal@kernel.org
Subject: Re: [PATCH] libfrog: adjust header order for BLK_ZONE_COND_ACTIVE
 #ifndef check
Message-ID: <20260127164309.GB8761@lst.de>
References: <20260121064924.GA11068@lst.de> <20260127163934.871422-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127163934.871422-1-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 27, 2026 at 05:39:29PM +0100, Andrey Albershteyn wrote:
> This is because of the order of #ifndef (in platform_defs.h) and #define
> (in blkzoned.h). The platform_defs.h defines BLK_ZONE_COND_ACTIVE first
> and this causes enum to fail and macro being redefined. Fix this by
> including libfrog/zones.h first, which includes blkzoned.h. Add stdint.h for
> uint64_t in xfrog_report_zones().

Thanks, this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

please order this before the cached zone reporting series, or fold it in
to preserve bisectability.  Or should I resend the series with this
change included?

