Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E273328B40E
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 13:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773754787; cv=none; b=ia3lX6ARpZmF0mTN2ptcOP8AkLAsnB586TTB/fMDxlAC61DOjKksqZChYjA1b7oC+3H7AM3AC6WOm7Oy2AjKZigLJV5aoK/qnEdOOjO0hFHaDOCIuWBafE2OT136sgJLILijySJT4zT9Xw/Hq7GkrwMu/fakwEmTZR9GUSMndOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773754787; c=relaxed/simple;
	bh=UBGnJ5W/Kt8SQqIxazb3nfyHXMhGGF5SvtQLj4Q3X5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zn2fw8hX/qdBkuZrOVM0qrLjdmTiMIJf01u7eQEJx7Q9H0/ePHwBINVPB/fVFqx4aUUP78ejeeJrzU+AoZhucJ+zEUoRb2pCJ4UAR55sTnmzeAK8K0KwFi5yPF+1kJDynf8hn1jMSUty1OASIgEVOG1qrqV5IRoU6+GDebgmS7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9479168BFE; Tue, 17 Mar 2026 14:39:42 +0100 (CET)
Date: Tue, 17 Mar 2026 14:39:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: buffer cache simplification v4
Message-ID: <20260317133942.GA924@lst.de>
References: <20260316154216.1598410-1-hch@lst.de> <ablFUL_cBSJBJHgp@bfoster> <20260317125604.GA29925@lst.de> <ablY4bjxZs54FWeS@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ablY4bjxZs54FWeS@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 17, 2026 at 09:36:33AM -0400, Brian Foster wrote:
> Where is b_hold an int? AFAICT that was part of the first patch in the
> previous version, which isn't included here.

Ah, the first patch is missing as I did a git-send-email for too few
patches.  Resending...

