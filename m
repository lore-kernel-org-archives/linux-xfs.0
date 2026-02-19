Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FF1202997;
	Thu, 19 Feb 2026 06:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771483224; cv=none; b=b6V+rP89C9wH8ejxUM26GmXxQlo5nW0Rr/UaZ/n/kEiXjr6suK3WCqYR6q7/YFx/Q/b/j27EH/CzHmfSnbpHwWWFv+GGVARbfonKBZ4iTRB0Fg0O8dwW3h/r7uwqkieawpiCJUeFP6yteHUqhNXnjUz1m1+Me+VOtbz/nj1dfRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771483224; c=relaxed/simple;
	bh=4KUTUQkbcJ8cuYCZCwKOGoqCxDyU2WYPeMOSap8+VMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hjv7SCJfv1lx8kj9ntIBpTOZvMBRa2dqkoaogNraaEk+5uopiQxtpIKkl1k3+d+rpgiLalFsBc0Cm9A5kGiUirsyQvu18Oo+Q+OWffxH8IvWRTDMDYmeYvmv64G5HEEvFIEDgl6aML6A/g7pijAmt6GXX8+82MdgFkXygAq7BL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=negxqXjR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="negxqXjR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QbcmnG8HMLdnu7YbbjaFu5p2ZXs2xFNLsUjV23ti2AA=; b=negxqXjRZGNeScHlz9xMx0W8xW
	aT31wvnVXBnFLreT7OkqXEUdWY0kDT7wm3Z0Al482PEb9//vq0XgQ3Peh/SJNl8t693vht+cB4V8Z
	f7AS2lbKg1bSE+slQ3EIpqeYY9H811cQzVolAUxKZ6B4Hne6eFvkWMuMFJFNHfWXGbrPqYe0qF+jE
	4Sq7rgxkWhb1iTkX51Gdh0Ok4So3Ngjs98FHJYDQOWNmwHTtl4yBEpgwPYUqST0VvuXY+25UR2wYT
	gve9CqqFegmuX736MP/+p8L9JDGexAQk7ZhUXW63i6VqyUj//t788mMbybLbGK6D8QjeFRQzscmoU
	vfR6mVmA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsxi2-0000000Ayly-3NFN;
	Thu, 19 Feb 2026 06:40:22 +0000
Date: Wed, 18 Feb 2026 22:40:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
Cc: djwong@kernel.org, hch@infradead.org, cem@kernel.org,
	david@fromorbit.com, zlang@kernel.org, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, nirjhar.roy.lists@gmail.com,
	hsiangkao@linux.alibaba.com
Subject: Re: [PATCH v1 3/7] xfs: Add realtime group grow tests
Message-ID: <aZawVm-cjoyM7ErV@infradead.org>
References: <cover.1771425357.git.nirjhar.roy.lists@gmail.com>
 <f1230eca56f32e26b954be6684d1582dacf2aef6.1771425357.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1230eca56f32e26b954be6684d1582dacf2aef6.1771425357.git.nirjhar.roy.lists@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 19, 2026 at 06:10:51AM +0000, Nirjhar Roy (IBM) wrote:
> From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
> 
> Add unit tests to validate growth of realtime groups. This includes
> last rtgroup's partial growth case as well complete rtgroup addition.

Please tests these also with zoned rt devices.  They are a bit special
in that you can only grow (and in the future shrink) entire RTGs, and
don't have the bitmap/summary.  For some cases that might mean just
not running them (if they grow inside a RTG), and for others they might
need very minor tweaks.

