Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB0224336D
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 09:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781169284; cv=none; b=F6h//FZJfLXuW0gE8BByy6cms6FP6J0YkGpEU7WwP2UEASFLmpznh6US1SPbRx1L0tgb2ryjYuFQ3BXNF92A1XH2tSrNV53BdwcTiR8BvO0V/qJZLzwj5ZnkqJzMKxHP1/E1aOuGHLPVjuDyiIwHeT5/7kKtaLRPb2GCQ2bLqA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781169284; c=relaxed/simple;
	bh=eogbbu4cXMHqCC45LPF8MUQJrPs1Pny2X0gZ78bgCuc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cpSLx5F4y3y22g0sItxeJQbkIA0i7kpOkaEsXyzcBns88ytWwZUy7oH7VP5MpvjR0O7Xw7f0ezI+2DMhcIThB9RRzgAlD6ITrgwrsb98DvFUoRlrX+siJA5BNNbyfHeVgSG0yiquaJ2ZO7M1iCMYy1wiaEarIeYPOUbCrzs4mko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I/xeOm/1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I/xeOm/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEDB1F00893;
	Thu, 11 Jun 2026 09:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781169283;
	bh=RNl/tZF59/lt/05bCuIQoImoOwajC67c5UnfFCM2xUA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I/xeOm/1RVGpP7Uj7Z31Qs1dDLD2mBh5MJ01pntxxRLHnQk+MQyNaQBf3+kWk65Lp
	 VDx7jN1uH7fL82Im8czxyo4BPOwqfISjPxZeYFyWL81he+B6NwCx3EdVbY/ZVXjM6P
	 PYftsMiyEWAQa2jiF+IQSme5y/qr32j5FHl+D1TbAvxWaVoXqcjiHNg7xCsvX3ccKw
	 UKbKA+I8vLmrBiafiudbQEv8qZQNDDR9uTSsh7pkDyrNGNlgEgOousp8qpr7Ti4KA+
	 oEOmSwBFo5r5c2mfKO5r3/dwULD0WhpRp44TRr5w2s5KcFdON540wwCXnwkz3PtVhu
	 nQpNuAw/YvjIQ==
Date: Thu, 11 Jun 2026 11:14:39 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 10/21] xfs_scrub: don't report media errors in
 specially-owned areas as file data
Message-ID: <aip8bIhSvpgEtqvF@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
 <178055303293.2608728.8048137726163765459.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178055303293.2608728.8048137726163765459.stgit@frogsfrogsfrogs>

On 2026-06-03 23:06:56, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If a media error occurs for some disk space that has a "special" owner,
> we mustn't try to walk parent pointers because special owners are not
> files.  If it's an extent map, we shouldn't accidentally fall into
> reporting that as file data loss.  This was, like the rest, found by
> Codex.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
