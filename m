Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ev0ky+mW"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A4E170B
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 22:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Hwhy7MGnqPbMN3YhCC0nGVOeDgsCuCvq3Zgn/492m1k=; b=ev0ky+mWoVxDIFqObJ5BfhY1C5
	icohjbvS50RtmTBz+CT2JYJO6/sTctUiVIOkmq4SRYtgQM14kaJzbMmhbRbwAr6XxdcoHqD9wnqXy
	EbxnZHZBgxBZ7+q6qoPA9Nb8hy/X/+5/9tzVtv7aEbmnsIj1L/th/OH2V9jgePBq2NOArE5qsTn3R
	4CRINfw47lzqKJ7GuKxZyvf2Fh4cwn+G0FlCKJuoLXtFewVNvLS7Tg1iGOoCfXJob1+qzWhInUei8
	mPVGOaT4Qc1Z49s1h5nZ8Uv21ZwIIQO2xEICtBb6f76xPkMnt7kn4o5pNIutPrS3uJWvcJkG/ry1z
	okl5NY8Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r6lnO-008eHy-06;
	Sat, 25 Nov 2023 06:05:38 +0000
Date: Fri, 24 Nov 2023 22:05:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: roll the scrub transaction after completing a
 repair
Message-ID: <ZWGOsogKQX0AnLlE@infradead.org>
References: <170086926983.2770967.13303859275299344660.stgit@frogsfrogsfrogs>
 <170086927027.2770967.2620740447463313551.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086927027.2770967.2620740447463313551.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 24, 2023 at 03:50:17PM -0800, Darrick J. Wong wrote:
> Going forward, repair functions should commit the transaction if they're
> going to return success.  Usually the space reaping functions that run
> after a successful atomic commit of the new metadata will take care of
> that for us.

Generally looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

A random comment on a pre-existing function from reading the code, and
a nitpick on the patch itself below:

> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -73,7 +73,7 @@ xrep_superblock(
>  	/* Write this to disk. */
>  	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_SB_BUF);
>  	xfs_trans_log_buf(sc->tp, bp, 0, BBTOB(bp->b_length) - 1);
> -	return error;
> +	return 0;

After looking through the code this is obviously fine, error must
be 0 here because the last patch touching it is xchk_should_terminate,
which only sets the error if it returns true.

But the calling conventions for xchk_should_terminate really make me
scratch my head as they are so hard to reason about.  I did quick
look over must caller and most of them get there with error always
set to 0.  So just making xchk_should_terminate return the error
would seem a lot better to me - any caller with a previous error
would need a second error2, but that seems better than what we have
there right now.

>  /* Repair the AGF. v5 filesystems only. */
> @@ -789,6 +789,9 @@ xrep_agfl(
>  	/* Dump any AGFL overflow. */
>  	error = xrep_reap_agblocks(sc, &agfl_extents, &XFS_RMAP_OINFO_AG,
>  			XFS_AG_RESV_AGFL);
> +	if (error)
> +		goto err;
> +
>  err:

This seems rather pointless and doesn't change anything..

