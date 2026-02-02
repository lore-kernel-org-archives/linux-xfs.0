Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2ABB1C84BB
	for <linux-xfs@vger.kernel.org>; Mon,  2 Feb 2026 14:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770043127; cv=none; b=D2rkdXkk1nuGmkMNT02o4qFnsg8NLJOP1G828G18PcY5w6XoNsPZzVA4bj6L5eXUAOrDRxI0AXAVfk5zozd1kVVLibWnq9bM/FY5EyOTI4o8QyOf6JkD/AUe2my9Au/WkotMQHxWDhchS03qnDLw6xQBRZjUtM+AAHbqXXc6UNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770043127; c=relaxed/simple;
	bh=PrAXrrlrSUINsxO3vpkzIVWRSrEu2G7umCEsaGg3yiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IMvufF10Y+CWP2loTGNOVlxfyh0eAtsf/D6Qg7UCtqlVrssZnp6hGqipxcd3YiGsllebzYsVO1sDz4yFJZwzatTog0v8h54k3kgjKiIIazqwVWlNUaYLNireijfw3vJ5ZXU0VqY0Iz7yX88n/ja9HCSJ1Z4S+thtF0gIc437IVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZcI9N+zk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZcI9N+zk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yfVBrvgRzjEQxFJEPjYVp8VVePe1odDur0CMEHAzOaM=; b=ZcI9N+zkBnhws1D1hUdRk1K3nv
	QMfyi/cMujqnbeKpbXODfAwn7VVgqjYiuNAc4WL1P9btmSQiF4tcD/5mRx8umM7QESmwqX63Av6h7
	YJRIv88uS+hA2E7lrt040yGLaSCwMay/zFEsW4Yi+k6fL2Ix9Ilzzn3/xyKOTE4gwGRhBwwfAUez0
	FCkhdT2TbtCWpFEylr7wInAAIUDbLkFQfbo1zb8g0UuG7iuQGd1W4RzKuVCrJsrmnMJsoFr4wuno7
	Vab6kztc/iIgWY4IqJKW9bwd0PHv0gXaVYg1kw7RnRiTvE5dsvzIu+5RYvNJLSAkPAtCwEydgGYAK
	C4fBFC7A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmv4f-000000057CZ-24Mh;
	Mon, 02 Feb 2026 14:38:45 +0000
Date: Mon, 2 Feb 2026 06:38:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	ritesh.list@gmail.com, ojaswin@linux.ibm.com, djwong@kernel.org,
	bfoster@redhat.com, david@fromorbit.com,
	hsiangkao@linux.alibaba.com
Subject: Re: [RFC V3 2/3] xfs: Refactoring the nagcount and delta calculation
Message-ID: <aYC29YuaLHhQJuTz@infradead.org>
References: <cover.1760640936.git.nirjhar.roy.lists@gmail.com>
 <b84a4243ee87e0f0519e8565b1da5b8579ed0f64.1760640936.git.nirjhar.roy.lists@gmail.com>
 <1659bd90-2fbc-42df-abbe-3da52402feb6@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1659bd90-2fbc-42df-abbe-3da52402feb6@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Feb 02, 2026 at 07:45:56PM +0530, Nirjhar Roy (IBM) wrote:
> 
> On 10/20/25 21:13, Nirjhar Roy (IBM) wrote:
> > Introduce xfs_growfs_compute_delta() to calculate the nagcount
> > and delta blocks and refactor the code from xfs_growfs_data_private().
> > No functional changes.
> > 
> > Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> Hi Carlos, Darrick,
> 
> Can this be picked up? This is quite independent of the rest of the patches
> in this series.

For a 2 1/2 month patch picked from a larger series, a resend is probably
a better idea.  But the last days of the merge window might not be the
right time for a pure refactoring without urgency anyway.

