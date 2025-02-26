Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90D72459E0
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 10:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740564086; cv=none; b=pkKznH8KtQ6Gy7149ck2PDSFTvGGNmvW401fhKvBd9PcTE4wva48Pjr2T0fhE4IrRXQARuHv0adDZfpk16flJgZgRvce5C19Khtwy+I/z8f/iiwK7JhowkrFsMhnkAfS+nC/LMhO/LV73GRww2Jl2LlhIwHzYL5O1KqAgVQfNbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740564086; c=relaxed/simple;
	bh=dGizeGgpZRtViW/8kfLztiy+s3S4Mh6v9iKgSUvRmic=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=JldZBRlhq02XHgUYrVm+JEnq9Bzzfgd7g/3NjdVhCZ68lIYMeEZhR3+XVIiiRPCxDFR6vDjZxUFk9Lo/aseviqjvddXcopx4JwTsFYxFL44XZMEylpmJxubAbksl0KkOgGsNAVVFJZS53tGCJxIvGMPbNM3g4Bz7Ng0oJNNlDUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DK5Qj2qJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DK5Qj2qJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CABC4CED6;
	Wed, 26 Feb 2025 10:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740564086;
	bh=dGizeGgpZRtViW/8kfLztiy+s3S4Mh6v9iKgSUvRmic=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=DK5Qj2qJylL9+McJJgGF05WfTf/TKdrkqU9/9M7Cup9JgorffHwI6GTT1bL6bJB9z
	 uAJy9esOcBon3RC2gH+tboMQ6A+OLUsA8YeHOlLIyrV2YO3rJH3cHJLEtnPlbqn2bV
	 pKcj+8xL15uB0V1e13OlxVKODynt4INarjvhEjMjTZZSuSZA5xOJ5qqxh8LV3nLlDC
	 lCtb42kpNk1a5BLa0zOGGAkouPkprbnK62tPMxpYtMOLlXDtmSh+d3vD+jPeRBpS8E
	 7QX9XrDGzeBbYXzaiHB09yc+MqAUzMqJvIkZ+ubAt7a+wxS+EInf9R60rlFZV/NRWg
	 EKa+OspRtKU+Q==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
In-Reply-To: <20250224234903.402657-1-hch@lst.de>
References: <20250224234903.402657-1-hch@lst.de>
Subject: Re: buffer cache simplifications v3
Message-Id: <174056408496.108535.5208300152894563156.b4-ty@kernel.org>
Date: Wed, 26 Feb 2025 11:01:24 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 24 Feb 2025 15:48:51 -0800, Christoph Hellwig wrote:
> this series reduces some superlfous work done in the buffer cache.  Most
> notable an extra workqueue context switch for synchronous I/O, and
> tracking of in-flight I/O for buffers where that is not needed.
> 
> Changes since v2:
>  - more comment typo fixin'
> 
> [...]

Applied to for-next, thanks!

[1/4] xfs: reduce context switches for synchronous buffered I/O
      commit: 4b90de5bc0f5a6d1151acd74c838275f9b7be3a5
[2/4] xfs: decouple buffer readahead from the normal buffer read path
      commit: efc5f7a9f3d887ce44b7610bc39388094b6f97d5
[3/4] xfs: remove most in-flight buffer accounting
      commit: 0d1120b9bbe48a2d119afe0dc64f9c0666745bc8
[4/4] xfs: remove the XBF_STALE check from xfs_buf_rele_cached
      commit: 9b47d37496e2669078c8616334e5a7200f91681a

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

