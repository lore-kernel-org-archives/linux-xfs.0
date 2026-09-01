Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A390C375F88;
	Tue,  1 Sep 2026 14:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788271600; cv=none; b=luyQBV65kU5UKd+4dU3gz49EXJmK/MBTrlNxSSY/9k5fjojWm9glEROf0f8I2tCLtoms2JmnKDSazvrJNj5ySwFFvQbSDRws/HRDvZyZh4q7+Wmv11vwVmtsR4WAIHDmKpV5FQx8mynDxbhgpon/m6oxL7hsF1aNlnefBBiHQSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788271600; c=relaxed/simple;
	bh=pfEw+catxzGMxudahJKkQKCBOdZc9VFE4myZYoBg+MQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h/vpQ+x4BCrP5D/DPAXxgauAYDeeWkw0SFh99J3DDy0408k8MfBT4t/kYv3CGbtUf7+trkPsSQ1kuhzTh9WV+qrLnEPhUtP4Efinf1P73On4IiYEIrrzPgBzHv0hfp667oElXzIJfRtSsRK9KDVufzHNrphDtx25ENXY5W/EkOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AX+lCmtp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AX+lCmtp"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 28CCA1F000E9;
	Tue,  1 Sep 2026 14:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788271599;
	bh=ilKoQlpCvzhTyrDUQx53cJMDt5ZTDRS8pSngTfrDemE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AX+lCmtp/LmRzZ9aopuOr1SWJ1nf3YHefIKvYHdS+TcngZoKwRRvsqKwOgZpVYFU2
	 hIDJ99P+fyDjxsFOKrBB07c2DKpV464w392Ha72zQA0wyq28J8BCebWMgOIgkf1gxg
	 63mwtbFeEJM2qHbUT/jAhg3vqVRhke0Rp4MOhHYVaew0uji2yuxjVHFe65V75SkAtC
	 dnjpFSdq5g+fyQkOu3f+ifMVbisQjmL0DTIPUUYVV3IW9USQQVrDLAVL/sVgNhk+zQ
	 lV/94pCMkKI6XBAWjg606my8jCi5j3zzHSGPw3N/HEvRwHTBhDtK+0JaOIaRGxPxhQ
	 OG14DsbNo+lng==
Date: Tue, 1 Sep 2026 07:06:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 10/17] block,iomap: fix protection information
 verification with initial bvec offset
Message-ID: <20260901140638.GE2114998@frogsfrogsfrogs>
References: <20260831064010.2574896-1-hch@lst.de>
 <20260831064010.2574896-11-hch@lst.de>
 <20260831175222.GD1933798@frogsfrogsfrogs>
 <20260901081232.GC22531@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901081232.GC22531@lst.de>

On Tue, Sep 01, 2026 at 10:12:32AM +0200, Christoph Hellwig wrote:
> On Mon, Aug 31, 2026 at 10:52:22AM -0700, Darrick J. Wong wrote:
> > On Mon, Aug 31, 2026 at 09:39:58AM +0300, Christoph Hellwig wrote:
> > > When reconstructing a bvec_iter from an ioend for protection information
> > > verification, iomap currently ignores the offset into the initial
> > > bio_vec.
> > > 
> > > This can't happen for buffered I/O an direct I/O to user addresses, but
> > 
> > "...buffered I/O or a direct I/O..." ?
> 
> I'd say:
> 
> This can't happen for buffered I/O or direct I/O to user addresses

Works for me.

--D
