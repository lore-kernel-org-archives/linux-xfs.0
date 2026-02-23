Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EBD23E346
	for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 16:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771863802; cv=none; b=Fo8QQifHkhsT6KgsiQvF9LcqiLz+/WVtDGFUKpHBRet1bCeXlOWFgMG+IIvZcXbbeR5RubgUzdKcPN4rvXYBaUDohCPoNZiGef1veLDAiZCWUUSy8bIKpoQTNk4a3jP1oUOYoUDAUL2U5wg2XWWiMwexryzi9/Hh1hulhxvqpuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771863802; c=relaxed/simple;
	bh=o4IVAdp2yG0qhK4Jw4zlNYSp4MPlUPAQf/b9xPb03cI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i6DZajyCeXPPpgTssbVYTG4uI/LDG9kaAOH8ssa1Q3gZZgF57u9NRO9zWksTEJoSrL0GM4loulnJ101VsmIslXGBQRTno9UZ/z70a9H+AiLRwkPHD3zTuyYkW8CJsklYM/gVPQzAYkozvhH01HKtyTj2jWDbAyuBcKAd1fR5NoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ApYYW+GW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ApYYW+GW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DB4C116C6;
	Mon, 23 Feb 2026 16:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771863801;
	bh=o4IVAdp2yG0qhK4Jw4zlNYSp4MPlUPAQf/b9xPb03cI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ApYYW+GWv+qpugBgn4UA7Pypezeg94JAvc1x6Y4YvFbUj4YflGTeRLRuHU88LyJnu
	 rCh2QfgIquDmBBy3YDx+yO/MJQwARIJiiwQZqgNct3+3wkKNI90QXhgzsF0Yp6jqMq
	 PQWo6if53UJCmj7PCo+vS/G2lPxDHZZzEnuSPie6O8y1c4ijwLWr9pZtSGPQKnKt/Y
	 2hoy7vpIb3XRYdrdkcbSg8OT4x5CLOptWrmw4OaUT1vFuUd+wvHl9QgNFW2g54UUSH
	 LNOLTEdPOrLPNIlTev5ZP+43ehBJ9/DVXw0EZ99glnLo3BShWvpZ1l+b+3Z+spHgrI
	 MvQfHvoQxlkvw==
Date: Mon, 23 Feb 2026 08:23:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: =?utf-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= <socketpair@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [RFE] xfs_growfs: option to clamp growth to an AG boundary
Message-ID: <20260223162320.GB2390353@frogsfrogsfrogs>
References: <CAEmTpZGcBvxsMP6Qg4zcUd-D4M9-jmzS=+9ZsY2RemRDTDQcQg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEmTpZGcBvxsMP6Qg4zcUd-D4M9-jmzS=+9ZsY2RemRDTDQcQg@mail.gmail.com>

On Mon, Feb 23, 2026 at 02:48:48PM +0500, Марк Коренберг wrote:
> Hi,
> 
> I ran into an issue after growing an XFS filesystem where the final
> allocation group (last AG) ended up very small. Most workloads were
> fine, but large reflink-heavy copies started failing. In my case,
> copying a ClickHouse data directory with:
> 
> `cp -a --reflink=always ...`
> 
> fails on a filesystem with a tiny last AG. Using --reflink=auto

How does it fail?

--D

> doesn’t help either, because `cp` doesn’t fall back to a non-reflink
> copy if the reflink attempt fails.
> 
> To work around this, I had to write scripts that compute a “safe”
> target size before running xfs_growfs. The alignment I needed is a bit
> awkward:
> 
> 1. Round the LV size up to the next multiple of the filesystem AG
> size, so the grown filesystem ends exactly on an AG boundary (no
> partial/tiny last AG).
> 
> 2. Then round the LV size down to the LVM extents size (4 MiB in my
> case). Rounding up to the LVM granularity can reintroduce a tiny last
> AG.
> If the automatically chosen AG size were aligned to that granularity,
> step (2) wouldn’t be necessary.
> 
> This feels like something xfsprogs could support directly. My proposals:
> 
> 1. xfs_growfs: add an option to print an “optimal grow target size”:
> the current(new) block device size rounded **down** to a multiple of
> the AG size.
> A --json output mode would make this easy to consume from scripts.
> 
> 2. AG size calculation/alignment: when choosing an automatic AG size,
> always round it down to an alignment such as 4 MiB, or (preferably)
> consider the underlying device/LVM extent size when it can be
> detected, instead of using a constant.
> 
> 3. Docs (mkfs + AG sizing): when specifying AG size manually,
> recommend: choosing filesystem sizing so the final size is an integer
> multiple of AG size (i.e., no partial last AG), and aligning the AG
> size to the underlying allocation granularity (e.g., LVM
> extent/segment size) when applicable.
> 
> 4. Docs (xfs_growfs): add a note that it’s highly preferable to grow
> the filesystem in multiples of the existing AG size, to avoid a tiny
> last AG.
> 
> 5. Optional grow mode: add a xfs_growfs mode/switch that grows “as
> much as possible”, but clamps the resulting filesystem size **down**
> to an AG boundary, and reports how much space is left unused (e.g., “X
> bytes left unallocated to avoid a partial final AG”).
> 
> This might sound like a corner case, but it’s easy to hit in practice
> when the block device is resized to just arbitrary chosen size then
> xfs_growfs expands to consume the whole device.
> 
> Thanks,
> Mark
> 
