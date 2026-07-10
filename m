Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D6F381B04;
	Fri, 10 Jul 2026 23:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783725086; cv=none; b=HkenKNEoQrkKQzHYlxBQR2wDaJac1TE/d2EOUIoe62LDe6gYCLOvZNAQSMi1eAwEz5fD0xH5Uorx0bgfPSCAky1L4D8+pnVq2X8zlIEvCqJ+UE6RjPDzred18rN+iLzY9j2cla27mp2iMNJoZRoKFjDKxLIhDId3/UwMuNg2yhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783725086; c=relaxed/simple;
	bh=nmuNCWxyCi8jzzlw5tqqHXlNgWoAdPyOQR/OJiI1Kb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qOEM1VJWFArUZ1jzWQYfHxQqfT2IGTAnmpNpuJ20H9/sdavm4KyVZLw1Qe1TbI0RsRCuU7vjKevUUA4rxepkF8NlHzvdHxDNBvNVVrs/adYFC/CoN6oM1ZM7D6Odvg3alkD+f0u0FLrLWeARX3kQNLjmGg6PnHXalP9Uu6TgXOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dvg9bD0f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dvg9bD0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E9F1F000E9;
	Fri, 10 Jul 2026 23:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783725085;
	bh=lmReB4YfsUmYlBzVCb27IBmpsFMAZFKysWECQFUPa44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dvg9bD0fAOmbip2lkwOOscdHwsK7ch300TBNdvvQq/0HxjjXmZrU7/t41ylG+gO2+
	 qCbmItV/TjWEGHuFZ9Nltuf6Eem48B0wenIu0jgNaijCqweAqL+IQbRQrCOAAm21xn
	 5VtabOFJbCAQ1dL3dsvtGlHmsPGRo5UDayIFpRDJBJFSIhFULc676oM6CiWkewdl7V
	 LTjLIry6cv7caZfnruDM3GbeeWEXpQx+ogi9OWbWfRfeyjhB05fNbKeivlZhvb2la0
	 dk/IbnaoE7qLFBM2w8EHuvDUIW8dIE3UqU40LM+hqZF8XJBf9jm5AglobEJxTknKot
	 fCioOsZmBN2TA==
Date: Fri, 10 Jul 2026 17:11:23 -0600
From: Keith Busch <kbusch@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	axboe@kernel.dk, brauner@kernel.org, cem@kernel.org,
	jaegeuk@kernel.org, aalbersh@kernel.org, tytso@mit.edu
Subject: Re: [PATCH] fs: report direct io constraints through file_getattr
Message-ID: <alF8G6Fw2aFh-2_o@kbusch-mbp>
References: <20260708011843.1036846-1-kbusch@meta.com>
 <20260709071352.GA20180@lst.de>
 <neamg3phll7hjwd765ddtqebtxasdvkoskff75dqzmgzv2xy5i@mf4agr6yoizn>
 <20260710212058.GA1911@quark>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710212058.GA1911@quark>

On Fri, Jul 10, 2026 at 05:20:58PM -0400, Eric Biggers wrote:
> So far I haven't seen the point.  Yes, applications can benefit from the
> lower alignment in theory.  But especially with encryption/decryption,
> it isn't at all easy to support.  This has apparently been getting
> learned the hard way, as (for example) alignment was initially relaxed
> for dm-crypt without testing it, and it had to be reverted
> (https://lore.kernel.org/dm-devel/20221103152559.1909328-1-kbusch@meta.com/).

To be fair, that was most certainly tested in production, and it was
reverted for a bug not related to alignment. It was just a mishandled
early exit corner case accessing uninitialized fields; a trivial fixup.
