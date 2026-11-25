Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795588789;
	b=C/Hbs6fpWlT52qzlWi+UGlFMoU35EDbmsf4asS4855rZ2FMmSqeKwJ57WDf4jkEYrgrC
	 ETet5vIinazSL6s3lvFdO+u/kLzfGgIqKBxAsFg6RGqAcmF8zoMAFnO3JQ82Ag9H1/0Hh
	 LN/gZlwgLMa3lZunA0GdsSqVZndVGhB/OPd/UdPmVKfZfwCso1CF3MSnPjdsROx2KhUin
	 BtbZhApNQGYlHb3HxrIjT4xrVcxnTUY++49gWcuzjS1sg5z+F9uXZBRWmBffWpw65qVHD
	 PypqiASg4+jS6q3gZAOA9jiog9reib85phLg4qYlTsHtK/DEawK8qUeNv0A7bQ+QQMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795588789;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=bKRjO+D5/mdN9xqqmbkrDnO+wuBUyzomR8aA5OO/ht0=;
	b=frDIkOBl6+d39JdKqgjHpQJOXyi0GQDNbymdqltOWKX3oT6iOZODYIXZNJKQ5S6aU29p
	 rj9eVsEN327wY0IzCfvPL9Ee2Rrg/jE452vnK9pdDe0qc2DgJXbexRqHSj6LBQADkcHW/
	 x5xGreBbx+wdQ/1DlSLiC20Qf7kyWNLWY0WUmfKlTmffmvLDdHV6ni/MQzMa9cn7Fjdz6
	 RNKCtf+itozFZf5QHqNUd4ZekN+lMdFVd2Oi7sN8naxtILvujgeB9ouC42neuttmW2aHw
	 MVm/e5IWrFffaTqT3K/VjBWzIYcjkNp//qgWoD8v4Ul+aVcj2GUkL7LqPCN6DRhuqMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=QjcK+aeI;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D50A606A31E;
	Wed, 25 Nov 2026 06:39:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D50A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=QjcK+aeI
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bKRjO+D5/mdN9xqqmbkrDnO+wuBUyzomR8aA5OO/ht0=; b=QjcK+aeIBTzWA0FDbzlaVVfSnA
	MaIDmrFAimSF0IH/VOOAdrVqHlr55xRWZvjAD7AO6tY56/s6ULVkkI5Iyceu1bUYDHandw/RQ+Clg
	RckGw8qXnM6hTZgZ4MNJwpGpcYpS5lzuiAnoXH/gDTN38S8XJU8oBaLNfEUvAGtpefDfpRk2vtOCX
	LhcbKiupaTdzGDKNnaqzmLbPVgVJJpbQjlYVPggbpyBHRiRLQWOuocapjLGJFNs9KJYHiBtn3jtRI
	V0VP1/3TBhDfRAnYcUCnnuB9sqaSN824+Sq9JG7gBgYcMpJOl+B3BnQ1VgRlA6ug0CqWsuC5WtyKA
	42VRBCDg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xW6fU-00000008jHd-3yyB;
	Wed, 25 Nov 2026 06:39:48 +0000
Date: Tue, 24 Nov 2026 22:39:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Kyuwon Cho <kyuwoncho18@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: reject a hole in a remote xattr value
Message-ID: <awaCtCi8BIfimHRp@infradead.org>
References: <awB1mmg22PhD_efC@infradead.org>
 <179523678723.1642977.7101755246592074809@gmail.com>
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
In-Reply-To: <179523678723.1642977.7101755246592074809@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

FYI: posting in reply to a thread is not great.  In general, please
post it separately.

On Sat, Nov 21, 2026 at 02:05:10PM +0900, Kyuwon Cho wrote:
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -427,8 +427,11 @@ xfs_attr_rmtval_get(
>  			xfs_daddr_t	dblkno;
>  			int		dblkcnt;
>  
> -			ASSERT((map[i].br_startblock != DELAYSTARTBLOCK) &&
> -			       (map[i].br_startblock != HOLESTARTBLOCK));
> +			if (XFS_IS_CORRUPT(mp, map[i].br_startblock == DELAYSTARTBLOCK) ||
> +			    XFS_IS_CORRUPT(mp, map[i].br_startblock == HOLESTARTBLOCK)) {

Overly long lines here.

Otherwise this looks good and like a useful improvement.  Thanks a lot!

