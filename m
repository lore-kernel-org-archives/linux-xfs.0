Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106A535AC37;
	Fri, 12 Jun 2026 08:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781251736; cv=none; b=Je4ydr4iJonjGlyDZmxK6KcF2Y1GV8mqKLspkSLmP+5VpxNwYDd4v0jrhF/c8MkAoghZB+YG7ImMdQe2mhga3v/2VDrEYKp0xj8encQasVRz2aWVB9hjB51urawCKt6hbS1N8giFfMZwbHAbwD/xDIkXNyMjPWrirBGiiLV3sUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781251736; c=relaxed/simple;
	bh=ExfSAcjV91vuVPY50XAYD6gMyXfA3CfuB08cUTYiQFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E1gnFIUJa+JhsjGVOacQX/1p6dXdBIHv5D8poPMEwz3bfvvNpieQ2PrdpZM2Y9PTXVpxrg4s+0v/cZ0HSW85pwmeJO0/gJGge0jQ+hxJa3i/0PO8Xa3NdpHojYnNNowWccxYVsKlVbmAiGvu9N4cs3/2u/hHQymVf6caWzHXELQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E42B868C4E; Fri, 12 Jun 2026 10:08:49 +0200 (CEST)
Date: Fri, 12 Jun 2026 10:08:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yao Sang <sangyao@kylinos.cn>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
	djwong@kernel.org, zlang@kernel.org
Subject: Re: [PATCH] xfs/333: test zoned realtime writeback EIO shutdown
Message-ID: <20260612080849.GB13962@lst.de>
References: <20260612074231.1109213-1-sangyao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612074231.1109213-1-sangyao@kylinos.cn>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jun 12, 2026 at 03:42:31PM +0800, Yao Sang wrote:
> +_require_debugfs
> +_require_scratch_nocheck
> +_require_realtime
> +_require_block_device $SCRATCH_RTDEV
> +_require_zoned_device $SCRATCH_RTDEV

Anything that requires a SCRATCH_RTDEV is XFS-specific.  I though a bit
about how we could generalize it to not require a SCRATCH_RTDEV, but
I think that would be a mess.  So maybe just make it an xfs-specific
test case.

Otherwise this looks great.
