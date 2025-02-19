Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767AC1C3C12;
	Wed, 19 Feb 2025 06:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739944805; cv=none; b=gqIQUl+DfT0j8qmoOvjgW2NoPv/C2ltGrCRpjVrP8MKCDqMGb7ij+CaVWTtdbIaVhvvA0AN2tNW/IYXL7FLM/Dxo8Y9Cn5Rwu0VQZzExy2qdl0rH70avgDwWYbNXrUMHgsHf5PaGRhD5PSambZsHkpWy5ADeiUdiE1u3t0vyi8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739944805; c=relaxed/simple;
	bh=SrAP5cxjpaf4qfxUs+pEN3r0LZ5prfV17SphOLrn058=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FkBNeSyhAMIaJoY+v6dEG8UD563sUujfN1wf8pAvhYcBkO0uj4L5rRlOGIllSE/V/nOXw6aYZ0cqYny/J8i+QlVmWV2LYL6OwQVT6xwvPm32Hu+RQWQF/a2rQefD8nNzbfwaxr0WD+B3PmIA3o3xklEdmj2nrrdtjKNOo1e1/nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Xk7v9MfS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Xk7v9MfS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CMnrkqRyrwpZ9oLL1PfQ7rkza2FZlrKSpHxp/+FsUYA=; b=Xk7v9MfS4ngEQHnNxDzBvJx2om
	3BPn75bwkvtCr0XJqeDmrDPoo9nEq4Vbj06+tHkHUS76KCRX/HxndOwxjgrb2LysWTZzjpIcBLS89
	ExSW1K3GgoJqzbZqyIDZ3kjJS5HYzYbtQaXqRocly5JWilZSC7higX6xG8amTH4ZdRLF9LQunRrRV
	Yy+Jv7gxz9F1+JXwiS65EX5pyEzjJtYJnxattRJs4L0JTmGwR2z+YiJX0lFLabIMLGmIpU9qvK/tF
	MNAUbYJL5xc8OofrUyvEAnzLvWm+Onq7cXC48OcyRPhEtxVoxhhdrR8J/BGDoHhuuASYcAhmYNnJU
	28Eo0adQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkd7r-0000000AyXO-3UJG;
	Wed, 19 Feb 2025 06:00:03 +0000
Date: Tue, 18 Feb 2025 22:00:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 10/12] misc: remove the dangerous_scrub group
Message-ID: <Z7VzY8rzwaDftY0c@infradead.org>
References: <173992587345.4078254.10329522794097667782.stgit@frogsfrogsfrogs>
 <173992587588.4078254.2278340733226774088.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992587588.4078254.2278340733226774088.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 18, 2025 at 04:52:56PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that online fsck has been in the upstream kernel for 8 months, I
> think it's stabilized enough that the scrub functionality tests don't
> need to hide behind the "dangerous" label anymore.  Move them all to the
> scrub group and delete the dangerous_scrub group.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

