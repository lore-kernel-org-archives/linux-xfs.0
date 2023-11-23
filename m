Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EcY/aR7o"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBB4AD
	for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 22:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=T0YLudgwIubhL7/bI8M2XT0+SgFZiinUGO3V5dXYTTg=; b=EcY/aR7omHjYnGju+3NED/TxbY
	hmw+A+z6PrQdKedg33KIsZtA53gsCSMHjKmTkpCVaJ4Yot8CnO8T333C71zUePRLveBrpI/QjTpeh
	La5DMRRb2YvyQFVhsWEupyo9r3baWN7lpq7JHlo5r29ptkb2INmvlPHu3dOS2pi+to2EMSU788Ex9
	yRAvAgA6NOMEKmST5Uh4Ddw1DP5aaq/X6OaW0g3M0uR6rcxxXmfhyQlZXpQKUWbv0p+eewUWeYOtm
	lwXeJhoTE6NTQoHO8iaBFZxf2AsyZzeqhOWsAjwBB0L22hvwauWu6d5Uysr+vCUqlqymQcDB2ZIB6
	rLujvq2A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r63O4-003vsH-14;
	Thu, 23 Nov 2023 06:40:32 +0000
Date: Wed, 22 Nov 2023 22:40:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs_copy: actually do directio writes to block
 devices
Message-ID: <ZV7z4LnIqK9BwoCG@infradead.org>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069442535.1865809.15981356020247666131.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170069442535.1865809.15981356020247666131.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index 79f65946709..26de6b2ee1c 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -854,6 +854,8 @@ main(int argc, char **argv)
>  					progname, target[i].name, progname);
>  				exit(1);
>  			}
> +			if (!buffered_output)
> +				open_flags |= O_DIRECT;
>  		}

I'd just move this outside of the if/else if chain and do the
assignment once.

> @@ -887,20 +889,22 @@ main(int argc, char **argv)
>  				}
>  			}
>  		} else  {
> -			char	*lb[XFS_MAX_SECTORSIZE] = { NULL };
> +			char	*lb = memalign(wbuf_align, XFS_MAX_SECTORSIZE);
>  			off64_t	off;
>  
>  			/* ensure device files are sufficiently large */
> +			memset(lb, 0, XFS_MAX_SECTORSIZE);
>  
>  			off = mp->m_sb.sb_dblocks * source_blocksize;
> +			off -= XFS_MAX_SECTORSIZE;
> +			if (pwrite(target[i].fd, lb, XFS_MAX_SECTORSIZE, off) < 0)  {

We should probably check for a short write as well?
Also this line is a bit long.


