Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162658C1F;
	Mon, 23 Mar 2026 06:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774246682; cv=none; b=Y0R1a8sZYMg/2M/1pTpfI1svrQ//VhzrIqddfa7Mq6JEvGr0WgGwXsw+7qxjt+meGnV3GPCcV9Re8wQ11qjoxDiv/ti1YhCrAaw1cA1PzIfeGlOi3hkXpgOXBhyisUQrW4utnD1SIBfVthRnz/douw4DS43nffWK0jqhlNn6WRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774246682; c=relaxed/simple;
	bh=cr+kahZ2/t2EpUMpwrP2N5H3I2zs3nZxr7LjchR9w7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=coyJCLSppcmsadZ0GB+PTVRkLUPKuXnZT52FcSMbGYl95z2+ggkS1t2sNm2Q8lCdnkWJrJa7cKtG5X3fLOqXo9fzsSQDsAeVxPVx8FZYv5VuA9v0CQzQBkuZwjHu9HrteMFG7R63YIE++hrxhcrseEcL30uI4cnZ1emeieDPgqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aFKWEqmZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aFKWEqmZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qq9Ch574Mk78jIY+CDuu0xPMYpbUQ/02GbhKWjWT7tk=; b=aFKWEqmZjoUnAND7Oti8tRqFQS
	rRZiwEit2/yijbx8iey0wIMzpgKjPl1m7nAQzI1/YDvgtZzG0C6QpxiPEkNgUY6Kg7gC7dBd4S5/M
	7UroMAEmjQ1meU679Gq9EkgFQau7t617hdNyC51Su41igcnkvbIFijYgQMtrtWrjs0pVtBcNBtKqT
	VIZX6YC5nD/gDr0WJFajhqCtkhxVi87+SxXgBDUiDjYQzchvxHLUrpoA79Q+VhG27WT075MlooZtN
	PJvLyndjjXT9Boal1Tp5BsnWXU4ynLF7IL9gIE+Yw1xE9LCusQhnOfxWjRnoJ8beOt5QeaRDJQS1n
	PCEjLusQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4Ybu-0000000G7UV-3pwN;
	Mon, 23 Mar 2026 06:17:58 +0000
Date: Sun, 22 Mar 2026 23:17:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
	Tal Zussman <tz2294@columbia.edu>, axboe@kernel.dk,
	linux-block@vger.kernel.org
Subject: Re: [Bug][xfstests xfs/556] inconsistent {HARDIRQ-ON-W} ->
 {IN-HARDIRQ-W} usage
Message-ID: <acDbFtQw0mom798e@infradead.org>
References: <20260319194303.efw4wcu7c4idhthz@doltdoltdolt>
 <20260320163444.GE6223@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320163444.GE6223@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 20, 2026 at 09:34:44AM -0700, Darrick J. Wong wrote:
> --- a/fs/iomap/bio.c
> +++ b/fs/iomap/bio.c
> @@ -8,7 +8,15 @@
>  #include "internal.h"
>  #include "trace.h"
>  
> -static void iomap_read_end_io(struct bio *bio)
> +struct iomap_failed_bio {
> +	struct list_head io_list;
> +	struct bio *bio;
> +};

Between this and the blockdev dontcache work I really wish we could
have a generic offload using a percpu lit and workqueue.

Also I don't think we need the separate list here, a linked list using
bi_next should be sufficient and avoid the allocation in the failure
path.

