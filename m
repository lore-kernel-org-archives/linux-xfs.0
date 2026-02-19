Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69EE247280;
	Thu, 19 Feb 2026 22:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771541535; cv=none; b=D8p16gfert1npeW8W4rsN0iSpmsX3DXgcmCL9Upq2HPccBAxM9z06eINNEG8xSvQIEdL5uy8EXQH2Hj0OTFVe/jZ7sCChRhcVVul/fphqezRP9vICfS/vQnQiTWxPJRUch3P8KQEDqXKPPnQVYCobDgozAqYAqJauBoIJLOYUwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771541535; c=relaxed/simple;
	bh=7eMEdZbUmR16KtSQRvUUh7y5VeK7ls2QS8IQzjkJstA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WImIQscvgz61s5Pa5kmnWLaialobNrnWzYO+D/rq/+dDoSD/sp9wwKNjnEyoV12YRkvisb55Cfr19Glk35j5bTbctwIhP9IG/OhiCMNSU6BvZphRlHV4cN4/e5CIerRDbsIYWlByMQGzZwuC65z/kQ8HXvl52Tz0ykdTMzj5j48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DiAbiB/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DiAbiB/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A6CC116C6;
	Thu, 19 Feb 2026 22:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771541535;
	bh=7eMEdZbUmR16KtSQRvUUh7y5VeK7ls2QS8IQzjkJstA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DiAbiB/nXrc/VfXKY/PIXdvsoS04NB8VHTMjDEi7rkWL0uOeUvcvZ52K83Xeu32HM
	 VP7vgTEDv1q/7OeE11wsG2OFMvd6HFFfzaHVD/D2l653NLZzk5WdbaocCL2szsRfK/
	 EbV2PAZZehqXNCMwC3MDyYpS0ij6qfBkmWdiZtsE6e/LcmNj247xMfR8sjkUs9IWXI
	 wQf2R3kxyJKgCD/6TSZHhD07WpQYuE+AneRzBMzbKsSA8bXd6YR7Yr4D7WVvmG7H0v
	 tnHU8gOScslFwhK3UcU7zBOxUvrGQhH/gsF6AiyjoK7NNkys5R6CzOZI9LswK9cYYZ
	 3ASwOge1lF01w==
Date: Thu, 19 Feb 2026 14:52:14 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, brauner@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] fserror: fix lockdep complaint when igrabbing inode
Message-ID: <20260219225214.GT6490@frogsfrogsfrogs>
References: <177148129514.716249.10889194125495783768.stgit@frogsfrogsfrogs>
 <177148129564.716249.3069780698231701540.stgit@frogsfrogsfrogs>
 <aZa0XkylrjTYR5pg@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZa0XkylrjTYR5pg@infradead.org>

On Wed, Feb 18, 2026 at 10:57:34PM -0800, Christoph Hellwig wrote:
> Allright, this is basically a dumbed down version of the XFS ioend queuing
> just for errors.  I don't particularly like it, but it's probably good
> enough to fix the regression:

Yeah, let's hope so.  Thanks for hodling your nose. :)

--D

> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> 
