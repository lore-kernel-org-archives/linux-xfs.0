Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C26417365;
	Mon, 13 Jul 2026 13:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783949696; cv=none; b=V5LfjE1OUzpM9A5Ali4ZftJ3BNdNl6GQB3pzR3pUeoxG/VrDmIYWjkdeTr9ZaaUMifY3DSQPRe/Q+jaF+5g2L9FRoGLYVHthlywRokraBeBZ/va+HK0hJ+J3razgW/zkutioC+UVtziix/h6WPEaFwuRtf+1ZwWmTYPwu1zQqOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783949696; c=relaxed/simple;
	bh=Ihl7Zv+S8lK2Qbl8pS4ZerKVP3FF4zAqyi+O0CbW+DA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Umd7xLqLOdO+oeHtnqlXZcBY0kSLW6573DYf+1lMrNO4m+D/Cia43jaFlaQ9PDkBv0xVUJOvRTnBOuzfMtH2XhqcRGSW919uBG1cQ1izk0f5kN2UKB+ZLRgO9YLJKZaVCihJE9fKiu7fijWqsxENnbrUm0gHtLeRMKE3o+l4WDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C31BE68C4E; Mon, 13 Jul 2026 15:34:49 +0200 (CEST)
Date: Mon, 13 Jul 2026 15:34:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: Pankaj Raghav <pankaj.raghav@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>, Zhang Yi <yi.zhang@huaweicloud.com>,
	Pankaj Raghav <p.raghav@samsung.com>, zlang@kernel.org,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
	djwong@kernel.org, yi.zhang@huawei.com,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH v2] generic/795: add unaligned boundary test cases for
 WRITE_ZEROES
Message-ID: <20260713133449.GA26357@lst.de>
References: <20260709083048.3849610-1-p.raghav@samsung.com> <1adabe60-17d5-49ff-a6e6-33f90debf6fe@huaweicloud.com> <20260713100414.GA11013@lst.de> <db3ed600-8a4a-4932-9e4e-2f5a5d27cdd9@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db3ed600-8a4a-4932-9e4e-2f5a5d27cdd9@linux.dev>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 13, 2026 at 03:21:36PM +0200, Pankaj Raghav wrote:
> What about adding an option to io/filemap.c to take a flag that allows calling
> fiemap without FIEMAP_FLAG_SYNC? So this test could depend on xfs_io fiemap command
> with the flag support enabled? I can revert this test to the previous version which uses
> xfs io fiemap instead of filefrag.

That could work, and adding this flag would be useful in general.

It still has the issue that we require bleeding edge tools, but at least
feature detection for the flag would be easy.

