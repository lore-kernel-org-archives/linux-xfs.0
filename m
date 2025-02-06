Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC8D22FF5D
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882230; cv=none; b=IuuqVmBNaleZ+UnFL+WpdDRwd+35f+VHU8bxbF8herKLHfXP1FaS+907ggnPcrXntl2ebZdp7+J+HtxLznVhA8jLJ5b+Io1QhtQgsSGzbhcqzTSuuRcOPYGh9SChiE2VqPJvjRzfghDsRIVbD5L9Wth96B2uMmGhgucgDET/jC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882230; c=relaxed/simple;
	bh=QjatB0FZ0W7pCw5FkOfYcrBK1xR/OvXhvyQneQ4dsvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r2NmBjK4Ur9j/vq/xRPnfpqV/0NsJ1+dT/LgZRFnWLTnR2ms2DSnAv71tI5LYQ/vUgWG8hiz7YG5JcHecDWg57MMrk58oG/H/PMoMLEBz0tlvsxJ6SXHoYaEuVsAD53F+sZ1stC/xdvZX8oEONsJwb5joadY40Rad+gSsM1GhDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QV8yFgPV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QV8yFgPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8AEC4CEDD;
	Thu,  6 Feb 2025 22:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882230;
	bh=QjatB0FZ0W7pCw5FkOfYcrBK1xR/OvXhvyQneQ4dsvQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QV8yFgPVf+zbFZMc1KyfpzBRkH7TFeJt+tumSVjb7fEkLFEJUTAwN94yELANTbGzG
	 oD2qDUdBrs31DGE/NzWRk7O8O0Ww11k09zKsUEbna+1impT4kvGe1sZJ3DGOyW5fQC
	 TbxgAbuKK/dJJ09J/DPBGgY8JU4Mz/yFJT8FlP/QR0wvGfrxcv2JYJggAG/Q4zqm3C
	 7zmr7et1KfAY4VrnDgbPKZuPjH4PtQaIJoleLrhy/MjLqbUyJe6yNStonAotKVgzrr
	 h3gUPfdKfl4Ec/H+zRNClbaXyWcADmE8ZZW9NFj2iRofQJaZUZVN4SHqWXjj8EeU8F
	 uQO/V5CJxXWoA==
Date: Thu, 6 Feb 2025 14:50:28 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: da.gomez@kernel.org, linux-xfs@vger.kernel.org,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>, gost.dev@samsung.com
Subject: Re: [PATCH] mkfs: use stx_blksize for dev block size by default
Message-ID: <Z6U8tAQ3AKMKIlWs@bombadil.infradead.org>
References: <20250206-min-io-default-blocksize-v1-1-2312e0bb8809@samsung.com>
 <20250206222716.GB21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206222716.GB21808@frogsfrogsfrogs>

On Thu, Feb 06, 2025 at 02:27:16PM -0800, Darrick J. Wong wrote:
> Now you've decreased the default blocksize to 512 on sda, and md0 gets
> an impossible 512k blocksize.  Also, disrupting the default 4k blocksize
> will introduce portability problems with distros that aren't yet
> shipping 6.12.

Our default should be 4k, and to address the later we should sanity
check and user an upper limit of what XFS supports, 64k.

Thoughts?

 Luis
