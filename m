Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1391674045;
	Wed, 19 Jun 2024 06:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777844; cv=none; b=PBWqZcZqHIvO0xcMe1AMvaj9EaeDTw8gLIV08fvheOc6mfZSiY48XhYabzWJiXG0iGFApA/PuhT3UsZlrfEe2KY58XRJvjiKBiDupgZuvDe/wj5lPZ+mzNmQkX9RR52MG0FPqt6A2pG5oURdVivnrSIVW0ZPtfaWtCQAymEdMhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777844; c=relaxed/simple;
	bh=09g2woHmRkasxAJ6FXQxMMuMs4vFkq9WmvobphN67WM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AV+WFM5E74uchZc2sU7h7CxzNix5QK4xwqhymhrKOe1K/PcIAjGIJVsx1VO26mkHm7DvwDeGFIFdkxkeaa2KnR+7qAeVEtTuyxFOfBJP6uKGnsweFBByO6cyE5OOjh8pEUxR9MA8k6LHFgrifr91HRJG3UQH7LbmHjtvouVEwpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DkoKe7pd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DkoKe7pd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=09g2woHmRkasxAJ6FXQxMMuMs4vFkq9WmvobphN67WM=; b=DkoKe7pdG4wPMcFHi4DDb6Cw+T
	jiZexc3UKik+mYgeA7n6EJiAge03BwjgYte7pnSYPmvnU04d9NxLGDVG8SZEBviwTctmnRobMozHr
	uveVwBIVC71NcmuxcInME/+dCCxIsqrHhoaLnrrH+Ct4YLznBwgs2b+lwv+HdJ0LHYqGf/X8kL4Gi
	xlfz+5+QR6AQ50I1SP4ryHjsqFMJUeCp7gHZI6KCZ8k0ScHIfFVGEcsPOTKoHQCIXLgpOaQwiQDBt
	F+Zn9h/yq/JOBgoUAwSKAtIbQAHqJ7KCbbg8HCG50xP1SOocGbMfbA8cdpEG7Ys0+KMIs2RunR6ka
	XAzDCacw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJodE-00000000239-1HUG;
	Wed, 19 Jun 2024 06:17:20 +0000
Date: Tue, 18 Jun 2024 23:17:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, Allison Henderson <allison.henderson@oracle.com>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/11] common: add helpers for parent pointer tests
Message-ID: <ZnJ38HnvfHRbZR-s@infradead.org>
References: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
 <171867145930.793846.17850395645232280136.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867145930.793846.17850395645232280136.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +++ b/common/parent

Should the file and functions have an xfs_ prefix as it's all about
xfs parent pointers, which won't be portable to other file systems?

Or maybe just merge it into common/xfs?

