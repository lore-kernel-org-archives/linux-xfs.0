Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794491778;
	b=aldYZvzajb8TmrTfX70sT2biilfkkJ9odpv16k8nQq3p62oaWixeW25k5oyT9htRYSZN
	 VqDD0elZBOfD/q3ZEfz9TVtmoJOvE1uZlyqhzAtPQX5ziuadC7EYvWOFKhMd6iy421y+2
	 YNv9oLMQlUcHVlbUS81C5w+b0Vs4u2cmgPz1AeeGgP3Yugbxc1qF+kFefg94bsLsxNKWM
	 a4QuooxtHvmaZSAq1Z/d/VYQYgldd4Kc0QB3qZ1nlj2RVOIkYmxreP8JM3kP/XgrnFvU0
	 JQinB+LTherS1n3EgPwR2Hlf1ISvwAr8vjyHdtPUapZnD3vSejl+SgGteR0v5647jcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794491778;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=AQt28fZp5HVlFC1EZNgwC9xQF0hTf4n3n0q7pzZ1d0WgUMSZDivmRmBlaApLEYtwBfof
	 DwsUenFEAhGcjHiG+K0cnQUOUgTwuVpgIS4GIp0kHVttvWf4HMHMAt30GKPlRXwSMnQZk
	 uZa4Jip+MsWOmospSL3VK7s+SVEybvHqjqTtwCiR/VoaeWYdG+D+mRoA+oOIHtIVYaZbv
	 BNSb8GCmxwo8vv/xRLz/pOezziT0l4KsBPCyEocWF8VFd6n77BxBKfNrOlhhZ9uVXc2Pq
	 z4A7CCXfKHSact30nr4N+lTMyvM4Mf1BikUjlk5r+kKt7uBpP9tCWnBCjJG83NAmO0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880B4606A31C;
	Thu, 12 Nov 2026 13:56:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 880B4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 531A368D05; Thu, 12 Nov 2026 14:56:14 +0100 (CET)
Date: Thu, 12 Nov 2026 14:56:13 +0100
From: Christoph Hellwig <hch@lst.de>
To: daejun7.park@samsung.com
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
	Dave Chinner <dgc@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/438: fail metadata writes with the buf_ioerror
 error tag
Message-ID: <20261112135613.GB24290@lst.de>
References: <20261112-xfs-438-dquot-retry-v1-0-73149b823246@samsung.com> <20261112-xfs-438-dquot-retry-v1-2-73149b823246@samsung.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112-xfs-438-dquot-retry-v1-2-73149b823246@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

