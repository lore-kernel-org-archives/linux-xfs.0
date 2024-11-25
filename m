Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360382500DE;
	Mon, 25 Nov 2024 05:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732511808; cv=none; b=sbe8Gg83kPRkLpqMyvhZ3JthrNRJNJkZRiLPDeBdBD7ZuATX4om7Gqd+K0Z+vGATgB+ve5w8Vb6kCdd3bhyRjvgYr+ipymvCbektvDAd/RPwxjCZ687dbOMq0EiSW302Xxcg6oSWIDthWjk6MmyIdSiLdDIU/30R6e0UvSUvBag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732511808; c=relaxed/simple;
	bh=+1AAnvKsvzjB4HfOnQQsfkyV9kmvs/+6DA/fbUxlGDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=flYXpQSVgd8YENtkYFxQ+GTzuBSUouhBVA2cKTAZj+YRDu8FZh+e5gxSIeBkoCx4pr7KuJLExRQjwq7jR1/06IZop0Kbbu7kWicO9K3pq5ZYajWnsMsCdxXM3HPvm/cUcCQqhDlzqbyG8DWsp169YgndAQ7zj6QkEKeBXNbbYOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yVNK/zjf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yVNK/zjf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Xj7Q4hc7lJG+5vks50nmvB55EifD3Rwc2+pN6+1/0HA=; b=yVNK/zjfAP+xhA4yDb1Jh7XmMC
	bMBW1qIms4nEMaXzV7F5Q5bhYtE4QxcuhF8SdyNpmDmkuGHJS1RCTCQWNDEvByHPv7FUfBi2Z3+QD
	FXiPLm8MMvwzLmLCpzV5OmUn32w0eB0Nal64+NvQqgoQw7r1L8c5kDLqsdMGfNtohcPU9n511IlLr
	oA07TAP/pWWP17qvowj9+3HcNTFXjY9dEWEiiujwrARuVQwpTVDFhuUqG1Eo2DJTmPZ34ecnYVfOm
	wJzhl6EaqvbEO5oXMIDPyLGs2UKRJ7FpF6yO1JRb5PIF7lI2hG8ca8kLxBc0+bo8EW9fWpg9o1L12
	8uAkcpSg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFRSo-000000074ug-3mID;
	Mon, 25 Nov 2024 05:16:46 +0000
Date: Sun, 24 Nov 2024 21:16:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/17] generic/366: fix directio requirements checking
Message-ID: <Z0QIPvrmeUduX4FA@infradead.org>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
 <173229420269.358248.6325435085396026110.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173229420269.358248.6325435085396026110.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 22, 2024 at 08:54:53AM -0800, Darrick J. Wong wrote:
> -_require_odirect
> +_require_odirect 512	# see fio job1 config below

Hah, I did not know about this optional argument to
_require_odirect, which sounds pretty useful.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

