Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAE2288535
	for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 23:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766188563; cv=none; b=OvbXs/+T5IeYbarf2J5h2FmNZjiAvRVikP2BXbdB5OliJEgmJCa9kHXGy7be88gwosuxMEC/4u+8/q06h88id0DwVPiKQr6mEktGQvFSjAP179rzuFIo9stZZhK0qiRLSvgyhaPgvMstXaeUxYO9/7GTn0WNbja5sniw0bO5tgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766188563; c=relaxed/simple;
	bh=B5MfP7q+guGNcVE7Ea4/amG9p0A70DqGAQfE0dJlPp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BFoMosKg89BowhgmYKlNU7ugf3R+xfiwoReS0NKXvdlkVIrdiJ5LjACq0rz/IpN9i+qN4maqmQLQAVFzWeEdMaBfDEmzDDdRu3e5hqE0sOJZ/yzhrokdEaoxITvRFlRCj18hoHKCOpGbegihRMAv8SDK+uodMs1QcDgzCwX57PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V36obV7P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V36obV7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4268C4CEF1;
	Fri, 19 Dec 2025 23:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766188562;
	bh=B5MfP7q+guGNcVE7Ea4/amG9p0A70DqGAQfE0dJlPp4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V36obV7P+i54v16MxZ+6bzdYAJIOLMu+aniNpmPbAEaE7KbVrT+m+LDiaRZWN456O
	 PJwa5FI9KiDfNVjYdmqrJumi+kWHQIyZOExF8Orw6qVvKsfDXhm2AKG/3SPrBInCaf
	 QDk/XF9Ps62E57KbtnkPxUwv1JzX9DmN48SupLtvrOHtM/XRBxoOBQzb2bShCvDDEg
	 fW7TQWxRKYKKHHYJqmtCKB6EOlaU3PL4xktSWTCUJNpJ0uzywdLpt9G09yrD1gplhS
	 ZNqojeFEAs6nBKOhNcdkJnJg3sBoScJoX8A8CKXYIoJrbzMd1FMPlfLguT3PupURax
	 ap1REiuT+2ATQ==
Date: Fri, 19 Dec 2025 15:56:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH v2 0/3] Enable cached zone report
Message-ID: <20251219235602.GG7725@frogsfrogsfrogs>
References: <20251219093810.540437-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219093810.540437-1-dlemoal@kernel.org>

On Fri, Dec 19, 2025 at 06:38:07PM +0900, Damien Le Moal wrote:
> Enable cached zone report to speed up mkfs and repair on a zoned block
> device (e.g. an SMR disk). Cached zone report support was introduced in
> the kernel with version 6.19-rc1.  This was co-developped with
> Christoph.

Just out of curiosity, do you see any xfsprogs build problems with
BLK_ZONE_COND_ACTIVE if the kernel headers are from 6.18?

> Darrick,
> 
> It may be cleaner to have a common report zones helper instead of
> repating the same ioctl pattern in mkfs/xfs_mkfs.c and repair/zoned.c.
> However, I am not sure where to place such helper. In libxfs/ or in
> libfrog/ ? Please advise.

libfrog/, please.

--D

> Thanks !
> 
> Changes from v1:
>  - Fix erroneous handling of ioctl(BLKREPORTZONEV2) error to correctly
>    fallback to the regular ioctl(BLKREPORTZONE) if the kernel does not
>    support BLKREPORTZONEV2.
> 
> Damien Le Moal (3):
>   libxfs: define BLKREPORTZONEV2 if the kernel does not provide it
>   mkfs: use cached report zone
>   repair: use cached report zone
> 
>  libxfs/topology.h | 8 ++++++++
>  mkfs/xfs_mkfs.c   | 7 ++++++-
>  repair/zoned.c    | 7 ++++++-
>  3 files changed, 20 insertions(+), 2 deletions(-)
> 
> -- 
> 2.52.0
> 
> 
