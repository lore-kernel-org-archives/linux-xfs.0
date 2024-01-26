Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949CF1CD0A
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 16:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706286425; cv=none; b=n2kGATxfezOBDaQ0ZH5O5IUjDShVtPBrl62I1/h2V38b16SQyn5KP98rxcI99UAYoAprvnsRKAU5bYuZOkBxT9NT0zHi6bBz9gdK1F+nE1t//VL9Bee5GRS3pKne8MnAbmBXGttiYqgnHMURlngmMrittvXWFVTKw4PoLkP0LZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706286425; c=relaxed/simple;
	bh=c1kqkBznTfQG+o2Ws5GYzRv6M2eYMEfMclPrVWxetA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UiOwJeSlcHFp60zXhnxqEOhfAebX0S8OCmtt9kEoNpOQcAjr8pY47Dv+gpFJKm1xzPR4uM+cnk2+OFBnTRw2xvTVspQydIBaSNvu/G5XkxSR7HZT8rSUeofMCa/k5vgknmS93rhKCt0r4g7woqVdGkwCej64yg2x/gdpO5zSVtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kIKpYALV; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kIKpYALV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MoCxtq1T03XgSJvkoQI5WYvO92xmQhfwt4sXWWBLhpM=; b=kIKpYALV4F6TgwUNp/S1bA03Nb
	z2rNfp7MZHbHzuj24gSjMQmFhX/vucWQY8WYcAjt0BveutzluHzrbUlaTHPkFrZKp8cqxo0iaSVPc
	PmhMrjAT3/udbIQdphKAOWblOEsmVMCESC5YdXv9IVlbAg3ngdOPt7zDYjxpY8dQaj0ZgRPpiYm3S
	Rh97KikPE62sh+pyNiFcRVDbNqvnOTSsAIRk9dxLIBbabT2SYlhF5yVQ6niFS64xp8zAzhM+TSn6s
	opgwRMofm2iK839FP99AAATAurbSnuzKOuLdqS5BA/SreoX+uXI62NlEL+NRXoLA4rLaAgpelhcuU
	HByJ2Kww==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTP2h-0000000EA9b-1rYg;
	Fri, 26 Jan 2024 16:26:59 +0000
Date: Fri, 26 Jan 2024 16:26:59 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 13/21] xfs: don't allow highmem pages in xfile mappings
Message-ID: <ZbPdU-w60GkBUXDi@casper.infradead.org>
References: <20240126132903.2700077-1-hch@lst.de>
 <20240126132903.2700077-14-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240126132903.2700077-14-hch@lst.de>

On Fri, Jan 26, 2024 at 02:28:55PM +0100, Christoph Hellwig wrote:
> XFS is generally used on 64-bit, non-highmem platforms and xfile
> mappings are accessed all the time.  Reduce our pain by not allowing
> any highmem mappings in the xfile page cache and remove all the kmap
> calls for it.

Ummm ...

> +++ b/fs/xfs/scrub/xfile.c
> @@ -77,6 +77,12 @@ xfile_create(
>  	inode = file_inode(xf->file);
>  	lockdep_set_class(&inode->i_rwsem, &xfile_i_mutex_key);
>  
> +	/*
> +	 * We don't want to bother with kmapping data during repair, so don't
> +	 * allow highmem pages to back this mapping.
> +	 */
> +	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);

HIGHUSER includes __GFP_HIGHMEM.

Do you want GFP_USER?  Compared to GFP_KERNEL, it includes the "cpuset
memory allocation policy" which ... I have no idea what it means, honestly.

