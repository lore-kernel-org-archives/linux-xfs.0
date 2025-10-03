Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0AF25EF90;
	Fri,  3 Oct 2025 07:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759478181; cv=none; b=n20hLHUdLgMP1ciFzI5pFRpWOTuMi1xwKKCytnUCfYwDAb0Vmz545NH0fhKwAAlF6t7J9NFdDqzTd1eKwqrg5UewLjqdJpCLduchhGPaO9oyfi8KAEscNM1joS+zNRQOnLE1lV9Pas5X6LIa8nnZ3wjmcFLfOkSmJCUkbbVOnDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759478181; c=relaxed/simple;
	bh=BMomsJz5Azu7YQm86dJHBABz7seja3RN/p1W3QvRRcA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kFWimI4NeQvKmHH9LOZGA9ptINXfKzmm5cF1lIV0xC21aYn75OL8li84mJrjqsEzoqkF8059NcrhkCC5fP9lRTuiggc1sixnAn/WVnm06btTc7lpdMAfALsISG1MLlolTu7QpKEevwWUqUKuUfDRGW1QPaeXYUWuVyXIDgVFS04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BCB21227AAC; Fri,  3 Oct 2025 09:56:15 +0200 (CEST)
Date: Fri, 3 Oct 2025 09:56:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: kernel test robot <oliver.sang@intel.com>
Cc: Dave Chinner <dchinner@redhat.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-kernel@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [linus:master] [xfs]  c91d38b57f:  stress-ng.chown.ops_per_sec
 70.2% improvement
Message-ID: <20251003075615.GA13238@lst.de>
References: <202510020917.2ead7cfe-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202510020917.2ead7cfe-lkp@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 02, 2025 at 04:11:29PM +0800, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed a 70.2% improvement of stress-ng.chown.ops_per_sec on:

I wonder what stress-ng shown is doing, because unless it is mixing fsync
and ilock-heavy operations on the same node this would be highly
unexpected.

