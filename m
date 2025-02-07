Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D011A255C
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 19:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738955776; cv=none; b=HYRSyM+DwrbrePH4Iw1ITw9d8UUBwCvrLp6meeNK9yU+2XCWjfVK21YT0j8yT1uIfXgTlU3u+tYzgH5loOmF9PWJGQ4mLST76F/pOVMEWTUWStm5XgV6bHIqTxiy2agA5kH3JvcwKc69Lb3IAQ7ynqbb0tG/ikDstojwR6sU4sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738955776; c=relaxed/simple;
	bh=9QbqWKBjJd5u4EGScTarJQhqGIRf9PcBj4juvJ2ObNs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lNoPrRbSl2HAnYDD4eINoTYifhL8N5+epQLHv62gC3/Lw91TF4u42+98g7dExz7jAEdNEQMC00tR8JlhFnRC059gncMAeANyj3spHsIZqyiH3a2buq9fbiEbXWMKGuDEAMNiVz+83KSfvetPICdOYex2YJ+UyqYPACj/MibNL7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G36YVSVa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G36YVSVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4829AC4CED1;
	Fri,  7 Feb 2025 19:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738955775;
	bh=9QbqWKBjJd5u4EGScTarJQhqGIRf9PcBj4juvJ2ObNs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G36YVSVaY/fK33OjyUT5WxO2cy66ly8wqscgvZDh7tw+WftoEWHhus68zRb1HChcU
	 SQqipWZDmfySQC1AYeFwEuKPWoWteJIGNi5VQk9TjxIdAsUdKOgMGiAOBTV2XAmi78
	 7iOTNvw/mW8QyOKtih9BLrPqu4ofqiVHNpfCF7irdfp2ijBr9/nsI1Ma7nPBt7OHkE
	 /WceO2QHvmEb5yQtYYMIavcswsO2ZEUZGJjTj51jEC5mfQyNud0/rUmaUVGyGDQyLN
	 vo2V54BZJjkz8J+dNkd3wSzcilwX9Yyy6qzBL79Sd3tRzlxOzA/4NJ4Gr/z/Sql5XU
	 GQQ9DT6BjzG4Q==
Date: Fri, 7 Feb 2025 11:16:13 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Daniel Gomez <da.gomez@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>, gost.dev@samsung.com
Subject: Re: [PATCH] mkfs: use stx_blksize for dev block size by default
Message-ID: <Z6Zb_WiK_vwHzdny@bombadil.infradead.org>
References: <20250206-min-io-default-blocksize-v1-1-2312e0bb8809@samsung.com>
 <20250206222716.GB21808@frogsfrogsfrogs>
 <Z6U8tAQ3AKMKIlWs@bombadil.infradead.org>
 <xqv4zn3atz47a4iowk75tf6sjslyo2pqgj4qpcb6vsmvezwcaz@fade7dldiul4>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <xqv4zn3atz47a4iowk75tf6sjslyo2pqgj4qpcb6vsmvezwcaz@fade7dldiul4>

On Fri, Feb 07, 2025 at 10:12:07AM +0100, Daniel Gomez wrote:
> On Thu, Feb 06, 2025 at 02:50:28PM +0100, Luis Chamberlain wrote:
> > On Thu, Feb 06, 2025 at 02:27:16PM -0800, Darrick J. Wong wrote:
> > > Now you've decreased the default blocksize to 512 on sda, and md0 gets
> > > an impossible 512k blocksize.  Also, disrupting the default 4k blocksize
> > > will introduce portability problems with distros that aren't yet
> > > shipping 6.12.
> > 
> > Our default should be 4k, and to address the later we should sanity
> > check and user an upper limit of what XFS supports, 64k.
> 
> To clarify, the patch addresses the cases described above. It sets mkfs.xfs's
> default block size to the device’s reported minimum I/O size (via stx_blksize),
> clamping the value between 4k and 64k: if the reported size is less than 4k, 4k
> is used, and if it exceeds 64k (XFS_MAX_BLOCKSIZE), 64k is applied.

Ah, neat.

Then the only other concern expresed by Darrick is using this for
distros not yet shipping v6.12. Let me address that next in reply
to another part of this thread.

  Luis
