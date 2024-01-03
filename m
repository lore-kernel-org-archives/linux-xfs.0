Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CB87E
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 00:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FqEB2vcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A81FC433C7;
	Wed,  3 Jan 2024 00:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704240377;
	bh=lAWPx9hsW37NZeqfqylZPFGXVPNjysG5TVDou/YTbWk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FqEB2vcAUbeFeYk7qILvY2ZJr6eWuP7EretPyzWz3aAXHqk5roOoAPy9O+82xba7V
	 AwrxSKsDlsEnRSbZfX52dnYVMn74h9AduPEBsqGYyJ9/6Vv53TlBZA6/pTwCowZ6ZJ
	 eETI/bG95mFOGoauoSQoZ2NyQthHYrwGaKyeye84B8SXPGVk9cph7WicvFZ7/nuwdx
	 WJP2fNq0LBl93HlfG01M+ZIsW0RxEAXDlbvnVaeisDhux9tNJzziaYd/o29qYY/tGl
	 27KvMun5j/T9xrfnF0AVLCmvgOd/uG+c53pfma8APr4HqJ+6icVSrbFqcQRwiKfTn3
	 zAXJPsBJz7R6g==
Date: Tue, 2 Jan 2024 16:06:17 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: create a macro for decoding ftypes in
 tracepoints
Message-ID: <20240103000617.GY361584@frogsfrogsfrogs>
References: <170404826964.1747851.15684326001874060927.stgit@frogsfrogsfrogs>
 <170404827020.1747851.3610479881365181597.stgit@frogsfrogsfrogs>
 <ZZPv2kzw5mr38RE1@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZPv2kzw5mr38RE1@infradead.org>

On Tue, Jan 02, 2024 at 03:13:30AM -0800, Christoph Hellwig wrote:
> On Sun, Dec 31, 2023 at 12:07:03PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create the XFS_DIR3_FTYPE_STR macro so that we can report ftype as
> > strings instead of numbers in tracepoints.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But why not fold this into the patch actually using the macro?

That patch has slowly been jumping ahead of other patches in djwong-dev
as I've wanted it for symbolic decoding of ftypes.  After a couple times
of carefully cutting out that hunk of the patch to paste it into another
earlier patch I decided it would be much easier to do:

$ stg export -d foopatches/
$ vi foopatches/series

Change:

	xfs-patch-001
	xfs-patch-002
	...
	xfs-patch-300
	xfs-dir2-create-ftype-strings-for-ftrace
	xfs-patch-301

Into:

	xfs-patch-001
	xfs-dir2-create-ftype-strings-for-ftrace
	xfs-patch-002
	...
	xfs-patch-300
	xfs-patch-301
:wq

$ stg float -s foopatches/series
$ <patch stack reordered with minimal work on my part>

--D
