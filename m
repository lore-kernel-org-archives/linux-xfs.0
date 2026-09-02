Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C724A64D6;
	Wed,  2 Sep 2026 15:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788363436; cv=none; b=k/8EwOt7+1i5wj+pFUe3qULRl525WQLs3Q6aqI3GT1X8wgBnhfQnAB4jhEgRF7Gssx726dJBXhoTNmmN2pFYxJgspivPeuzIvDIVCNetAQWGTWXCKCHd0MauiqmFdQO00iFddgSaFKMF+TC4Y2A/hVQW83vvTLcmSeXLmjAUt5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788363436; c=relaxed/simple;
	bh=tg/biQZJ8A15u81Yho47yR0mdfrZmRAqNwXAAixKXJM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qPIiUSDrwK0gJK/yPBnrQIGBs+dbdoxHe5N5C8zohYUWnLtpK4/ogHCvWa/C7HeiomC+QpGOhFKqAqTXXx7vucsTo6qu1xrUn+k41IzF9eJ4mrpk5QXnIRcB22wkus4h0mt9lwkrlvWBnOJgflTzn77FlSpj+I7dIp6ciChI1+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vi9gnkcx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vi9gnkcx"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C79501F000E9;
	Wed,  2 Sep 2026 15:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788363423;
	bh=FEuaXBfKge6LQfMfQvhHogwpvoCPLY8EjPWntedn/RY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Vi9gnkcx0yrsrXPSgm/0yYLZcxND4HKypzJ5Cm92gQWimGelG9RPN8abOajNfVZtq
	 VLtI6pvuFTYbqmITqHy1tlH9f+JAxMNDZ5DhZG/aHqDdgOIsUnttA1PC3yckWUvmZG
	 K4UZGx+Lmr7TGI9Wm9wYYbrZuj4wrgxNP4dN222jmqXomOPHUao/0msrcLWJhVMvw9
	 CBYd36QuUCTcQzohPo4TW+IabNqd0nvj1AVY14RmKan9O7iX1TAyLVGNhtr8Xp/dhs
	 NoFmcyztV91gEFMxyt8EK3RebEcdrogn/ZX58CORwA93pm2QCQTEW6SyBN3Geyb9wk
	 7aEUvCxv/kLRw==
Date: Wed, 2 Sep 2026 08:37:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: compute dquot checksum after resetting dd_lsn
 in repair
Message-ID: <20260902153703.GN1933798@frogsfrogsfrogs>
References: <178832750681.3508131.6009513367948627110.stgit@frogsfrogsfrogs>
 <178832750773.3508131.8667220003399042973.stgit@frogsfrogsfrogs>
 <20260902072341.GC26173@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902072341.GC26173@lst.de>

On Wed, Sep 02, 2026 at 09:23:41AM +0200, Christoph Hellwig wrote:
> On Tue, Sep 01, 2026 at 10:49:16PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM complains that xrep_quota_block updates dd_lsn after calculating
> > the crc of the ondisk dquot.  That's clearly broken, so fix that.
> 
> Yeah:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Also why do we set the lsn to 0, shouldn't that contain a valid value
> (probably the current LSN, but I'd have to look deeper at what this
> does in detail)

Hmm.  When I wrote this dquot repair code I was mirroring what
xfs_qm_init_dquot_blk does (memsets the new dquot buffer to zeroes,
doesn't explicitly touch dd_lsn).

It probably ought to be set to the current LSN but we don't really have
a dquot log item for determining that, and assigning 0 here means that
any subsequent logged dquot item will always be recovered into the
ondisk dquot that xrep_quota_block writes.

--D
