Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aqUcjbtv"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35145193
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 22:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1fMJP+60nzF1Q0851e76dyAqxnctxKJcumzbmHw0oMU=; b=aqUcjbtv+7GmvZMUTONGCrgy5D
	csdub+Mc7Nub65ukgkIwFfh1gaJRuonbxSBdpB3eaYfa8EMX/eYqJ2B73t216H7SLyDLQ12iEIDml
	s8idu4Ua6VTeGaRMh9HxtPu98PQ1E1RPUTHr3fN7GQR1V4/7XmZotEMR1Tz5Gj+xhVD8vam/GetfV
	Wk4iqfEMr5fRvDdc32RXNwSdxG70vcrswSapuXFFpWLHLe1Yk7G7+fY8eAw4mMzoge0tLW7oGehpw
	cdP00L3n3ziqaxNWR+5aIs+qeh+4D6pn/OJQUE9e0ri94cATmfBCQcwjU66jd/qYjypCG3yDfybh2
	vZGQnFcw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rB7U0-00BwuH-0K;
	Thu, 07 Dec 2023 06:03:36 +0000
Date: Wed, 6 Dec 2023 22:03:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: abort directory parent scrub scans if we
 encounter a zapped directory
Message-ID: <ZXFgOMVapbhQrSh2@infradead.org>
References: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
 <170191666222.1182270.11568535367691161509.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170191666222.1182270.11568535367691161509.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +/*
> + * Decide if this directory has been zapped to satisfy the inode and ifork
> + * verifiers.  Checking and repairing should be postponed until the directory
> + * is fixed.
> + */
> +bool
> +xchk_dir_looks_zapped(
> +	struct xfs_inode	*dp)
> +{
> +	/* Repair zapped this dir's data fork a short time ago */
> +	if (xfs_ifork_zapped(dp, XFS_DATA_FORK))
> +		return true;
> +
> +	/*
> +	 * If the dinode repair found a bad data fork, it will reset the fork
> +	 * to extents format with zero records and wait for the bmapbtd
> +	 * scrubber to reconstruct the block mappings.  Directories always
> +	 * contain some content, so this is a clear sign of a zapped directory.
> +	 */
> +	return dp->i_df.if_format == XFS_DINODE_FMT_EXTENTS &&
> +	       dp->i_df.if_nextents == 0;

Correct me if I'm wrong:  in general the xfs_ifork_zapped should be
all that's needed here now, and the check below just finds another
obvious case if we crashed / unmounted and lost the zapped flag?
If so maybe update the comment a bit.

Otherwise:

Reviewed-by: Christoph Hellwig <hch@lst.de>
