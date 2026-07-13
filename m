Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63CB36AB54;
	Mon, 13 Jul 2026 21:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783979939; cv=none; b=BpWhsiW2YBUxg1uur0D5FdkxnwPpL1SzFl1cZdxhm8aNTGvKeOcIJf7ew5F5TgL725b1VNu8VWYAiFKVA3Y4dFM++O41/s5ZhokUbUEwJH+l4+EOvtGQD0UM3ZSPuIGk6gTAO9JW7982TnMN92ybvIoXOXrQH8p7l0xmm/g30UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783979939; c=relaxed/simple;
	bh=vqw8TTldIFZyic3po9piSYT70VQlOcmnbhxs7lZgcxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U8zqOUD+uPdXTJFbsSHIU6pqqkLP5TuJYoTT/wVnS5ThK1+mZPzRryMSDKjl2nQm/9fAubN0yoCHTsBmJfqiWuNnEYOHEe2YCwtZEx9CcokIK0ZD9rBze0FuC2v465pzljnYFISWo73tJ7dGCiTXZRSu5vvb64fLXDblCOqZgtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iq2to0T8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iq2to0T8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4DCED1F00A3A;
	Mon, 13 Jul 2026 21:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783979938;
	bh=bsyqfOt7m8P6xewAHoeNVvka0UN3Tx8Vv0ojaHslYkE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Iq2to0T8nSENu+Vy/qW4SwD/t7DqbtEseqmw+1u2ugb9xQcYKDXe8QoV8mUCNXPHr
	 qkAH67ctcXq2xdMuk8WD1mmNfdmXdw8TVHWVVb5gMPuxCCyAlLw0RY+RToNV5+1sOF
	 VJcY8aCNMjeHDmE+79jZYM8k2azs3OAfTs+4tBeLYVb20Xh0/+VSJNoWJhFWO48D3L
	 EZpKM7u+qVhEfWoSr3rjX3mWUyO4rlb/d/LJAvgmZv8dGfFf9saZTfIR8NiQHE73A1
	 gWB+2hFPtslixpaOGqloYd021Ak7qBLmEp05PUzw1APwRqAVzIlynkUof/04kYrlW0
	 5+5s2Ak6q8UyA==
Date: Mon, 13 Jul 2026 14:58:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: write the rg superblock when fixing it
Message-ID: <20260713215857.GG7195@frogsfrogsfrogs>
References: <178346726054.1271589.14164163317011378817.stgit@frogsfrogsfrogs>
 <178346726193.1271589.8429966417697809477.stgit@frogsfrogsfrogs>
 <20260713064105.GA29416@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713064105.GA29416@lst.de>

On Mon, Jul 13, 2026 at 08:41:05AM +0200, Christoph Hellwig wrote:
> On Tue, Jul 07, 2026 at 10:04:26PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The rtgroup superblock fixer should write the rtgroup superblock.
> > LOLLM noticed this, oops. :/
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Can we get a testcase to verify this?

Hrmm.  Right now both superblock scrubbers don't do much for group 0,
because both buffers are pinned to the xfs_mount, so they assume that
there's no need to check anything.  However, the ondisk super could have
gotten corrupted (or blown away by fdisk), in which case an immediate
crash could render the filesystem unmountable.

So, I could (a) teach the super scrubbers to read the primary / rt
super; and (b) teach them both to log the superblock and bwrite it
immediately to shorten the window in which this could happen.

What do you think?

Also, this patch should be calling xfs_log_sb *after* xfs_trans_getsb,
so I'll fix that for the repost.

--D
