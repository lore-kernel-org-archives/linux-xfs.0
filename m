Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124951AF0DC;
	Wed, 19 Feb 2025 05:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739944629; cv=none; b=UA9wiqLudwOy0Wv2aWAMZMgMymi6Z48Ayu/JawugDkXfMRl1u8/3oBdWoFdW3pmwFuvMMmccRnqlw9AId1Os3uxS9l21JzdgL85rB9EQlFRWwyB2bWTI140LEcn0JAw4fYg/wxnoIwoQXZ4HLDUD049IsHOGHqE6nCLLG4Gk1W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739944629; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mEJ91p3Xd/3NR16E4JhTgNaS94E6JJUUq5CtaJM3MBOkV/uVtJJxMTd+At6lutdMx1FcuV9avAp9vh4j5p7gTnAEUCmxYwZ/IB6USvLWY+UmoUnJcMT4KWnW9EQ5AO16g00I5qLu6luWRNqip4pemF3d0wRNpDJF8/zoqT5WO7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hiboUxX8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hiboUxX8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=hiboUxX8/z9HHXl4vgXQnkx9PW
	oUvOYxSJi2XhKfdHvLqbgfeyWDnjmwWpi18s0XOEYTkJod1Zvu336H1D8AYR7ziD69FZrGXTWvGwN
	ARcxztetTYCJVWHnl5foakI82ayEQ+eGmhGt9YYuxOyI1bAl9nLDfAv8QDr6RTXlE96au5gBXsE9p
	gL5EX+Ab7psea2EHIHL5NqH8hTkelQEkML5FomDrVff4oJq9X5QXV4T4/LkroM198Ev24qy1gg9Jg
	TpZi7Pz0fHNP2xfiuJlnJ3AFxZ8+Gr02V2dT754ywHt/M65Lc5sqQSZZdXLgIjqS0i9tI2C1kFh/5
	gCU3y7uw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkd51-0000000Ay3K-2MnQ;
	Wed, 19 Feb 2025 05:57:07 +0000
Date: Tue, 18 Feb 2025 21:57:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 03/12] misc: rename the dangerous_online_repair group to
 fuzzers_online_repair
Message-ID: <Z7Vys5H3uSkhcDUS@infradead.org>
References: <173992587345.4078254.10329522794097667782.stgit@frogsfrogsfrogs>
 <173992587458.4078254.18086350374208102213.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992587458.4078254.18086350374208102213.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

