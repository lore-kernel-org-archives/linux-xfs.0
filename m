Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9513255F2C
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 08:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768205411; cv=none; b=JQVf4kunDwNSwl/HW1JgVyYl2r8BLv0m1MZ1GdPqAseQQLwzIkZMosQ+mj60xDwQqCHHB4OkPGID/tSP1TialqOlVcUuVN0V1WjliyuECAtOTiLgFijKf3+wwxBWub0dOZjR+0KboGVf2f65OuSqFVq/oGzm5vyzHq7cJ0+hKNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768205411; c=relaxed/simple;
	bh=QXvBh1ak3N6/Es/UyLYAq3wGpb6Efa/7X1duj97jGy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mzqN/mfXQY2KoEm12MW+Qn7I4GMc1ddrmRCmXZqQ9Dg+OwTzmOG+8GuZmKcUn9FXKaYiwfjjrv2ICUbjvslLNX5E/fpX0Y5Uq1ZBzexdA/6Xas6pWmJYyaCNbfAc1PWQxIqPTxUadL7rNBrMLB0TtQx0uP+INrFMo8fUl60ntZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Te4rDbEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Te4rDbEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDB4C116D0;
	Mon, 12 Jan 2026 08:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768205411;
	bh=QXvBh1ak3N6/Es/UyLYAq3wGpb6Efa/7X1duj97jGy4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Te4rDbEE07+r9SVp+0XInTYSPPEPf+JRnq9OzTmY4ZjE47P0E5gkA4fAG8Jhc/xDo
	 oXfy7Pzd3WSIvhOMW+SQnGPycQ4AyrIzO826lSFFqftiVnz7SzoJO8YlkEV4tjEsnI
	 D/RQMrNKr29n4w01k+QVTZ+yGtK9pVmmQ69NljW7ZMnB0uxAh+y2clqP0/lgH7iNl9
	 oWuv/JuiOZ3xJYEWq1+lbanZPQaH5I5LZ7MoS2MvdPaywPP3cYmQe8hm+WuLGJRBuY
	 437QqLp0bJOO4p5aY1BjRdIXADhAG7OtZeKC4LnaoRYHbm1tmQjqVv7wtMsSzuJSF+
	 cMQUaamNXgk9Q==
Date: Mon, 12 Jan 2026 09:10:07 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, 
	ojaswin@linux.ibm.com, djwong@kernel.org
Subject: Re: [PATCH v3] xfs: Fix the return value of xfs_rtcopy_summary()
Message-ID: <aWSryrkF2_6oxU9f@nidhogg.toxiclabs.cc>
References: <83545465b4db39db08d669f9a0a736fdac473f4a.1765989198.git.nirjhar.roy.lists@gmail.com>
 <aUONoL924Sw_su9J@infradead.org>
 <d9cc2f24-6c06-41ab-835e-453a4856fd0b@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9cc2f24-6c06-41ab-835e-453a4856fd0b@gmail.com>

On Mon, Jan 12, 2026 at 11:43:53AM +0530, Nirjhar Roy (IBM) wrote:
> 
> On 12/18/25 10:44, Christoph Hellwig wrote:
> > On Wed, Dec 17, 2025 at 10:04:32PM +0530, Nirjhar Roy (IBM) wrote:
> > > xfs_rtcopy_summary() should return the appropriate error code
> > > instead of always returning 0. The caller of this function which is
> > > xfs_growfs_rt_bmblock() is already handling the error.
> > > 
> > > Fixes: e94b53ff699c ("xfs: cache last bitmap block in realtime allocator")
> > > Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> > > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > > Cc: <stable@vger.kernel.org> # v6.7
> > Looks good:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Hi Carlos,
> 
> Are this and [1] getting picked up?
> 
> [1] https://lore.kernel.org/all/aTFWJrOYXEeFX1kY@infradead.org/

Hello.

I can't find a new version on my mbox. Christoph asked you to fix the
commit log on the patch you mentioned.

If you sent a new version and I missed it, please let me know.

Carlos
 
> 
> --NR
> 
> > 
> -- 
> Nirjhar Roy
> Linux Kernel Developer
> IBM, Bangalore
> 
> 
