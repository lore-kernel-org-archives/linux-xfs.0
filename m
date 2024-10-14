Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A50140E2E
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 08:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728893490; cv=none; b=Soy2N6oJxFyQtV7urW2K6hLHAGxVYQPNP2u6MQ+IcDvIXMRsruIr19QFaDcRN7H9fMXYCFSZBpvdRJ6Z8i/HmyYe/NGFcAHtuaJXS4aqMpBl6SgTp/3BNa2vHpW3Om0loMVJdWTuVdu08tBq8nPjiZjzYqEKu8RD0vCDRhHf+NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728893490; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PQRQI1DQj6M18ecZDYOT9qIpkKtvagC5PNrKdi7lHr1s8J8HhpDdmkeEbOY9j6kl6+VayNqVRn/tAanYv+KhNFSVoR7/7MytWxNA8lYemnzL/9SlpmvHiYYWSiH/fjZxcsJeivGkQegsbRzmw/zIVck7I3oV70kRvBWYTnk7rIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SVMoQX3y; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SVMoQX3y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=SVMoQX3ycg8irGRXwKPH2uTc4b
	m2B0rSy8iTTm0tqoX2+1sh+ZK+V5LrNb4OvcqT5qXK6QbkJ1dAU7keIBwBPLWYbqIbBxikewbqJ5A
	A7Tg+mRwXFlnaOBSLi/UONdq41sQ8lwSoxRaWN5+vcTTUPvEFYVkRY2Xe+JABR8OQW5ZzhN34ZsQq
	Rsm4XAVayDTHuorL4w4s8+WtijNZM8uU71iXJWeYwEw/7JnELyns7+WzwMJ3RDVZcZOg1npmjNiBp
	cnFvc9EkKBocOVEUP5YyHVsC4LHcMCkXI9k4aB2+D2MNwuyqd0uzxM+j5qNBMFVBYS9e1d0yOFdeK
	lnt6hu8g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0GAq-00000004DVv-2xih;
	Mon, 14 Oct 2024 08:11:28 +0000
Date: Mon, 14 Oct 2024 01:11:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 33/36] xfs: move the min and max group block numbers to
 xfs_group
Message-ID: <ZwzSMGqQ8OfdmLYg@infradead.org>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
 <172860644812.4178701.7302557147054352474.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860644812.4178701.7302557147054352474.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
