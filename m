Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7C810957
	for <linux-xfs@vger.kernel.org>; Tue, 19 Aug 2025 08:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755590930; cv=none; b=cy1aLTm/3LYJDdeBHRtg7Z9DT/7QfUrNFGnR8CzkbVLP3qQrr14wf9o0c2ddjNmyq6Teqljv3EvxONw693JUQhxFnbV/aWY2tkTw1mi2sEZKeEQ3mRwoqdCPpsqroRe0ukNVKhlT+6ElPnd+G16uTTsb/DVKGYWFa55+7Dr43Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755590930; c=relaxed/simple;
	bh=+riFsxCjZzTZxbMlS3cIWvUyGdQR17Olg9snW9JTNf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xa+d1a4OEm4a5VVa482J/QEDQwpyec+UE77xe8SpnHIWvhWtYiM6Rj1VYl0W9Luk9s2u7kbtfgx92Msrr0NOcFEHxXrT4bzCg1f0TuZYlEn73BCEnlaJ36gmdkzGCdgGAekuGDvxCjTawWwuFqlqwFfG4r8u2+Pku5dH/hXG8WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dQfZDJQe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dQfZDJQe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=70GEK9dfv9p+TFu/eb/vcGBsd6F3OMSz4bF9RvXgfsk=; b=dQfZDJQeomvzjCLvdC8jyLlrhf
	83rcOeoVnU6nVuzjtPzCNdINlihDBDZZUy2ISSeNSIbZB3MMIxfIa+PSxfTFDroHsi1KA84v9b7oj
	2Iao72svZJ6xaxNUVneR0lJKf85U54+19d0sU7ppEjZnxO77HNSrdTVG2k+q9qqEezXqW1bFcks9f
	k2/Be2JzBOBMO3RnGTzK4aqoOMASLfNCaZ+/EHeEsUwZQAotBNTzGRHU2WF1u1L1Ls4QKO3qKRPrN
	JyDqbKU99nMojIBU7hjMtntGtso8ID2TwvJoFetTP5/TJLWTRnn5dBav/UQypXGhaACtXX6YSzy3x
	/AnVpH5Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uoHOh-00000009lVc-13hh;
	Tue, 19 Aug 2025 08:08:47 +0000
Date: Tue, 19 Aug 2025 01:08:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Donald Douwsma <ddouwsma@redhat.com>
Subject: Re: [PATCH RFC] xfs: remap block layer ENODATA read errors to EIO
Message-ID: <aKQxD_txX68w4Tb-@infradead.org>
References: <1bd13475-3154-4ab4-8930-2c8cdc295829@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bd13475-3154-4ab4-8930-2c8cdc295829@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Aug 18, 2025 at 03:22:02PM -0500, Eric Sandeen wrote:
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index f9ef3b2a332a..6ba57ccaa25f 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -747,6 +747,9 @@ xfs_buf_read_map(
>  		/* bad CRC means corrupted metadata */
>  		if (error == -EFSBADCRC)
>  			error = -EFSCORRUPTED;
> +		/* ENODATA == ENOATTR which confuses xattr layers */
> +		if (error == -ENODATA)
> +			error = -EIO;

I think we need to stop passing random errors through here (same
for the write side).  Unless we have an explicit handler (which we
have for a tiny number of errors), passing random stuff we got through
and which higher layers use for their own purpose will cause trouble.

Btw, your patch is timely as I've just seen something that probably
is the same root cause when running XFS on a device with messed up
PI, which is another of those cases where the block layer returns
"odd" error codes.

