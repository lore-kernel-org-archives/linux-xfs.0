Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CC13BFE5A;
	Mon, 25 May 2026 07:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779693192; cv=none; b=YiD4BPO6KiYF0//Z3ltmAVeXjIfIrJL2IcW9C4zi9I5UIQbLMZH05CKJh82BkxsfgMCzgqfDJm1Q83In84XQ5gF9DOPSwN2JCu6houpRLHmaMLBF3P1qismmSeVeWAI+D3LW+Ib8xp5NIQki8gq346crPF/Ggjrk2ryDcchdfcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779693192; c=relaxed/simple;
	bh=FS5ThuxsvmIuClkshV+avduWtQeuuHgNW8Ws9Gcbb7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G5jfVLDrwTJfYb7NNK5iHyqgDLwuIBJ+nRBki2xkWMkHi44ied2q1XvkQ+ESuwRC9m4nEgRA0CiPj7vcoMkNVgpOg9Ct+eWYEm/0CrL3AKUYSjWziaaJKQ9FH5KlPOInKAgG+xDWMktLUsmI1zkM48r9L28LCgNl+Wbhh1qdwnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rja6ZMgw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rja6ZMgw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=J+0lw6yfGWbYib4LjYGQU8KARgYeOuTXyg6uoz1irQ0=; b=rja6ZMgwmYky+Mgp3cOdXeyx1e
	BWeT3Dll/ki7OhlFpBcbMZUinH5ZAdARDxNfcaYorr5hdha1ZmpqsjV2AZtvooTbwix9xU+Qt1cGX
	f20cVi1CL6K1T2wq5wvN+v+mmk5jxvZTOrU3TGNB8a0AmHwJY1+iDiPIViCXsd/YqYDGlXj/4mQAa
	iNYS/iNzCk+jDDD4E9ybBwQucdVLe0ZXpXJ6HX14XmesUwdgFqPSrlBuCQGNlDceCsRox81VQ8VVD
	FKFY/ikLOxUPiZxa9Gjm3AiiXRkvQcHewhCnhQllKIyVN9ieSKgzJ6bUKEO5DQkebUtTspjL2i4jY
	iPAyGYew==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRPUs-0000000GVL4-446x;
	Mon, 25 May 2026 07:13:10 +0000
Date: Mon, 25 May 2026 00:13:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, amir73il@gmail.com,
	zlang@redhat.com
Subject: Re: [PATCH v5 05/10] fstests: verify f_fsid for cloned filesystems
Message-ID: <ahP2hjv9zl_WL1kg@infradead.org>
References: <cover.1779367627.git.asj@kernel.org>
 <a24645463979d0550e0010030995b0ed609215c1.1779367627.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a24645463979d0550e0010030995b0ed609215c1.1779367627.git.asj@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, May 21, 2026 at 08:54:55PM +0800, Anand Jain wrote:
> +[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
> +	"btrfs: use on-disk uuid for s_uuid in temp_fsid mounts"
> +[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
> +	"btrfs: derive f_fsid from on-disk fsuuid and dev_t"

Seems like these are stuck on the btrfs list.  Any progress on that?

