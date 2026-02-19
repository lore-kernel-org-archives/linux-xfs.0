Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65592E612E;
	Thu, 19 Feb 2026 06:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771481592; cv=none; b=DvLoLZsALyg+7ibpLRFwQv1ljm5v4cn+jTvDRPO0Iq2ErjZWjVOWg5VPXqZbij0aKXipo9q8vAYRKuPFg/JZNUzxp75/arUnGPU+cvEaE5MbWejbId/gJY71YLoCnfw+U9Ee/zwDgEb4DoANLp9NxB214l3h+vUgzhnnkiOn180=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771481592; c=relaxed/simple;
	bh=RxxxdfajEHaI/jju8/9cJREhGRV8kr/Qg86lvf/4xV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wf9nnIiHFnipwOuE/h5av1/SghwXELrGmyHRtbKUrlbBQDavXSdZD1q7oYNPJrCFQ06t1o4PaTq7kfoxDbj7zHihUmoxng2Awl+gU8jF/z9bKuhsHB28kri8nw9OYNEty8KcomM4wSjio4CCADJSFjN9697RvIlPC1VGOY39rtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=A+KTc/gW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A+KTc/gW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xdl6iGsitpaEc6UBImuJONbK/SeMmcaNZ/i2PmSgABQ=; b=A+KTc/gWcEdFzmCgOPIZdl7Ybo
	Mhf1Gk5c4eQ+VkkxwcrHiD8lpajTRKFGf4GiKWZpg3nrdCVmn2VogdWfeY5e2yveq1nivX0erq4P3
	nVJZPAOExAZ38sSRZGKyo3EPXN1pgKtjj9EWenOuOL4aI43CyzA0B+hUQe6RwntW+HWWMIS0C3Roy
	2QYrxdPSZGgJblAHhQc/dMOFlHGQzWNlKzqqLGXEpm3tokGM/4vJsvT+Eu6w5SU2UXsgqbRVIrTR5
	j3KdjYw3MuYNVg3bAFBto6V/7mta6Ua4rPOiTfzirwWz8dJxrn0n9pm9qerLEm4pzHuMGJP48IKg0
	PjiBuiGg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsxHh-0000000AwoJ-0cTr;
	Thu, 19 Feb 2026 06:13:09 +0000
Date: Wed, 18 Feb 2026 22:13:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
Cc: djwong@kernel.org, hch@infradead.org, cem@kernel.org,
	david@fromorbit.com, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, nirjhar.roy.lists@gmail.com,
	hsiangkao@linux.alibaba.com
Subject: Re: [RFC v1 1/4] xfs: Re-introduce xg_active_wq field in struct
 xfs_group
Message-ID: <aZap9Qa6lKW6j3rC@infradead.org>
References: <cover.1771418537.git.nirjhar.roy.lists@gmail.com>
 <da5ba9783ebf0641e2edd4229162f5c138e0a3d1.1771418537.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da5ba9783ebf0641e2edd4229162f5c138e0a3d1.1771418537.git.nirjhar.roy.lists@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 19, 2026 at 11:33:51AM +0530, Nirjhar Roy (IBM) wrote:
> The reason for this change is that the online shrink code will wait
> for all the active references to come down to zero before actually
> starting the shrink process (only if the number of rtextents that
> we are trying to remove is worth 1 or more rtgroups).

I'll look over the actual usage, but please try to avoid bloating
structures for very rare uses like this.  I think this would be a
perfect candidate for wait_var_event / wake_up_var.

