Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA7C20B2E
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 04:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712724097; cv=none; b=hEAZGSscki+dC5PJt+Gup5EXrhRLh+bTnb2qlhFKh7lJp06XPFQxGE87J9sfU1fZsGecTe8yILfzbzrofBHztOY5GWUSJaL1t5PUw0rcN9AIZFX7610L1fWjOxImG6z5peCvUQN9q/u7k/gQYEULgPeYunZt+Z0C3ozf5qfz7No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712724097; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h9ekcjJIsvWUAtr/DpYE3M9HrqebE4c911rxde1ZhbdCAMlAENAoGuMMKrLFnxxXnNv0WcIcQIu/7fsMwh4hHQ8ldQ6iJHyJbzLIrrDOZ7vyPxBlyhPIsP2TuTNSYeIaM+W+VSn84aQWKhgOhHWzxNWc+9xOVLsNJnGU6QgOojI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Bxnh8GIj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Bxnh8GIj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Bxnh8GIjwNpQUHNsO8cG3Vjfon
	GkFlYMwvwLUYQlbvJI6SE01vbSWZ8Cqxw8G+lQSn/eIahUtfZm440/Hm17GsWvQQ4pS0FKxeL+KCp
	We1BvPPq7BIq7Sx/2San6jNWlMym8xSnTLGEpleJTKj8YYmGWUEpoTHLU3MiyJKPUclRsPaJuiTo+
	MZcm42+iHa9PADLuVJch98YIjH6GTcf2nvRmIANInDxLXe3F3XfyXZkwjGMqB+i2pgqwpXp9x0jrz
	Pk9YGgbrPi2J07B93pABJsmJBUnwnykOQafMfjyLITSCSUKaI/h9NwkGwN5LnAp10xg3/gKP7w1HZ
	joQlDUmg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruPmB-000000053h5-1Y2S;
	Wed, 10 Apr 2024 04:41:35 +0000
Date: Tue, 9 Apr 2024 21:41:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	Catherine Hoang <catherine.hoang@oracle.com>, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: Hold inode locks in xfs_ialloc
Message-ID: <ZhYYf4Eq4V6qVIR0@infradead.org>
References: <171270967888.3631167.1528096915093261854.stgit@frogsfrogsfrogs>
 <171270967955.3631167.14088032466565972952.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270967955.3631167.14088032466565972952.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
