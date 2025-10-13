Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA4F315D22
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 14:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367272; cv=none; b=LqQEvgAQhK3/ATM20ZPiKuAIR0DL9ML7PJusbQPr6KPHjmnHldkyLihVcCnlWcTnQlIuxuJago4VhDsrtEZMcE1YDcMqUszJXYEqkLWQJEHWIyPlCmy6fUJZxhOVuAh13af3zVNU6zVEIYmUm/lSxdEt6nKlodYivIOvnIC1+pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367272; c=relaxed/simple;
	bh=sqCa5OceFo6Fu3XVU2a/oJriYXxXm4Apqoyd06QiUUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZD1NRVehMGQk6kNl0hN7+1FB1MDwuGR8FAh/9LbEOsNHqnlLSeq5KHd27vOY0+R6qVaGDyYjErv+CBlbZL6MhTXfk7se7BYWvUUjFlJB7n9RI2ytP/GK8q9yKKe7IONQkbQCqGLIHBp3jOVNLeS0TD97cus4EUm5k2PLKZcYU9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JQH81KhX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JQH81KhX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC526C4CEE7;
	Mon, 13 Oct 2025 14:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760367271;
	bh=sqCa5OceFo6Fu3XVU2a/oJriYXxXm4Apqoyd06QiUUE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JQH81KhXf6p3AeL/9ylQC/nFMtC23enVq3BR6htcUyFuBiJm6kO6J1ZIYrLlkYOHc
	 xhx38VZrEWjmpP41UgNI6/O83hY9B6CF9azJLePDV34BHqaO/jwOK3DXKiOlH8+fiC
	 HxFt5G4ap9hUk+hx1zIqjWCbUUluKdpW6RJcs+71kf0/xvBnvwlsoPiFxa1HV5Ncx/
	 HnXGmS9si5qho0uSFP+urbe++jyxlU0mRvjJHByAnb13R4a04HQQmgsHV+dinq9U/j
	 Fxa99YiIQBzoJrwRNwkyHcClThWcKNPokTGkjZJnpeq7GLLg6qTVBQbVNybHkAvmUK
	 BMl53puxkXLVA==
Date: Mon, 13 Oct 2025 07:54:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: track the number of blocks in each buftarg
Message-ID: <20251013145431.GJ6188@frogsfrogsfrogs>
References: <20250919131222.802840-1-hch@lst.de>
 <20250919131222.802840-2-hch@lst.de>
 <20250919175246.GQ8096@frogsfrogsfrogs>
 <20251013054647.GI6188@frogsfrogsfrogs>
 <20251013062942.GA1886@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013062942.GA1886@lst.de>

On Mon, Oct 13, 2025 at 08:29:42AM +0200, Christoph Hellwig wrote:
> On Sun, Oct 12, 2025 at 10:46:47PM -0700, Darrick J. Wong wrote:
> > I just pulled 6.18-rc1 and noticed that the rmapbt repair now dumps a
> > bunch of warnings about daddr 0 being "beyond" EOFS in the xfbtree that
> > holds the in-memory rmap data.
> > 
> > I think the reason for this is that xfs_daddr_t is actually a s64 value,
> > so the comparison in xfs_buf_map_verify
> > 
> > 	if (map->bm_bn < 0 || map->bm_bn >= btp->bt_nr_sectors) {
> > 
> > is actually comparing 0 against -1, so the second part of the if test is
> > actually true.  I'm not sure what a good fix here would be?  Maybe
> > 
> > #define XFS_DADDR_MAX	((xfs_daddr_t)S64_MAX)
> > 
> > and then
> > 
> > 	/* The maximum size of the buftarg is only known once the sb is read. */
> > 	btp->bt_nr_sectors = XFS_DADDR_MAX;
> > 
> > Hm?
> 
> Oh, right the switch to use a xfs_daddr_t means the value is signed
> now, and the -1 cast won't get the max value.  Your idea sounds good
> to me, do you want to send a patch or should I?

I'll send a patch once I make sure it actually fixes all the new online
fsck test failures in -rc1.

--D
