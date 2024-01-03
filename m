Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C9AEBD
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 01:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kCof8oRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872E3C433C7;
	Wed,  3 Jan 2024 01:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704244511;
	bh=MjteWalgthfXL4ZkKdMjs4VRr5XmzTnd5ZWqXI0PoCQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kCof8oRlVrHEY91ihepBpz7mqQV+INiJ511ij7RPmk15sH0Xqes83nnCC8GGOFk5w
	 cLUHJ4aTKoRge9Pjejrp6q7rpASAdxLyDUnmq+w6DgZA/u5XPBRJ+Uxrm4LTgg54Bt
	 LBpMn5RHa/NpEc49N8/xZAH4apev81IxKB7x1LD3k8NGAtSnunfVv+kKAn3Aiqmn6a
	 gZM0zHE0YBTemb5SRI6HnlKuD0rhTRlYGFoTkSMwzXUUNFoTvhGn/eHogCmklySAM6
	 TGelrwe3u6YZMqi0lsZWmcM5BWr1ygnKNGuX8zH9OnG1og2rP4qvFB51dKYLkpC7Fh
	 XggUFm9HEAwxA==
Date: Tue, 2 Jan 2024 17:15:11 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: encode the default bc_flags in the btree ops
 structure
Message-ID: <20240103011511.GB361584@frogsfrogsfrogs>
References: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
 <170404830543.1749286.11160204982000220762.stgit@frogsfrogsfrogs>
 <ZZPmflimTzsSzH76@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZPmflimTzsSzH76@infradead.org>

On Tue, Jan 02, 2024 at 02:33:34AM -0800, Christoph Hellwig wrote:
> On Sun, Dec 31, 2023 at 12:17:28PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Certain btree flags never change for the life of a btree cursor because
> > they describe the geometry of the btree itself.  Encode these in the
> > btree ops structure and reduce the amount of code required in each btree
> > type's init_cursor functions.
> 
> I like the idea, but why are the geom_flags mirrored into bc_flags
> instead of beeing kept entirely separate and accessed as
> cur->bc_ops->geom_flags which would be a lot easier to follow?

Oh!  That hadn't occurred to me.  Let me take a look at that.

--D
