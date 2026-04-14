Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F093C242D7F;
	Tue, 14 Apr 2026 01:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776128461; cv=none; b=LuIq1ywsyLnlOSUUpAwiTgj1ODd6XqCIHQ2BcWmA2qAULGkw7ozZoXowRboomoIciYjdfTDxw4hn/DbmmkwfooYTAWt5f/vOkQi6wWqDgrKp0d29ZAuWtAI3u/Zr3gp9txopaz3GMZHlAUn/GEFoPpObE/DsUHQ1u/GtTgcPG14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776128461; c=relaxed/simple;
	bh=BlKAU1Qs9rgI2Bqmfdqc8qzuGcapi4hy62HJFElwNlg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZnWBkaXnOrCxoOh4CaF6h++ABn38B6wLjBIMul1RZj8sYH5gCTSGHXuvOG7Ia6sJY2Fun4+CSINfEBoTGUAgU/Bef9URAIIOY/WzFLgWgkYij4zTolIiXbqzSEyY/xpgjwc+7xuiPcoym8iyczvUlbDgMiL5K0vbcffefyAPS3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ItZTVKbw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ItZTVKbw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0219C2BCB4;
	Tue, 14 Apr 2026 01:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776128460;
	bh=BlKAU1Qs9rgI2Bqmfdqc8qzuGcapi4hy62HJFElwNlg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ItZTVKbwDZepUnrt+HdE2B6u4vredkj5WGDCbKyOvS3ZcQ753b8bmPX9zt6bZqd30
	 RsKltzmIOFvE1T/nou2enuA+Lkb3suHuAu6H8K1j1alNq6r3aXOwzPhU+DUtHK+VQq
	 nfx5yetcmtIxLAzO6DvvViiJHpnGUpWk4LUTv5coe+s9wxC2nJWNtzAMXKcUIyKwyX
	 RVuJ5GUWz3wMSUUxlehkPmDfSkfDFLUoCpGO+or39QbJ5mTF0iQxPB3XCd5sQOzCrf
	 9loSVk4RqecCV77MEgU1YFcSnOkEa+czJfs0OxainfqAEswEOec4p92kzumNqdv6xY
	 J2oluuY3sjyfg==
Date: Mon, 13 Apr 2026 18:01:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <dgc@kernel.org>
Cc: Yuto Ohnuki <ytohnuki@amazon.com>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] xfs: zero directory data block padding on write
 verification
Message-ID: <20260414010100.GA150005@frogsfrogsfrogs>
References: <20260411142411.72194-5-ytohnuki@amazon.com>
 <20260411142411.72194-7-ytohnuki@amazon.com>
 <20260413175921.GM1048989@frogsfrogsfrogs>
 <ad2M2SH6BQfY0uhH@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad2M2SH6BQfY0uhH@dread>

On Tue, Apr 14, 2026 at 10:39:53AM +1000, Dave Chinner wrote:
> On Mon, Apr 13, 2026 at 10:59:21AM -0700, Darrick J. Wong wrote:
> > On Sat, Apr 11, 2026 at 03:24:14PM +0100, Yuto Ohnuki wrote:
> > > Old kernels did not zero the pad field in xfs_dir3_data_hdr when
> > > initializing directory data blocks, so existing filesystems may have
> > > non-zero padding on disk.
> > > 
> > > Zero the pad field in xfs_dir3_data_write_verify alongside the existing
> > > LSN and checksum updates. The pad field is pure alignment padding with
> > > no runtime meaning, so zeroing it during write verification is safe and
> > > has no additional I/O cost. This lets filesystems gradually self-heal
> > > stale non-zero padding as directories are modified, without requiring an
> > > explicit repair pass.
> > > 
> > > Suggested-by: Dave Chinner <dgc@kernel.org>
> > > Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_dir2_data.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> > > index 35ff119aa84b..aecbab61014c 100644
> > > --- a/fs/xfs/libxfs/xfs_dir2_data.c
> > > +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> > > @@ -382,6 +382,7 @@ xfs_dir3_data_write_verify(
> > >  	struct xfs_mount	*mp = bp->b_mount;
> > >  	struct xfs_buf_log_item	*bip = bp->b_log_item;
> > >  	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
> > > +	struct xfs_dir3_data_hdr *datahdr3 = bp->b_addr;
> > >  	xfs_failaddr_t		fa;
> > >  
> > >  	fa = xfs_dir3_data_verify(bp);
> > > @@ -396,6 +397,11 @@ xfs_dir3_data_write_verify(
> > >  	if (bip)
> > >  		hdr3->lsn = cpu_to_be64(bip->bli_item.li_lsn);
> > >  
> > > +	/*
> > > +	 * Zero padding that may be stale from old kernels.
> > > +	 */
> > > +	datahdr3->pad = 0;
> > 
> > This needs to be gated on the directory block actually having a dir3
> > data header (aka xfs_has_crc()).
> 
> It already is gated correctly - this check is done 5 lines above:
> 
> 	if (!xfs_has_crc(mp))
> 		return;

So it is.  My bad;
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> -Dave.
> 
> -- 
> Dave Chinner
> dgc@kernel.org
> 
