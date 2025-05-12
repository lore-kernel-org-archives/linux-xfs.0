Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975B42576;
	Mon, 12 May 2025 04:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747024394; cv=none; b=I0LmRf0Hqiz2X5Z87ual8AbAg8k/5Fmj2H9hOLb7P2usb02ndzEEJUkMLcZS83WvBNd+D5SUSC095RRtOvgP6rUq96U4qM2MuK5LVKY6HUJyIr9Yv9f4Xh3BFg62mVGDMsSzMZ/JkQ0zbOUi9ZdiJKcw8K/+OJlnNCfZBY//JgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747024394; c=relaxed/simple;
	bh=tWeFyTxj2hPH68SrOr39fjj3oCl1IUTQyk9dZFjLhI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AEAA6b/WWzCSQdMY4Pw06iE85X4oQmW2APaO/viHgQx/WtXkzOCbULAwd/tQdVqqL99AZaA43pTsNnZ4o0Jbc3e8HPKSW2F9l48pTlwyF0LX8RnxaPzHr1HM3vA19XIeIY2EG4MpV+UUpy2iXSOzVrEU98PEy2eZhzSsl2+Q3ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jrBXgWTU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jrBXgWTU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=8yOWI0Re8ZNIDtdLqfMil9sp2GzS4DTu9uulu14xS8o=; b=jrBXgWTUqmY6rvuSwbFz/l7Qf3
	oFximt/ivX7CPuP2jxNarf3d30ifQlN9R9+tsG2oYvKgA1ZeElNiJOi/vJLAXbw6UmWELLkrzrTE1
	RjU2ujOFbzoUOCa4sG+haAQQ9X9HugHS8ErdS3itN560xq3C5ADYP5hyYZXeaG8g8W6VBrcZjb5KX
	roFc9E1iAhOwiU2w9ALWGFtTcKvhEpxxu528hgPxbzirVOaAbVfc+8/DGbQ4LznXmhBn15U8ovErA
	7ScPtEbnJjGD5pd5dPF0hLE9IXo0FBXa+ZasThiWwhLZbqrcCkEcCjb3Xy/RJPf3ziKsCx73yYX+b
	3t5PWKsA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uEKqm-00000008L87-0Fwh;
	Mon, 12 May 2025 04:33:12 +0000
Date: Sun, 11 May 2025 21:33:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: cen zhang <zzzccc427@gmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com, zhenghaoran154@gmail.com
Subject: Re: [BUG] Data race between xfs_file_release and
 xfs_bmap_del_extent_delay about i_delayed_blks
Message-ID: <aCF6CEJoh3En3icU@infradead.org>
References: <CAFRLqsWw_6XYE5K+31UBV+DOUht1MG+6v=P587DP-Su3z8t3Rg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFRLqsWw_6XYE5K+31UBV+DOUht1MG+6v=P587DP-Su3z8t3Rg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, May 12, 2025 at 12:01:54PM +0800, cen zhang wrote:
> I would like to report a data race bug detected in
> the Btrfs filesystem on Linux kernel 6.14-rc4.

xfs?

> The issue was discovered by our tools,

As in KCSAN?

> Reader (fs/xfs/xfs_file.c):
> xfs_file_release  {
> ……
>         xfs_iflags_clear(ip, XFS_EOFBLOCKS_RELEASED);
>         if (ip->i_delayed_blks > 0)
>             filemap_flush(inode->i_mapping);
> ……
> }

And this should make it very clear that the race does not matter.
bu we should indeed throw in a data_race() and a comment to make that
clear.  I'll take care of that.

