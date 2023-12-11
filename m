Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B364252F60
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 19:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zwc6J9Qe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B72DC433C7;
	Mon, 11 Dec 2023 19:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702322392;
	bh=9NFV/iV58Tk95MiwjsfQiwlI7855xoMfa33MFCd9lAM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zwc6J9Qe6rzFRHELjj7WBump+6pqzRYWQyjUs2Fa0jgtl0kYGtjcLRnEzmWaqerRn
	 waMLsavt1+fn7R34f/H2V112Q+LRsd0SchT66qPt+o4FFeDAp+5EUz1E1qf7pUxSgx
	 hIR+ItNpSMWhpb42oUBMfNIPJHLmmCpPbI8daBHAzqiKhaPaci8z/QzOTeNBNlUm2f
	 OFT1UOWJrLK8GVfMsL0l0hpFTu8q8r5MzNPIjN2pjZdjwO3yHEpTNgCZjH5ktKYWL1
	 gSt6iU5cjDCjhl6W+G+D2NrohJAWBl+tkMclGk+a3hYu+vKsUSn6HCLxa4kvZdho5l
	 dOLrYh6pXB4PA==
Date: Mon, 11 Dec 2023 11:19:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: abort directory parent scrub scans if we
 encounter a zapped directory
Message-ID: <20231211191951.GT361584@frogsfrogsfrogs>
References: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
 <170191666222.1182270.11568535367691161509.stgit@frogsfrogsfrogs>
 <ZXFgOMVapbhQrSh2@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXFgOMVapbhQrSh2@infradead.org>

On Wed, Dec 06, 2023 at 10:03:36PM -0800, Christoph Hellwig wrote:
> > +/*
> > + * Decide if this directory has been zapped to satisfy the inode and ifork
> > + * verifiers.  Checking and repairing should be postponed until the directory
> > + * is fixed.
> > + */
> > +bool
> > +xchk_dir_looks_zapped(
> > +	struct xfs_inode	*dp)
> > +{
> > +	/* Repair zapped this dir's data fork a short time ago */
> > +	if (xfs_ifork_zapped(dp, XFS_DATA_FORK))
> > +		return true;
> > +
> > +	/*
> > +	 * If the dinode repair found a bad data fork, it will reset the fork
> > +	 * to extents format with zero records and wait for the bmapbtd
> > +	 * scrubber to reconstruct the block mappings.  Directories always
> > +	 * contain some content, so this is a clear sign of a zapped directory.
> > +	 */
> > +	return dp->i_df.if_format == XFS_DINODE_FMT_EXTENTS &&
> > +	       dp->i_df.if_nextents == 0;
> 
> Correct me if I'm wrong:  in general the xfs_ifork_zapped should be
> all that's needed here now, and the check below just finds another
> obvious case if we crashed / unmounted and lost the zapped flag?
> If so maybe update the comment a bit.

Correct.  The comment now reads:

	/*
	 * If the dinode repair found a bad data fork, it will reset the fork
	 * to extents format with zero records and wait for the bmapbtd
	 * scrubber to reconstruct the block mappings.  Directories always
	 * contain some content, so this is a clear sign of a zapped directory.
	 * The state checked by xfs_ifork_zapped is not persisted, so this is
	 * our backup strategy if repairs are interrupted by a crash or an
	 * unmount.
	 */

> Otherwise:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
