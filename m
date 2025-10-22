Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40991E5B68;
	Wed, 22 Oct 2025 04:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761107340; cv=none; b=cbq9spTjMwRjbCDAL1iIpYuncCVzA7d2TvphP9g2FQv382rQ7YkRumIh9Hx0bpL8igIodmxrU5b4j5C60V1jYyGZxx0ytJneUbVwIPIPApUw2ZHkmOPfFdaRvo2IW4QeCqITklMW2kptJOZFveHuOVij/klME8dgvGFHvmBorj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761107340; c=relaxed/simple;
	bh=cw20ikKdXwmFw8RfpjPp+SeOWPkF2gJOHgkDT89ikyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TY2B8TXGAva0qaB0sXwZ8/jqFGyDfc1bksS95zoC4anlUSOVWJ8a6ydVIeX1I0zuP0bOBoI50d243d58j+k8F68oxLxZyhDKE9J3CjjnLWhDOddcAwBzedasBPhIGeW+YRPQmFDbajb4iXiynNi4DL7vV5ckwSyuJcq0FMs+OOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HWZWx2HF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HWZWx2HF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE6FC4CEE7;
	Wed, 22 Oct 2025 04:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761107339;
	bh=cw20ikKdXwmFw8RfpjPp+SeOWPkF2gJOHgkDT89ikyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HWZWx2HF27CjWoVZFCvz6XHYDdGaNyw4igbixFE+8yt3Rqkh/Q/Tg0hqCydU+3iFE
	 VMdt4wWkhCkYcQs+2btoZl3WhQFyCwjkwZ0VtxSzFz93R0CeEnlk0ZFL0KHhrS4/G6
	 o8k5XEJ6XqJ+7Fdk8Cbb/jh2ClI+mQ7n57yqkgaCCm4cX7utUU1fxn1vxzsQp6dwNE
	 QgtteVNbPWZ8HORKFcy4VzizSK0hEcZV1ynkx048Ujs8NIEFE8nxKEbjTlBZwwwA7I
	 y9JprkgI0fQ9wLkMiB2DbnSlztGfeM/G+i+8HISIIl9rodqeTRj4goovz99vkX0M8c
	 u9NMk4ADGb0zg==
Date: Tue, 21 Oct 2025 21:28:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] check: collect core dumps from systemd-coredump
Message-ID: <20251022042858.GL3356773@frogsfrogsfrogs>
References: <176107189031.4164152.8523735303635067534.stgit@frogsfrogsfrogs>
 <176107189073.4164152.3187672168604514761.stgit@frogsfrogsfrogs>
 <aPhcblEhs-8YXWkB@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPhcblEhs-8YXWkB@infradead.org>

On Tue, Oct 21, 2025 at 09:24:14PM -0700, Christoph Hellwig wrote:
> On Tue, Oct 21, 2025 at 11:42:35AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > On modern RHEL (>=8) and Debian KDE systems, systemd-coredump can be
> 
> Only KDE?  Most of my test systems don't have any graphic
> environment set up.

Non-KDE Debian doesn't bother installing systemd-coredump.  My actual
test systems have non-graphical Debian, but then I stood up one OL10
system for giggles and <kaboom> coredumps broke. :P

> Anyway, the changes looks fine:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
