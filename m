Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D0E383998;
	Thu, 16 Jul 2026 08:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784189911; cv=none; b=MVrIWI3Dj+ORBqtU5ly0oEtTRIKH9mg6bkplETX0F0kCqri/VzMIMe3xQv2prmxXsNIMA5W4AuqsPyhARarGHxb8/W2+XaxlI9FWZ9gWocIM/g6QSa2sy16yoPJN3gblHXlDihvevz+RLCVXy7pJntQj1+Gdw+z5C+2HWdp/rNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784189911; c=relaxed/simple;
	bh=T+UYfk+VcO9LP/Z758EMllAQcQZmPo2YWENEoGqn7QA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nupTv1I1EUxkUJGQS54H5dKH+9VnKJ6vqA3LcjWPq+jasLfeapqT/y7+X1ANaN3HlV6aSWwbiv9fL+50ynD/p0iGGOgzoOCZSoujGsOGszVGhjtPjYV+rXfRu3tj7tuzeoRyBy4MlASz4WmZWInOZ1ygAbnbNH7DxJO6aS1Vu/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 768EC68C7B; Thu, 16 Jul 2026 10:18:27 +0200 (CEST)
Date: Thu, 16 Jul 2026 10:18:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: check cowextsize in xrep_inode_cowextsize
Message-ID: <20260716081826.GC12330@lst.de>
References: <178416797326.2008054.12517273271060887961.stgit@frogsfrogsfrogs> <178416797381.2008054.6629007049464918838.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178416797381.2008054.6629007049464918838.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 15, 2026 at 11:06:22PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM points out that the function that corrects cowextsize should check
> i_cowextsize, not i_extsize.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

