Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794932551;
	b=uH1StUCwQRlLPH1a4w0KAAdLUwSnFCzbrp1wsHtJi/WhVho+3iRYyPwS+7ic2Y9uIb0g
	 tmZlJ+XBdLl/VDljV+k+twMYxL3cPM+o+V2vUvAhsNVMbxalx6YGRbo0IdbJ2hKg06nWj
	 gDo9VyRe9MssGc/3JKEnzMUXxZdTEQYHWSl4UF6joxPus7iWMHDh+1pPhKhVWcGMQQQGo
	 hPSAwjCyUuXJNteDA8L4Ee+mxkPoqJ/so9o3WbGK8z09/SoIGx2nqnwJNz2+7QvPOJq/N
	 z+S9roxsHS03VkRrTYuYEsGq4rfRCIjEQNWc3fDUY1M102Nbm8SPp9Ewc4vbXMe9hZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794932551;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=7ozHhCZ3ZihxouUI4j459/3H/En+9bEIeJSKv08FLE4=;
	b=yVRiJgYyRkwZrd7k8QUW4p9aIsqk6ZxNP15ckqIirUpmy2Ue7CZUdkJT+Q67PJW1viWx
	 UlzeVVze98UkaPSRIhPrQb2nqnSAa38j/NFBWKDPBE3xhQoip2xQesLS9GGYg7KaEIMyj
	 pxtrNacwMhRbzDmVWpz4TAAdsDNYJHcqjIR70dqali8/wXfeOzjFDWlvdAT6hOZwvX51N
	 /SyFre08Mi/ussIPP83yQbnDIWa9yVagRHiAzZqk8SjpWI/XfaU0cT0EVVgelo4wEaMFT
	 Y/Y1iOd0CPwcPGYPUeMTdOvghtgzn7qbwv2oxSQm47SCoSXEKcqRDRFdepOPqp6k0yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XBzmkglJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A04C606A31C;
	Tue, 17 Nov 2026 16:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XBzmkglJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F661F000C5;
	Tue, 17 Nov 2026 16:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794932551;
	bh=7ozHhCZ3ZihxouUI4j459/3H/En+9bEIeJSKv08FLE4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XBzmkglJCnMg5frKEMxdQwuLZcGIEMSV7sjuFXYTvopkN7zZ5ZFUQ3qP0rGLI+CQk
	 WRC8p0qmhXxnJZE0wbGl3QdJQcistyRQLpHbCdLvnn5r2n1kT3qBsjRsSgrSFCujq3
	 Wm2v/NP0+ZZc9c/9BP5pxGOuxZRBRMf1wSKTJw7G5BE27x/UjgqOGTvJ/FoPztrINA
	 0huGgA6kO1LyRUvcUKSeWrrd/W+gCjIf9DMwwTbMZwiA/kuZwnogR1+i0SjAeS9Khh
	 2Kmk2DKuMKjDy038WCdvSbxEhfhFFB1FurDQqLS2WoFMe/DYjGOuFI1pcbPGamrn23
	 74IkVmv23qblw==
Date: Tue, 17 Nov 2026 17:22:25 +0100
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Lauri Gates <lauri.gates@gmail.com>, Dave Chinner <dgc@kernel.org>, 
	linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, 
	Christian Brauner <christian@brauner.io>, "Darrick J. Wong" <djwong@kernel.org>, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF
 buffer lock
Message-ID: <20261117-kiefer-beinfreiheit-entnommen-685343327ac9@brauner>
References: <au3wJNbRPXQZG5Op@infradead.org>
 <20261106204026.14530-1-lauri.gates@gmail.com>
 <avYb7D3bCmnw0Mbw@infradead.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <avYb7D3bCmnw0Mbw@infradead.org>

On Thu, Nov 12, 2026 at 12:05:00PM -0800, Christoph Hellwig wrote:
> On Fri, Nov 06, 2026 at 10:40:26PM +0200, Lauri Gates wrote:
> > The other is that for a "may share" bit, clear is the unsafe answer,
> > so a filesystem that cannot answer should not look like one that
> > answers "not shared". As I understand it, stx_attributes_mask makes
> > that distinction, while struct file_attr has no validity mask today
> > (it is size-versioned, so one could be added), so through
> > file_getattr() btrfs would currently read as never shared. A spare
> > bit in stx_attributes adds no field to struct statx, which I hope
> > meets the concern Christian raised about spending statx space on the
> > case-folding RFC [2]. If fileattr is preferred, the bit could instead
> > mean "no shared extents", so that clear is the safe default, as it is
> > for FS_XFLAG_CASEFOLD.
> 
> statx sounds good to me, but I'd really like to hear from Christian.

I'm not fond of it mostly because it seems FIEMAP is a debug interface
and adding bits into statx() to make said debug interface quicker or
easier to use feels very wrong to me. So I'd like to hear a better
argument why we should do this. Otherwise, I think using file_attr as
suggested earlier is good enough.
