Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B97335C6A5;
	Thu, 24 Sep 2026 05:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790228975; cv=none; b=ljK8lXrXaYe6HFRKYZc28NCq6h6CvE5VLmI5c6PAP3a9hIbl0R6+3Rsj1w6otLLETtr72EKV25PPZmmZiyPjFB+V85FOSrGJQVqDIiK2ChXiYOG9gVQsdPh5lyVnZ2FYN9P52FbD2pBAfAMKsEjlxfC0GgSeZpKEX1Ds21l/f4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790228975; c=relaxed/simple;
	bh=uZOd2/GpT31jfYjtMH4p5HOMHKAxTMU9bMl5toN9vZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LmKg8TPZiLO0Qv7hhWrMygRVHJHWaREKKR7y1/kwkNKKAmUyxTpobcKTlXgoY6Yj6twNYoBM5Lsp31pemszVCLjbGAevP58hhhWEm5q6kYoDT28D+JC1gBZRXXih7KZc7A0SbNkN6Er+QJ8HUFEVqYkez203a2UnJAbizHVDG9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fWwPlHRy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fWwPlHRy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=C2+C+WZyhdPnR+Xzj5TIE/BUJWcaJ2F/KQMC9qjwpVI=; b=fWwPlHRymDvpwcHfrJOv3uLLxo
	/4mh0Iam14TXmZG8V7Y8o90MkrAhSQ+7dW3FFmBxTwcy25isHwtRYQtcXKaetTs/GhW0L/1ABRm+W
	rBtpK7eYDPCWuaUr5o9Z/I1ItwO5Jua8EmEi3W58arNZS/HyTWoDF5WIU2jLpsSheTKNaYzBLfEdK
	BZAn8PKPyXCjzzPLlMcFUXcXDSZPKb59aksQ1r0wud7FyehBUKA53W1OxGymOlKCZvAN6vcV2cAdv
	AOqF4LGRxxhIPIc3CKHjwtGgnGl9RsTOhsngp4wAy4eP3u4Xvi0Csl1E7JWvVom2Y0wjsHs7zmgkm
	fPKa2Vcw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9cKo-0000000A5IX-28MO;
	Thu, 24 Sep 2026 05:49:30 +0000
Date: Wed, 23 Sep 2026 22:49:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] xfs: clear the symlink zapped flag if inline
 symlink is ok
Message-ID: <arS56qGams3qQ6qB@infradead.org>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
 <179014159607.1875436.4270560289215383490.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179014159607.1875436.4270560289215383490.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 22, 2026 at 11:01:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that we fail to clear the SYMLINK_ZAPPED flag if an inline
> symlink checks out ok, even after a repair.  Fix that.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

