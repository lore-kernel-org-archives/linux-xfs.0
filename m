Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D58820ED
	for <linux-xfs@vger.kernel.org>; Mon,  4 Nov 2024 04:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730694549; cv=none; b=n8glabJCIw3V2XSbHeLc8F5b08WjZlCW07ALgsBleJrryntqW+xqAszC4PBJGfFip0KI1sXapvRCQKZKoXHQabLLmyfJVyg7B+EOG7ZH93qzvZ7YjIQRXD+jlooML/T6L8PBb/oKQwjROrmvq+E4/nzJFM+91l2CmgE1/lNCyZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730694549; c=relaxed/simple;
	bh=M+dhws8h2duV2s9d3cKrc8WpvN0QUw/TL0PxQLcnItM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cUBZUDX6maNUzwhCDCorSxenrGBEQMro/HC4JEyzLs7p34wZFVYjMnU83dI56kxtmm6fcIUZBxU7OCr8QK68WginewdmxmoB3tyHG2F4u1+dPikLO/DHSiVcM40iqRoG8BME4Zl4zahyOQyYyG8Yak0KTKgsC1TFB0FMt6dWkiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 43EE6227AAD; Mon,  4 Nov 2024 05:29:04 +0100 (CET)
Date: Mon, 4 Nov 2024 05:29:04 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, david@fromorbit.com
Subject: Re: [PATCH 3/3] xfs: port ondisk structure checks from xfs/122 to
 the kernel
Message-ID: <20241104042904.GC17773@lst.de>
References: <173049942744.1909552.870447088364319361.stgit@frogsfrogsfrogs> <173049942802.1909552.3233838341241015760.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173049942802.1909552.3233838341241015760.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 01, 2024 at 03:19:05PM -0700, Darrick J. Wong wrote:
> +#define XFS_CHECK_SB_OFFSET(field, offset) \
> +	XFS_CHECK_OFFSET(struct xfs_dsb, field, offset); \
> +	XFS_CHECK_OFFSET(struct xfs_sb, field, offset);

Despite comments to the contrary, xfs_sb is purely an in-memory structure
and nothing cares about it having the same layout as xfs_dsb.  As we've
kept them in sync so far I'm fine with adding this check under the
expectation that I can remove it again when I finally start removing
struct xfs_sb, which is long overdue.

Otherwise:

Reviewed-by: Christoph Hellwig <hch@lst.de>
