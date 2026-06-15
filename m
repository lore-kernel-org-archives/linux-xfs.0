Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FCB3016FB;
	Mon, 15 Jun 2026 07:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781508308; cv=none; b=qTW+goeCxkkdyK1ko+k79yO0DlooROjJjZkmqVn+ZcayRJTrgrIy+eI2HtIM4uLRYRs13iGBjclxGDWjcAQ0zigRke8iIa73sczTGd+xFni1JI9geqLRhAVMp2w27IY+wgYudbTIWZsBPB/rMdr5TsIZCSgIg8/ZUNDPDC9ZyUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781508308; c=relaxed/simple;
	bh=QuHN7tLtCUS6UCmjcALbvD3mMp9dt4j8TDfQkYz8hNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BR1JW89jKh0O/wD7jSBUy3aTdFwPCAar4feZTUx2HfHAu9RtVxxxNDTymwuGUjhQv5RniJ3RpCSmhO8LFOcA7xSyz3WaRZnlLfLAc2I584VPg5tP9LrVuDTWx45RXLj77DwRShw7NiSaF02Qk/axcPiJM1yu6OsQcX8QcD7a5SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eAktbm/3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eAktbm/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE171F000E9;
	Mon, 15 Jun 2026 07:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781508307;
	bh=uVPw5vNg2RnDVpQQeZW9Ic4WYmxP8j64LsQHJCwVIMw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eAktbm/30+EPCGqCPdsN/GW+L+cxOlL5boiRAJ4L1HerwH49RBR7qnnpNjymcbebN
	 +AYwJBmw1rLWcg+U4Wn8Z89qUjNTOOP0MoEmlSO/aB9qTwTMbo/3YE7Wu6F+GiISQt
	 DIB5IDwMU3kAF+O3oE72fwyPBhWERkUtqpSk1Cjma1OLyqkg1Ayp/BjBtQr++bVMkx
	 VUbfBnNj0NnU3XZq44iM+a2bcoEhcifFMv1oCmHKaEyHFnkJv/UHTsNb+UorFrgcZJ
	 BnNOFNfHPHUuRmQiyBpe+l/5jDghoOIJji0LOKRsqWr6JxjmmHVeMWgHufFd3znbVI
	 RUwaKlUaeCTAg==
Date: Mon, 15 Jun 2026 09:24:59 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Zhang Cen <rollkingzzc@gmail.com>
Cc: Mikhail Lobanov <m.lobanov@rosa.ru>, 
	"Darrick J . Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH v5 2/2] xfs: shut down the filesystem on a failed mount
Message-ID: <ai-ow6hms2DPyXkX@nidhogg.toxiclabs.cc>
References: <20260610191904.12533-1-m.lobanov@rosa.ru>
 <20260610191904.12533-2-m.lobanov@rosa.ru>
 <20260613081322.895929-1-rollkingzzc@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260613081322.895929-1-rollkingzzc@gmail.com>

On Sat, Jun 13, 2026 at 04:13:22PM +0800, Zhang Cen wrote:
> Hi Mikhail and Christoph,
> 
> Sorry for the delayed follow-up. I was tied up with other work recently and
> did not get a chance to continue following up on this issue.
> 
> This series appears to address the same mount-failure inodegc/quota teardown
> race that I reported earlier here:
> 
> https://lore.kernel.org/linux-xfs/20260528053554.3047829-1-rollkingzzc@gmail.com/
> 
> Could you please carry the following tags?
> 
> Reported-by: Zhang Cen <rollkingzzc@gmail.com>
> Closes: https://lore.kernel.org/linux-xfs/20260528053554.3047829-1-rollkingzzc@gmail.com/

Too late.

> 
> Thanks,
> Zhang Cen
> 
