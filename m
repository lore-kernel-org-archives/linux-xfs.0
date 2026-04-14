Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408FB3770B;
	Tue, 14 Apr 2026 00:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776127199; cv=none; b=CqJBJmPO/K5/tfKHx7D9Xdx19iRtGFRiC4tYidI39D4vE0Y5DvShsl00fZjMRMmfNdD1CLcFZ5ILGTdvHA91AAZVwGSxd4sro/qJXxDrTkx4nS0ax/eUtubpW7/pPmSuQIcGEeOeee7Dwt2UomMW6XYN8JAKBF5qA5ZrZpxwYRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776127199; c=relaxed/simple;
	bh=kBGRZRZmFp7/dT23yT4zgWTQi2bK5YTCAEiZpsyzbYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z8ukkzzIc3vrajEZMIOf55nJgm5UqzL0MQgtMFhRrjObqTiuDlYQlVnIVvflH0a2vqBsAqIX6nUfZb7WPezkF9tmEd82/GvUypneMqSnfHY3qsX/7QNHnK27YcT3yT9I5obpOsMrSq04ZPwf133B482N7Uky4drJoTewMQQIyBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VzMLtSvM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VzMLtSvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274D8C2BCAF;
	Tue, 14 Apr 2026 00:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776127199;
	bh=kBGRZRZmFp7/dT23yT4zgWTQi2bK5YTCAEiZpsyzbYQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VzMLtSvM3d0wa+EZFFGZFhRLMmIVowO/unQBSMDZ9FRj/vfofG3LftJ/p8S+PPtoH
	 exYT0ZFwJGyPQI95fSoPyd7pti/iVItWTd2hGXNsBx8cD5mtkCiUwrl58e5seKQmCT
	 pCQZYYC14fCdRyYTwrku9UVinKw9OWZOh7vlHdIMmG94pCTEfxCLByKTHmUTYyZ7VQ
	 W/t0zlUqs4tdM1v53eFqVpO2bdadl8t5Wt6byHRVPTJ+ZiI5I4RjPfRMrCATQBW0pi
	 yjw4iJeeC8zEXnnmVNXKNCuPzd6F6opNnlYKP2Numi8s9Is9xL6gVkzE2D1e2CoaWr
	 OFw+fNxaaho/g==
Date: Tue, 14 Apr 2026 10:39:53 +1000
From: Dave Chinner <dgc@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Yuto Ohnuki <ytohnuki@amazon.com>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] xfs: zero directory data block padding on write
 verification
Message-ID: <ad2M2SH6BQfY0uhH@dread>
References: <20260411142411.72194-5-ytohnuki@amazon.com>
 <20260411142411.72194-7-ytohnuki@amazon.com>
 <20260413175921.GM1048989@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413175921.GM1048989@frogsfrogsfrogs>

On Mon, Apr 13, 2026 at 10:59:21AM -0700, Darrick J. Wong wrote:
> On Sat, Apr 11, 2026 at 03:24:14PM +0100, Yuto Ohnuki wrote:
> > Old kernels did not zero the pad field in xfs_dir3_data_hdr when
> > initializing directory data blocks, so existing filesystems may have
> > non-zero padding on disk.
> > 
> > Zero the pad field in xfs_dir3_data_write_verify alongside the existing
> > LSN and checksum updates. The pad field is pure alignment padding with
> > no runtime meaning, so zeroing it during write verification is safe and
> > has no additional I/O cost. This lets filesystems gradually self-heal
> > stale non-zero padding as directories are modified, without requiring an
> > explicit repair pass.
> > 
> > Suggested-by: Dave Chinner <dgc@kernel.org>
> > Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
> > ---
> >  fs/xfs/libxfs/xfs_dir2_data.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> > index 35ff119aa84b..aecbab61014c 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_data.c
> > +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> > @@ -382,6 +382,7 @@ xfs_dir3_data_write_verify(
> >  	struct xfs_mount	*mp = bp->b_mount;
> >  	struct xfs_buf_log_item	*bip = bp->b_log_item;
> >  	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
> > +	struct xfs_dir3_data_hdr *datahdr3 = bp->b_addr;
> >  	xfs_failaddr_t		fa;
> >  
> >  	fa = xfs_dir3_data_verify(bp);
> > @@ -396,6 +397,11 @@ xfs_dir3_data_write_verify(
> >  	if (bip)
> >  		hdr3->lsn = cpu_to_be64(bip->bli_item.li_lsn);
> >  
> > +	/*
> > +	 * Zero padding that may be stale from old kernels.
> > +	 */
> > +	datahdr3->pad = 0;
> 
> This needs to be gated on the directory block actually having a dir3
> data header (aka xfs_has_crc()).

It already is gated correctly - this check is done 5 lines above:

	if (!xfs_has_crc(mp))
		return;

-Dave.

-- 
Dave Chinner
dgc@kernel.org
