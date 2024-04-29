Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B9B8627A
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 17:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714411085; cv=none; b=jqnui94mvuOY5w1E6aEBIBQ2R+uDf/iKYY7y4iWPCDTfTD+v7gYmBPD7zfIW5Qrzhu3/nnv1rJ3eAFS2AUiyECWY/Ai17XmWmTdPcmmWUcqRJi3mtBr9SVyLpVcpgAhFwWriTkahzKFk/4nU7w1Ddn7ecGOv8awpifZg+UvfRXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714411085; c=relaxed/simple;
	bh=504fPuYJh73/51F0gH1J+V3mqTVebS3sme34xIO6gqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BWuURvPHCsZdNNnd/RgGS0j5Z4JUCRU+8m7v9mX3Z9RXhPxCcgz7iphVhE/y2o4DMt3OktHEM5arOnf+2xhI4RkaGV53y7R9jHmikpOfzV6pS4DfBaxmY7G1c/4GIKIYs/UpliMqhkG/jq0QlC0U4zVBTpRR131g+dYfTxat/Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4B1ED227AAA; Mon, 29 Apr 2024 19:18:01 +0200 (CEST)
Date: Mon, 29 Apr 2024 19:18:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: rename the del variable in
 xfs_reflink_end_cow_extent
Message-ID: <20240429171800.GH31337@lst.de>
References: <20240429044917.1504566-1-hch@lst.de> <20240429044917.1504566-9-hch@lst.de> <20240429153356.GZ360919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429153356.GZ360919@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 29, 2024 at 08:33:56AM -0700, Darrick J. Wong wrote:
> On Mon, Apr 29, 2024 at 06:49:17AM +0200, Christoph Hellwig wrote:
> > del contains the new extent that we are remapping.  Give it a somewhat
> > less confusing name.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> That's a much better choice of name!

It's your choice so it must be good.  I actually slightly prefer the old
"new" naming :)

