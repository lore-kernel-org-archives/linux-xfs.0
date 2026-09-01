Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0558471266;
	Tue,  1 Sep 2026 09:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788256204; cv=none; b=TzJJiUT6TVEtub9uhs2sTvzZn1PYQCEOLQYtHBwvbbAXgDem2hBZxYkfzlyCumOrJoekPld8Fcyv4TgVGR1896PLL+POPSDHqaAIaFX/nIDmJV9iBexacUeXdmRhwpS2ltz1rS5WeBCLdZ7H5Z2ahBwqrdVGKd6jRcqjq85tuO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788256204; c=relaxed/simple;
	bh=iSCW1tgBwO/8D3wyzo5hxYTTfWB/HJbDfcDolw6N/9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kesxt9yZ+boWf+YP1hTKUB2Hs4DtKUEfisCld3Y2zQBwAUEE2+1C3kzteE/xyYo8TQPnOICz5e6RCfQqDxtkkHI8iQgr81MYPWkxgncC8r5JTfxAKezqJvXyRRrAWR8mPSICe9hGzOVi8MSs8ErGyU/4oy7vi24WKAYnLz/NZ0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=es2n5VTR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="es2n5VTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6061F000E9;
	Tue,  1 Sep 2026 09:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788256202;
	bh=faJe30iVneW5ofWb8SDPjgnt2v+HWbEaVSoLIQNmZC4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=es2n5VTRSPwAfmBHE70/cLlx8NqtEIrN0WIlqDPuJO71vuZwtVMwrZgFDKKyE2/uG
	 ardYYTMZhevpOCDOUo3/Bg54HIyYMGiKNM9/75MvNvhhWEC8h1K/RYImE7Otw6+9MU
	 UbXhOAQSfs/JeyY/YIyUgocv6r7IEQkjzx9IANh9G1e0Pmw6uK9gK+Pe00tlxCDoHJ
	 WSrTPY3guYKCmm4mPUJRXEB355ZJTrF2B84a4SrIsLzWuPvvU687midebKxwK8y3QQ
	 zbuHbim9EQat2wKFD6TwDf2sWGNLoIW1OYVZjnKfAPa7m0o3BJKU2aVJuTKThwxgoJ
	 YkJsh0OuCWoVA==
Date: Tue, 1 Sep 2026 11:49:56 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Hongling Zeng <zhongling0719@126.com>
Cc: Hongling Zeng <zenghongling@kylinos.cn>, darrick.wong@oracle.com, 
	chandanrlinux@gmail.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix array bounds checking in log recovery
Message-ID: <apafftcOk6XIDYTQ@andromeda.toxiclabs.cc>
References: <20260824094535.219503-1-zenghongling@kylinos.cn>
 <apZ5UptiKsVGgPHZ@andromeda.toxiclabs.cc>
 <6A969D6D.6060808@126.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6A969D6D.6060808@126.com>

On Tue, Sep 01, 2026 at 05:39:57PM +0800, Hongling Zeng wrote:
> 
> 在 2026年09月01日 15:06, Carlos Maiolino 写道:
> > On Mon, Aug 24, 2026 at 05:45:35PM +0800, Hongling Zeng wrote:
> > > The log recovery code increments array indices based on bits set in
> > > blf_data_map without verifying that the indices stay within the bounds
> > > of the item->ri_buf array.
> > > 
> > > Since blf_data_map is from untrusted log data, a malicious log could set
> > > many bits while ri_total is small, causing array index overflow.
> > > 
> > > This can result in an out-of-bounds access during log recovery, causing
> > > a kernel crash or memory corruption.
> > > 
> > > This patch adds array bounds checking for ri_buf access in
> > > xlog_recover_do_reg_buffer() and xlog_recover_do_inode_buffer().
> > > 
> > > The check in xlog_recover_do_inode_buffer() is placed right before the
> > > actual array access, not after incrementing the index, to avoid false
> > > positives when processing the last valid region.
> > > 
> > > Fixes: 1094d3f12363 ("xfs: refactor log recovery buffer item dispatch for pass2 commit functions")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
> > Hi,
> > 
> > is this a re-send? A v2? Please specify why you are sending the same
> > patche again. This saves a lot of time trying to understand why there
> > are two patches with the same subject in the list.
> Hi ,
> This is the same patch version, but the previous submission failed to
> apply because my local repository was out of date. I updated my tree and
> resubmitted the patch with the same fix.
> 
> Sorry for the confusion.

So this is not the same version, it's a rebase against top of the tree
and that should be properly described.

I'll be updating for-next soon this week, please rebase it again on top
of for-next once I publish it and re-send it.

Cheers,
Carlos

> 
> Thanks,
> Hongling
> > > ---
> > >   fs/xfs/xfs_buf_item_recover.c | 26 ++++++++++++++++++++++++++
> > >   1 file changed, 26 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> > > index 57929f115055..7148716366ba 100644
> > > --- a/fs/xfs/xfs_buf_item_recover.c
> > > +++ b/fs/xfs/xfs_buf_item_recover.c
> > > @@ -485,6 +485,19 @@ xlog_recover_do_reg_buffer(
> > >   			break;
> > >   		nbits = xfs_contig_bits(buf_f->blf_data_map,
> > >   					buf_f->blf_map_size, bit);
> > > +
> > > +		/*
> > > +		 * The bitmap can have more bits set than there are regions
> > > +		 * in ri_buf, so we must check array bounds before using the
> > > +		 * index to access ri_buf[i].
> > > +		 */
> > > +		if (XFS_IS_CORRUPT(mp, i >= item->ri_total)) {
> > > +			xfs_alert(mp,
> > > +		"Buffer log item index (%d) exceeds allocated regions (%d).",
> > > +					i, item->ri_total);
> > > +			return -EFSCORRUPTED;
> > > +		}
> > > +
> > >   		ASSERT(nbits > 0);
> > >   		ASSERT(item->ri_buf[i].iov_base != NULL);
> > >   		ASSERT(item->ri_buf[i].iov_len % XFS_BLF_CHUNK == 0);
> > > @@ -688,6 +701,19 @@ xlog_recover_do_inode_buffer(
> > >   		if (next_unlinked_offset < reg_buf_offset)
> > >   			continue;
> > > +		/*
> > > +		 * Check array bounds here (right before accessing ri_buf)
> > > +		 * rather than after incrementing item_index. This avoids
> > > +		 * incorrectly rejecting logs when item_index reaches
> > > +		 * ri_total after processing the final valid region.
> > > +		 */
> > > +		if (XFS_IS_CORRUPT(mp, item_index >= item->ri_total)) {
> > > +			xfs_alert(mp,
> > > +		"Inode buffer log item index (%d) exceeds allocated regions (%d).",
> > > +				item_index, item->ri_total);
> > > +			return -EFSCORRUPTED;
> > > +		}
> > > +
> > >   		ASSERT(item->ri_buf[item_index].iov_base != NULL);
> > >   		ASSERT((item->ri_buf[item_index].iov_len % XFS_BLF_CHUNK) == 0);
> > >   		ASSERT((reg_buf_offset + reg_buf_bytes) <= BBTOB(bp->b_length));
> > > -- 
> > > 2.25.1
> > > 
> > > 
> 
> 
