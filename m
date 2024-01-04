Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EB31F60C
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 07:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iUN4GsnR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Mbt7OJ9pJx9SRllnqDxD7oA2Gi2BNLitiVcuZfFdNng=; b=iUN4GsnRHaF1C9NDYmVBfnJr8V
	JZD8LPLdFdpptkxExHwEzFXiinA6svetJje9x/AGP8lxACIsYSRsnsInwz0DqHTO7jpCp9BXB6aMr
	oy76sDjJ22DoOh1Ksn7aPCVQOvdMOcAaFEWqAkGlF1WZcL/+k1seNBN+Ugkm1AR9Ow/IMKZbiofNM
	kKGoLy0Ew8+ELWqJz0U/RRwxYenJ4yc5rqT9FsvZiZe+JsF1fXJqJ1kLgtnBkkEpEr6CvMtSyC7Ul
	/3Fw1Bm7qBX/Erd2qHdpoZMvcU17Qh7QFVqy5K/KZdszAdZjl119+RBvXoub3Wh+l1rTby+ApgWDw
	vZVot1+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLIMI-00D6du-1F;
	Thu, 04 Jan 2024 07:41:42 +0000
Date: Wed, 3 Jan 2024 23:41:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	willy@infradead.org
Subject: Re: [PATCH 9/9] xfs: connect in-memory btrees to xfiles
Message-ID: <ZZZhNo9X8f2AAGjE@infradead.org>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
 <170404829726.1748854.1262147267981918901.stgit@frogsfrogsfrogs>
 <ZZZWFjy1fGwSCx7C@infradead.org>
 <20240104073217.GD361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104073217.GD361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 03, 2024 at 11:32:17PM -0800, Darrick J. Wong wrote:
> > Any reason this doesn't actually remove the page from shmem?
> 
> I think I skipped the shmem_truncate_range call because the next btree
> block allocation will re-use the page immediately.

Maybe add a comment explaining that?  Note that shmemfs pages once
dirties will keep space allocated for them in memory/swap until
explicitly punched out.
