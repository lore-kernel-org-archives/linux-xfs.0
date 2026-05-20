Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E44B375ACB;
	Wed, 20 May 2026 12:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779281693; cv=none; b=YjiTmMaQLxgiLcT3GtiFkJmEIzoiQB7bRoO2ElDN98f7fiRjWrUCMm7hhdKw9CBl+qIHhjxb7WZgRsA1lcpFli4Xg2vwZcgUHIm6AR4MLWtJ+rIrMsnh1728Vznlf459c3SdfE0c0F4o8clht8Izvoe9kUg8xfLQkR/x8O8kskY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779281693; c=relaxed/simple;
	bh=qgDYWr/4InV3eYWusmtiA7XZuVrysMkip2bjmcV6kdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RaHZ9fhEgx4RoEcq/xjLVP4477axO02oCC+1aTsvTJotlKnCsszgpozA++VBWvVNHgm0HILozs2Y98cFecgVNjiWEDFvBfCiXERP1cTNdNqeHrtFAQDjJDBIVPSeqZMrx8sEYSFc9z14UaUnGjnIQAxL4RoyDeKuIK60EQa7/1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RACqazUE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RACqazUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8869D1F00893;
	Wed, 20 May 2026 12:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779281691;
	bh=G9nYrlVDfcGiD+sy6zZ3kUqNfgbrUZ/GdYElP70bpsQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RACqazUEHQ8Slq6nlyU0UVLPFHU9J+KWMeLWgJXnewYt51G9Yu+KqGk5XPRzgle0R
	 1Tld1WNgPRYlPiVbWmEIeu5nbdAnc0XMvI+LKd+/Nb8pJwtQ3MoMxSoIcWiGGW2vlK
	 vAyEkl3i3pL8pMRf66NQ5pdnJFe2MhaWn2wIWikcxxHp2QItZXa56chnP2UuimDhry
	 SROL33rOMog40z3JdYwDRjsn7Z7R9rWshRJjwFHXeADUxK/4Ijy3Donq/y96Aa6xng
	 w1YrB/jXYeYnThPwpt42idHL6lYYTnuw8d2rjvIaTx0kIVUd6Abq3+OUpaEe4v9oix
	 NaAPDHsO5NUAg==
Date: Wed, 20 May 2026 14:54:47 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, amir73il@gmail.com
Cc: hch@lst.de, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	djwong@kernel.org, Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v10 03/22] ovl: use core fsverity ensure info interface
Message-ID: <n67pde3prjxt2c2u2pvjytfw7uzwbeij2yljlrwh7fixcgnzhp@piqsltgpcc4v>
References: <20260520123722.405752-1-aalbersh@kernel.org>
 <20260520123722.405752-4-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520123722.405752-4-aalbersh@kernel.org>

On 2026-05-20 14:37:01, Andrey Albershteyn wrote:
> fsverity now exposes fsverity_ensure_verity_info() which could be used
> instead of opening file to ensure that fsverity info is loaded and
> attached to inode.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> Acked-by: Amir Goldstein <amir73il@gmail.com>

Amir, Eric, this is the last patch missing a review. Could one of
you have a look at it. Not sure who should review this.

-- 
- Andrey
