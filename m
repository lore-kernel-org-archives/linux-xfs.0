Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973EF1CFBD
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 15:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706282107; cv=none; b=tXohbXWIbuuLXDA+YePRbcpUchcEMNvilUnY+aKzKhsq2x/OecVFYIsZ1+a7rvAVkvduqNkXNtNMErMSbS4f708cAmKJQ+zclI/dfL2NMUVcUeOk+1PzsgWEJtOL09+vsJea7bXBCetUnHKxx+ncAwD2UV8r2rwaIXHQQ/mMR04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706282107; c=relaxed/simple;
	bh=KtJtdwVsjF/64zD1LoehnCtfNwvIDf3CVJ5cbEj7t3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NhY45N5QesHl9PGeXeh/RaFLdfT9pfa8Fd7bumvCW38tJmkvXmzGv0FvThZTlPUb2NtOji5wyVcLB7UH0p43EWmgDINuAaVJY+bMFXe4ZzzBLe4odkMOmPt/BMLrsZy4jzgsETTIbTQ9zUub0Zt+RrzHxMBMjsO6HabBtap+/DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jWR47hp0; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jWR47hp0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/hdn1lU9kvqu0h/7oAskjzQaoQjkaJypO8kJZ8unQs0=; b=jWR47hp05JN9AhwB2mfH2FCS46
	3ZoPm3hoU0RRWs7nMUzzr2O3tOtnhpaT2WCdgdhtVCyqq8daA/tUqzTbpK0TPcYauWwolS0bYyhe0
	bn5B01nCaXTt1q12HnJ8SOhW4iFwMZHxJSNWLJBliQ6ok6Vq3EkZr28ouj78LeIwRnXPIA9GFBFui
	vVTygYaQsT8B7uMSu1/BTtvk5GrPltXNO1bCCFvig/42G5Hn6v3Rm/sRd9e9ySPVv3mYFehLtLfJW
	HUcdndpww6+JuWMz2v+pGeGa6JW/sOTcbrceAc8G/lfX4/0qepByE1HIeD+HnSIcmXbFGn7/0Bk7E
	4fEPzDVQ==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTNv2-0000000Dz9K-47oU;
	Fri, 26 Jan 2024 15:15:01 +0000
Date: Fri, 26 Jan 2024 15:15:00 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 05/21] shmem: export shmem_get_folio
Message-ID: <ZbPMdB9Ue-lNQcQG@casper.infradead.org>
References: <20240126132903.2700077-1-hch@lst.de>
 <20240126132903.2700077-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240126132903.2700077-6-hch@lst.de>

On Fri, Jan 26, 2024 at 02:28:47PM +0100, Christoph Hellwig wrote:
> Export shmem_get_folio as a slightly lower-level variant of
> shmem_read_folio_gfp.  This will be useful for XFS xfile use cases
> that want to pass SGP_NOALLOC or get a locked page, which the thin
> shmem_read_folio_gfp wrapper can't provide.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
