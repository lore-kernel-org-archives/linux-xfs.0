Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05EAF35B64C;
	Tue, 15 Sep 2026 06:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789453917; cv=none; b=FxplZUR9qu3V/X/XfNQJ2Y+pFx5oanVQTIZ+X48BsXnRv4ihIP/2zhmZy5NNNAH7FtMMF+DVFtDAgMpE15eXqi1c3TA50WrV+yzZZKFms6bykIAHtG31L4Z9OY8VbH92mOusCRds2MFt9TvmLyYoHIQcGYe3qhnJ+Pi8MJAyB+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789453917; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jekrnZluQnwKilzp2dh11A9ZDskwaNQKCZ37UrbiA1E4V5c4vTDsUFI8BVCwkYF3iXC1xGhF96dge6ZwjGWaUf87IIgVVNSdVB6gA/NxMJptkNtqIqfbTOVCSNsIsoHIkBL7cwHOU9+ChrcMy7oD21AIzib7BWTuEJkrDWCdZvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=S4TJ/K4V; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S4TJ/K4V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=S4TJ/K4VOwslWjEUWE8mWXVSPx
	7gXA3u03X+gCIbh+Up2hdNfqa64lBYWm5oAd4Rd4qgLouPH+mZUBanQlH+hlslU1oLRjY/jDEA6T9
	R98pgI3n26bbdFo1xAC7tRdhwURsL2VWR/GcM/5CPjcjyZpipJNDUVh4puRcBzeLM8ncg3dbHSigA
	pw/4eo1dbxKmmaEs38KAjYaIx+ez/RDKu/36Nfu0WfYnM0Icz/M4UIYGIUl0K8dQxOXIM6dtfhpAc
	aUa40RwFMFuQ2Oho6McZitr0rSUro9Z3AG03QqAjt/35omph4jRloylMpczh1/HvtIpOiRosKCj34
	4wupfWGA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6Mhv-00000005Leq-0kFl;
	Tue, 15 Sep 2026 06:31:55 +0000
Date: Mon, 14 Sep 2026 23:31:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/11] xfs: fix cursor and pointer handling when
 recovering iunlink buckets
Message-ID: <aqjmW9e0mbSEL3sZ@infradead.org>
References: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
 <178945048669.3061055.10490235412243530399.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178945048669.3061055.10490235412243530399.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

