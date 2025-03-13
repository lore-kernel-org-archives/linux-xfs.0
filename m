Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F481FC118;
	Thu, 13 Mar 2025 07:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741850665; cv=none; b=drjSeVN1jPXQW+WBS5D9IGFOzaY2SznjaNeaSVr75aK01KHuPfsblGOCvGNbE13ttTsMOm41bJKR4qfplWtXeXZOgmKvzShvHYB6Vb2JNTxuEUfWhcLAowwFkpRfAGHfNbYU4zIUH04xunMt27W8A9eKm4MDQeecpvh72T86bJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741850665; c=relaxed/simple;
	bh=3NshRvn65Q92EDA611Kpx9oJ/YQWuWpDQFJhqA4g8+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K04ePiByJYPPenc3HiuZDJ5L5Sp6ZEpRgg9/cqJ8zf0lmORYxl6VbN6xYG0VAkSELYGEBPJIBUE1JNDaNCqp4T3OE8GABvHz1DftDlEsFgbhKZpqfHTgpq/KBt3/JMvq2dVmawtuXPduAlPQ7KXYBAgD9jNDf+CJ6fZ462tFOhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9C00468C4E; Thu, 13 Mar 2025 08:24:18 +0100 (CET)
Date: Thu, 13 Mar 2025 08:24:18 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/17] xfs/419: use _scratch_mkfs_xfs
Message-ID: <20250313072418.GA11310@lst.de>
References: <20250312064541.664334-1-hch@lst.de> <20250312064541.664334-3-hch@lst.de> <20250312200512.GB2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312200512.GB2803749@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 12, 2025 at 01:05:12PM -0700, Darrick J. Wong wrote:
> On Wed, Mar 12, 2025 at 07:44:54AM +0100, Christoph Hellwig wrote:
> > So that the test is _notrun instead of failed for conflicting options.
> 
> Which options are those?  I'm assuming that you're forcing -r zoned=1?

Yes.

