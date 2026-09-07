Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98D72571B8;
	Mon,  7 Sep 2026 05:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788760450; cv=none; b=DFFdT/Ow6saVcW+4qTLRYmUWwCi4xN3Y0XRyLPhFNdnlrefjPzqw71rFi03tXGK2X7LO8zfa5tNUvwwicO+lr1WBs6vGCfdYWDM3uon4olIvOmkNZajnAg7px+VFNnjjmFB4b0NvFGkyAFDr97UP31ErhoWWuDbbtoyd3zdRE48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788760450; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=buRF109gO4XRcPrAz6/hmWHnycVlcjOhkdm5xXdFRQ9u+rvHLFdT1xFIrVicp5BmRYiWMRaYpROCyog4y99nCH2acOjQ5MjmOK3/JDtKiAwsVFRJTzuIcd+eywpUDjA+bWhJrq69L0pxCmFUE0QscEWtTsHbN1Z2s5hy/+pm6iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0C71468D05; Mon,  7 Sep 2026 07:54:05 +0200 (CEST)
Date: Mon, 7 Sep 2026 07:54:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, abuehaze@amazon.com,
	akpm@linux-foundation.org, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, dgc@kernel.org, dipietro.salvatore@gmail.com,
	djwong@kernel.org, hannes@cmpxchg.org, jackmanb@google.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	vbabka@kernel.org, willy@infradead.org, ziy@nvidia.com,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Brendan Jackman <brendan.jackman@linux.dev>
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-ID: <20260907055404.GA31706@lst.de>
References: <20260904115629.3993331-1-dipiets@amazon.it>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904115629.3993331-1-dipiets@amazon.it>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

