Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5992054F2
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420822; cv=none; b=ko+/P6PW0hSrfGeKIs2Hlpq97I5Zbd68lApqL60Dufsbbs38AWTb9KU1LQnCJq6jmU2cmTzZ35rEKFh4M7FZp0KZz2EbGvFHxn1oPk2gNM84Epo2+nqtmCqRB4vUkZC5NDMST4vHfpQsh0nJaCtZ5o6EwyTdj7zgqR+dpr40qPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420822; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iRDPs6dlvWPLnMeyStT3qrzQP+zbASibEBL5uGGqRaoPbcQSf78ku19iMyghWaVwzW+ZBEJ5QXUpHq9dLN4B7PfUacuf+aq6Mrnq4zuTrHRqycT+Ng8i57XpEgDml5toa2ZuaGOx0Xah+LQpklp+/snk7cu95QbIaR+R7aTW85E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ox1EqeMd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ox1EqeMd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ox1EqeMd2UeWVK98jpakTivi1s
	zRW7G6xzH7sWkQhSoGVY1/uWUcXz54pQd1MkV50bMn+db746LdLl2BbKsTpkHLpR2InQdeokdlAUy
	jMVB/gWejXinsglPpoqxmFDnT86N33UvwHDI2fqIVE+WNmmgYhBoIQijxldxcYenzxwVmAddsdwuB
	LmwDNwKQzYOGQHR95MqWBGwyxGUJxZ7pYAn9KsMVAIcLUk12HJXtaZMfgfIVuTUd064rtUNzAuAJK
	7fsWJXhrsrIVW5zBgkHtNybXIyYGPDRTejnQfk6apaHWDoyGYm3OOFAnnWjzNXvFtkq84vZ/gfb5b
	arV+/xAw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQoW-00000009iIA-3uSP;
	Thu, 13 Feb 2025 04:27:01 +0000
Date: Wed, 12 Feb 2025 20:27:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/22] xfs_repair: rebuild the realtime refcount btree
Message-ID: <Z610lJOYLuSS2OVI@infradead.org>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
 <173888089192.2741962.1542453669085725843.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089192.2741962.1542453669085725843.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

