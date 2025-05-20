Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F56F19E971
	for <linux-xfs@vger.kernel.org>; Tue, 20 May 2025 12:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747745278; cv=none; b=ZFERCKj4iPu5zlTSm9pA6dmmdmm/v6sckTGaRllVzGHi4xgr6u+Xc9vQLNtlcfiPXDhrqSAd08lzK38jDxUQBuCfbsLKXyewEVv+VIIeCJXo5s906464pGwkcYkmzHrmVfRB8SLgm4Qhp17gXYe/A5W6luNz4Wp10nfPLZUy3lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747745278; c=relaxed/simple;
	bh=p3edqmoU5dwXUZKt/pWexZfyNFF1haGA2PH5AaOIDnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TX2IyB7qQsdospVILSEALTHQYFvsfsptGgh/GxR2WFGk3BQ9uVNGYpOeU775CNMAG+oDGy5Y+E7fdsSkqKySxzmsWPSDVzFRinSLZi1NkVv/TRmqZzEYKL727rdcfW5dATTVjQUI+OO0tmZBn+hMVQJgG7WdDA0yAA3E3B6k8hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l6vGQhK0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l6vGQhK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC162C4CEE9;
	Tue, 20 May 2025 12:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747745277;
	bh=p3edqmoU5dwXUZKt/pWexZfyNFF1haGA2PH5AaOIDnE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l6vGQhK06D9K550w8gXCoxFSGIpYwlF+i0uY6haDmwWkbooEPP/xc+t02ns8cyQBC
	 uj08ISoDZAlzlURaAaclriJBI/+YsX1HgeeTa+J+gMtQhD9G6MX1Xo8isnCxPJnqqQ
	 REuBJ0bgKQ5ydpsn63sGG0oSAm4gGjLP/7HT5vWZ+HEnsbJb7TiEoXP1E/IXO7vbpM
	 PulAJ+X2rhPIHE+PEWZ3QbllL6ysz8VVDJY1Rz6FS5O4+uFXNYQ8XZlXjZw4JUdhBH
	 J9o90gtztj6xuvzCVVtjq0HqmNIArilGsEa4FataPZQjMMWdlxMkK29vppgs8Nl9bn
	 13K6FbHEXiDVA==
Date: Tue, 20 May 2025 14:47:52 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Zizhi Wo <wozizhi@huawei.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, dchinner@redhat.com, 
	osandov@fb.com, john.g.garry@oracle.com, linux-xfs@vger.kernel.org, 
	yangerkun@huawei.com, leo.lilong@huawei.com
Subject: Re: [PATCH] xfs: Remove unnecessary checks in functions related to
 xfs_fsmap
Message-ID: <le2sd5pz32vvwt6l7t6wgzmtdewdn5o77t5656kbf4l4545iul@2ppxdylrnzjg>
References: <20250517074341.3841468-1-wozizhi@huawei.com>
 <9_MWuMXnaWk3qXgpyYhQa-60ELGmTr8hBsB3E4comBf1_9Mx-ZtDqy3cQKCTkNa9aVG4zLeTHVvnaepX2jweEA==@protonmail.internalid>
 <20250519150854.GB9705@frogsfrogsfrogs>
 <kzgijlgzweykmeni664npughps5jkgf34l7ndyj3zzwgq2wrbi@zbwrkf6xcmzh>
 <QW9YI98DcQqphE8-s07KFEcBLpkLhiozJvfGBPPOrtYNXx81V8ynWQUT0ojRyiC2EocVMPpxcpgyUvsrGkAIrA==@protonmail.internalid>
 <fc9a4b4d-9209-4346-a652-cd1661e583cb@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fc9a4b4d-9209-4346-a652-cd1661e583cb@huawei.com>

On Tue, May 20, 2025 at 07:57:19PM +0800, Zizhi Wo wrote:
> 
> 
> 在 2025/5/20 18:38, Carlos Maiolino 写道:
> > On Mon, May 19, 2025 at 08:08:54AM -0700, Darrick J. Wong wrote:
> >> On Sat, May 17, 2025 at 03:43:41PM +0800, Zizhi Wo wrote:
> >>> From: Zizhi Wo <wozizhi@huaweicloud.com>
> >>>
> >>> In __xfs_getfsmap_datadev(), if "pag_agno(pag) == end_ag", we don't need
> >>> to check the result of query_fn(), because there won't be another iteration
> >>> of the loop anyway. Also, both before and after the change, info->group
> >>> will eventually be set to NULL and the reference count of xfs_group will
> >>> also be decremented before exiting the iteration.
> >>>
> >>> The same logic applies to other similar functions as well, so related
> >>> cleanup operations are performed together.
> >>>
> >>> Signed-off-by: Zizhi Wo <wozizhi@huaweicloud.com>
> >>> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
> >>> ---
> >>>   fs/xfs/xfs_fsmap.c | 6 ------
> >>>   1 file changed, 6 deletions(-)
> >>>
> >>> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> >>> index 414b27a86458..792282aa8a29 100644
> >>> --- a/fs/xfs/xfs_fsmap.c
> >>> +++ b/fs/xfs/xfs_fsmap.c
> >>> @@ -579,8 +579,6 @@ __xfs_getfsmap_datadev(
> >>>   		if (pag_agno(pag) == end_ag) {
> >>>   			info->last = true;
> >>>   			error = query_fn(tp, info, &bt_cur, priv);
> >>> -			if (error)
> >>> -				break;
> >>
> >> Removing these statements make the error path harder to follow.  Before,
> >> it was explicit that an error breaks out of the loop body.  Now you have
> >> to look upwards to the while loop conditional and reason about what
> >> xfs_perag_next_range does when pag-> agno == end_ag to determine that
> >> the loop terminates.
> >>
> >> This also leaves a tripping point for anyone who wants to add another
> >> statement into this here if body because now they have to recognize that
> >> they need to re-add the "if (error) break;" statements that you're now
> >> taking out.
> >>
> >> You also don't claim any reduction in generated machine code size or
> >> execution speed, which means all the programmers end up having to
> >> perform extra reasoning when reading this code for ... what?  Zero gain?
> >>
> >> Please stop sending overly narrowly focused "optimizations" that make
> >> life harder for all of us.
> >
> > I do agree with Darrick. What's the point of this patch other than making code
> > harder to understand? This gets rid of less than 10 machine instructions at the
> > final module, and such cod is not even a hot path. making these extra instructions
> > virtually negligible IMO (looking at x86 architecture). The checks are unneeded
> > logically, but make the code easier to read, which is also important.
> > Did you actually see any improvement on anything by applying this patch? Or was
> > it crafted merely as a result of code inspection? Where are the results that make
> > this change worth the extra complexity while reading it?
> >
> 
> Yes, I was simply thinking about this while looking at the fsmap-related
> code. Since the current for loop always exits after iterating to the
> last AG, I thought off the top of my head that the error check for
> last_ag might be unnecessary. As you and Darrick mentioned, though,
> removing it would increase the difficulty of reading the code and could
> also affect future developers.:(
> 
> If doing so could bring significant performance benefits, then it might
> be worth considering — perhaps with some added comments to clarify? But
> in this case, the performance gain is indeed negligible, I admit. Thank
> you for pointing that out.

As anything, it's always a trade-off.
The key thing to take away here is your patch make the whole code it touches
harder to understand without bringing any real benefit. Even if you could
prove this adds small performance gain to the fsmap interface, perhaps it
would still not be worth the performance gain in lieu of poor code reliability,
giving the interface you changed. So, it's always about discussing the
change's trade-off between complexity and performance. In your case, there
seems to be no real trade-off.
