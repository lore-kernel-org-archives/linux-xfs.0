Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D5057320
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 23:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zv8YRRLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11162C433C8;
	Tue, 28 Nov 2023 23:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701214061;
	bh=B6F1AiZ/lx7H2iMELu+m60uhL80FZLbDcn7Q34w68Ts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zv8YRRLLueVVsJfjmxOIvyXc5yA2xGULuTiNR97C2g2/D7FwJtijHELmnRiantzUO
	 oUptDYgzsj/Rp2ZPIH5ktUeyFdaJ07aK2HQns+VoYlmR6X9xvdtHMhg7t9TsPe29zq
	 O/4gItE2OZf+yTNZ8vDOAI4BUXur3KR2HSUA6DJLKUks8DSq5hbiG+t7To3IZtBGmW
	 uTxa7ZWGn6RozHIpHOxUqzopvCqZuLi7534wyDnaZzu6lJWlFt9dMml0aE+6r814a1
	 Eovql4K8Cb2BXzqQxH/+qrf+PaR/ieqG3+KYHnfmZ0xdMf85sv48tXL+6vGVJFrxcI
	 oOR14WQ3mqDfQ==
Date: Tue, 28 Nov 2023 15:27:40 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: check rt bitmap file geometry more thoroughly
Message-ID: <20231128232740.GE4167244@frogsfrogsfrogs>
References: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
 <170086928361.2771542.12276270495680939208.stgit@frogsfrogsfrogs>
 <ZWXzaiaUDQYrT/5x@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWXzaiaUDQYrT/5x@infradead.org>

On Tue, Nov 28, 2023 at 06:04:26AM -0800, Christoph Hellwig wrote:
> > +	/*
> > +	 * Now that we've locked the rtbitmap, we can't race with growfsrt
> > +	 * trying to expand the bitmap or change the size of the rt volume.
> > +	 * Hence it is safe to compute and check the geometry values.
> > +	 */
> > +	rtb->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
> > +	rtb->rextslog = rtb->rextents ? xfs_highbit32(rtb->rextents) : 0;
> > +	rtb->rbmblocks = xfs_rtbitmap_blockcount(mp, rtb->rextents);
> 
> All these will be 0 if mp->m_sb.sb_rblocks, and rtb is zeroed allocation
> right above, so calculating the values seems a bit odd.  Why not simply:
> 
> 	if (mp->m_sb.sb_rblocks) {
> 		rtb->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
> 		rtb->rextslog = xfs_highbit32(rtb->rextents);

Well... xfs_highbit32 returns -1 if its argument is zero, which is
possible for the nasty edge case of (say) a 64k block device and a
realtime extent size of 1MB, which results in rblocks > 0 and
rextents == 0.

So I'll still have to do:

		if (rtb->rextents)
			rtb->rextslog = xfs_highbit32()

but otherwise this is fine.

> 		rtb->rbmblocks = xfs_rtbitmap_blockcount(mp, rtb->rextents);
> 	}
> 
> ?
> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thank you!

--D
