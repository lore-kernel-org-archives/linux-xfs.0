Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD00F383A5
	for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2024 04:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711685672; cv=none; b=rklyfMSJVZuGJtIiI8bQAhL+Imsmtn1cQOt/pcKDJmS6JMGZOHOyzPsZkLat7WsxoeDgYRa+unLUe8UI2ek/BYZ/8G7aEQCZpEhlVhXgX300ODhUIRhLfogYPW50JKLmILOsGfSqDbGUphnmLV0Qr9+jzLjqhTvO406boQRqzt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711685672; c=relaxed/simple;
	bh=YVU+p4STAflnzG7CRuErMbqULyZ/9BgIb6i7OvXkQw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k8ZFGaeYHq4zPSS15TxrXt7L/vMzgFkJZf2go5zx+TlM3m55uPtxfZgWzmyOjSYiC//BTtI+M0S6eysbA1Mj1cgmUXQ+bIMUN3I/R6aNvwtbJIY+x1IMEh2NNXMOovYKF5E3xcRo4fPhrLX+7n+MqjFAqTABZw2/pTYyjDNuWgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id ACA8468B05; Fri, 29 Mar 2024 05:14:26 +0100 (CET)
Date: Fri, 29 Mar 2024 05:14:26 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/13] xfs: free RT extents after updating the bmap
 btree
Message-ID: <20240329041426.GA18850@lst.de>
References: <20240327110318.2776850-1-hch@lst.de> <20240327110318.2776850-4-hch@lst.de> <ZgTuWIIMrtupCRav@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgTuWIIMrtupCRav@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

FYI, I've picked up your comments with minor edits for the commit
message, let me know if that is ok with you:

http://git.infradead.org/?p=users/hch/xfs.git;a=commitdiff;h=445d786ae6e50f6631118e0fa378ad0cd72076a9

