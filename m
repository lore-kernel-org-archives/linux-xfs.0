Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E01B2054F2
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420739; cv=none; b=NTOxBFnwTloL45Of0ETb0e29chDiHV+yQcIYkIl4CqiG6Vpb0adzPz+kZ1iMnUJWfI2F2n9EUeJiIqHifofOtNeqdikzY3tPU6IwL6Z5LaN218Anj/m49dSmQh3A1+zjs2DECI7rFlWyfKLGDqulCmBD+XrIc87RsMpiZ/9nFfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420739; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I+PTfoMldL/wfiHnMUI4qo/3lX4QuDUePhJg4HnMSXlg6MZgF7fpE7+QW5hZuZQavXGixeCmxuCkS/AIoVJzoUIcL7XF7JKz9es4jaqTeRrtbOtfB7K08xV4fxyKF068iM/VQL+R4Rrq7b9uod2bBBaQjCHE3yGac60vvIWzlzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oRg81wU3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oRg81wU3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=oRg81wU3LvE09Uz9w5DBLQIjpA
	85dULSXNlJQIGQUHu4FEUZf98EOfKiMuR4eD/k3t5PCBX0hQRd0Bpc2lD2qpQFE7TUF0M45GM78mY
	Ir9r4CbhbCj8q5hqWbyo9k4GAbTmq3f4wf68Bouw5qwSCkXm2Ixp2IUaGTv37e8fZhG8O2pzvWPRn
	Ix9kx6wRl/bEQ5WaaBxdOiYpyeR6U2GZiwxVrC3w0a1ezcC6RyWNxVten4u9w/8az5qM9+MgcJBFu
	Pw85vIQ284QJcAlpm94pYtMlY1b9Ge8gQgFtrnP6FQ/SRejDyiD4g82by81pKldVsmUjBSj7aBJnB
	n5LIsGxA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQnB-00000009iD1-32FW;
	Thu, 13 Feb 2025 04:25:37 +0000
Date: Wed, 12 Feb 2025 20:25:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/22] xfs_repair: compute refcount data for the realtime
 groups
Message-ID: <Z610QT73wRQTO5Re@infradead.org>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
 <173888089146.2741962.17033508683404359801.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089146.2741962.17033508683404359801.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

