Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0604F883
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 06:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710830230; cv=none; b=De0kVDgCrMnNIyxJcFrywazwhaBzVpby45mL/q9WrYPggSZlR2O93VlKJPxeu4NDa68idXhkyAS1CUfU64zcCjXlvxt8Hy5NuufUoiGkqQJD6Gtj4O419qSSaDtm0L5nuo8ojfqhu9o5HNvNp9BrvOZxssXeyHzZ32ZC4uAvpBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710830230; c=relaxed/simple;
	bh=mCt+bG0bRvaLyaewOE0MtEJ3n1935TJr8h+V1glaNVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BflWc5NM1Oa2BMpb8ZK3TAwpa75KzJqJLJUOaOydDYMQ/hzviJLMFLcM4EBJ71mFT9oRfAJDV81h+Z6h473yNi8U4RD6+gUuziL+c68QZi3PDemsqKo1ZWptAFwGPBR8tGT/FNF8iKcMELiiZubDP0tHC1+POxnbl941MJ/FzJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TnakcLDT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TnakcLDT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mCt+bG0bRvaLyaewOE0MtEJ3n1935TJr8h+V1glaNVU=; b=TnakcLDTFsT1UwLyzvdKGRrsJC
	hmgEtv67tKK620mjXpu13MMeCU/I8TmUMU1kZqcuOwsXrweSFT22rOhpEV10iE8EN9cGa8UhxyBXH
	0h1Xrkv4Kaa1k3J+r4Di304aMQN8ts7lp6TdgY8diEHEm4sD2TVBLYYwuVTXKSmERnR/930q4Hq8v
	A6Gj1Dhhkbsjt44eixlHo9Wx7g8tqsdKZV6tpt+KIApbaf7xsqMmeISEA/26jqggctUEyqb96Itrn
	R1w8IgejfqDQw6Xt739kI9QksKLAJ/6/g44VKScDDZ2WYC/l/jlZMRmiolGc2Q+6jMtEbrG28+JEt
	1xg/imeQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmT5v-0000000BWii-2RNY;
	Tue, 19 Mar 2024 06:37:07 +0000
Date: Mon, 18 Mar 2024 23:37:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: Re: [PATCH] xfs: quota radix tree allocations need to be NOFS on
 insert
Message-ID: <Zfkyk7b_gh7MLwBP@infradead.org>
References: <20240319004639.3443383-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319004639.3443383-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Didn't this just get merged into the for-next tree already?

