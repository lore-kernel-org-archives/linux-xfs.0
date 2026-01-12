Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2512773FE
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 09:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768211810; cv=none; b=amVl2KhzAMrhZyd0m/ghbkxg5yaTfjo9Qp84UyB4BOGLEF1XwvB3Wcw48MadmVi1k7NqEGxemw980Hq578+8H88SEsRXNgJ+9KUcZDHS8FnC5EOc9jbBKB79UhktiP99GtYYF3HozJq8HYubgNaoFdOC5ij6b5rns5w75/DMvJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768211810; c=relaxed/simple;
	bh=rO5uVbbL49I9HmBJVy0DoUVLM43dqE/nG9SmTbvDWu4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H2BlRpzCEuQrt7WGd5aKGDCUR6bsLqC/H5yKi5sbrfNDdxCQm8ToHpp1lfkkyWrWnDb8mBK8aq98FUfalHwpwqMx4clmdXLYxO/DLfIHAsSZbzliWwJ12PuWkdLbI+/E5k4o73uEz1hrJ2gQWYJuGjowadyTRXWPsoP2IS3W9O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dp+XfIOW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dp+XfIOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF60C4AF09;
	Mon, 12 Jan 2026 09:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768211809;
	bh=rO5uVbbL49I9HmBJVy0DoUVLM43dqE/nG9SmTbvDWu4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dp+XfIOWvzyKcAAa479jqhao4CPUUrhmB+8Nmm5bRpL3HFL8H8T36htvAu3Wdma+v
	 qhTxwXVZkmmXwEE+yUIyADAPqAyaF1U9Bpz/feWZLcalu67clGjpj2S/fh39pu2viw
	 IZm/sh+up37oxduARku3ZvIUdJpt1w/8AxPWyVH8anBVXyliTTbDsvLovJG99Rb81+
	 KckROPkvCzwXvs0AsXug3xlmWMI18/uBGuZFTZCyiV5bbG2aaO9wzck0QHNCSALQ4T
	 T+kuAYsb9UXqf5jIbOORcLqTzr8jNuFAs1KWl7nr2CAfjiqIRJAg315GcbXRzVxSdh
	 zBWWZ52pA1Tjw==
Date: Mon, 12 Jan 2026 10:56:46 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfs: Fix the return value of xfs_rtcopy_summary()
Message-ID: <aWTFORPaMx0tjbmj@nidhogg.toxiclabs.cc>
References: <83545465b4db39db08d669f9a0a736fdac473f4a.1765989198.git.nirjhar.roy.lists@gmail.com>
 <aUONoL924Sw_su9J@infradead.org>
 <d9cc2f24-6c06-41ab-835e-453a4856fd0b@gmail.com>
 <aWSryrkF2_6oxU9f@nidhogg.toxiclabs.cc>
 <8316699b-5ba4-402c-a0c0-17cdd0838347@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8316699b-5ba4-402c-a0c0-17cdd0838347@gmail.com>

On Mon, Jan 12, 2026 at 02:10:01PM +0530, Nirjhar Roy (IBM) wrote:
> 
> On 1/12/26 13:40, Carlos Maiolino wrote:
> > On Mon, Jan 12, 2026 at 11:43:53AM +0530, Nirjhar Roy (IBM) wrote:
> > > On 12/18/25 10:44, Christoph Hellwig wrote:
> > > > On Wed, Dec 17, 2025 at 10:04:32PM +0530, Nirjhar Roy (IBM) wrote:
> > > > > xfs_rtcopy_summary() should return the appropriate error code
> > > > > instead of always returning 0. The caller of this function which is
> > > > > xfs_growfs_rt_bmblock() is already handling the error.
> > > > > 
> > > > > Fixes: e94b53ff699c ("xfs: cache last bitmap block in realtime allocator")
> > > > > Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> > > > > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > > > > Cc: <stable@vger.kernel.org> # v6.7
> > > > Looks good:
> > > > 
> > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > Hi Carlos,
> > > 
> > > Are this and [1] getting picked up?
> > > 
> > > [1] https://lore.kernel.org/all/aTFWJrOYXEeFX1kY@infradead.org/
> > Hello.
> > 
> > I can't find a new version on my mbox. Christoph asked you to fix the
> > commit log on the patch you mentioned.
> > 
> > If you sent a new version and I missed it, please let me know.
> 
> Sorry, I have re-sent it now [1]. Anything about [2]?

I think think it slipped through the cracks, could you please re-send
it? I'll pick both this week.

Carlos

> 
> [1] https://lore.kernel.org/all/9b2e055a1e714dacf37b4479e2aab589f3cec7f6.1768205975.git.nirjhar.roy.lists@gmail.com/
> 
> [2] https://lore.kernel.org/all/aUONoL924Sw_su9J@infradead.org/
> 
> --NR
> 
> > 
> > Carlos
> > > --NR
> > > 
> > > -- 
> > > Nirjhar Roy
> > > Linux Kernel Developer
> > > IBM, Bangalore
> > > 
> > > 
> -- 
> Nirjhar Roy
> Linux Kernel Developer
> IBM, Bangalore
> 
> 
