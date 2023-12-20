Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C30A38DD9
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 13:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iBW/B4fk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CBBC433C7;
	Wed, 20 Dec 2023 13:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703080217;
	bh=0YjrHnodvuNXaCJQCKXdc5YBMyZWGUK7Cr8KHHWvti8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iBW/B4fkm/4KrJYAUi8zkSPK1l1tkxugo64DVmBQYVqjPESVinOpzxGQUJUU3ueJ4
	 VWHGVnl+LdUAnLs2qOV9/zfqyIqVlcDVB15vu70nxiVU8YcoytwAj3oikPKc/e8QdO
	 7E3kSwDGt0+dLdCeEFjfu4IOCdYemNJ9MjmOSU1YJpjrHb6ly5iLx9DM+rcXwajRZB
	 weJgY7YMf9BObhfcFydX03LrVgn4YMh4QsL38AOqgVm9DPoYeIOoH/zEebYXAch8dd
	 vHK5I5wVCVKQSAHldg5AdtG61g32tSesW8Zp7ud01dqI08M4FY/R0PlUYu4s+EsRbP
	 mOsnv+mb6717A==
Date: Wed, 20 Dec 2023 14:50:12 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Wu Guanghao <wuguanghao3@huawei.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
	shikemeng@huawei.com, louhongxiang@huawei.com
Subject: Re: [PATCH]: mkfs.xfs: correct the error prompt in usage()
Message-ID: <uwxo3zad6hahzzfv4hbe5xsyplypvnpkz3ogfiwviva5hjn75a@hk2y7wvrcc2r>
References: <2a51a8b8-a993-7b15-d86f-8244d1bfce44@huawei.com>
 <20231220024313.GN361584@frogsfrogsfrogs>
 <jgDh5pu5yp0Cmwf0O61mcFZxOGEBxRpVdyszu3poTQwpcTN5sbmTjlfv6RdsC9ik-Rf0uK4ZYeH_0szAG1dbjw==@protonmail.internalid>
 <6abc40a8-8049-6c1a-37e4-d459b73b3d5e@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6abc40a8-8049-6c1a-37e4-d459b73b3d5e@huawei.com>

On Wed, Dec 20, 2023 at 04:48:36PM +0800, Wu Guanghao wrote:
> 
> 
> 在 2023/12/20 10:43, Darrick J. Wong 写道:
> > On Wed, Dec 20, 2023 at 09:59:04AM +0800, Wu Guanghao wrote:
> >> According to the man page description, su=value and sunit=value are both
> >> used to specify the unit for a RAID device/logical volume. And swidth and
> >> sw are both used to specify the stripe width.
> >>
> >> So in the prompt we need to associate su with sunit and sw with swidth.
> >>
> >> Signed-by-off: Wu Guanghao <wuguanghao3@huawei.com>
> >> ---
> >>  mkfs/xfs_mkfs.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> >> index dd3360dc..c667b904 100644
> >> --- a/mkfs/xfs_mkfs.c
> >> +++ b/mkfs/xfs_mkfs.c
> >> @@ -993,7 +993,7 @@ usage( void )
> >>  /* metadata */         [-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,\n\
> >>                             inobtcount=0|1,bigtime=0|1]\n\
> >>  /* data subvol */      [-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
> >> -                           (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
> >> +                           (sunit=value|su=num,swidth=value|sw=num,noalign),\n\
> >
> > Doesn't mkfs require sunit/swidth or su/sw to be used together, but not
> > intermixed?
> >
> > --D
> >
> 
> I think the '|' in usage() should be related to the modification of the same feature,
> so there is also 'sunit|su' in the -l parameter. There are already other prompts for
> mixed use of su/sw, and I don’t think there is a need to remind it in usage().
> The current 'swidth=value|su=num' prompt makes me think that the two modifications
> are the same. There may be other people who think so too, so I suggest changing
> the description.

The | suggests either one or another value, and that is what it is doing on the
other options.

finobt=0|1  ... rmapbt=0|1 ... etc.

Same applies here:

Either you use: sunit=value,swidth=value OR su=num,sw=num.

The -l option has the same principle:

-l ...  sunit=value|su=num

You either use sunit=value OR su=num.

Carlos
> 
> >>                             sectsize=num\n\
> >>  /* force overwrite */  [-f]\n\
> >>  /* inode size */       [-i perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
> >> --
> >> 2.27.0
> >>
> >
> > .
> >
