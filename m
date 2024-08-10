Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31B215854B
	for <linux-xfs@vger.kernel.org>; Sat, 10 Aug 2024 16:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723308115; cv=none; b=HKNWyAvo2O6oa0xmK+kzInAmyPEK76KVcEJ/T1awbiFH0kRab9hAhb2rCmMSkmNgltFV4dCtjp3OW49YRgtmMKeZTaabTuO2Z+ENM3fI2j2oywlMEhfHP423CatsKnmw8z6AXCL3FuyC/6qzRNd7PJLpvfC94k0+SmAG8MkrBeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723308115; c=relaxed/simple;
	bh=xcoo7173ayO+YYOb70x1cczsrwtg0FDCShurla6bTfI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SFxks+hRheqdwX90rhwg2rPodzLAKkXOfuKZ6JxIG5WYHy4RijtG+4tpuSc5arDtYgTMW5qYjgrZOUKOixBon809fI1PxsNtMBbShhuymwBD5rp8rg/h7Twnec7gKoczd+3u0pH/VWjgPVPPQCCO8lbaPT41f7x08CGf91OQnV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gSwPE1wc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gSwPE1wc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AF8C32781;
	Sat, 10 Aug 2024 16:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723308115;
	bh=xcoo7173ayO+YYOb70x1cczsrwtg0FDCShurla6bTfI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gSwPE1wcW2MBzI7bLfOZ965ykNjG/q/l8m1M7iMG5z09jjQFCRan6bB95f1VLW1tw
	 dfJWXC14I9BNdeLfhPrQE9fjJ7gOT4AmaO4YWmVzXKoM6XjL2eKvmATHatnEuOL+OE
	 ClWg/Kg/akN2FnyBGRGYAi1TGYIAQCO/52nPiWKc/8ySb9Novl6K/ouLE4Q38dHuub
	 NIz9APmCiHDLlM82pSj1C+t6coZoJpx77TsfJZJY7O65SAVFsZ2Y+GOwqwvvQSwDCq
	 SXLJptVZHSzJWCL8wVkwa3qkH+My3zKpJsmMmCqHF/J7EQ79XHLADDAsqp8BbZnTSm
	 47i0UHu/87Feg==
Date: Sat, 10 Aug 2024 09:41:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: conditionally allow FS_XFLAG_REALTIME changes if
 S_DAX is set
Message-ID: <20240810164154.GF6082@frogsfrogsfrogs>
References: <20240805184645.GC623936@frogsfrogsfrogs>
 <CAFqt6zbwgNsD5Cti3bQ8Fu=8mDSedb7B9iY1zDq10qMcuJmorw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFqt6zbwgNsD5Cti3bQ8Fu=8mDSedb7B9iY1zDq10qMcuJmorw@mail.gmail.com>

On Sat, Aug 10, 2024 at 08:18:16PM +0530, Souptick Joarder wrote:
> On Tue, Aug 6, 2024 at 12:16 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > If a file has the S_DAX flag (aka fsdax access mode) set, we cannot
> > allow users to change the realtime flag unless the datadev and rtdev
> > both support fsdax access modes.  Even if there are no extents allocated
> > to the file, the setattr thread could be racing with another thread
> > that has already started down the write code paths.
> >
> > Fixes: ba23cba9b3bdc ("fs: allow per-device dax status checking for filesystems")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_ioctl.c |   11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 4e933db75b12..6b13666d4e96 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -483,6 +483,17 @@ xfs_ioctl_setattr_xflags(
> >                 /* Can't change realtime flag if any extents are allocated. */
> >                 if (ip->i_df.if_nextents || ip->i_delayed_blks)
> >                         return -EINVAL;
> > +
> > +               /*
> > +                * If S_DAX is enabled on this file, we can only switch the
> > +                * device if both support fsdax.  We can't update S_DAX because
> > +                * there might be other threads walking down the access paths.
> > +                */
> > +               if (IS_DAX(VFS_I(ip)) &&
> > +                   (mp->m_ddev_targp->bt_daxdev == NULL ||
> > +                    (mp->m_rtdev_targp &&
> > +                     mp->m_rtdev_targp->bt_daxdev == NULL)))
> > +                       return -EINVAL;
> Any chance of  mp->m_ddev_targp == NULL  ?

No, m_ddev_targp is the device you give to mount. e.g. if you do

# mount /dev/sda /mnt

then m_ddev_targp is the block_device /dev/sda.

--D

> >         }
> >
> >         if (rtflag) {
> >
