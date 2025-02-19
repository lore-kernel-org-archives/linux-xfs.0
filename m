Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3661AF4EA;
	Wed, 19 Feb 2025 06:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739945105; cv=none; b=oqBm0Z1Qq5x/J14Sy3nPFUr3P+8wBRj/wwvn9UPXL7TOgyAHqA6NDHCxu+sGSKqfxjpuPeolvnOfEq8sam1KZxyRzq8/fz0s6Jc8CffZVNqdybWGUQLwlSbpcHC5eQVjw3G8fRX+L7d68wAMXPqxc2SzgJss4WDuhU4stAZMHoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739945105; c=relaxed/simple;
	bh=uHd0tlFTsL70YdbcGTz0zOVND+0wuu571hlWi4/eytQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GJa9LRA9GJsBgxBtS7jis38Dp7s6iwUVGtVJnXZ+lX0ZHSwezqJ1f0t2sA5X6Fnyx8gMc6Q2hajv8gT2Yf95UcyDKLO4y1B7cj4Lx3PmnBLZxeabCb5HmF43OmQNMS8X5SMeFt0Qw0ThkOE7rDvPvPyTBTljxPhbk04NvJbzigM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lqAucObc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lqAucObc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDEAC4CED1;
	Wed, 19 Feb 2025 06:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739945105;
	bh=uHd0tlFTsL70YdbcGTz0zOVND+0wuu571hlWi4/eytQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lqAucObcUGRUvts7ZyxKOIRx5McEUVjCg5P6YHDlXXNEa6j6wlGsnTGgLAGqNywiy
	 qQDcMR+dE95QcH9LBf1WMJBmeJOPeJArNQAFiDSIdVtSmVPxBWh+ugnZSkkRXpB9Mp
	 VEWe4h36iw97vY3mf4Chq2qgAR/77ZFbwwktFNujFIR4iqTY9n/876fLu1m6Gfe31q
	 AqwDC0m65wwzmJa3reWfXX3eE7sOhYhSUI+vK/uSny3cAwQd0Ihgv/5icilNONsLQM
	 Y0oNjVD/ctYBdKep9eG8y+Hng8VhlvugwXDrJQGDbNdnvvGHhHyWdwh0evUBwoix0m
	 a2hQ8JxMmjv5w==
Date: Tue, 18 Feb 2025 22:05:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 11/12] xfs/28[56],xfs/56[56]: add to the auto group
Message-ID: <20250219060504.GW3028674@frogsfrogsfrogs>
References: <173992587345.4078254.10329522794097667782.stgit@frogsfrogsfrogs>
 <173992587607.4078254.10572528213509901449.stgit@frogsfrogsfrogs>
 <Z7VzmdxUtQcNcgzS@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7VzmdxUtQcNcgzS@infradead.org>

On Tue, Feb 18, 2025 at 10:00:57PM -0800, Christoph Hellwig wrote:
> On Tue, Feb 18, 2025 at 04:53:11PM -0800, Darrick J. Wong wrote:
> > fsstress tests and two fsx tests to the auto group.  At this time I
> > don't have any plans to do the same for the other scrub stress tests.
> 
> Can you explain why only these four?

The rest of the stress tests pick /one/ metadata type and race
scrub/repair of it against fsstress by invoking xfs_io repeatedly.
xfs/28[56] runs the whole xfs_scrub program repeatedly so we get to
exercise all of them in a single test.

(The more specific ones make it a lot easier to debug problems.)

--D
