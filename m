Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AAA1D5CFE;
	Wed,  1 Jul 2026 00:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782867325; cv=none; b=fGrsr4qYPoiiYAQzLwAZM1CfWROZn0R3ZgDU/vV3JhZVhCw4uv1b5Juyx2zlcQwwfSkCSaOalC6aWn8J2KjQ46YeCBNDoxe7plHkjTCbkybSblTK0q2d2N+WkIkEjf5YBS1ip/Y9RYBuFor0aAPFQKLtMrmj9+O9O34X1mFkrDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782867325; c=relaxed/simple;
	bh=9Z9ArON/QE5u8rhZr1EjOO8ZsX628W+KI6v6x5rZZx8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nqmi4S12r79vso0b3zhGCn78kkVYUTI0IoEiCVQ3lpXFC3V4xicxgqXlsXvnVf1exCuoVbRE92xBuLAx4PwdmJYNUu0X+afqYtmH9JiG3azZLw+PlDU3gUp+UTIg6vLgCPK9x1HYq+2ZuITXVYCFDfHnhZEc3QSpG4CCTJzFjrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eZ7L5Dg7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eZ7L5Dg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE22A1F000E9;
	Wed,  1 Jul 2026 00:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782867324;
	bh=jvGSubRhLRrfQ1Bx0YzokVu5xaLPDT8+PK7Fx2Fmv6Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eZ7L5Dg7bX49psz4qjSk4Khp8OAhc4kVhEkRG1PWaPJk5GpugpbYn5ZZ8e7wyrfyy
	 LfcZSiq33O/rJMOkZEkGkGXcksVrUhecvtntn9J9w/PKK/Jbw6LuiiOQkyfOCoHnu4
	 doB0xjnZNcWqr1RPdASTY8Ip6AfxtPtZadiqiXV04oO9wrJL8NoRz50MoxK2YVITgw
	 TFhWcEGpKAL9XW0t4OGfbS9CstGO0npV6ev5jB4xYIpjx08oPwff41REc9t0T/cnLD
	 BnrnNTvVHxq14TbQWfBUPaH6b7uK/WzgUV88R7eq32rxQ9Dv4F4x/KB+ZJ1Iv0Umbg
	 jDOrk/lrDqlCQ==
Date: Tue, 30 Jun 2026 18:55:22 -0600
From: Keith Busch <kbusch@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, willy@infradead.org,
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	"open list:BLOCK LAYER" <linux-block@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 10/18] block: convert iomap ops to ->iomap_next()
Message-ID: <akRlehPHzy-F_105@kbusch-mbp>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-11-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701000949.1666714-11-joannelkoong@gmail.com>

On Tue, Jun 30, 2026 at 05:09:25PM -0700, Joanne Koong wrote:
>  static const struct iomap_ops blkdev_iomap_ops = {
> -	.iomap_begin		= blkdev_iomap_begin,
> +	.iomap_next		= blkdev_iomap_next,
>  };

I think it's generally safe to use the same mailing list for the entire
series. There's no context here on what "iomap_next" is because I'm
subscribed only to linux-block. I found the rest here:

  https://lore.kernel.org/linux-fsdevel/20260701000949.1666714-1-joannelkoong@gmail.com/

FWIW, everything looks good to me.

Reviewed-by: Keith Busch <kbusch@kernel.org>
