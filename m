Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795192321;
	b=gyNHGo3lJIqU54mcgmG4tV2gi6btOg4uJX19ufQRnrpzfl0RGzUP2vdKR3VQm2PH6elG
	 jaH7PcwJB82BeGzjMIFGsUDVy46dickDCvNxvlFHgE8nNY/3qASSQ5nZdpiFzy9Lat8h/
	 BOcHYpAd4Pp9blUwQ2UlYKRYaJ7ozNleYprAwMDJNw+0ANeF00C+29X0C/Hl/Beu9SIsk
	 OHNr+IVcptZbcZCcNyIKuH2PhPb5c4x6in83Z47V6kSkQaOJV8DkH8thNyxWju4tA6zqf
	 arvWtzscIyXrg9xfQ0DE9Pb+z3m0kqcJp6bJuaHCot6aQwBSqj0FuX+n5OUevymmlPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795192321;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=yvczUFIoJKzHdc0TeA49LudP29hlJ7OXD3M2icgcAwQ=;
	b=Rn2CVoQaooSsAEstiWC8rP/IqPCBhS1pkewWKmYYRIIYAoM2uNSuPmUPWIMXjQ311ESz
	 r8TPNdJJ2snSZbwH0pM9iV5fNmjcygInCabBcD/Ts8+DiVmAE6l5/svuDyxXNgy7YL6w6
	 W0vXbz+EQKXfxXWbT9DUhlc7H27uQxbXc9ZmNIWfUYKMRlf9kcIh3b0h+8cDEsjGUZwOD
	 AkyZDCckkij4RwsyHQtjDnsi6NzLMSHuJpQ98k6wK8kBwzOTE62xzbTRqwBAYrUJQZ8e/
	 Kd8wkYu8zi5qlUGwFCgG3Aj89j+wk1R0YpJ5JNbjgKepm6uRgo6CTVVlzqZAkIjAoKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=LCRTkiJR;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B52606A330
	for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2026 16:32:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8B52606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=LCRTkiJR
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yvczUFIoJKzHdc0TeA49LudP29hlJ7OXD3M2icgcAwQ=; b=LCRTkiJRxgBxNnqrG59/UdVvTr
	v8Cp603/iilaeAd4zSMU7vUiJRBnsXBU05Y9TIXhd4vYDzv/E7uGMh8T3fzf1/EnMlSP0TsfgFbDW
	dd4DfSaCoVy1ELhW10YfGdjKPNvNqjFfoKXmJVA1fbcrhUaIEu7IBx0ufN2wuKFXofZMYfJ/z89tC
	INWAK5MhHyzD5VRHuL2/hc+vYxD6MBmjt9Oi4bOSNxtZIcYotmV8Haluu/TCmdVxDmwJM8/IKNCxA
	AbLMZYuU0EmgN9PxmsSbZZ4EI/FjOyJH1UwQx6ZEYApL8DTV/JNFBmgwWUTW65jXbByg4pJi7JuBG
	V4KV6DcA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xURWq-0000000FZ9d-1dgM;
	Fri, 20 Nov 2026 16:32:00 +0000
Date: Fri, 20 Nov 2026 08:32:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 01/59] xfs: set the unmount record operation header length
Message-ID: <awB2AKAtMYqKay0e@infradead.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
 <20261116231707.3625263-2-dgc@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116231707.3625263-2-dgc@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 17, 2026 at 10:14:18AM +1100, Dave Chinner wrote:
> The unmount record is written to the log with a hand built operation
> header passed directly to xlog_write() through xlog_write_one_vec().
> The operation header length was never set, so the unmount record is
> written with a zero length header even though it carries an unmount
> log format structure. Recovery does not check the unmount record, so
> the incorrect length goes unnoticed.
> 
> Before commit db357078b0423e ("xfs: introduce xlog_write_full()")
> the operation header length was rewritten correctly by xlog_write(),
> hence the incorrectly built unmount header went unnoticed. After
> that commit, xlog_write() never rewrote operation header lengths for
> regions that fit fully into the iclog. This change exposed the
> problem with the unmount record header construction.
> 
> Set the operation header length when building the unmount record.
> xlog_write_one_vec() now validates that the operation header length
> is set correctly for the region being written, and shuts down the
> filesystem if a malformed record write is detected.

The proper fix here is of course to automatically keep the length in
sync.  I have a series that does this, but if we can get the quick
fix in before I won't complain.

> +	/*
> +	 * The caller builds the operation header itself, and xlog_write() no
> +	 * longer rewrites the length when the region is written whole. Make sure

> +			"%s: region length %u does not match op header length %u",

> +			.oh_len = cpu_to_be32(sizeof(struct xfs_unmount_log_format)),

Please fix the various overly long lines.
