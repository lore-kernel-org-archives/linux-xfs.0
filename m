Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451383904D7
	for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 13:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768311392; cv=none; b=H4+QpMvBoxrwoiRM0KnWucHiY98OXbfjRzUC/mvSs9CA4nLKFncKWHlaosOtalmM/ti5aKD0ttLu3oAlLjP+cP8jlg/+PhV6GOJXpm7okSAAHn9ZRpmkW8ExaIvf1kmRTUXrrWliyC/+U1+/7DmxVR6nDGcr+o1PEkQADVPoQY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768311392; c=relaxed/simple;
	bh=PpWYvaGTcxGfEgc3oOhnT3ttz/DamcU+gE2mF5+9314=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UC43P9Y2XpDbeIYKPtSADbUbc54X710VrxjCBgvNnZMutK76bOudnS5giBR1Sya/OVRSXQbkyqWpRfU5pgDXIU3vYM5ZMJRHnHR3zCPpXwFEu6Cv7a2kyGPJRvDqWmUiRaMD7aehHC3GHKiySoiyXa4+rh55QNRtPpiaoWlMbuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tKP5N5lG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tKP5N5lG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBE2C116C6;
	Tue, 13 Jan 2026 13:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768311391;
	bh=PpWYvaGTcxGfEgc3oOhnT3ttz/DamcU+gE2mF5+9314=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tKP5N5lGXihjLKj0XtuihVS4FSehAbNBLkrMH1PXSWhg6Uak76aCs2qfiQ/9AM/2H
	 PiWkrVkzMRHpOf8MiRP23LZCA8bnk0LQEK15Qbx7ZFZ+1dtjuZcchs3KbOf9klnCRp
	 IWyuBqC1etasXIZkks3IxciMLkLnUAAFBJ0GgY8zPJ9oHa9yl3F4DBFC9qLNOjg9VQ
	 026nZrxvJ9TnyJ8gRjPPknM0TfyuPaxCGJ/8bvQBpB/dNnHbMdV5uWBD3NhmKxrrh2
	 M1RnEFK+HPAYar7Mnh2Nzbc+uTvQkwgUQ9ZC6bR1qwc1lzz5r0WXEpYCXbnsTWwAAe
	 wy/jlinexnCEQ==
Date: Tue, 13 Jan 2026 14:36:07 +0100
From: Niklas Cassel <cassel@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, mark.tinguely@oracle.com
Subject: Re: [PATCH] xfs: remove xfs_attr_leaf_hasname
Message-ID: <aWZKR16It8Lm2Uvp@ryzen>
References: <20260109151741.2376835-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109151741.2376835-1-hch@lst.de>

On Fri, Jan 09, 2026 at 04:17:40PM +0100, Christoph Hellwig wrote:
> The calling convention of xfs_attr_leaf_hasname() is problematic, because
> it returns a NULL buffer when xfs_attr3_leaf_read fails, a valid buffer
> when xfs_attr3_leaf_lookup_int returns -ENOATTR or -EEXIST, and a
> non-NULL buffer pointer for an already released buffer when
> xfs_attr3_leaf_lookup_int fails with other error values.
> 
> Fix this by simply open coding xfs_attr_leaf_hasname in the callers, so
> that the buffer release code is done by each caller of
> xfs_attr3_leaf_read.
> 
> X-Cc: stable@vger.kernel.org # v5.19+

This looks like a typo. (Thus stable is not on cc:)

Probably not enough reson to resend,
(since the stable scripts backport anything with a Fixes-tag anyway),
but perhaps s/X-Cc/Cc/ when applying.


Kind regards,
Niklas
