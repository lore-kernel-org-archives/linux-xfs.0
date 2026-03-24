Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7746C407100
	for <linux-xfs@vger.kernel.org>; Tue, 24 Mar 2026 17:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774372514; cv=none; b=dX4Kt+HRb572vyhiq+RwWoJSbqjkOUOIbyi8mk2eX7/lKqJfUpEGHvvaZn2sq1IAI/xiszUSFAnINumGRzLrkZuxilk4JOvOr2qBhHm0AarKK4VfKSxmFoI1nZWBga0qUQo6s7xSpYFRxLw/HOKWqHmkWb55Ja66KgYqSZYQqrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774372514; c=relaxed/simple;
	bh=Bee7ELSW+8Ka2JJv4DOWB536cqm7x972M6vqivJh9ss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RpZQjv4JVxUa2VCHFfsD6IWNiqMqRI98jstXqvcwFcTw1O/1/JtdpxMGt5UrU/tJ/piCnKiTW9eGXqfSzRI/o6xeKNqDA/KpMzyn0Z+LuYYTtQ+VkX3zeTwVolXOCgtZ7qECIifMstSBON18vjaHf6vqwqLYgtAiICb5luqcA9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M1TnjAPq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M1TnjAPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51817C2BC87;
	Tue, 24 Mar 2026 17:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774372514;
	bh=Bee7ELSW+8Ka2JJv4DOWB536cqm7x972M6vqivJh9ss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M1TnjAPqkHT1TzzbIQgpYVh0g297HBZpWGn7S7MipphR1MeXqNoOPalunNlhjsSmn
	 nEh1pgvueCZkldwxMV/VJWKufiORmzk/hN8LO+WPBXZVzhzaKOrmvyLtRWEEbvTQhF
	 AtgkwOSBgGXnkCYTX5zC3y49ltIeIiS/c1IsnK9KXBSRFSA5UgZuovY5x+BJPG5Idc
	 4HUM+rtwR0eDZ9xN6rbV0woK95su9/W4TKeoPEqAEOmUDvZxIygDmU16UcbOINDs/2
	 BVwF7cm9oULNtD/1q6gdsJm7fbJ5sCg8IYRkCfP1V6f2/PCbtvYlx4OTgYqEEiwG/l
	 +6S+LGzbuGu2g==
Date: Tue, 24 Mar 2026 10:15:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, Long Li <leo.lilong@huawei.com>,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/3] xfs: don't expose stale pointers to callers of
 xlog_recover_iget
Message-ID: <20260324171513.GQ6223@frogsfrogsfrogs>
References: <20260323210157.GM6223@frogsfrogsfrogs>
 <20260323210351.GN6223@frogsfrogsfrogs>
 <acIsjx8FMnv1tDVY@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acIsjx8FMnv1tDVY@infradead.org>

On Mon, Mar 23, 2026 at 11:17:51PM -0700, Christoph Hellwig wrote:
> On Mon, Mar 23, 2026 at 02:03:51PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Fix this function to avoid exposing a stale pointer to the caller when
> > returning an error code after dqattach fails.
> 
> I still think this is silly.  
> 
> > Cc: <stable@vger.kernel.org> # v5.15
> > Fixes: 4bc619833f738f ("xfs: refactor xfs_iget calls from log intent recovery")
> 
> .. and certainly does not actually fix anything.

<nod> I'll let cem decide if he wants to trade more stack usage for
removing theoretical bugs via this patch, then.

--D
