Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F49C8E0
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712729115; cv=none; b=GwK7TwstULImFbvQus/ZY1NAj7fiKi8jzO3TgBGgtiivoFdRuxYVCviGTMio+F5DbfFgUDuqfzl8I235QY7ddzWUAJk2eG6wBoQrU4jBgN5S/4OOPgEXT+5qLrZ5degabl6x6zbx8pE6fV1Pe29KRHP5m+YCiw+lKqalR5pn4CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712729115; c=relaxed/simple;
	bh=jiTH+E2B75eOCaIuHXDt/23jc413uuktyN4cuc/LDaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rO4LYr1IYY7mwopXaq9T7Og7qGzqAOR6FurgL9cFuukGCtgkKeS6T03YulOYfFe5iws0c2YAdF+BX4QYclH5LoUO9Nx7OZPDQ3QP/guCVLisCaiDnWwdYLPQztQIQ/keT/7wD/0O6W0enMM/9NM/E4V+me/2AfQ0TyvSjW+3Xas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=INeTRuDE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="INeTRuDE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dqdkbtAbgj3tCjlA8yJZDantsJC06WHDdC/9luVXbH8=; b=INeTRuDErdtnSVQhMm10fon+Pn
	XN8uI6eYCGGxAmWFPLzwAz4MhroduLZ4fdGaouM3TF9npjeb+Bu3gN8lej0Bd3hbW1SAfMUAle/4d
	FLv1hr5mb/xYBULAxsiasX3Pk6DLZDLOFQmVkljZfSgR43ujTVaJBRvF0CDRoSgK/TzhPOiNPYRSo
	SiWxSOCmk9LbQkNiTUW7XN4iqPuavogeo9aUv71U2/cKXOayTqi/qA4l0Ghy3/Lul/ZLgS8i6vSAk
	zoyIG5DqAgD6ArHKrBqkgpZfiidLeuKW6EWUwHN8bIm+Lr+9otPLUInT2QJx3JoXDAYYHTKuyuNeQ
	LIXci1uA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruR56-00000005IhP-2pDW;
	Wed, 10 Apr 2024 06:05:12 +0000
Date: Tue, 9 Apr 2024 23:05:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/32] xfs: Add the parent pointer support to the
 superblock version 5.
Message-ID: <ZhYsGGe431pONR9Z@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270970042.3631889.15727225239821945588.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270970042.3631889.15727225239821945588.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 09, 2024 at 06:01:04PM -0700, Darrick J. Wong wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> Add the parent pointer superblock flag so that we can actually mount
> filesystems with this feature enabled.

The subjcet reads a little weird.  What about

"add a incompat feature bit for parent pointers" ?

