Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5824BD26A
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PllDNpqL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4yhgIXbGIOcDyh2Mco+QVQ80qmJNH1iJL+E7tvL5OFw=; b=PllDNpqLEP0HXEcgTUjeYRNDtu
	CjH/kY2s0ZeUM7vtUSuolaJ0TH49+R8/fnu1Yy5LwxN70+bF8+MkFdMq3qAH1K8qKhsPoRm/dvcbk
	u3cYpo80Elx3pJqT7Oz3/9BJotZGoSpmiWkgtg8GiverZx6CnS4n+bR/LbanlIwSOI1QU55yBLfGh
	wywr9WJ48tR+brCRMuvJQfO593CBzVmuNe3LYHx+rp1tQ7oeteO5aX/AGXf9Toe+zDVmoOrPV66A8
	yOv8cwCElqPmTzGqkVrfuZrnqlbOiHag32qRSoRNl8te8URd2xQ/QDojO5YHF6cQNCnCqk1t+C7oA
	CSYtPgyw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKbwz-007aJ0-0l;
	Tue, 02 Jan 2024 10:24:45 +0000
Date: Tue, 2 Jan 2024 02:24:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: speed up xfs_iwalk_adjust_start a little bit
Message-ID: <ZZPkbX55ytrI3raP@infradead.org>
References: <170404826492.1747630.1053076578437373265.stgit@frogsfrogsfrogs>
 <170404826523.1747630.4260188331032209988.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404826523.1747630.4260188331032209988.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 12:04:42PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Replace the open-coded loop that recomputes freecount with a single call
> to a bit weight function.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
