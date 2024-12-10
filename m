Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500AA79FD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733809982; cv=none; b=OehCAH6KKZv5wz9beYY6tdOd3DA00m8z5HUCetDeuvYJOak5FhPWFYMERAGR62qbbOh6Xyb/95WnqmkpoQZoSVdPY7HKB0NUdYYLS7AoN75FsH7Ss+eGfCdrPyyPNXXuibzJ0lZNqMcaR7vp4JieO3VLbvE9ur/nNfYN7BbQ97E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733809982; c=relaxed/simple;
	bh=CJfLHtG8LKGLx1lw+Js2MNwJdaIm3mMr6uGwmdilGTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U5Qi3nBz36w4RlKrHvntqxVObFhnG1EY7XMvTjutluREeGLPMncvQynlaLUZFMRCCzjfvjMu5yP41NN62dUXeRdPkH1cjpUm5wAEQn1v3HeWUxitOGPPJL4jDkQcpn+UMhG13zvNO/AsZUKU/W1wWw/qNqWAkW5hjsfmV1fIVng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d6xgmiwS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d6xgmiwS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=z1HRYFfzuKYcFao3Lb0C7sjIPLgxCphBRvQ3+6YtTi0=; b=d6xgmiwS+NIPjIxfMgXQCvta9q
	zMFj/0Ej+mTJ7IXG9TPmoQDpSAujXu5pjj7hGQLB5qOfsa9i+ggPOSLdobjHwU6/ETg+HnKA0fWAT
	Z5waul4nhz7qwlY8mk/EgbQMomyYh4agrOCx/k3FP6t8Hvp/S3yx9edrnsIJqyq+XMhKgVo9EstUn
	+kCpKy/pysgAvG1g+Fl3A5hdNl/DxrggCO90nqfy3TQJAnji6ZUS/shRCrpFDdeeLhtLMels37rWg
	xOhMSkqKaiFNVY832RHB7tv7wNTZ4Rs4JlkvsEGf8GouUSY1SjG4fW+Apstb8K+QwCYCERzP+XHg0
	y0sOUxDQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKtB6-0000000AJeo-3m8g;
	Tue, 10 Dec 2024 05:53:00 +0000
Date: Mon, 9 Dec 2024 21:53:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 36/50] xfs_mdrestore: restore rt group superblocks to
 realtime device
Message-ID: <Z1fXPAHmSToru25O@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752495.126362.8968721228760590908.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752495.126362.8968721228760590908.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +++ b/mdrestore/xfs_mdrestore.c
> @@ -19,8 +19,9 @@ struct mdrestore_ops {
>  	void (*read_header)(union mdrestore_headers *header, FILE *md_fp);
>  	void (*show_info)(union mdrestore_headers *header, const char *md_file);
>  	void (*restore)(union mdrestore_headers *header, FILE *md_fp,
> -			int ddev_fd, bool is_data_target_file, int logdev_fd,
> -			bool is_log_target_file);
> +			int ddev_fd, bool is_data_target_file,
> +			int logdev_fd, bool is_log_target_file,
> +			int rtdev_fd, bool is_rt_target_file);

This almost feels like adding a little struct nicely clean up the
interface here:

struct mdrestore_dev {
	int fd;
	bool is_file;
}


 	void (*restore)(union mdrestore_headers *header, FILE *md_fp,
			struct mdrestore_dev *ddev,
			struct mdrestore_dev *logdev,
			struct mdrestore_dev *rtdev);

and also be useful for at least verify_device_size.

