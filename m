Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9B61D6BD
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 16:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706286589; cv=none; b=t7CqBkY5OkPVadOhGektkpJqpPGfLyfPq+EgvchUNP9vMz11wv6vWYI1AQkCwFU5d707/TU3Y/vK9I97vbX5OtctqtHYeyetpg8J/BvR3SpMHgqivYJ/VQlkVxwHWokKubX/uqqKaH79dLUDBOv/qFi8xaljIyZXem5CL6XcU0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706286589; c=relaxed/simple;
	bh=K3tKwdi7n7CfPyC7UuRmFD1Avigh6DK3BhGcjF9Nx7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BNfmQrWS+J7Nk70PyKzvQJWDQM8vcTGZB0rCG0BFv/zka/pSOoU+5nLmTKm8fre0S/1XRi68sUrKanT00td/mvXKLoj51IWT0VsSITqAAjolJffYY/43NyOS9g1+pOdzuLr0jm4dIV593jY8nAL0NRiCS5pvm7UZE2cgv4Kp4E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FicqndMj; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FicqndMj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wy+XkLuRo2PBD+rdI0vTOnLpO313KFe+vZMzhQ+4sws=; b=FicqndMjK7dzS9MlZz8+h/SsnW
	6HNo4t7w3Mfun7L15lEnPdPxkGSQCygt94YS8uSsjGlUpSkwUg7qqX5CzL8DxuIRrbaTyXqfeAyue
	rYNhIaMqo3ITU+GVYnIFBSorGb8hH2oLUvS0paG6xiVdQWGFVSm3eBNu2YwJrCmDyE6ytjUPpOTW/
	xh8rVs3tjFgIZXxFrxpusA+idTZnU1SqSlvT2deBWpf9kSBVyP4WDFPvC+gsR3Q9LdchjnR3aJBJz
	idmvaVMPN+eyI2HQhc4JvuKIrZdWPCMHVzSs1KTl6T+sBeXC7iDA5OYlLqGtlNv2V/+GCYxj3UR/i
	mPa5wIAw==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTP5L-0000000EAub-20YU;
	Fri, 26 Jan 2024 16:29:43 +0000
Date: Fri, 26 Jan 2024 16:29:43 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 14/21] xfs: use shmem_get_folio in xfile_obj_store
Message-ID: <ZbPd95QsTMLBObSL@casper.infradead.org>
References: <20240126132903.2700077-1-hch@lst.de>
 <20240126132903.2700077-15-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240126132903.2700077-15-hch@lst.de>

On Fri, Jan 26, 2024 at 02:28:56PM +0100, Christoph Hellwig wrote:
> +		if (folio_test_hwpoison(folio) ||
> +		    (folio_test_large(folio) &&
> +		     folio_test_has_hwpoisoned(folio))) {

I need to put in a helper for this.  I'm seeing this pattern crop up in
a few places and I don't like it.

