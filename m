Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9963B5C97
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 06:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706855464; cv=none; b=ay7shGzwWAGLpqCmEV+tiwSvyXC+rDDmYqxDCO8DVRvIxURY2WBOspanXU73iRhmMmhruiK/xJk84qoolBO8FNFWmlyJvZ+36HDpT+HyPWq98RkYxIsmRqAbUVtUb5fnk+nJ8MK6L3+Mtonv519fi8kM2JBSjayoiyqcCfyuncQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706855464; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YddxJb+V3PhjHi2anaR+xfFysWc9Vf8QLtwr3PPwpQWvRu2BMiT9IrsDbCuAE6saAXjwKsCgjYlo65jsbWGm0jCvUljramY76KjRN8yHCVkufjoHqnN1ogYiB4Kab7/VQ+6HrROTZAyE+zi0st3Yt9TZznDUXvx6iZckc1l4cD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=27RR02zv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="27RR02zv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=27RR02zvOT/rXdUlMQ7Ab4ACAC
	ylTzvBcaSGbuubT+ir8uqFa1nEEGSOaBbUvlW1xoJubpBsgby3+7WJ7+Fbir0sVgrvTw9COaEZRNv
	0kcluoFkylFTCRvOqu42ONagvDBRx76JAW1Z9/NnEC69wnHVb7jcxblj8DBW7VpxVXXP11I8Eglpe
	N5yX9G8B/Mc+GKVk1Mpu1xFAo/V669/KpVHX4yXzw+xm39fo86zcW0emxhLs0H3CqlpeGJIvty6lW
	ggpcKTqtBgcRA5wTKuziZZ2ApD+7xP405GmYaCNhCZOQwnJLyRCsYL/RFMeQ0R48Vud0kp/7BOfWt
	yWFFAzfw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rVn4p-0000000AQg1-0eN6;
	Fri, 02 Feb 2024 06:31:03 +0000
Date: Thu, 1 Feb 2024 22:31:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: create refcount bag structure for btree repairs
Message-ID: <ZbyMJxZ_LQM3M3A5@infradead.org>
References: <170681337865.1608752.14424093781022631293.stgit@frogsfrogsfrogs>
 <170681337904.1608752.3526552383569668536.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170681337904.1608752.3526552383569668536.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
