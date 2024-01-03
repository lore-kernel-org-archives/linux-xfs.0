Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E8AEC5
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 01:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gPH67/QA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEE1C433C7;
	Wed,  3 Jan 2024 01:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704244183;
	bh=9b2AqZGwuteq+DO4YxmFbMqEU5TeJFtYtL0ttK5l6J0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gPH67/QACvIdKvMff3Evc1uvNW/33PaYVYVcYZd5qL4OL7WJX4Jb1p3nvvSqJUTaa
	 zZa+JMw/BlVq8lF1QPMl999UgsU96UsSKUFa36KUOOSbvv/1MsMuphpD6G2kiNwoxx
	 aU98Aj7OE5f58jembThCdx0uiTztzQf/eozqw8H/vft/AKFRWa6JsIXz8NwYSDL6+b
	 QKjic2FRIaVdsLHB5Yq154okrTRZRSJAR0ppIol7IL4IVprlBVioKr28cWGXadSRHX
	 xoctq+u6/ebArZYNVFzHJ2y8GHqO6Xjcmsin/mu4/CMOkoltj/phFraC3a/y1oHOjn
	 Qhm6uvQA4/1gA==
Date: Tue, 2 Jan 2024 17:09:42 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: iscan batching should handle unallocated inodes
 too
Message-ID: <20240103010942.GA361584@frogsfrogsfrogs>
References: <170404826492.1747630.1053076578437373265.stgit@frogsfrogsfrogs>
 <170404826619.1747630.14010547497155037331.stgit@frogsfrogsfrogs>
 <ZZP2KC/dDD6TeFxo@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZP2KC/dDD6TeFxo@infradead.org>

On Tue, Jan 02, 2024 at 03:40:24AM -0800, Christoph Hellwig wrote:
> Any reason to not just fold this into the previous patch?

It's a performance optimization over the code provided in the previous
patch, so I kept it separate both for bisectability and to preserve the
incremental improvements that I've added to online fsck over the years.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D

