Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2DE46B8
	for <linux-xfs@vger.kernel.org>; Wed, 14 May 2025 17:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747243836; cv=none; b=o8SI2cGxh/cK2cuiCknbSSjqhOAj2xgZlpb+THJPO+2yyjkFw08071vLU3+17w3I8T9yEIsrXn1QRIg846hC2xGX4/gqbqYBt6+gElXYOteXoz7jdDBKi5/0KzM67cCFIzJ7/rnKJhwAOnigA+QnfaFtiZiplRTc2YfINLnronw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747243836; c=relaxed/simple;
	bh=nEY5XVv8N2IGOG0Pk14xMKUpUvoVisVP+z1arptUsFA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gf5D6YB9Jjii1yQ6+sBbuj6F9zVB+UQFXnf+AjiPsqXPrlS+1NKfGqIlI+VUUHvQy/vwyNIPq9TI3w6K/cRVMOuOoXTJ0USIedSoo29Tit+DDk7V+NYMNp0Wx7ZCViyxaSnPt5MRHNGrmg5rF7pmWhciDKdmzqO88F8dAjfoW30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tSREyiko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tSREyiko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AB7C4CEE3;
	Wed, 14 May 2025 17:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747243835;
	bh=nEY5XVv8N2IGOG0Pk14xMKUpUvoVisVP+z1arptUsFA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=tSREyiko8exqBgKuURaMHDBTdyRSyC0RFkUUNk+rPRzahLzhSl1C8JFwNmt+PnYz/
	 3+m2+yGE5lQRS4yFs33wHrl/yi8raA+nnpRAS05/ZhDCjeKWpdADfJ6NvxFscI7gak
	 c6oHVcvXtqPfFx8CAOZcpxoixxwfUytBAIjBj8wttYlG/RmmwNzgA/zx0VjO+0hKYR
	 m7tzC55OldYj7dwn4NDiFphIlG9W125woDUIYiGmdFZhXaut6n/8/ZyCkdYi+SVm+v
	 cM9UCJNGKLMQTXJ4Yg5fJbUvK+mpfMugaoAtCOmdP3EC8Rc3l8vUxwlbRyys9iccAX
	 rYEiYSY76ixCA==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, 
 Dave Chinner <david@fromorbit.com>
In-Reply-To: <20250513143529.GI2701446@frogsfrogsfrogs>
References: <20250513143529.GI2701446@frogsfrogsfrogs>
Subject: Re: [PATCH v2] xfs: remove some EXPERIMENTAL warnings
Message-Id: <174724383436.752716.3320211038944937438.b4-ty@kernel.org>
Date: Wed, 14 May 2025 19:30:34 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 13 May 2025 07:35:29 -0700, Darrick J. Wong wrote:
> Online fsck was finished a year ago, in Linux 6.10.  The exchange-range
> syscall and parent pointers were merged in the same cycle.  None of
> these have encountered any serious errors in the year that they've been
> in the kernel (or the many many years they've been under development) so
> let's drop the shouty warnings.
> 
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: remove some EXPERIMENTAL warnings
      commit: ca43b74ac3040ae13be854e6a71ebd7a91e5fcfc

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

