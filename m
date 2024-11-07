Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19367195F22
	for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2024 07:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730964610; cv=none; b=S7OMiOGg1LmmiDyCzwzRnx/hCrZNuRXs3DNXeL6dNanubHnv1tACGoXnD/iNNJdSscXQivWOhWWQR+GBqN6WeXlKYnupIsV2kyGbGYwrTy49GskE3KIBt4ytWHUcJASuVnhT1cVc/w84xF7sioZX/ctdL9RygCXh9DZTSYsWKUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730964610; c=relaxed/simple;
	bh=t+ordc7nVqEYg3lmsCOfFcX480LUn6TT6BVBiZ0fE3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=psQB+3L/Z5NrZ2HhaM07lMmTSkyXHGrm7iB6pjwlFULQsepm+iTiyZ6F08tqgaCytWZ1+GQryPjqUWzFpwMfHT7f6tvR0SOgYT7k5wITCi/8s7vpjBwfMjfeFb0edJ3Cp1v23EI/t/+YR9AdTpVMuHqOiNji12jotxSjDo97DvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2E73B227AA8; Thu,  7 Nov 2024 08:30:06 +0100 (CET)
Date: Thu, 7 Nov 2024 08:30:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/4] design: move discussion of realtime volumes to a
 separate section
Message-ID: <20241107073005.GE4408@lst.de>
References: <173092059696.2883258.7093773656482973762.stgit@frogsfrogsfrogs> <173092059714.2883258.9567907120205476743.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173092059714.2883258.9567907120205476743.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 06, 2024 at 11:18:54AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In preparation for documenting the realtime modernization project, move
> the discussions of the realtime-realted ondisk metadata to a separate
> file.  Since realtime reverse mapping btrees haven't been added to the
> filesystem yet, stop including them in the final output.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

