Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B35C3E7158
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772552975; cv=none; b=DNqAOjbzDqv5NJPbL9+dkQFnQC66NgPM7O1wwB6afopRdYfFmEFUgGirt/2Aqa3TeWW2HTv5nVPAuqYn3e0LQ9rns1JREcDTeoSgyl018rxHcKcLP7g8Of9GjWkbMEqe+kD+3vIu8bKC8N+sX3Slvy8sZJas2N3B7YrPFAC1Kns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772552975; c=relaxed/simple;
	bh=Vxu1qfFIgN1qOocAjpP3vFPSriuOZkmj/+SDoGdRR2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZZYEwPyqGyD2AMfK5fcSfPKoEgJcLyK0pqfP2DD7eB2XwyOai/wKNt29/CwwmOHHkmqma7YnNeSR6qm+zCIvnvlCfzURf7eoxLJfLgWIYf7tp52DIByvfFH7rCg9wQ+DS31yEHALQxkBfYk/yVj2SJ3txX+MBijQpBqg2bvCHbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PfOGGlIr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PfOGGlIr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Buu74u41vICdvAQiIxStiE+5/GgUvF0ZwGzIxNeXnzc=; b=PfOGGlIr2ya2As8WIPdxp1Kyl6
	mhvJCfuCVBigxBE3vZa1NY2jB6ohRHL9SaiiDWfna3zD0sbpWac3sEnP+OFCpLGeOK+duO6k8eg9X
	36FSQqud1wqHCwtZ7MSP+p8QzCKzTlcQFKL35crd6hNFM2ITQCcahuP1bbvR2efaVUtfU8wh+4/ZC
	+uhSoy9gmy1Jd2FD9WHlUKH/tSSWI7ojrn2Z3BjI0hOU1jT76ZazEpXU+McZ/qoLcGNq7IfNUKH9L
	DctXTXdKpXXkYmZ60pjH8MexRItQQaHjAeLDR4nDMrZJQj4EifhhaKwqxV2K80S7bIKN/rz4uzGZ5
	UjqPuB3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxS05-0000000FT3y-2eHC;
	Tue, 03 Mar 2026 15:49:33 +0000
Date: Tue, 3 Mar 2026 07:49:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/26] xfs_healer: create a service to start the
 per-mount healer service
Message-ID: <aacDDXudwf9ygIkQ@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783527.482027.17759904859193601740.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783527.482027.17759904859193601740.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +/* Start healer services for existing XFS mounts. */
> +static int
> +start_existing_mounts(
> +	int			mnt_ns_fd)
> +{
> +	struct mnt_id_req	req = {
> +		.size		= sizeof(struct mnt_id_req),
> +#ifdef HAVE_LISTMOUNT_NS_FD
> +		.mnt_ns_fd	= mnt_ns_fd,
> +#else
> +		.spare		= mnt_ns_fd,
> +#endif
> +		.mnt_id		= LSMT_ROOT,
> +	};
> +	uint64_t		mnt_ids[32];
> +	int			i;


> +	while ((ret = syscall(SYS_listmount, &req, &mnt_ids, 32, 0)) > 0) {

Should this use a wrapper so we can switch to the type safe libc
version once it becomes available?

