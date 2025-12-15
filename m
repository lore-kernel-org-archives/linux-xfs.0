Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3734A31DD8A
	for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 05:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765777064; cv=none; b=Ow5MvQUbpX15dgiL/mMXULf3fysNBfdeQia2UQaHSXmZ3SOLVy1D5JY7DdYLLfp09r+sSCLuU724fYdQXGQBs2vu3tWf7ZkXw08bmbCxrix8u0STvUEHlszKEq83Yc7eNyiZP5o54sCwFQVLuQbYSDOEYr3Dh88YfRrUYRCDWQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765777064; c=relaxed/simple;
	bh=zmFT+efJnh/ZzOmiHI7RfX+m710EhRfULI9vkhW3+04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pYuGVA0G/+1gSEhKJ1PIWUFxEucg8qJsD9l2WZj6UKIgifNJ6P8IxtsixwZXGz4IyA+e5iN0ckkNGJ8lbYxF/v46R2MsQ6ZNmzTb0XDAFqjdPDLzOqNEDGY3b1fOrmDccbs/hToSgurC+ndwCwR6xqqMbhqwe8wVw7SDjfNWdyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=upN9JNeY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="upN9JNeY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zmFT+efJnh/ZzOmiHI7RfX+m710EhRfULI9vkhW3+04=; b=upN9JNeY90EHqZZ1YuH2cAEF5E
	ydAdgZpw5pwCXlw+Hwz1dUGAgtScobPa8mX4j5zCGl5MtCiHxOZs1xJKhf4zyYmemKIS+teCOdGBT
	SGh9sM9flfx6U9+iOiySkuk4mG3oq5XYTnzYYSPZijOa+WLGCAontGxSJNFDoeYwpKdKxwVThIMI7
	kW2f7PBA16uASAlo1S7RulkoyYiFeJRwn6xUbmrHeXlQwz2uUNnhLMA7z1cXpF1zjo0NUdE+CxvhG
	fS+feFBntiSPLXZ7SJK0X0+odIdxnLUSPaQi18H0Tj0m3GuSi0eT4crcpebTzmbV/GV2lPy8MhsiJ
	v7ziihug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vV1H9-000000037UX-425O;
	Mon, 15 Dec 2025 05:37:40 +0000
Date: Sun, 14 Dec 2025 21:37:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ye Bin <yebin@huaweicloud.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, chandan.babu@oracle.com,
	dchinner@redhat.com, yebin10@huawei.com
Subject: Re: [PATCH 0/2] Fix two issues about swapext
Message-ID: <aT-eo76enT15FKkr@infradead.org>
References: <20251213035951.2237214-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251213035951.2237214-1-yebin@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Can you add a sentence or two here how you found the issue?

Any chance you could add a reproducer to xfstests?

