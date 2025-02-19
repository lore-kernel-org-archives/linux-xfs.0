Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89031AF0DC;
	Wed, 19 Feb 2025 05:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739944595; cv=none; b=XWJ1N199cnOszzEN6WgLRg8cTBjgv/eKzjsiREJT3WReu9ngVvrixGbjvjbJRI9rlt1tq+DDK+ggDNB5n2zBKLso6eEv0zSb7eeaOyKpw6CgLf0VLmGRZan9RRwR7CiD+PJL0wiN4JUEHykEeE3NSraaD6iVdT/zxDRjDSpCzFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739944595; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sHiWu6BFTD/z0cDplMPiGnVxmOkh3LCkZHJn8P6wBHJCOkk0dbTqR5ne4wjscmEsbhiQUnfLYg0OKjbYMtKxEnAM12OAK4xDFg4L1yinKwZUuZEpV11PIhbvEmU8MzmqxJslEt0e7QWpaWTWrNICk1NeP1K5rYup4LlZv+gXL8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zuQZZvUj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zuQZZvUj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=zuQZZvUjOZPswrOLou6DV0AF29
	oc8YM5z+RrlDtt4hCviNpkfixC4THmJvtRLIHuNb0Cb4fLYvydECABbtc0mlDuql7r9H+zVckMcyt
	yuoo4R0FhN7UUhlp2NA5wZnnl0vudQ9VGi26iLMWWWpR7mpPaCj/2I3eYUd8OG4qynH1MnHgLtN10
	OOc7EdaLDaJFYhV8fV2hrg41kRhzvWU6Tn1SmYhN1skDCOAMYUfmksFxxzzdtYb4wGRKqOzOxm2yW
	ohcFoDYJMQPrY3b3ln8hoNnRZ4Wu5/qu/0mMfBASDSnHpYpshoW3z5I5G5xE0sXLH0+vD9BIXXh5G
	ISh/mCgQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkd4T-0000000Axyb-1Xcj;
	Wed, 19 Feb 2025 05:56:33 +0000
Date: Tue, 18 Feb 2025 21:56:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 01/12] misc: drop the dangerous label from xfs_scrub
 fsstress tests
Message-ID: <Z7VykSK2esnAjnms@infradead.org>
References: <173992587345.4078254.10329522794097667782.stgit@frogsfrogsfrogs>
 <173992587421.4078254.643040435477009688.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992587421.4078254.643040435477009688.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

