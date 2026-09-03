Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532534457BD;
	Thu,  3 Sep 2026 11:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788434515; cv=none; b=B3THa2hEbtaUwdhq8/+qP67PK0QvzvIG94Z5XKBg+kqyN84O8t+KuRYTu46A35rSYaBB2Ue3WPEVjc4foJng9TMjsJ/nW8LRN62PRQOh8eFfxA6W5I101OohwmYD5eP5AVtGehIxD3TPdIq2lIXTkQaLuSyUWcjC6VLBU3nMPzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788434515; c=relaxed/simple;
	bh=18z8T6RNwfGpu4FdM+1Krdgr0LUvbHj1QlXEGHIv5YE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y30Y/GyjyrpSm8cxyh1PdyGDMXgU0hE7i2kJcaDNgww22Sc4GPsuLLsPmPclNA6L6oGzyS4g6fxyxplkP+tNAiV/zvG2wiLXbI2Xagc18s3S5a0vbr/bBmwqRBdQvQdMcAB9RHyOhC6C5eR6zfzbCthf1W4Hzs4s9Z5hX3Z0Kdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gf/euQXe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gf/euQXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01411F000E9;
	Thu,  3 Sep 2026 11:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788434513;
	bh=iNtvG+NceKc7rz8vd3pkivaiCUD3PHOrzWYe/Ie2B5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gf/euQXeS8DvLmz5kFHFQCblgP2HwVPrIbYaATW0mDZ0XPCGWfVGjWCdDwTwIVrXF
	 Gkkz3ruOTEfFRQBahFoPLaxJXRCuIzdAQWRBcO9/C50jsD312GET1t9MXm+C4zgPDF
	 fZQlw3wMPm1jle3HrlSqCtDOfIrnFQAzpaO+ofz6CXmCKGHdYdByoiMQ2RkPM1CBiU
	 O3baP4vaVzwNv3nSvX911mr15fPK5Njw48S+gGiq6PemK8mIs8L8oa8UH2BP7zxhEH
	 bo1Z9AfwPfWI0DAu7UDto9rf+o+stxNAWmYcTg2kYtAd6P9OHGcTy/N26tES2z7C9T
	 I0AD5KGTul7YQ==
Date: Thu, 3 Sep 2026 13:21:50 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests <fstests@vger.kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: test mkfs.xfs config file generation
Message-ID: <aplYLUHLGTq7CaYI@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178821870568.2381199.9038448943413709082.stgit@frogsfrogsfrogs>
 <20260831233430.GK1933798@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831233430.GK1933798@frogsfrogsfrogs>

On 2026-08-31 16:34:30, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Test configuration file generation via mkfs, xfs_db, and xfs_spaceman.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  tests/xfs/1909     |  123 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1909.out |    2 +
>  2 files changed, 125 insertions(+)
>  create mode 100755 tests/xfs/1909
>  create mode 100644 tests/xfs/1909.out

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
