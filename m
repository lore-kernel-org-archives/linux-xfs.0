Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760BD1B85D0;
	Wed, 19 Feb 2025 05:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739944672; cv=none; b=OnrryzPtLWycwMhxPhWUD8DxOT7qbxHnz7pkIQlAtdQwl4+RrWIm0QRAI5Z4/H67kkNvwCxUJpaWDebyDrIypmozbaHseD1x6O/9HjObm1EeZ+OaQvs+HmP83T7M6kZyyaGYdTR/iYaBRokJtqaR8MysXJqO89YXCce99pwzpbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739944672; c=relaxed/simple;
	bh=UwC5ku2iu3V80ZQ3e/4GSlEvLJ9TacCFJA8x/N5KDRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V+zsQ1hrGnyB4AyvKmQOeYqxgMcbq6RUQs5hCE9L90Zps+4ZmJI6IvUL4VuJIqTAlcZKMP3uubRFM+DeCMZJRw77vcxHk1nH9JIJjC3SEM3ky/thTHrQbVwCk6pdYmZFTMHbHM0JImeRNaSLILuZtVxI0D+bwBhMMrO0s3eWAJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uAuAcC/b; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uAuAcC/b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5J1YIb1yBA/55VY+/szAu45JKQo4CSbDQhxW2YxkEWU=; b=uAuAcC/bFvQAjnkLIjomhkDBtW
	a9uweI4OlHiT6SZIt2sAT9uqqN+GB+kss/yKsXoxhLvxJ3ZnvtHER9NgysurCWhR8PlTZMh6ErWKD
	+IILF1q3SquAGDG0XIgvdHZfPXu0zcsbz01Qi37ikaqxhldgl7ZwQ5j3MrKXwc86Kjmz2X7+ObGHd
	z9q1t4HnMHGuPWMSrrd86lB8LeHlut2KYfma1tulb8Ucafg/tcjFTVQ8/vDQo+J9jym4ERWkiCmyd
	LxbTJwaiRr+hsTgYRhIhD+7iBBCQB8aLOphhMnHjGkG6zeI4Gc6qegm1CS3+lV5r1LCLhvE33HTIa
	UCScGs0w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkd5i-0000000Ay63-3xkQ;
	Wed, 19 Feb 2025 05:57:50 +0000
Date: Tue, 18 Feb 2025 21:57:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 04/12] misc: rename the dangerous_bothrepair group to
 fuzzers_bothrepair
Message-ID: <Z7Vy3uQjOJqrYtFD@infradead.org>
References: <173992587345.4078254.10329522794097667782.stgit@frogsfrogsfrogs>
 <173992587477.4078254.8323426815916976827.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992587477.4078254.8323426815916976827.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 18, 2025 at 04:51:22PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that online fsck has been in the upstream kernel for 8 months, I
> think it's stabilized enough that the scrub + repair functionality tests
> don't need to hide behind the "dangerous" label anymore.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

