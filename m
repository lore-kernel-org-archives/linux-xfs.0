Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78EE286AC
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712729646; cv=none; b=EHfmkZfBBXOXHJCulyyHze9FhMwL5E0IXR6tieB67Mrif/jaJ/qFD93H5AiV5o/vJZ8FwHADukxBS8ZRYEpuYMmQFhLUDalrWdBBxhgtUFYVwFwOpNpTqhR/AeNuGOmUYp83uwY7QqGdJkQYzjNCMCI5NF7akB3sz+3N/NUCAiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712729646; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cJOcMb1RFnll0wmsg9X7tLzHen3jxLzVGYH9Dr+exB3TK8q4hONb/c8et/b/00VCN3v5irg4ebAHgp0tPrTvh04yEfdvh/9B0hO0LXdfEW6pMSzI4L8klYet+v9fMLvMwcg9FWnKDfevu+3iNUgHzPYRsLzpR0rETaEQBLNWla4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Krg2yulb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Krg2yulb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Krg2yulbvA+aoOQBBpgVDOpqlQ
	Gje4lrp2hsfT1Dm1kcD+kw1m0SVBM62tTst6lm8Um/8fVSOMmhffBMdLf7tc9BGvWS/9Ruey9Vtp5
	gyKIM5KKOM7jQOPfzB2/NliRL+u6v3SXIkSHuCXMwGkkpKaAI+y8AO8iEdnqh3tgluOFuxe3eIV2A
	E5qQnvnAYgLDz7FXZORk1ai9BBxmyEXyWbc/VkJnRYAOYMZZo8fs4n57TGI6XEn5eAuCKxbnBuiD5
	i49iRx/0IOnGwkbZkKiKvLEnHl8uWRuAZyC6vXY938InlMIYd6c+YwWdpR+HZrVDxtgkp8f/YiKIW
	bSINL2Ew==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruRDg-00000005Kqj-1DPd;
	Wed, 10 Apr 2024 06:14:04 +0000
Date: Tue, 9 Apr 2024 23:14:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: deferred scrub of parent pointers
Message-ID: <ZhYuLHKIRAFYRm1D@infradead.org>
References: <171270970449.3632713.16827511408040390390.stgit@frogsfrogsfrogs>
 <171270970533.3632713.1334905881423990253.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270970533.3632713.1334905881423990253.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

