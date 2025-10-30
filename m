Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4804C336EF0
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 07:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761809345; cv=none; b=h45JKMtRxxAV5v3ZKn/TXhJ8AJIU3eJo6wZ10tLS9XIm3Fva34+Hc48ZsNJKa1I/IpE9SPr74BNE8LZtE2qQZ+9Bv3DDQ45JIENYPYfYxzmcOpN+CbIiNqtXK2q4Skbtvc7wlgnhQ/WvINwH59mKYIXD8tcRzBpBAmxe1Nrh5gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761809345; c=relaxed/simple;
	bh=cqFwqwD4OVnGMRbNFRFM8s/mK8FmXsto7iqwiS0lvdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o+Vdp91QbH7EJvaxO1NUHyPlS5ae92hR7B4KtkRmWvBLPygYjWKhrg8KRdaynuDyDZmzn2iX0CJjvwdfWjLxAAh0EFgtcXuU9ymnqsjol33DggmzrEfe2bjo8cauiHWJ+0I2nu742Ds1dqHlcuohpgEoPIYcTVyOxUnbmC6iSwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=N5+PzXGZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N5+PzXGZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IpvaDk6iBBfEEUQ/Fetn4YCPkuBUfKIjW0WT/eOnscY=; b=N5+PzXGZC6147vKGzMqsfJlPlS
	ujt2htGTEOa58aVW55PjPXpzATwa4fSircWGH5PJY/zZggHqRJQ80tsiEa/0xVlIjMORNv3Yk3h8/
	ccF/MW6AWfLnJx4x0U333krsrOfKC24/DTQTQ5+LadMouwhRkydylPIuyZmtJ5UYL8SIq9B23T7+1
	eeU161B1nKjhPGRt4nduA3l1xDY0OueDzkAN2UaP9bZaxVufHXJGCvLPnMopk9S/BRYGp6s2zKYFx
	1TM69bm9PUV90Cr/y0DbtYyAzK/vIwtIF9YL0hevnbv9Z26ng7PiehMBRNOhSkMpv0PTXqCma/BmM
	m4iujHzA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vEN5g-00000003dB4-1qGE;
	Thu, 30 Oct 2025 07:29:00 +0000
Date: Thu, 30 Oct 2025 00:29:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: yi.zhang@huaweicloud.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <aQMTvHXCNwbu8fgl@infradead.org>
References: <0e89b047-cacb-4c23-aa83-27de1eb235a5@huaweicloud.com>
 <20251029175313.3644646-2-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029175313.3644646-2-lukas@herbolt.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 29, 2025 at 06:53:14PM +0100, Lukas Herbolt wrote:
> Add support for FALLOC_FL_WRITE_ZEROES if the underlying device enable
> the unmap write zeroes operation.
> 
> v3 changes:
>  - fix formating
>  - fix check  on the return value of xfs_alloc_file_space
>  - add check if inode COW and return -EOPNOTSUPP

The changes from previous versions go below the ---.

Alternatively add a cover letter even for single patches, which can
be easier to maintain.

