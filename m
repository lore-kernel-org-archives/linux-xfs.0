Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1EE2BEFEF
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 05:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782450287; cv=none; b=X5+etEWT/ITYS87sUUnm7OgNFhd5iJ7Pcl+QDsnD63r9vrz510EBn6ulso4dY8sefNW6KrxQQeR45npY5VDGgdluZhsm3H9v9eu7P/T7nqFyJG/0l57Jnz9ZaW7jCN5DIx9vSaiw6nbTdeXU+EFhr6OMG/S5TBsNxUUHcdWr5R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782450287; c=relaxed/simple;
	bh=UwXsxB/phVXC8wosxZxAOSlLma9Or73s3W+BGcvxXjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JrJKIgXW6TRLNd1XZfRxotAgJVcXD124+HLE6iS8qpn5Q214PhiFqYVXaE6Tg6NeY3SZbriyHxn5S3H+3Rqzc8NZ9uFJG9/Y9WF1QfbEivMpICdJtTp0Aextl77Un8QKbOsVAmYkZ6ut8wn/xvvBN7pcilu/I1B5zyX8Ja7HK2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DC30968B05; Fri, 26 Jun 2026 07:04:43 +0200 (CEST)
Date: Fri, 26 Jun 2026 07:04:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 6/8] xfs_scrub: don't leak phase 5 scan items after a
 failed workqueue_add
Message-ID: <20260626050443.GF8786@lst.de>
References: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs> <178242801415.1981574.15526143457820896308.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178242801415.1981574.15526143457820896308.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 25, 2026 at 03:55:46PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex points out that queue_metapath_scan and queue_fs_scan fail to free
> the allocated items if they are not consumed by workqueue_add().

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

