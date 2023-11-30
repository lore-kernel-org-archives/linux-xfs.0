Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uw7Zg3H6"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C29F198
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 21:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ljOBpl4nrhYvgCElAsI9TLcQPqtkUii3rnyNC/Tg99U=; b=uw7Zg3H6VLXEOh1eIbo2tmr57d
	d9Z90otKWgWJuISxYcJHMKs31n2kDjsr/yZzQdHR/JEYuXq9bp5UeWH9zMbjsF5XGzQJb4/B3jXMF
	LdOpVnK29GVLtyf1zL8OCINkJjujwQyKJzEuvrBNUgM7As5dljoBeX+XJ10dsbNJ/c8E3ZkmlnByd
	ikMqEmHJXdDxt0xILSCPB7xy0JUtFIPI1FBawwp8/ZeByHGo2Ped8/JiUaLiE52vyCmmxwhuOf4SR
	a96S9EVaTdtR98ttGg1Ifgaxk8WEXAHznvEsc9wfbw/uLBsH+GCzLDq5XB+LVYwTzAOJDkYC67S42
	OsuNMPQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8ZYB-009xyZ-09;
	Thu, 30 Nov 2023 05:25:23 +0000
Date: Wed, 29 Nov 2023 21:25:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: improve dquot iteration for scrub
Message-ID: <ZWgcw/npBRQcu+aK@infradead.org>
References: <170086928781.2771741.1842650188784688715.stgit@frogsfrogsfrogs>
 <170086928854.2771741.10145606242704137068.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086928854.2771741.10145606242704137068.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 24, 2023 at 03:56:48PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Upon a closer inspection of the quota record scrubber, I noticed that
> dqiterate wasn't actually walking all possible dquots for the mapped
> blocks in the quota file.  This is due to xfs_qm_dqget_next skipping all
> XFS_IS_DQUOT_UNINITIALIZED dquots.
> 
> For a fsck program, we really want to look at all the dquots, even if
> all counters and limits in the dquot record are zero.  Rewrite the
> implementation to do this, as well as switching to an iterator paradigm
> to reduce the number of indirect calls.

Heh, this basically ends up doing what I suggested in the last patch
(and a lot more).

I'd just fold the previous patch into this one, as there's no point
in moving the function just to remove it immediately.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
