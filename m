Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BDE387B29;
	Wed, 17 Dec 2025 10:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765967113; cv=none; b=RM4z/0nZpD5IhErMaywTVvvVho5MzCGDY93xB3MX5/vo87JhSFi6Jx9gl0Bwbk1j2QXH3QMw71V6pDnuNUrNuHyGEr2Gt7NYPO9esINzXnZda2uhJysaRtWgfKKgZw9ti13U286AvZ0aolfw6GfWCjXNbPXHsLr41fq0Z1dZjcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765967113; c=relaxed/simple;
	bh=Pb0j4dCJ2fyXl5MvjNhWT4QsGYjM8MvxdvpespVWVLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OcUjjLZHWImsHsvlixu/KqUtsf8vzIXLPX8wnqCoFuJI2jTvyvd5VRYmFKcGrW5p3tnG0/aXzZ1AGW9j9SXppjTtRyntmSOMC/JM6kH0+iOIjnyMFLZMOxEZkxM4KHksamTNctUNsoO1anFCE/fsYp4/5K6r+pV2hdhxLYIfZYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WJ5bvWe+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WJ5bvWe+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KLVf30kTD7z41p5OwfhOQe8fcJDkzS4OklSVdyFkSI4=; b=WJ5bvWe+5xCjdz+DmUAnBzaGiQ
	lFEbIvaHIBXMrPdBYaV79UM43JsajOnSL40eCTAYGqD+I/3LacrBIPMgr85ZvkSXVKKOBGzu44k3B
	q2iRkCuSv7bXQZv+HTafUsbog9a8APmX5ytgFEchJLHPSGspLg+ePBSjGkBwxviSGczX3/GAplHaF
	cfwSYieTuCpHsV4KfjGb9oaZSdNydWpxsAf8jciFAKMG3aNEbId4K9I3jmX4rYx5BTP+hLJ2oIgLS
	l7SCW4fuyBMSdUYJsWpO/ElHlc236k1uOQvZF1kNcQtFfHz+PQGxlhtVnRxABjn/gXRdDcutzLuUi
	fs0sGguw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVoiV-00000006dpH-3f5Y;
	Wed, 17 Dec 2025 10:25:11 +0000
Date: Wed, 17 Dec 2025 02:25:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/649: fix various problems
Message-ID: <aUKFBx09MGp4Z2bu@infradead.org>
References: <176590971706.3745129.3551344923809888340.stgit@frogsfrogsfrogs>
 <176590971773.3745129.6098946861687047333.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176590971773.3745129.6098946861687047333.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 16, 2025 at 10:29:56AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix a couple of problems with this new test:

It looks like this patch got dropped again?  While my git repository
has the commit ID, I can't find the test in the patches-in-queue or
for-next branches.

The changes themselves look sane to me.

