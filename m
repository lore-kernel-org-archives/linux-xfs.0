Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="toAHmDif"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CBAAD
	for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 22:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UgEZ5TrN84JaSIxPNtFudUQVpRRiiBI7R4snrCAGcrQ=; b=toAHmDifc+9CMA0KWl8WIJBIdl
	cyall+16VoRYukHosywV48Hic2bUs4OafcbcBFj5qBZA7MQQSPUg8SC3zrXkpD2GEaeC0niJ+ILsl
	3+bg73Bt4cMKvNmThv6e/4uEfzyjnEaWDcIEJ6ztVeCDageVdExyvnnjkf/3fEEaS1PyG+/A4pYhR
	/yj7rphHo9zdDwUk5eAA18SI0BKvFA80GU2Qj8hi/iqsVlrNFUVvd5/ghQoQGa1I1M1RzFtODQKWx
	UN9axQiXy7BUPZHSL7RjTwJeFXe5pHz77Pke8Q4ObRUbQeY0qE4GpNkMc+qVuhrDkS0a5+OA78IaK
	+ilUDciQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r63Ry-003wCz-0L;
	Thu, 23 Nov 2023 06:44:34 +0000
Date: Wed, 22 Nov 2023 22:44:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs_mdrestore: fix missed progress reporting
Message-ID: <ZV700lG5q/ZPRbI6@infradead.org>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069445938.1865809.2272471874760042809.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170069445938.1865809.2272471874760042809.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +		if (mdrestore.show_progress) {
> +			int64_t		mb_now = bytes_read >> 20;
> +
> +			if (mb_now != mb_read) {
> +				print_progress("%lld MB read", mb_now);
> +				mb_read = mb_now;
> +			}
> +		}

>  		if (mdrestore.show_progress) {
> +			int64_t	mb_now = bytes_read >> 20;
>  
>  			if (mb_now != mb_read) {
> +				print_progress("%lld mb read", mb_now);
>  				mb_read = mb_now;
>  			}
>  		}

Not sure if it's worth the effort, but to my pattern matching eyes
this screams for a little helper.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
