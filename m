Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C0127456;
	Wed, 18 Mar 2026 06:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773813714; cv=none; b=n017FLZhnfh+jXXVo4xS2tpZOyIzRimZalf0P4nXgjLNvN/oQCBIJqcIOO/8fTM645PMolC1Is3rnutGrBzz2VuCOnAw2KLwnI71EffBkgMZvrxqpsfFmUeYDFuvyytHT3F1bS7KDQOsaqtEU+MxvvV6ze0k0vsflLUIwFT+8Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773813714; c=relaxed/simple;
	bh=Qny+bfVFNeIfiAraVFIqIGaVDB5OpuwjtpxRR9O80F4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r0b9PgYy83GBgr9hSGcJYvyuHhRBL5Pg6iUR+kQsfBiBqQclazgyxIcF+TynPGytkoJm/D3fTOThcg5gbTtlv6teEcSbdQOu6glTAzoU22NG0pUEXLda1MbxrEAQSo3iL2Vy3jlVDI3MyLcPKFJSy56ChG0LdAEHdvXGSFNXh2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=I/Xgcuq7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="I/Xgcuq7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZhyqQ457E5RwuyIHgNVwn5OGHG0qGJJx/s3CiyAm8Ik=; b=I/Xgcuq7qurw+H33WjzJhKXW0U
	MNe8ERoS1cQ4Fr6aokN24Fcf5jdiojzcfgmDJSx8fzYuXralYmwsg/hoye+4rK8br3nnuGBujVKxB
	0RcWv1KUIu+miMgsguBSVnP8y3J8XN2xMVuIpZo/9d7GQbbsYnuRghgmoibqMBPhUPWntdkRpv0dF
	sWiiu+gRNzpRjFKuA72+WueppwYTr0H48GDmUts+idPi/HLB9Fag778EWgu6sFMcBWo5qETzmFri1
	X+VLuAiAlgHutC24XMKwtlV55KRGNaParjGK2N1XqF9L5qiwM7rOcu7TMSYsJyi2iwgjTPu4J3pri
	f4awAbww==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w2jyb-00000007p8H-0dvN;
	Wed, 18 Mar 2026 06:01:53 +0000
Date: Tue, 17 Mar 2026 23:01:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/805: adjust for new autofsck fsproperty defaults
Message-ID: <abo_0X-3Sk4Gt0ED@infradead.org>
References: <177370372656.2108664.15986990094116651469.stgit@frogsfrogsfrogs>
 <177370372722.2108664.4085087401055083414.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177370372722.2108664.4085087401055083414.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 16, 2026 at 04:29:35PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that mkfs will set autofsck=repair for filesystems that have both
> reverse space mappings and file parent pointers enabled, let's stop
> testing the "no autofsck option at all" scenario to avoid problems with
> older mkfs.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

