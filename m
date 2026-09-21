Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5DD3769E9
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 22:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030738; cv=none; b=oTw8uoIDCdlN2ZOCW+x+lDna1QKwYk0InuoXEGZXJkDBetlxgz6COp+LIbQAaQxn5h/qaTR2r2CMcqunIky2YCLMWcRA6K3wNClHAtXnjbDDYQuudLEMyYZZ1zNlqXdydj7/PiJENfMaW4JvJ7IS60gt/ufhsZp7jv9J+c6K8fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030738; c=relaxed/simple;
	bh=L/SdbmNIi/ck4lI4svyFyDkIrVgWRZnsv7US0yKhjvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QEtfsDCJ06JprDI+hEC5Pi1Ms5le9UG5SoCy6Sbwu+ocNc9Lud2/Qgzw4OclM/+YBfMtaBJfOeSW6tGDp+UMLL3XzL79jRuGqEttyyk38AlXFYg7Yhpc15wXQuZprmCzJP/jgggXYkFo4zjcBYkb/3m5pXdbIoSqj068Zx+DKmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nfy2Dd9x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nfy2Dd9x"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3C1401F000FF;
	Mon, 21 Sep 2026 22:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790030737;
	bh=8j1Xmt/g0ZWXSNLfM+ZCFfkcSS/F0qPb/Risu0r1b2U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Nfy2Dd9xMUpqqeDuu2G2KUWVRjOGxDGq/s9t97aVYAO61+6c3GCSsqAdcG5ZjBgCO
	 A5rMrB/2eYPz4soBq4KP6Dk1QEtdZs1FqDjHXJ1y6ENcVrQ7aN+ygNo97U8kGoD/0P
	 1p28STVS4GSDmhadqh5wt1zuDtLhX417FOKn/ehua+qJyUEua11aGrYzUt8D0lnpz4
	 AGL+2NYeLX/+8AIDtU6wLkrHP/tSW8K2/mMhiF7KaHfcGGoTgK9CVgrp5RZVHglSET
	 T7B7I33KYGDpgwyfg/eTEAtbllBv9yWy7VxmkdYqXlT1pWD6G7w4MzKWFxu4ID18v0
	 CZsj5/uIA7R5A==
Date: Mon, 21 Sep 2026 15:45:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mkfs: add config file for the 2026 LTS kernel
Message-ID: <20260921224536.GQ6283@frogsfrogsfrogs>
References: <178996057889.169776.13298686198868661581.stgit@frogsfrogsfrogs>
 <178996057914.169776.676694849229728136.stgit@frogsfrogsfrogs>
 <arDrUJPMZW7hXC8N@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arDrUJPMZW7hXC8N@infradead.org>

On Mon, Sep 21, 2026 at 01:31:12AM -0700, Christoph Hellwig wrote:
> On Sun, Sep 20, 2026 at 11:14:43PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add a config file for 7.3 since it'll be the LTS.
> 
> I wonder if they are going to move it given that 7.4 should land
> just after new years?  So maybe wait a bit with this, even if it
> does look fine.

I dunno.  From dhansen's PHB predictor:

the v7.3 kernel predictions: merge window closes on Sunday, 2026-08-30 and release on Sunday, 2026-10-25
the v7.4 kernel predictions: merge window closes on Sunday, 2026-11-08 and release on Sunday, 2027-01-03

Either someone should ask gregkh, or we should send a flood of bugfixes
to slow down 7.3. ;)

--D
