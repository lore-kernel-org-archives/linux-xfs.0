Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CF41C304A
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 22:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733955512; cv=none; b=pv88N7XHnZKZCldSUFRJH483vuA4vhuLC1iF/6iSGk6o0Bo5t86eKnJMof5fPOAWA2cRCX1EnHRaohdpcgTrB72JOymKNatJ47Qwur3mfez9R7CfVm5fNTBQItQhVjrQbBvbQ1Y7AfOIOQZOy640ob6qVtGw9xXgZxmqLM2qh8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733955512; c=relaxed/simple;
	bh=IBUm5F3yS82GTcTB3+IDDH31sm7ThxJpgwSXmxqZYsU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MiHftD29pPpMqLj0TsXuZKS8YH5nR0pio6a/ooAfyqYkIJFmxTaYKzE5UKNlPPLAQ7d8kGuOsyL/Gb/EfTK2VaifiKWqA2qMdlw8yfOhmPV3/VpIRX7BWkF7I6i8IywUudrjOiIXJcwP3mKtWpgX/qJJ8zKV6/dZS1BufEkzmGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XnsMmhNG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XnsMmhNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBFAC4CED2;
	Wed, 11 Dec 2024 22:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733955512;
	bh=IBUm5F3yS82GTcTB3+IDDH31sm7ThxJpgwSXmxqZYsU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XnsMmhNGQ9fYSD1mNe8FEEk13yNjkfMihYfOqEvIeGDCsV3/XKiGNH8Wjn1vhwEfI
	 vH/VXxOfZW9hks0YQLLZ/gOOLJzYo4yN38cbGqyxt1Eo3UFp9wPl0xCyjb2yxXtCcZ
	 qAaPgkMAwGt0XMm/IQvcx2DPTgTTPlV/zfuoPIf6A/Mq1jH3HJM1soFmTiJhLfmDof
	 dwo1Ac8sYvrugtv7V6/l2Kmf2S5c9paGIHaR7mKOX9OmpJatAPYjMk32ms4B8B+8U+
	 0IZ6FKwlGLDsuFHYl+rvKiYW+iLk9QGKhfsaNTYxIxYSOW6fOuNJ8JUJcWmDsqH/88
	 NO7ojTF264f2w==
Date: Wed, 11 Dec 2024 14:18:31 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 46/50] xfs_scrub: call GETFSMAP for each rt group in
 parallel
Message-ID: <20241211221831.GZ6678@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752648.126362.13619225422874515961.stgit@frogsfrogsfrogs>
 <Z1faBj50DquwPikG@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1faBj50DquwPikG@infradead.org>

On Mon, Dec 09, 2024 at 10:04:54PM -0800, Christoph Hellwig wrote:
> > +	struct fsmap		keys[2];
> > +	off_t			bperrg = bytes_per_rtgroup(&ctx->mnt.fsgeom);
> > +	int			ret;
> > +
> > +
> > +	memset(keys, 0, sizeof(struct fsmap) * 2);
> 
> This could be simplified to 
> 
> 	struct fsmap		keys[2] = { };
> 
> instead of the manual initialization.
> 
> > +	keys->fmr_device = ctx->fsinfo.fs_rtdev;
> > +	keys->fmr_physical = (xfs_rtblock_t)rgno * bperrg;
> > +	(keys + 1)->fmr_device = ctx->fsinfo.fs_rtdev;
> > +	(keys + 1)->fmr_physical = ((rgno + 1) * bperrg) - 1;
> > +	(keys + 1)->fmr_owner = ULLONG_MAX;
> > +	(keys + 1)->fmr_offset = ULLONG_MAX;
> > +	(keys + 1)->fmr_flags = UINT_MAX;
> 
> The usage of keys here and various other places looks really odd.
> It's an array, so doing pointer math instad of the simple
> 
> 	
> 	keys[0].fmr_device = ctx->fsinfo.fs_rtdev;
> 
> 	keys[1].fmr_device = ctx->fsinfo.fs_rtdev;
> 
> ..
> 
> is rather confusing.  I've actually cleaned this up but forgot to
> send it to you.  Feel free to grab the patch here:
> 
> http://git.infradead.org/?p=users/hch/xfsprogs.git;a=commitdiff;h=5699e03cf03e6b1189a89f903631046d16980ff6
> 
> and fold it in.

Folded, thanks for the cleanup.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!  I've folded the scan_rtg_rmaps cleanup into this patch but left
the other two as a separate patch.

--D

