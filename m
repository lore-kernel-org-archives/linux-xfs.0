Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D3B371887;
	Tue, 22 Sep 2026 05:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790055211; cv=none; b=JS9xyjYhJYxvN26MN9sdpe1/+5orqRLnp2vj0mMv19NPDR1Jgiw6CFBrWYEHYicxQ4tOpiGJuTS2KZLyhV6mgdfA0Q4EHEKWpSPm1Z4966gfqLhLupKOlbTno+lGttwRo6v7SNk2UHnUAIDFTGDCJ4NtpKk5bpYvDrqY+qIqAMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790055211; c=relaxed/simple;
	bh=h84gXq+SL86TbuVESyWXTeeTzJnfX8MDK+EJb4juO8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HoR1rs8FZuwBAoSR8Gk/L10zS/XGiijRl6QtHktNJBEsbf/PLZOnVEyZtPtJk3ffbiFUt5WM+h/fW5DU1rF/edeY1+uCA0CMx2LpCcY9qWaGBGkAiLT+OrczHkQdo7DRa7xfVKLp0JUMUz7v8fQpiKBCtODoXzDGoKhepIaVnWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KND5GFQ5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KND5GFQ5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PEej17IE5O5XVPLLwI6VqWxPXAeqh9Y8G0u+ymZgRZM=; b=KND5GFQ5nLmEDGyKAmQWVyGmka
	EzYz5im/mcnsUSQITLSHVNgFOpmjq3ftSj5Y3FJQ+kbjurjpuzEJyrNnFEoQLR7jD50J1sP8ZCj/b
	kC3eHUmCkfzxtMdlP4GHHeUJrHVsWX03cvcUesSxiRohkGy09+QBaSMyTTRXQkeabZChN3XUZFTe1
	9P0Q3nxEJgw+pMq4tkXEqs4xxSW+3KCfoXQc9ijNxFvb3saWer/ccds5Bf+/cCAA8uhROBbAayEtr
	kyAxQmEu2l8pwd4n03q4O0jMQqWlLayvGJG+Bpub/U7g4rOrbjm2D7XAiASvmTGx8o1XEiutcT4xr
	qtcwN35g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8t87-00000004Fhd-1eha;
	Tue, 22 Sep 2026 05:33:23 +0000
Date: Mon, 21 Sep 2026 22:33:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/3] iomap: don't resubmit an ioend after
 ->writeback_submit() failed
Message-ID: <arITIy2upsoN-DlW@infradead.org>
References: <20260921083133.2960-1-parri.andrea@gmail.com>
 <20260921083133.2960-2-parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921083133.2960-2-parri.andrea@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Sep 21, 2026 at 10:31:31AM +0200, Andrea Parri wrote:
> For XFS the second bio_endio() lands in xfs_end_bio(), which
> list_add_tail()s the already linked ioend into ip->i_ioend_list.  This
> corrupts the list and leaves a use-after-free/double-free window against
> the ioend completion worker.

Do you have a reproducer for this using some kind of error injection?

>  		if (ioend) {
>  			error = wpc->ops->writeback_submit(wpc, 0);
> -			if (error)
> +			if (error) {
> +				/*
> +				 * ->writeback_submit() completed the ioend with
> +				 * an error, so drop the stale context.
> +				 * iomap_writepages() would otherwise submit it a

Overly long line here.

