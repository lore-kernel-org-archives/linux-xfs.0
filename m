Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D291E44C64B
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788434232; cv=none; b=nIzI50c+Xfi5rXcpLXDJA830d2GWU0TBXv+QO1KyW2z1GUjSimIeoMhTmROQK5VBpqz9XqfoDk5MH/buaomzo6nPWJhM3NlfRGd893lvu/Tqa+uqH3xUtuGDxcPEWkhoEG3DZypE1KC3FDGC8tH8uL2ddwYlYLNDfY3C5fqhpk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788434232; c=relaxed/simple;
	bh=1CFfxwmIRXKRm4yjIUOGUdiM74bYZJmLfsVV1k+sMM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m7VdeSl0+pISus2rlN3n67w+7cnuYCYKETgqj4+Fwh6IbWJEhbEXykQzTary7G+OTNJRBxGrF3RNZG47OAtRlbgGKLbzRcTlSZRd2TZgTjsP/0Pf31LRyS3y9k+f3KTrnxR0llfi481tRU03DAyfRd+/D/ty0sB1jfyB+8LNO5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OvnNhkA2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OvnNhkA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25CA41F000E9;
	Thu,  3 Sep 2026 11:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788434226;
	bh=3cNZnJ+rqfZpgjUVXa3WeWqbgFmptTa1/8KAAR07v7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OvnNhkA2OhIzgKIgPL+8m7joYT6rknmDFINzq9wqENI9XHG+fbh/AZ/QCNoWrqJkT
	 vhVuVK/L97NVKI8S5rkRa6Ee4xf0B+5CbKfRy/v2q5UVeGwjTOONXeN56AcyhW9UZ6
	 0FkQjpj5xCv+R5Pd2rcGFkSXjxY40Uu4J3IxXcbXyqCno7dBDMsNUS6buuxn8xQWbq
	 zY9Mpu8dDfNdEPCQK+wOKViHnkK/z2CzqHT/Y5tr6hIBCiCE+tgv2mYFh1ed26MnDJ
	 6jg0EYqauQBJzrwh4qAJbcsfGKBKZ0K5rDoTPbWCG18m850rjPwQPvXn6dj/Y8RKSv
	 S8BlgvyXGGItQ==
Date: Thu, 3 Sep 2026 13:17:04 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] mkfs: automatically upgrade autofsck earlier
Message-ID: <aplXExkMu48rVTdb@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178821870568.2381199.9038448943413709082.stgit@frogsfrogsfrogs>
 <178821870608.2381199.14359672932086572200.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178821870608.2381199.14359672932086572200.stgit@frogsfrogsfrogs>

On 2026-08-31 16:26:49, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Move this chunk of code earlier in mkfs.xfs because a subsequent patch
> will need the final value of cli.autofsck at the point where we do the
> dry run reporting stuff.  Nobody changes cli.autofsck after
> validate_sb_features().
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  mkfs/xfs_mkfs.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
