Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47956155C97;
	Mon, 28 Oct 2024 08:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730105169; cv=none; b=UISxIqAZngV75tF5psKEix87UwWzPKxQqX6GfKfHWbZF363ur/gOQrrA/HTdVxnRWJKdInsGnuNTit0yBrvZcOCeTq34In9B/94pBh00CVVKgVYxKpQYAAkeI19VxJ35V/wnpsxPwyE8R31Z1WaVpHGFm1bjFEjQfWB1hC3nmJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730105169; c=relaxed/simple;
	bh=DT5Z8NwxLC45AS1FrNU6H0wnUJXidFVC2HadheB6WZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uyz9irl30tQFQE3Cg5uoNAjeelQieZdy3rqTCmLYLfalA1pVTWtWpMBGcRPTmuIiBE27FvmrQSn9P6JexT8ld4q2x2ur2a2wYr1THIdimWP7Jq8aOFIAKi0qYij0GWTofYhrVWiugJVZUuJPk4xeAyjD159/wstruZhoS2KMCDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tqfWtU2i; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tqfWtU2i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PSVEt+Yn14egwFSxq65ySONtQXdCj00f5oq16aAgkkE=; b=tqfWtU2iNMtxUn06nxAvSnZ7ni
	ZEGxmxIIW/ovZV+h4Cs+KeKRKA/T5Aa1TgpLfrLTUoLULn+ibPJQCS88+RPNAX4w4zZ5k8G1D9R5A
	FhJrVyd2E7RKNaokrYHuPXManadu39eYcpnqn++/fRd2FgbtYKxGYHLQ01sDpA6H5/VTi9b2laH7W
	u6kKu4VVR08KzOLMzQ269StjQ6B9ZchczPKmlJTaAGbiiEQoUkIR8sh1mm5PDoS8NtIApzlm6qzBu
	2fbY084VFj9mdd1o1lMY/tulQUkb/D48gj+UpoOn4iiufF9qJaGcAH7zdWl7iUS6BYiBV69z6Due+
	LFvzExjA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t5LO2-0000000A8Ox-1dkD;
	Mon, 28 Oct 2024 08:46:06 +0000
Date: Mon, 28 Oct 2024 01:46:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: MottiKumar Babu <mottikumarbabu@gmail.com>
Cc: cem@kernel.org, djwong@kernel.org, chandanbabu@kernel.org,
	dchinner@redhat.com, zhangjiachen.jaycee@bytedance.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev, anupnewsmail@gmail.com,
	skhan@linuxfoundation.org
Subject: Re: [PATCH] Fix out-of-bounds access in xfs_bmapi_allocate by
 validating whichfork
Message-ID: <Zx9PTso9Me5es7He@infradead.org>
References: <20241027193541.14212-1-mottikumarbabu@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241027193541.14212-1-mottikumarbabu@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 28, 2024 at 01:05:27AM +0530, MottiKumar Babu wrote:
> This issue was reported by Coverity Scan.
> 
> Report:
> CID 1633175 Out-of-bounds access - Access of memory not owned by this buffer may cause crashes or incorrect computations.
> In xfs_bmapi_allocate: Out-of-bounds access to a buffer (CWE-119)
> 
> Signed-off-by: MottiKumar Babu <mottikumarbabu@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 36dd08d13293..6ff378d2d3d9 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4169,6 +4169,10 @@ xfs_bmapi_allocate(
>  		 * is not on the busy list.
>  		 */
>  		bma->datatype = XFS_ALLOC_NOBUSY;
> +		// Ensure whichfork is valid (0 or 1) before further checks
> +		if (whichfork < 0 || whichfork > 1) {
> +			return -EINVAL; // Invalid fork

How is this supposed to happen?

