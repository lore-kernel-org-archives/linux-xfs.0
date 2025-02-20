Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F30E1632DF;
	Thu, 20 Feb 2025 06:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740032278; cv=none; b=Iwwfonde8lu2eBgYrlJPWNHDLyPb9fhEGEFgF+JfIKY/n6MYOjpUbtSN8t36/7scXBfOX5OFisctnvc7iJ1FMfQj6I+atiHWY67hXurVpMKFVGOGxZ0bExp70MrUkhL4zL/flh0ZDnCC1JCf5CgxsX45lv6aB3eJJzaaQoB/PjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740032278; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yh1KVvhaDfxJYq8baLZkjCPWnH/40HRwuBb9zSD8ke80JBljFLdAt6kSev8Y+PWlD5P08kCd0FEmexzNlco36w7JAk/itp1QtNK+bXft+Uzhh4xm3AsqEOQgG5044LKJzjhAjDzaGtAZx4v7ULgB8gYyqHT25k89szyR+rx8AH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5661A68D0D; Thu, 20 Feb 2025 07:17:52 +0100 (CET)
Date: Thu, 20 Feb 2025 07:17:51 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v6.4.1 09/13] xfs/104: use _scratch_mkfs_sized
Message-ID: <20250220061751.GC28550@lst.de>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs> <173992591276.4080556.2717402179307349211.stgit@frogsfrogsfrogs> <20250219191744.GR21799@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219191744.GR21799@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

