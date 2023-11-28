Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B883110B
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 01:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sPoMkZ3g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE0AC433C8;
	Tue, 28 Nov 2023 01:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701133746;
	bh=e5CYIE4MW5qnQp6hQKE98goG09XqjHr0kyQYW4mcJi0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sPoMkZ3gdDaC4b97F0uKUI2iIJaLP6FlnAE6CXm1nrRXPfgzFXWGyXH5J9gAAZxAv
	 9ET88+noU9ongRIXFPYzH5XvVWdXUe7tGirtSKX8bruAIZg0IrzKhZEH6B+G0Gqwed
	 DbSolOUFrWw6XmwbCbOZmOitAjbxaHg8/NrZzVxkTB8aezaNsQMMBJQJib1F6BlArz
	 8Y3mXo5op5fTXVQyySfo1IYsxhd6ZFQOlUx7rs+UMHLCN7HI49PgxYzr58P8QxPLTD
	 NuDxGDDW2j7DUeLEbjTstyJzKF3ZxM5YEuvc2nfzqzRcwYL6viigMOLuun9UgFkJGS
	 PP4yl254eVwtA==
Date: Mon, 27 Nov 2023 17:09:06 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: repair inode btrees
Message-ID: <20231128010906.GK2766956@frogsfrogsfrogs>
References: <170086926983.2770967.13303859275299344660.stgit@frogsfrogsfrogs>
 <170086927060.2770967.9879944169477785031.stgit@frogsfrogsfrogs>
 <ZWGQXZckfk6KvocG@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWGQXZckfk6KvocG@infradead.org>

On Fri, Nov 24, 2023 at 10:12:45PM -0800, Christoph Hellwig wrote:
> > +/* Simple checks for inode records. */
> > +xfs_failaddr_t
> > +xfs_inobt_check_irec(
> > +	struct xfs_btree_cur			*cur,
> > +	const struct xfs_inobt_rec_incore	*irec)
> > +{
> > +	return xfs_inobt_check_perag_irec(cur->bc_ag.pag, irec);
> > +}
> 
> Same comment about just dropping the wrapper.  Otherwise I'll
> need more digestion time for the new code.

Done.

--D
