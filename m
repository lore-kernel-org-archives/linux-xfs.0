Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2374B56E05C;
	Tue, 22 Sep 2026 17:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790098595; cv=none; b=Y3TNcDoa9RNX2eljaLFm7MPJDotsgzliyrTWblnGzhjbo9CXo5IQdp6UnMYxOE0/9jiUprq1p6PoY/qKSNAT+QVbyuzHEVCZIRpF4QOQAlqVLh5h4qvF203UfQUyU8nmVF+DX6NaD81sAgy4E7jSsPJ1UjkXcOcvVAiQLAWlfQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790098595; c=relaxed/simple;
	bh=BcR4NrlPgIKjBgbTBnyeyWv0byiojlnO/s2OolHEr0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y8sxhXOs7UZC6x2/gVTcFouS+Fet+814Gs+enNOwYq61q3ezwQDnsfJiMklvipBs9E2ua5tfIfOSsy9VL1ZECieGLn0BJdkjHkCgtCKJNVu17i3JE8bIcSytbmv5PkrJJJ0qmFTCRAVro7jXMCnPts000pWH4VDlY+/16F6B7io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DR5HcBvG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DR5HcBvG"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AB3D71F00893;
	Tue, 22 Sep 2026 17:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790098593;
	bh=059fGmqBGRizwF23FdWfipqynGEXzoEpe4Tj3yyu1sQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DR5HcBvGq9l47a6s7iXhD0/UcUADKnyDnnMaHVKmwvNpyOVCYpdToCnZC5lICI8rU
	 0l4hg33XqshRbSd/dSij11bJB6l/jd7ao7sR++WvA9bUhKAMEYQ8toK7FeDG9/XXSO
	 YAEyuTfXJAwIlZ5qv0AzT0t7sfN3AxMGH+5jLOd3rEGcit7X/yxfgKcblJKSZsgoVn
	 8LkTDNG7TRHG9NAcADD2OFIqYDb8tG7qYhaJ5ESmUauIaoY+A56Pbm8Fq7fVNThpUm
	 rHp2FAPPrICffUx4oHpC2xFs2kqCZZSvpymylMfnWThOQp4NlDdVpcUd9MwsRb0ehd
	 jnmuuAmW0SllQ==
Date: Tue, 22 Sep 2026 10:36:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/14] xfs: fix xfs_rename_space_res for non-pptr
 filesystems
Message-ID: <20260922173633.GV2705364@frogsfrogsfrogs>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120679.181988.11124162026436295653.stgit@frogsfrogsfrogs>
 <arIQAfUjbdiWmx6P@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arIQAfUjbdiWmx6P@infradead.org>

On Mon, Sep 21, 2026 at 10:20:01PM -0700, Christoph Hellwig wrote:
> On Sun, Sep 20, 2026 at 11:16:32PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > We don't need to reserve space for a parent pointer update for an
> > existing target if parent pointers are disabled.  Fix this regression
> > (which LOLLM noticed) so that rename reservations go back to what they
> > were before parent pointers.
> > 
> > Cc: <stable@vger.kernel.org> # v6.10
> > Fixes: 5a8338c88284df ("xfs: Add parent pointers to rename")
> 
> This just relaxed a reservation.  I don't think this is a stable/7.3
> candidate and probably should not have a fixes tag that causes folks
> to backport it.

Yes it relaxes a reservation, but only for non-parent pointers
filesystems running on newer kernels.  IOWs, it reduces the reservation
back to what it was before parent pointers, so it actually has some
performance implications for old filesystems.

OTOH nobody's complained about the dip in performance so <shrug> I don't
really care that much either way.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
