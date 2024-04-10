Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337F864A
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712728569; cv=none; b=SyDlDWhgkpOI5lr3/Gws239dlaFCcyqD1121+5Kv5WTaZK1cWGtClbPy5rrrqjgjyIvsxtF5EfVcu4URM098ydd1Y94ilFj3uPGsPiheL77gpPFqtqTITol7UVmN2O1VDo+e1Xp05NlsPxW5nE+PZIbOyuykp2wiW1AAcg59bgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712728569; c=relaxed/simple;
	bh=g00hLBey8YCpnj/Q/ANt0AxLt+IoJVtdCknvPWnUgiQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ghr78qjt9HZ3mB5YT6NS9F/QciSZn56IC0nQ2RB+1wt6JvF5Yw2bad0FQg5adF8UVx7Sjeuqs5b3BPV8aZgu0k0hEj9nV0GoUgWnj4iRKD6FdoIeSPzpDngzntxiz+ssDjJbzEkvTItLOMl9uxPM8pFjKh0cX4GgnbqASqxgdjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JgtqvEem; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JgtqvEem"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AVAWZjXNqxISeAVlI2ymFk9woz0+Q1rOu8l1ZiiFjGQ=; b=JgtqvEem902OXySMKM6yrdKqlW
	LyQndJS/GrhpfEETazS1AxtFThZIRvTWAod4WB4/yyzzfbezNfy7a4FSmeGEsqVGXupzA/oC0iZk8
	YOLHxWOTLutsbU03w4qIEDZ9jEX0bXbgDGNuDWSrxQJ5iiJMlyYW9eWR7zKfPh4vCt9ydegyIzHKU
	s390255mWtQ3DOzC3BL5lFIrJWRFfIGUoXFn9WlvAvObSxgQNG03cmx0RxJUQIDju9Zf3ls4ixZhl
	bb+VdrgMNnlJx/YUeO05IUtCuHG8EdyI/ME9V0VfwSRtmuZJQotMN/W0JzqsfpnIjmchAiYO7jtIR
	mO5ZYiSA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQwI-00000005HFP-0uXO;
	Wed, 10 Apr 2024 05:56:06 +0000
Date: Tue, 9 Apr 2024 22:56:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/32] xfs: split out handle management helpers a bit
Message-ID: <ZhYp9j_4g7bNmfEf@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969991.3631889.18004647832726113704.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969991.3631889.18004647832726113704.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	handle->ha_fid.fid_len = sizeof(struct xfs_fid) -
> +				 sizeof(handle->ha_fid.fid_len);

If we clean this up anyway, maybe add a helper for the above calculation
and share it with xfs_khandle_to_dentry?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
