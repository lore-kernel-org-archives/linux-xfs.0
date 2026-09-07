Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812C425B082
	for <linux-xfs@vger.kernel.org>; Mon,  7 Sep 2026 05:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788760768; cv=none; b=KUKIv3F/0c1sfgNsDwlQKpgXx0ZwKbb4v/nQZaaSMxkmsZlPQB1k5IrnUvuWtKUXa0uLFjZIZWc4RTg+5Y5GIa2FyFXUZhEQG1f5GrTY9scr/JW4U4adcSty+PHlpQRaj03dORtqxVflaaCDAYJm6BCSyfx0vlTNZBayDI5rqMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788760768; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rS3nxWltXt6FKumb4Uhf+9PNZD+Rf11yW/YTOFgUH+lRrqqfV7PHbZAlXlC1VOVSzL8EXc2pdry4DarzD1COZpRlw4AGeBg8c3uKWPmZcmJCRgITXvN4jVLzIK5QrgPtYjpftuL+ELzevlKOhxOR/LJ8Zph2BCxY4+m5JbZo5mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2AB4668D09; Mon,  7 Sep 2026 07:59:23 +0200 (CEST)
Date: Mon, 7 Sep 2026 07:59:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: report runtime failures in scrub
Message-ID: <20260907055922.GC31753@lst.de>
References: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs> <178850312561.1198660.15558855470989904766.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178850312561.1198660.15558855470989904766.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

