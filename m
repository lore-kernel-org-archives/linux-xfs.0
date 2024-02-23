Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83C814CADA
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 17:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708709372; cv=none; b=t0xN+G5C1SMePtzppjAqM5XwuylQ1xNzyzSguZ8xbsrXivNNTEb6QQDX4rxNNjDZHy6m9E4esCGe6FSbL6EsyHnHvw135IGeUMZAALPpx+qaldp2gRTNvQ0Kw/6GDYggtlcRBv9b/loeGrgPpwDImZML77lmZePkXi4MBf6DFxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708709372; c=relaxed/simple;
	bh=AMtk33sWMqwLKIgDWbbm/ajYm1FRBg5T2NLNiKJr4Bs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Od03AGqITivy7j9mEjdw5Yyhsfuf+O+uMp9z163HnevFTboAbmB/xfyF9t7JUwVRzBeBMmPl3Lc4j+SxGKx3A6xc7CXUdq4S3nJj4DmZjeReJZ9CqI1dLH3UZ1sWlB2ZLVdznmza9A0dkBVom4xa0TFHpzUrYDMqbr6AT8DB1sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cHE2azDl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cHE2azDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2460EC433C7;
	Fri, 23 Feb 2024 17:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708709372;
	bh=AMtk33sWMqwLKIgDWbbm/ajYm1FRBg5T2NLNiKJr4Bs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cHE2azDlN9nx/Xnb3jeL7XmCUus2UIT4YtNBDdgvvK6V5ITtKKOas9ZkKsXKzXF/5
	 nNXp/NvikhTtTq73urRMciihuPFFZPatjjOd7UQjAnZLyikGXCURSjDno0fM6Yb9/i
	 oBMxInRHc4sc5eAjeX1cp0HAmOj1yr6/xzq7Bq1zooEg7mMqi4AXGYkws7KQJN3Syt
	 rRVZeedOFFhlaTdGpbJym9eGtim6HjAMtYMcZjyreBmE1b8645EXblAz5r8I2JEDcn
	 /xgb79Jcya3mLZjghwAdeVYhGAEhv0d8tuc/w/I6bE/kwCvw9NMVYNR+DcHPRhtsed
	 jAAmk9h2MPuXg==
Date: Fri, 23 Feb 2024 09:29:31 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/10] xfs: support RT inodes in xfs_mod_delalloc
Message-ID: <20240223172931.GY616564@frogsfrogsfrogs>
References: <20240223071506.3968029-1-hch@lst.de>
 <20240223071506.3968029-8-hch@lst.de>
 <20240223172028.GT616564@frogsfrogsfrogs>
 <20240223172220.GA5004@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223172220.GA5004@lst.de>

On Fri, Feb 23, 2024 at 06:22:20PM +0100, Christoph Hellwig wrote:
> On Fri, Feb 23, 2024 at 09:20:28AM -0800, Darrick J. Wong wrote:
> > > +	fsc->frextents -=
> > > +		xfs_rtb_to_rtx(mp, percpu_counter_sum(&mp->m_delalloc_rtblks));
> > 
> > Should m_delalloc_rtblks be measured in rt extents (and not fsblocks)
> > since a sub-rtx delalloc doesn't make any sense?  As written, here we'd
> > also have to signal a corruption if (m_delalloc_rtblks % rextsize > 0).
> 
> Either way should be fine.  I did it this way around so that we only
> have to do the conversion in the slow path, but I can change it around.

I prefer that all the rt space counters have the same measurement
unit to avoid confusion later after we've all forgotten rt again. :)

--D
