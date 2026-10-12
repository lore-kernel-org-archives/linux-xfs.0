Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2C634F24E
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 13:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811305; cv=none; b=n8cxCmQtPDLqzTgtKc3DGdPs1cUfY5OiFtfAiMSZ7S5hzYBJX5h64zf3/CZvvwhgxrblifT/DzZOH/8zhRhXSvMJSXiQjEKtsb/Mw3aaghp0urNzH+icWsIPKEOOcSDNCkO3coQIdDjHzhw8zyoZBZDLzjw/1nbHCvJ9chhHdQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811305; c=relaxed/simple;
	bh=m1AzFScExkmgYncdyiKmEwqJvBCCvb9UDWQlE463Aqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gAzdWpCsdPEkqIYLHM2M/0T7H4GW95JPzWeIEjr80sOSb6wqACPWet30wloplCKwL2mcerGSNW2fb9v3n2nNJ98eO6GqyZqAmDLz9P1dalvhOsP2Eo03ofDpmMlk+397NfEDmQMkAvLj4naDK1OV7uamrx36ZePYp0AqrOy3Qd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=s8M0U1v6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="s8M0U1v6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wUxLY1B7edr8/bRmgkDg5WHXfxmfprlYwPCXp+JeX70=; b=s8M0U1v6pKC/frzJZDxRV/brCW
	37ISgdab1VWEIv+t8j4uTlfzzbOyPMi7JePx0aosm9pLQhNpE7Ow52jHJGvpf/8npcL2EwnoQ+Wlo
	QAD06ROP+/pReS3E1Tzumu+txqHhkIWYqotcHz+VJM1HT+xvBu2ACDBA2hAG8jct2L/AG9CAqks6v
	Xp1/RZghXeOlC+XlO1wwUVmGcuJBz+HRpgrjtpE651d747mo4+OC0hI/mL0jEOTCE6AmMczA6DCTO
	/15wVXrlSERnDkSJ/s0wU6duBQHetV8oYKvrs001YMf/vsKhiRBRVtKponDcJictKVPqZRKI3S0Zp
	qMkjjjZw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFyJ-0000000AYQU-3wx8;
	Mon, 12 Oct 2026 13:21:43 +0000
Date: Mon, 12 Oct 2026 06:21:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/26] xfs: hide b_flags manipulation from code outside
 of xfs_buf.c
Message-ID: <asze5x4ZrCI-Clss@infradead.org>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
 <179158947495.3719791.6891995032675051951.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179158947495.3719791.6891995032675051951.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Oct 09, 2026 at 04:47:27PM -0700, Darrick J. Wong wrote:
> +static inline void xfs_buf_set_uptodate(struct xfs_buf *bp)
> +{
> +	bp->b_flags |= LIBXFS_B_UPTODATE;
> +}

propagating the kernel flag to the libxfs one might be a good idea.
But please don't hide it in the resync, but make it an explicitly
documented separate patch so that it is properly described and
easily bisectable.

