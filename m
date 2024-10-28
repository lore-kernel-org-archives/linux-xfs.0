Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C783B1552FC
	for <linux-xfs@vger.kernel.org>; Mon, 28 Oct 2024 17:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730137907; cv=none; b=GtrVJoj1Em2XOMkJz9m8dzuzCu8UivdbZsw2GkKMeBIvle94G81238w5I8zqRG3nEMs8ccOzXwXrKBJz3pJAR2ZU+WqVsB7g1G0cvUjFhlgrFQ9SwzjxkgRijNybwRZ9ZWSL3x/UlIjNw91bNRnv31wPPLvCYgYmkjDmys7tgf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730137907; c=relaxed/simple;
	bh=3BIyJ/Aqtip8/Dqj/YS9HGFBmANalXvPkyTg+oI4sIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Of8dgndtzaInVuo/sQBwuaTQf/kvCz+JXbJOT0rvlLbw0QBEit9a6poF6bNj7OQYk+X960cDeHGdWz/CODNt92ArlPfzXv/Mf/vARdvncIipEnJen1D0f0itDDfFQhJV+h4bLHzV21AHKusolGC8ZP6ZdIR7eQj+o/1YDNRmwXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G5fx9U++; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G5fx9U++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CBDC4CEC3;
	Mon, 28 Oct 2024 17:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730137907;
	bh=3BIyJ/Aqtip8/Dqj/YS9HGFBmANalXvPkyTg+oI4sIc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G5fx9U++EQ0jMPz0XaK1rB6Xuam3vN98Hksjgyp+HxWHjMK8/uFexAxpx79gKX693
	 P/Sp+ms2F0PrStUy0RoSaLySj96SAViSyirU6AWGsqvT+KUeYOddWjSrGiL6QWXAKw
	 rUJGjN75NpSKqAxZ70iMt6029FWXQCoWRH0M+hpp5Da0O32vtbSPMnd0873wwHmgpr
	 FA/AtuNZhAqL0DIYFyZGKpLJocMJcVoL+aSBUMN7K/s80lTqxRBSV3ljkU5q9gCdR8
	 QR5uO710WdEZX89uZ6AnaWTeX029AApWQ8UqwqNpwH4SLUjHOuDipofGYtn6Qjx+Ci
	 nAFX+dxqkpsmg==
Date: Mon, 28 Oct 2024 10:51:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs_db: access arbitrary realtime blocks and extents
Message-ID: <20241028175146.GR2386201@frogsfrogsfrogs>
References: <172983773721.3041229.1240437778522879907.stgit@frogsfrogsfrogs>
 <172983773804.3041229.7516109047720839026.stgit@frogsfrogsfrogs>
 <Zx9Nmhag3cYuzy3e@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zx9Nmhag3cYuzy3e@infradead.org>

On Mon, Oct 28, 2024 at 01:38:50AM -0700, Christoph Hellwig wrote:
> > +	ASSERT(typtab[TYP_DATA].typnm == TYP_DATA);
> > +	set_rt_cur(&typtab[TYP_DATA], XFS_FSB_TO_BB(mp, rtbno), blkbb,
> > +			DB_RING_ADD, NULL);
> 
> xfs_rtb_to_daddr?
> 
> > +		rtbno = XFS_BB_TO_FSB(mp, iocur_top->off >> BBSHIFT);
> 
> xfs_daddr_to_rtb?

Yes to both.

--D
