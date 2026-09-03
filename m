Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3753121FF25
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788434443; cv=none; b=lW/T9ZHnIGwjJVUTX/gkbQtrrU0qVD5eMCTZpA1KWG8y4yAbE224BKIxGam2DbmBff5bGZSaeHmyEyHkrRyQkQ7gZmxlSaZ+FwtrGpweS135ZUtNcqKWrGLlRUB7x5uowsVbsf0HAPszJ+47FKalL99LHDbOB3eAOiPdvByFn1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788434443; c=relaxed/simple;
	bh=Pan9BR+zCYeumCDtf5vrUNOJ6RUYqo32qq3yVHXPEHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HeAbsQR/NZduVWbORv/q+Dd3zpwld6mQmnPhbRmsDTXOuO8Z7gXlVCUU40xOIbSxIppNs9uTreUdDbA6t2vDpYoOvFgjY71v6M56rqfP97TwdVz/Z9ylMv3/vyXk9zvFzoHJzPKCN9ieGxmJYogsYdKan3Gxk/qvgeJ4ZQfejBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CTXdy9jy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CTXdy9jy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD651F000E9;
	Thu,  3 Sep 2026 11:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788434441;
	bh=576DePrz7/YQEU6WyGKXax3pIsQYMfj/Rc7jd942DI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CTXdy9jy6T/gv6Shj7mFKLFF1i6LNig+5HPezFvmo5BrsfPb1SQTun4DKHj3wLQmG
	 To4krvRbtBwzeJ8NCdRYCUXRWJDq7vm1VpsWi1VHt7jlS94JAIzLanKD3Qf2K3XYHX
	 mIj5bSKzN0xmq8FYUIbzDLQCA5P/DXaJ+ExNUlau+CcLjyYYbzflQSBvYYhUAewuCd
	 k/pfwW6RM4nAJRgkZIl2BMnd1+kEc1EwyTUORjTnmEE4spJ5kT+iTXQJH4GAjZy4Wq
	 rs9SD8Qb4aVAdQvDG67NIfPIFeJz2jRsNSxAP0SVvK1KoSb5x0o1V3r1QTR0uk3KME
	 aBSvN+f2P5JBQ==
Date: Thu, 3 Sep 2026 13:20:39 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs_spaceman: print configuration file for mounted
 filesystems
Message-ID: <aplX9dftw7mYax2L@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178821870568.2381199.9038448943413709082.stgit@frogsfrogsfrogs>
 <178821870664.2381199.6011402424718513540.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178821870664.2381199.6011402424718513540.stgit@frogsfrogsfrogs>

On 2026-08-31 16:27:36, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Teach xfs_spaceman to emit a mkfs.xfs config file for a mounted
> filesystem.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  man/man8/xfs_spaceman.8 |    6 ++
>  spaceman/info.c         |  136 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 142 insertions(+)

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
