Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B202118C927
	for <linux-xfs@vger.kernel.org>; Wed, 16 Oct 2024 06:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729059907; cv=none; b=uS1HnISqzNx5C2G35t+5/Eq4WkSvLkw/hMvlbTUZng3N18DwL0OCL3x+AZ/ioNFESIiK/W0hOZxPDq56A7dbnG50YN+H6OhJMkgB4l6XA+VKc4KyyDzfGqCv6xzQbaqL3l/0p8dveH9/yJhcHR3yoXBVTwd/EFtD8WOPUkYhNNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729059907; c=relaxed/simple;
	bh=qQmE7J1EB4B+0OWfj5T0VlYIsS/csqZ9XtsXVUAhSrc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gLF317mKmCaaPLogu4f6MOneodi4FH0n4E+aHbBVol6CaTePpZfQGbEsUxZ59xBPQW6tTtuIXCJyn7s8JLBY5oTCZamaGYsTNFFRRXA7o8j9U0tWrt1JhP+o4IN5xaMavJZYOhIkWXLi5w9dxUa+fah+yQ7adEgS+5JJFew5K20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 10F63227AAA; Wed, 16 Oct 2024 08:25:01 +0200 (CEST)
Date: Wed, 16 Oct 2024 08:25:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: pass the exact range to initialize to
 xfs_initialize_perag
Message-ID: <20241016062500.GA25956@lst.de>
References: <20241014060516.245606-1-hch@lst.de> <20241014060516.245606-2-hch@lst.de> <Zw5p6k_R99zbj26a@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw5p6k_R99zbj26a@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 15, 2024 at 09:11:06AM -0400, Brian Foster wrote:
> What happened to using first/end or whatever terminology here like is
> done in one of the later patches? I really find old/new unnecessarily
> confusing in this context.

Looking into it first/end is bad because it is the acount and not
the indices, i.e. each of them are the last index + 1.  So I'll switch
to using orig instead of old as inthe caller here, and keep new.

