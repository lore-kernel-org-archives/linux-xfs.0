Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851B03C1D60;
	Tue, 15 Sep 2026 14:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789482799; cv=none; b=kqEdQ6Dmsm+vzEZTDmS0ig3ziFgSN1GqOVkGHtHTi9OY6rvWUCtOPDp8UomtxrbPawlZ6R/CC0spY7rlpu7Th1IxI/j8OFeCoWvvlcEblz/M0J2bnJxnlrpUA9IQ/MMBGX4UcoNOtTx0zdeGwGBWG4ltzamagwIv0CS1aRbPFo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789482799; c=relaxed/simple;
	bh=rjTRfmdF4dsNXIAfifa6pydf6YTF6cVSnvIqvX7O1Q4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tuYpWL0LBgZedLOb86SUxGvc7+zI3BHfaZp1YT/g2v/P43WhkIoZs0+RuueFp51mSTV+X4XNvbChLzHu9btpkCervHUqX0TOqyUIxftLdil/LXgep25jGf7A2dqAQTaCO3VYhqqeI9iaa0W+QX5jRqLfrtDIre34c8c3VluLSCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hERgPY0e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hERgPY0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17F01F000FF;
	Tue, 15 Sep 2026 14:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482797;
	bh=IERLX791zoT9cunZ7MeYik3FY+K7SJSY2TwlhRRhNQo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hERgPY0eLxZqNGHb7tujVhURflHo2JK4lwdXzNrHF1KNpT6oGV5dam5YluC6k1fHG
	 MES+fH1GS83nO6GgDiLcSFA/tRL/7MJ/6gDTzqmfDFg8ieT+sNZvJbZUx0ocFdjSkr
	 hHy9RZiwATlid6W5/ZLBEa30WZQWN/yxTdfc1YnJYkmoJcWeuDJ2iwH3X78ovFRqYT
	 YoIlSIRafnsU7XwzEMWyvRXWHc/R2fkh5yLyc7gUWMncBe9dqr7/Dlv/N+gjd9Ij0Q
	 yUlmfMM949Fq03e+excpfatYtyTXMaRc7Fj+1ZoM9fUj65zQtNClJ/gKIYvwS09qOs
	 +SyrMbgXVcZGQ==
Date: Tue, 15 Sep 2026 22:33:10 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, Anand Suveer Jain <asj@kernel.org>, Chao Yu <chao@kernel.org>
Subject: Re: [PATCH 1/5] fstests: consolidate _require_fs_sysfs and
 _require_fs_sysfs_attr
Message-ID: <aqlUOwnGPYBauYYF@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>, 
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Anand Suveer Jain <asj@kernel.org>, Chao Yu <chao@kernel.org>
References: <20260914172509.3799016-1-zlang@kernel.org>
 <20260914172509.3799016-2-zlang@kernel.org>
 <aqjsBs6QUtIukk05@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqjsBs6QUtIukk05@infradead.org>

On Mon, Sep 14, 2026 at 11:56:06PM -0700, Christoph Hellwig wrote:
> On Tue, Sep 15, 2026 at 01:25:05AM +0800, Zorro Lang wrote:
> > There is heavy overlap between _require_fs_sysfs and
> > _require_fs_sysfs_attr, and their ambiguous names make it difficult
> > to tell them apart.
> > 
> > So merge them into a single function with "_dev_" included in the
> > name to distinguish per-device entries from other paths like
> > /sys/fs/$FSTYP/features/.
> 
> I have a bit of a hard time understanding this message.  From looking
> at the diff this seems to:
> 
>  - rename _has_fs_sysfs_attr to _has_fs_sysfs_dev_attr
>  - rename _get_fs_sysfs_attr to _get_fs_sysfs_dev_attr
>  - rename _set_fs_sysfs_attr to _set_fs_sysfs_dev_attr
>  - rename _require_fs_sysfs_attr to _require_fs_sysfs_dev_attr
>  - remove _require_fs_sysfs

And remove _has_fs_sysfs.

> 
> right?  Maybe spell that out and split the pure renames from code
> removal?

Sure, that makes sense. I will incorporate the rename into PATCH 2/5 in
the next revision.

Thanks,
Zorro
