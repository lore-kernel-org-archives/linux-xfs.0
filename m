Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAB81E876
	for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2024 16:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713458995; cv=none; b=qNkt2YbYroiaSxJwF3eEnGUvXG1PRHUUJcz7up0IAgelrLcnOCg8nC2ufgxY9n1E1DpTbrVjN3TdzBGZPgxandZ6E77ysO0FUc+i2rjwX7l0VXox0nLCvfAn0af4k8ADuaHNTVXGvbhUaIlLUycG6kGjsBWlQe1JW9LWcEEKvk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713458995; c=relaxed/simple;
	bh=9QCxBNiAGEAIxxpyHToHkzxQedudVlBstC8omEChuFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MRymIV+AgH/rLQKoaZ2Qk6K2k6Jh1BzO3u+meo/UJjv2q5QZ024LF4YAwnu4bFQBfOwvAUvx5fkqW4ABwGIJp6zlftRXztGMqW6476C8WufMKihDyFLGjcGCMGljrObFs6NqkDeShAviLBSk3q7Be6YnuGtUHTLvkGoIPyxsAsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PyPu/Bxn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PyPu/Bxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343B5C113CC;
	Thu, 18 Apr 2024 16:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713458995;
	bh=9QCxBNiAGEAIxxpyHToHkzxQedudVlBstC8omEChuFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PyPu/Bxn+bWXWve0DdFkjeL5wtMA+uO1GCoF9yAcAy2d5COqBuyaPwrfAkrX5Kf+i
	 lSWgr6TGXRi7bh81S59XfsjwAEU5cQH0fJAXOU9OzZd3rtZg5MkINuOKZePCFQS54n
	 zQhtm+blyKU1ReGkz1yLRhfriGxwX6c0zLA2ZsnuCM079KxEsjYNAIIhfXyyhCdhNk
	 s0xZXeOMMLNf74cuTWe3mYs9CuHQAw0Uij11C2tCAMNiQI2uTnS8h8oojjmbiawzju
	 579RXGRyVenTuJFkzSAt+jnbLT2JUp4lkoWYQQnYYZhixN7gR7afGlwsDppSRo+Thj
	 LCdIb/jJ5tBLA==
Date: Thu, 18 Apr 2024 09:49:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org, catherine.hoang@oracle.com
Subject: Re: [PATCH v13.2.1 26/31] xfs: add parent pointer ioctls
Message-ID: <20240418164954.GK11948@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
 <171323028211.251715.6240463208868345727.stgit@frogsfrogsfrogs>
 <20240417024955.GL11948@frogsfrogsfrogs>
 <20240417222503.GC11948@frogsfrogsfrogs>
 <ZiCfu8Et9Fnmoy8T@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZiCfu8Et9Fnmoy8T@infradead.org>

On Wed, Apr 17, 2024 at 09:21:15PM -0700, Christoph Hellwig wrote:
> On Wed, Apr 17, 2024 at 03:25:03PM -0700, Darrick J. Wong wrote:
> > > +	/* parent pointer ioctls */
> > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents_rec,	32);
> > 
> > It turns out that the i386 (or probably just 32-bit) build robots trip
> > over this statement, probably because of the implied padding after the
> > gpr_name[] flexarray.  I'll change this to:
> > 
> > 	XFS_CHECK_OFFSET(struct xfs_getparents_rec, gpr_name,	26);
> > 
> > and let's see what they say.  armhf checks out locally.
> 
> Please make the padding explicit and keep the
> XFS_CHECK_STRUCT_SIZE, otherwise the ioctl won't work for 32-bit
> i386 binaries on an x86_64 kernel.

Ok, now I have:

struct xfs_getparents_rec {
	struct xfs_handle	gpr_parent; /* Handle to parent */
	__u32			gpr_reclen; /* Length of entire record */
	__u32			gpr_reserved; /* zero */
	char			gpr_name[]; /* Null-terminated filename */
};

This is now a 32-byte structure, with gpr_name starting at byte 32.

--D
