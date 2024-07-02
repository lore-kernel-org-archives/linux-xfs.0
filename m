Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606492B9D8
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898957; cv=none; b=OMAenYduSkw7kZBekFwaUI3G44PGXX1DzozFnggT9YZ8LFEbxeEqbnZ5qKTErPEcXfkLZtyhRFNiN9xy/v4u7F5Y3t6ZnBgXUiR2aFW/58xgBkVOJtpemyY+MfFFgnJNQVUQjHWwjxY6qlbF3MOzzBaZCsd804ee6rHSHNhB9V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898957; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CxVvQmOBwSXZLpoO7m0AffMnr3kCln4fLollcWeTYtDLpRt+cQ/0zKQs5C4Ov6zox2jvpOFDe/bant7Dpq139Wpz/73B+WBx7WsmkiE2rNkHsaY1rEOkgvvIb/Uk6KgnopDlv5kg+IgWMiBxqYlqLtvEVB1IJBU+6/SlE1/kO1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7886B68B05; Tue,  2 Jul 2024 07:42:33 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:42:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 5/5] xfs_scrub_all: implement retry and backoff for
 dbus calls
Message-ID: <20240702054233.GE23338@lst.de>
References: <171988119806.2008718.11057954097670233571.stgit@frogsfrogsfrogs> <171988119890.2008718.14517701027636602626.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988119890.2008718.14517701027636602626.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
