Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1388A29CB24;
	Tue, 21 Apr 2026 21:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776808039; cv=none; b=EEznZNsG2s9GlScCagqbN5PC65zVAv5Uu+uV0BzBbK9eeK934WzuxeadJ2YXj3jkXQ+coY3eot70wseyKyTOevmJCJ6p19FnUaEO4j2NiR2KRBo5pz8aFHxvKdLq2MplH6Zrg7KNv8dZtkq1jVrVuF1LPOd+tIMcDwdDomQR8mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776808039; c=relaxed/simple;
	bh=oSPokO+q3plCIej+MKM68XW8qDkR6dMa04YKSO3bIGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GVutPM6D4J/hP+QtZfVBQxMyyYUkr6XFWwC9NVgU7Q3WU0VUBiUGK+J2K4eW5ig0fJYEg2+eSmKyUwNxLXPnhYeHvNf6tjViGSYn0FNALjo3OlPdigNzPZB17Qg6OnV66QPIhhZVBcVAyALisVQet86HaoIxaG7zEKXUZmzWGKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r2jEQ64G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r2jEQ64G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC65C2BCB0;
	Tue, 21 Apr 2026 21:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776808038;
	bh=oSPokO+q3plCIej+MKM68XW8qDkR6dMa04YKSO3bIGw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r2jEQ64GDftqTVQLHKezLKKWKzDIZieUE0l8/KquLk+CrY+mskzigarYZ13lyk+v5
	 UY58aEU9eccI98ZWyWEAdL4lLGL46YYwwNXaz+4PDrZy9KYTdwC+3/5H4ZAmbgS4kp
	 zrqVFfL+5SMRgZGqDkbiyaItgl7wXZ6jr7Uh7z9Md8odOn8jmTGbPiSIx8nTEWWHe/
	 tbHSdk2JSAwS84I1LFn8UHjjQKNzMCDTPh47/K04vYKfFsNbxbtRnyRmXvL3XBexx/
	 RB9HdDTafglw9PZ0xJqhD/V9IIq+MsVrgFz2YOlGp7gTsUR8Ajq9KJ8+iYchnjiyf5
	 3FirERO2gFrfg==
Date: Tue, 21 Apr 2026 14:47:16 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	djwong@kernel.org
Subject: Re: [PATCH v8 04/22] fsverity: generate and store zero-block hash
Message-ID: <20260421214716.GD37143@quark>
References: <20260420114714.1621982-1-aalbersh@kernel.org>
 <20260420114714.1621982-5-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420114714.1621982-5-aalbersh@kernel.org>

On Mon, Apr 20, 2026 at 01:46:51PM +0200, Andrey Albershteyn wrote:
> +void fsverity_fill_zerohash(struct folio *folio, size_t offset, size_t len,
> +			      struct fsverity_info *vi)
[...]
> +void fsverity_fill_zerohash(struct folio *folio, size_t poff, size_t plen,
> +			      struct fsverity_info *vi);
[...]
> +static inline void fsverity_fill_zerohash(struct folio *folio, size_t poff,
> +		size_t plen, struct fsverity_info *vi)

The parameters should have the same name at each declaration site.

- Eric
