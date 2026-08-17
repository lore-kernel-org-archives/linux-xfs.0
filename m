Received: from mta1.migadu.com (out-65.mta1.migadu.com [95.215.58.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6459427F91
	for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2026 13:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973183; cv=none; b=r9FUhKkxxmPd24sLl1n4SJn8eIexDBwy/cWVl7KPNJCKjCJ77+1XkRRwRAVq8pfPlDTWjlh3jsYQuGLrHw0AEp+0Jziup18t0qR9Cj0ZCZcX67n3zmYmPzsA/IZz3gFJeTM9YsNQs3mgCn2Pt97kJDn4d8ZAc6qyQ3/ysbSj6DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973183; c=relaxed/simple;
	bh=3TpusMzd7P3socew3RIylYm80V4CeRzsgimpDnB14AY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pt1KZzCsUEmgfooQKrF/3XwagRB8ScZlwczQMgKJNmzKjk4IqSsVHSPe8z98k8pxoQuHHDE/fSrPNyGuHtTx4HE6eMRcYpFEe9S5xwQ8erl92mhNOPfn5gTUScjg+l2S+W+3tgM0E8YQgVJherszpcqUiOKgm3zj/7+qRRdB8rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oontv0Fj; arc=none smtp.client-ip=95.215.58.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oontv0Fj"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3TpusMzd7P3socew3RIylYm80V4CeRzsgimpDnB14AY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786973179; v=1; x=1787577979;
 b=oontv0FjSPtRmQyimAZwWTEpL5I1SA/+g7HIYN42mqj0Y8PH7r/furn3ea9dWU1gJ5kUftJl
 xA4YZoSd0TMvexIl2E6cq2gpuomjthxoTNSPgHgpPs2Iq9nresI7Zo3aiNRTml7NWBYdNcbIlGb
 k50hYbzLoJpf3FAnLd9lmlWI=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: from localhost (195.100.225.50)
	by smtp.migadu.com with ESMTPS id 922c91fc4dceb656;
	Mon, 17 Aug 2026 13:26:19 +0000
X-Migadu-Flow: FLOW_OUT
Date: Mon, 17 Aug 2026 15:26:18 +0200
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	"Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Christoph Hellwig <hch@lst.de>, 
	Dave Chinner <dchinner@redhat.com>, Daniel Gomez <da.gomez@kernel.org>, Theodore Tso <tytso@mit.edu>, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Dave Chinner <dgc@kernel.org>
Subject: Re: [RFC PATCH v3 07/11] iomap: Add DSYNC support to RWF_WRITETHROUGH
Message-ID: <aoMLboIzOmJzn7C0@quentin>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
 <a679d79b676d3a43332aba54ba25660c9ea9e1dd.1785908600.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a679d79b676d3a43332aba54ba25660c9ea9e1dd.1785908600.git.ojaswin@linux.ibm.com>

>  		return -EINVAL;
>  
> +	/*
> +	 * If we realise that cache flush is necessary (eg FUA is not present
> +	 * or we need metadata updates) then we turn off the optimization.
> +	 */
> +	if (wt_ctx->use_fua) {
> +		if (iter->iomap.type != IOMAP_MAPPED ||
> +		    (iter->iomap.flags &
> +		     (IOMAP_F_NEW | IOMAP_F_SHARED | IOMAP_F_DIRTY)) ||

> +		    (bdev_write_cache(iter->iomap.bdev) &&
> +		     !bdev_fua(iter->iomap.bdev)))
Shouldn't this be similar to DIO code: !bdev_write_cache() || bdev_fua()
?

As long as bdev_fua() is supported, it does not matter if the
bdev_write_cache is there or not right?

> +			wt_ctx->use_fua = false;
> +	}
> +

--
Pankaj
