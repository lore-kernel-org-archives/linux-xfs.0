Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDF222616F
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 06:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733812179; cv=none; b=hp7LpL7+i5wtrGFJOkTqZ8imOsvG+8G25Iud2cmWgsCnnI4wSjMhuEe+3ydtIMTX8dkRYNgNpW61CFzclcj6zVs5NzFYMkPzfHWHEB/PDyQoeq/rsqdhZBPwjcFbR28ElHTw1j8w27N7GQH9/cTSyxJOM0cNVjYRKFQLmhL5EF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733812179; c=relaxed/simple;
	bh=sIYvvzP7MXyVqhKUpgOxYyKqQxitwjS+8xrVK5K/l1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZHnltbvQSNxlhNWaTOZq9sl8v8ZwU8/sPAEgYvnTLyN1lu8ZfIpxQS+95FyKR74g5Ewvv50g/LjZ5Cz5Z9+LASOexQJ2w1+Oi4wxoM61EvYL1A2lmyjLLWCR3i5KunpDiRtq0Rg/L9vKPhVHzKHVqnqhpGbReTT4kKyJeaoE+/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hS8Sa8H8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hS8Sa8H8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sIYvvzP7MXyVqhKUpgOxYyKqQxitwjS+8xrVK5K/l1o=; b=hS8Sa8H8ubK+ojQu+3Rl3xb796
	sJRsjiMvP1ZnebbcY/QVK8kVkh8har+z+AaEnZMAA2EyB/3SnCSHnwXlmPQ4tbSm8lVZUoiIZ9xGT
	N1no4amnMQpUJyWkJ2qOrPRhaDv658hLqN27kIB+7B6zlWYhks8s6qjP+Ly8316jmHnboJpFw3g0v
	VyeSQxaRBSC0QMk5IKtQ8XcvZjOviUY9dmnIf57rGyoYAPUxX56sZCW68oylLB/3gWZPRFHudcU4v
	hfyYLkfG0uQ9Ky7woul3aDZIn6nXGEm74u1PsuTINW/Gtj59tKwyEVq60kGi2fDMcOYU8PqJHGMJp
	KppoGMjA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKtkW-0000000AQG6-1RnP;
	Tue, 10 Dec 2024 06:29:36 +0000
Date: Mon, 9 Dec 2024 22:29:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, leo.lilong@huawei.com, brauner@kernel.org,
	dchinner@redhat.com, jlayton@kernel.org, cem@kernel.org,
	josef@toxicpanda.com, rdunlap@infradead.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 5/9] xfsprogs: new code for 6.13
Message-ID: <Z1ff0OULfewHrBv0@infradead.org>
References: <20241206232259.GO7837@frogsfrogsfrogs>
 <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The entire resync looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

