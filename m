Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD52A3CFF65
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 22:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790376936; cv=none; b=BHndWXts7En75WvXHNf2XPA7z2v0n223FpZdfa7QmutOZ924EHBfO/ckmcly0b57QvY1fpQdG12eKOqpnfuKTUD1gQ6gJNvPBM/DKQK/uoyuXXTiLVCOr0N1ikSpgdgIT1XvLjUlYJm8+llnXsy+FKK9aJAMQFmthaPivosMpoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790376936; c=relaxed/simple;
	bh=RgNjWZEGKJVEZKFxCavHh/RGoON4ZKaanqC7GwQDJ08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ByfFQvT/TGcR5q2ouo8kT40V9QXSive0UP74aWNv7NeejkMORN8RbOB3XHpi5EJ2Nf9wI7hXc/trmAXVXDBZqKa4mouG5U/5SWYBOGO1OvIBMDrMGCxX2xYEdnxmzoiIqScF1KvzzfKxjY3AVuynNISVSodxF0CYgsegp6KNGIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cua6+pHB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cua6+pHB"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 795691F000FF;
	Fri, 25 Sep 2026 22:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790376935;
	bh=V/4G4l84DRQHPbEtQPjupTlN5Y3CN62fuzjoK7hm8IM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cua6+pHBoFYmY5AAF0DZAuskYUFKoPYQ9vjc5K7zoMxo/KqddoOkvkcg1xB/iyexq
	 qO5meSMGJa7WhVgBU7x/3ED812ZrMhNFvdlZsxKhAZIv89DcUYFd49Ig6JOEnwpph+
	 4aYsAsN3N0QYtbeKYQpxG3GUIxdT4mN3HX6NhwgEZzZ/sh6YKBgtVZAWLUGtzkFqEk
	 C3ivn2gt03IPsC8JC0n0tzBFtUpSX7lU1J231HcM3eBUCjGu49Z1eOLyrF+fHPVc3i
	 1xgHAXbpa+2JcQhgXtcV+0K5EFU3YcH8jWxfB6xzF5hRPV9y2s0xE8SvqMq8WhZMMi
	 NJYnr1bQCvJZA==
Date: Fri, 25 Sep 2026 15:55:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: reduce libxfs to kernel differences
Message-ID: <20260925225535.GA2705364@frogsfrogsfrogs>
References: <20260925152107.3386097-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925152107.3386097-1-hch@lst.de>

On Fri, Sep 25, 2026 at 05:20:19PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series cleans up libxfs to further reduce the difference to
> the kernel version, and to reuse xfs_trans.h and the various log item
> headers that my kernel series moved to libxfs.

This looks fine to me, though same as the previous patchset I'll let
Carlos and Andrey figure out which libxfsification they want to merge.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

> Note that in this series, it uses the Linux 7.2 versions of the kernel
> headers as libxfs hasn't been resynced with 7.3 yet.

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-7.3-sync_2026-09-20

--D
