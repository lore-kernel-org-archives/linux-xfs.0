Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6325F18C03F
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 07:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734074190; cv=none; b=bzMwmDulvNG8N/+56H2rpMlUqYvZOxyBAo0KLpYp3t5Dewpt/fg0H+e2Ku90lSMq+jvBhiKKPqFfhMGYYQ5Rrogcs244kWyBBgDywsbR5Y1XoTQ/5igyBsCKNBAXDTBljdO9wo2YKV9gknA3lWXZq+x4f2VJrsIjqdgR8DDlK74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734074190; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rtQUmvvMH9DEuXWHmnW7E8NPhbJxYnRwXalvj+WiB4lBqTaxUtfLSFDRQUAy2bNWZWYesccPJwa8eo1P3UOzIyU4Hq9C3xsWJTSM/JxK5lOCHokzk/FYTTH6NBVF4EwockvtG3ixtbAy50adTwSlOzHHqXqaldYeuJOnGOlIQgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yr3/jKWv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yr3/jKWv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=yr3/jKWvCQ+fAPgRsp1mnCdDj7
	Nf3Dt4DuNf42SkL0SFWYf8GA/AmK+gOz1PgQdq1eCI5cGNx38rS//1jJ+BQTM1B0F/uL7fHmcW33n
	FGCIpuyWhdy+EeVkB9S8kgJYwndKl1rXjHWHzJERrfTwCFA8+pk7z51B19qXhk088QY41TncJxSFg
	RbvooB9JxH7Ci9jDYXuIwGwpfhrS9ToVM0hIIMg9siyF/AoUCOep5vcVwQIu0vznM6NKLu8iuLIrE
	krb3I3T/uED/dkl+Ys7PxojbBWgtAo2mbJtDYCmI1QPzgKSdicjfZa4bgjDozjgAqaGlP8LH2pkVv
	Y6aF+Huw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLzuV-00000002waP-3hTS;
	Fri, 13 Dec 2024 07:16:27 +0000
Date: Thu, 12 Dec 2024 23:16:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/37] xfs: cross-reference the realtime rmapbt
Message-ID: <Z1vfS_QIoCBLy8c7@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123710.1181370.7451351485334242968.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123710.1181370.7451351485334242968.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

