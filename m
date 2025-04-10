Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BEB1C8639
	for <linux-xfs@vger.kernel.org>; Thu, 10 Apr 2025 16:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744302968; cv=none; b=ZD/9gN9Hn9NDpd5ZjWuKE3LDHov280EqWaeQAFV8Ws7lx7AKsz65TC1FgZcsV+63On6a710keVaALHtU713AXghqFFgelp2C90zK/eOPFSLVq8MRVwlWIpmgYE6/J0hh9x0Ir4llFRt3UxoRb36LnuZvxpgojSeE4LGX2WT0ckM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744302968; c=relaxed/simple;
	bh=/6PcrDhrxKVK+1PqHo9BwJ+ddy5MulUFMXzJufjxq1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=etWZhBz4koaUGLMDw0T9uWmtf8QUlvEbvNSsoAI987GV2vUEzNWFaYwcBB/Q/8YOvkU6rjBR00TVlrrsjsi02uPN/tS8xBaSGLAX8wn9IBjECdqcvY5g8kUKyil7VcBGlCGIMH8vXQYjL2C3HIdtBq9gUF+Z/PPmM2e5CF1b3ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V427Vqk3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V427Vqk3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7ADC4CEDD;
	Thu, 10 Apr 2025 16:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744302968;
	bh=/6PcrDhrxKVK+1PqHo9BwJ+ddy5MulUFMXzJufjxq1s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V427Vqk3iGu5XXuRrN9aocvrxOB+jQh09x55VIQllfxy3ctTdSRQv4fWv3nb84zcE
	 eL72eZIF9AxgVeGSX6Boz8iQWxeqcY7AGiRHGz5JSg7Ua04LnLzaPLpKuXd+z7wNHG
	 0yPBlAfiZ2noMJD3qGh/YoB72rZX8HK1U7CMwIuxCZbhWP+0dAULN07d5DPHqZKXOr
	 cq3JR+jfxx02S7AlIyP4QJMMJpjDUp2+nMbaXyWaysfQu86YMmZsyrvyWwOjibFyYo
	 tfXeMxb2aNrsjK5RaEA7G1oDOrUyrllEXF7GBUg8W3M6rEh/IP11R7ZFrZc/5SFQxA
	 jeM7Qzk6yD9tg==
Date: Thu, 10 Apr 2025 09:36:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/45] libfrog: report the zoned flag
Message-ID: <20250410163607.GY6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-27-hch@lst.de>
 <20250409155846.GZ6283@frogsfrogsfrogs>
 <20250410061424.GD30571@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410061424.GD30571@lst.de>

On Thu, Apr 10, 2025 at 08:14:24AM +0200, Christoph Hellwig wrote:
> On Wed, Apr 09, 2025 at 08:58:46AM -0700, Darrick J. Wong wrote:
> > On Wed, Apr 09, 2025 at 09:55:29AM +0200, Christoph Hellwig wrote:
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > I wonder why the other xfs_report_geom change (about the realtime device
> > name reporting) wasn't in this patch?
> 
> Good question.  I gave it a quick try and it seems to work out much
> better indeed and also solve the rtstart issue mentioned earlier.

<nod> I usually try to keep the FIXUP changes to the bare minimum that
makes compilation work again, and push everything else until after the
libxfs rebase part.  It sort of kept things sane.

--D
