Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E255B274B58
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 18:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760466060; cv=none; b=gUeMiLhvZezQg9DHt+bfdCNZDxPRCLimvAq6OawJVRFmUVpGnTpNZMzmQjNewuahjKFj86ZbCcvcQwpqbiMGVc5R4q0vgWzOF1x1jiwouFiC0NyqP2hTICJQSIS2cSD39S3Y407WZcDPadATjtMPddSROoBTcFuaLIGBArSdceY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760466060; c=relaxed/simple;
	bh=a3aEh0e41685j+1yEoSmrueQz1C4DMggRqVZtKrXmXs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KTH1B8RYKnftyiyc9pqqcdLQVre/KoHD+wDc/zE88wOAz6pBkpGvnLvHLsOvr3zRsOllgYCagadxPKk+x/DxcFc3VNlbUXdk5bUzfOlritzsCTmDKv+L1NcHp4Xd6Zu7heLWnphM14I4ZVRFju9v5QXkCMxZkU+3zSRIqmNUmEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nVOW1+at; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nVOW1+at"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77127C4CEE7;
	Tue, 14 Oct 2025 18:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760466059;
	bh=a3aEh0e41685j+1yEoSmrueQz1C4DMggRqVZtKrXmXs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nVOW1+atVeBVrqGdSS/05LfRMAY+y9dAibchnQFRNtfWwpJcR5wmaHpBP/+vmbSTG
	 sEnUtE8HXQXiITdApwMVOao8bCHY8L5G9BEPxQ0bj3e9cyLyspt3Bnb1t2bnUaVXAU
	 nACf504DoGnuYa4CUVg1DjkfUWPMyhQSOxfCG8QmpsM/x0fP1Xnxv26IDde7ns0GxR
	 YWIpzxgGr+hKMGGjpT3lJZZeyN0rmVDNAHezX/Jgnl2FxxcKic529pGzYX7WCeIYh/
	 8t+OIPT7CBKtUZtalnU+sFX3cdbETbkyy179T0Kj6b/Hv4ijRJ7y40LJrss1ZGKkIU
	 fS/eiI789yr9A==
Date: Tue, 14 Oct 2025 11:20:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Carlos Maiolino <cem@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't set bt_nr_sectors to a negative number
Message-ID: <20251014182058.GX6188@frogsfrogsfrogs>
References: <20251013163310.GM6188@frogsfrogsfrogs>
 <ec2bc94bc73a42ab61019b8de5951359d383247d.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec2bc94bc73a42ab61019b8de5951359d383247d.camel@gmail.com>

On Tue, Oct 14, 2025 at 12:17:30PM +0530, Nirjhar Roy (IBM) wrote:
> On Mon, 2025-10-13 at 09:33 -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > xfs_daddr_t is a signed type, which means that xfs_buf_map_verify is
> > using a signed comparison.  This causes problems if bt_nr_sectors is
> > never overridden (e.g. in the case of an xfbtree for rmap btree repairs)
> > because even daddr 0 can't pass the verifier test in that case.
> Okay so the check "if (map->bm_bn < 0 || map->bm_bn >= btp->bt_nr_sectors) {" will be true of the
> default value of btp->bt_nr_sectors = -1 and the verifier will fail(incorrectly), right?
> Why would we not want to override bt_nr_sectors? If there is device, then shouldn't it always have a
> buffer target with a certain number of bt_nr_sectors?

Online repair creates tmpfs files in which to stage repairs, and uses
the xfbtree buftarg so that it can build a replacement rmapbt in a tmpfs
file.  I guess xfbtree should be setting bt_nr_sectors to (max pagecache
size / 512) but in practicality nobody should ever have a 16TB rmap
btree on 32-bit or an 8EB rmap btree on 64-bit.

--D

> --NR
> > 
> > Define an explicit max constant and set the initial bt_nr_sectors to a
> > positive value.
> > 
> > Found by xfs/422.
> > 
> > Cc: <stable@vger.kernel.org> # v6.18-rc1
> > Fixes: 42852fe57c6d2a ("xfs: track the number of blocks in each buftarg")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_buf.h |    1 +
> >  fs/xfs/xfs_buf.c |    2 +-
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> > index 8fa7bdf59c9110..e25cd2a160f31c 100644
> > --- a/fs/xfs/xfs_buf.h
> > +++ b/fs/xfs/xfs_buf.h
> > @@ -22,6 +22,7 @@ extern struct kmem_cache *xfs_buf_cache;
> >   */
> >  struct xfs_buf;
> >  
> > +#define XFS_BUF_DADDR_MAX	((xfs_daddr_t) S64_MAX)
> >  #define XFS_BUF_DADDR_NULL	((xfs_daddr_t) (-1LL))
> >  
> >  #define XBF_READ	 (1u << 0) /* buffer intended for reading from device */
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 773d959965dc29..47edf3041631bb 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -1751,7 +1751,7 @@ xfs_init_buftarg(
> >  	const char			*descr)
> >  {
> >  	/* The maximum size of the buftarg is only known once the sb is read. */
> > -	btp->bt_nr_sectors = (xfs_daddr_t)-1;
> > +	btp->bt_nr_sectors = XFS_BUF_DADDR_MAX;
> >  
> >  	/* Set up device logical sector size mask */
> >  	btp->bt_logical_sectorsize = logical_sectorsize;
> 
> 
