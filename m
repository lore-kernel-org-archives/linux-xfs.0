Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC661FAC3B;
	Thu, 13 Mar 2025 07:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741850815; cv=none; b=mxxjuhj4QnfTts0yaMvabQRhToGkuEk28cYmVM44hvusj3YSwNO/biriz1zdeSQfHcXBPfagdySktnVVmtKYWxfe4HkRpzfwAwbo5bsSA861iOYH/OpkgnFsCDu5Sj2xZ5BCx5RyXFJLDlX9Qjtc8S5AkOSKdJWeowZ0hFmcMYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741850815; c=relaxed/simple;
	bh=KRRC7P8GQhVVpX4V2cwa9PBDj4WgklRzQhGLVjGchmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rXDh11ecMymInNGkQWEl0WuHwONX6W6/6eXUnVzYAVm6b6VB0YYjqkh5LxQvPgdFDo2UPSjVrcaNy1vSLAfGnXKcN9cXuS0bbHLExpgcyJxt1DTaK3LyoSorZUdQqduhpxTV5WdXgkaN8S2bFt2z+c/QAtGOfqnRbFrbBEhHN0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B325D68C4E; Thu, 13 Mar 2025 08:26:37 +0100 (CET)
Date: Thu, 13 Mar 2025 08:26:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/17] xfs: check for zoned-specific errors in
 _try_scratch_mkfs_xfs
Message-ID: <20250313072637.GD11310@lst.de>
References: <20250312064541.664334-1-hch@lst.de> <20250312064541.664334-9-hch@lst.de> <20250312201725.GH2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312201725.GH2803749@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 12, 2025 at 01:17:25PM -0700, Darrick J. Wong wrote:
> > +	grep -q "zoned file systems do not support" $tmp.mkfserr && \
> > +		_notrun "Not supported on zoned file systems"
> > +	grep -q "must be greater than the minimum" $tmp.mkfserr && \
> 
> Hmmm... this doesn't mention the word "zone" at all.
> 
> Maybe that error message in calculate_zone_geometry should read:
> 
> "realtime group count (%llu) must be greater than the minimum (%u) zone count" ?

Yeah.

> and I think you should post the xfsprogs zoned patches.

Still waiting for a baseline to post against, i.e. rtrmap and rtreflink
being merged.

