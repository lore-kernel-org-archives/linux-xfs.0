Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793698880;
	b=wBMKWilJbZqvKoAykKCSE57SPTgXOrBucu8OYYFaBhLD3eVqzJUut0p4GbwfJ04qU6xM
	 MN5CoClpx/+nHoI8fOkPB76dbx5KqvBrwlD6SHBAynwLgDXqu+LvqH5yo1ApW6kltKjSg
	 xcVmHPqO5zWI85G5NdawrFUq2NAFife9BW2PYB58sQ4++qUrXESfMGaIbtchHXoT3YCmo
	 DckS8n7GlvdXyeWj+M5E6QcH4CgFXMGN8SYmwfef1f9o8ZX3yewU9GRiqYxR9PXPgZN1f
	 CCY3HZCyKLYwdqK94eIOw7MkhMO3beo74dYl4GoLu8+a6b5qtXwbRIVJL5AiF61a0Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793698880;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=mecTDTVs5XTIo5shPImQxJvT/BhKqHbjaP97oQq8stw=;
	b=YiExMzuqxCEnqYVaXFlflALmz8/3mY06tZm0as0Mzl4LsRhWpIoFSGFW9cD5fSgRSiiQ
	 AZOR3ms0pDI8FvhfhJSx7Eje2qY9LXz2GnFbqLQKu8/ESsvhH/SD93YD6UgJhyIiSMCC6
	 WM30GeWMYmRA0kkpZYpXlBdBFRpZjDW1iDt6eb5VJusYa/pZ4T08olTtJKIY4esV9teUc
	 DekcyhgI78PRmMYa57tjw9Ccc45ARvDDGrU4oBUg8loPPFOYr+l1BdXGF75pwRs3Scar0
	 8hFZ5bC3ZCG8YxylD4vrz3T2dwme2RIVXWF0X6JdMpVvd3T+qf3mKAQ3wX9wf55WwPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=nlZ5LV6u;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADBA606A332;
	Tue,  3 Nov 2026 09:41:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CADBA606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=nlZ5LV6u
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mecTDTVs5XTIo5shPImQxJvT/BhKqHbjaP97oQq8stw=; b=nlZ5LV6uN8ogHFuSOY/QMgZjiS
	P6B7JFKmlszGT5chrdANm1mS/E4jsSmkGQuAYA4pKWamCcLveRnoIMlnkVc2+GQmck54p9m3XBM8i
	Qh0KMw/jy6EgDqRhVkOHFNiqlVN3RjI0bKpFeqZS3/RVIOeErVIHkuLkAoTJdKKuxESLnQeLJpf8o
	pyJkGYHAlSw39dbkfIxdNozSMCL00xVavUNpd98WXeQ4opHidak+SUhRpHFYVLRvQZTW9Xi3d3GTQ
	gkgvrrleHcvbAx181bNTlOw0zMEeImQwixuh1EGxLpiGD/jrUs6k/JDDZKrpAiAxqHNKQachV8rOF
	859kjt7Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOB15-00000001mau-1Fnw;
	Tue, 03 Nov 2026 09:41:19 +0000
Date: Tue, 3 Nov 2026 01:41:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: ebiggers@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v18 07/15] xfs: add XFS_BMAPI_UNWRITTEN to unmap
 unwritten extents in __xfs_bunmapi()
Message-ID: <aumsPwTUaMgsccSb@infradead.org>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
 <20261102144147.2393369-8-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102144147.2393369-8-aalbersh@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 02, 2026 at 03:41:37PM +0100, Andrey Albershteyn wrote:
> The __xfs_bunmapi() is used to remove all extents past EOF. Add
> XFS_BMAPI_UNWRITTEN to remove only unwritten extents, while leaving
> written ones in place. This will be used in following patch to clean up
> unwritten extents on fsverity inodes.

As discussed before, we either need to fix the Sashiko complains (which
could get really annoying), or disallow fsverity on RT files with
rt extent size > 1.  And probably also add a soft assert about this
to __xfs_bunmapi itself to make the limitations clear.

Otherwise this looks good.

