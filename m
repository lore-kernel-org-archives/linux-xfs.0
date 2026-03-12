Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DB02D2491;
	Thu, 12 Mar 2026 20:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347111; cv=none; b=RyOXsiyl80OoJtNgUHXac7Vyt1/nbVE0Fb3IotZLjbGpPYhZscmxmZvKMnolcZWzFzhemKYO6JnWdLaf1BJAjEjzKHLY7OGd/9Ju8PIVl/kF+NrXU60MgPCmiH+WeGdbrZ+UHwIBmdZxyBK6fbrHgPpyWNV7+FXE2IMWBMwUprw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347111; c=relaxed/simple;
	bh=J7IXhljzNHTMJ1qTsNrp6r+Ta+dVstxcIRH3VZLJPh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Blva34QyQNkcfTh56nOPTayjiPYifDzstDxtuv+FeorZhCIz7y+y36Dc+pWHlmi4wGyHEcN7ngNq2NQ7HZq1Nzmq1BijIeWa8KHn5VKaIug5WqHdQI6OfMQrx41OFRnd6GFihXf5fZ/1DZGzvFt2Y0QN6Y5cxykSzY7uBjLJxJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y3iDNiez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y3iDNiez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26802C4CEF7;
	Thu, 12 Mar 2026 20:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773347110;
	bh=J7IXhljzNHTMJ1qTsNrp6r+Ta+dVstxcIRH3VZLJPh0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y3iDNiezmZ1PdJ3xpbhiGwI3vQoAenC/2N4qaGlQqyNGzIBqq8WVvM0HGv+MFnJ1O
	 7iipFLmpOG+Jga2U0UxIV9MJ+60pdB5hHEg+58qdGdpibgTT8DkGUlp1si/OtlkQH0
	 3bREHam1Ug9WGpu9iOQCRLyQ1Ng6ATpTIDiWEj7yt1jNSbO4Rs/lxdL055DXj/xgDi
	 3AsCybI5/wv6/Usa+ZOZDY3yKXfMo+vbgJKTPftpgoET0Z40T6rzUrFs4biUS/WPKM
	 JJust59WQ5sFl+DGMKMXhNQEfH3G1MT4A7geGb0ZMa1sIscMiq+eRo7AjTCTSqOiML
	 PcJ4DQd/KeaEw==
Date: Fri, 13 Mar 2026 07:25:05 +1100
From: Dave Chinner <dgc@kernel.org>
To: Morduan Zang <zhangdandan@uniontech.com>
Cc: cem@kernel.org, zhanjun@uniontech.com, hch@lst.de, dchinner@redhat.com,
	stable@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+d78ace33ad4ee69329d5@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: use GFP_NOFS in __xfs_trans_alloc
Message-ID: <abMhIabvChMOsUrY@dread>
References: <24B50BB66059E3C8+20260312072214.475115-1-zhangdandan@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24B50BB66059E3C8+20260312072214.475115-1-zhangdandan@uniontech.com>

On Thu, Mar 12, 2026 at 03:22:14PM +0800, Morduan Zang wrote:
> __xfs_trans_alloc() allocates the transaction structure before
> xfs_trans_set_context() establishes the nofs context. If memory reclaim
> enters XFS through xfs_vn_sync_lazytime(), this GFP_KERNEL allocation can
> trigger a warning from the reclaim path.

PLease include the warning and stack trace in the commit message.

> Use GFP_NOFS for the transaction allocation to avoid filesystem reclaim
> recursion before the nofs context is set.
> 
> Link: https://syzkaller.appspot.com/bug?extid=d78ace33ad4ee69329d5

That's a PF_MEMALLOC + __GFP_NOFAIL warning. Has nothing to do
with GFP_NOFS.

> Fixes: 83a80e95e797 ("xfs: decouple xfs_trans_alloc_empty from xfs_trans_alloc")

Nope. That commit didn't even change the allocation context....

Indeed, the stack trace trivially demonstrates the cause - the
sync_lazytime() changes (in 6.19i, IIRC) have put a new XFS
transaction in the iput() path that memory reclaim runs.

We managed to remove all the xfs transactions in this path with the
introduction of the background inodegc infrastructure because
lockdep, memory allocation and other stuff really don't like us
running "must succeed" transactions in the memory reclaim path.

Hence putting a new transaction directly in that path is a
regression, and so I suspect the sync_lazytime() call directly from
iput() running a transaction needs to be rethought...

-Dave.
-- 
Dave Chinner
dgc@kernel.org
