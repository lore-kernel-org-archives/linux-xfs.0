Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7A126FA66
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 18:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739902526; cv=none; b=PZzIn9WPElRWw9co6PMqh8NJD4XnWhNC0vAlmeBZSvidz1rpWyQ/mww2RUSCme8wAp1eUmxVIeIA00G0P8bKCWLxieV7ozTmpC0bwdnfTusYKFMHu6dl8Z+yjDCHQCcaFHVs5JzNV95aqIOR/mzH/qops2aWtMgtVceafcrLeiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739902526; c=relaxed/simple;
	bh=MEK3MPkuQ7a+FbLE0ZZ7AT1mYNvW7Pv1hQK/abp9kV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pVMJ4wz4Avi4NI7rSkvQ+2ZzXOMrBWC03wukeLf/umforNpUmtxxxrun1vHgfrKtt0WCEE8am6F4GKwu0Bl+jpCcfWZ89YfEqIppSEa0VUWFP3fPn171dqepFqVq7PCRSXIix96TiigxG7fmYUCshMyvZ0O2ndyJEmNqwo74I8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k/q86z4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k/q86z4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354B0C4CEE2;
	Tue, 18 Feb 2025 18:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739902525;
	bh=MEK3MPkuQ7a+FbLE0ZZ7AT1mYNvW7Pv1hQK/abp9kV4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k/q86z4uAhsKCZAx7S3zIa7kEWrzrOcxGKKsT0QagFQVqXXmlITrpJCdTU2wxDuEp
	 IbaKfCIjbvNyQ5jPFqon1tL3n5dGUJTTdZZh4Aqw9Q+sQqF/ImdGHLCBBW2HZyVgKA
	 ObJRhIHd4HT/+V2WqdrDgJAse0H2YGCrnAlY/Nf66WGKUDk6escGCJQNrsfyosW0CI
	 5DptV0WrOfeizORBZqJ4+lehJDs9H90rdwmbAzFNpCCEvPxMexE+RIT1r4iyTwNyjN
	 X4eKtX2y/zcg63C6fkSheyqXILeM84BHNlc/QfSrZblKYcGwO8e0Hf/v9xyNyx8Tlu
	 YZdLV+gMo0vwQ==
Date: Tue, 18 Feb 2025 10:15:24 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Pavel Reichl <preichl@redhat.com>, aalbersh@redhat.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: Fix mismatched return type of filesize()
Message-ID: <20250218181524.GD21808@frogsfrogsfrogs>
References: <-uT7HOcTG_xe8v8U0_5OQg6ll9vJyYEFQeSs_2FwUHujx116vYRcX2iovzoJvkN8K9zDDmQxQWB6H1CDLiOVdw==@protonmail.internalid>
 <20250217155043.78452-1-preichl@redhat.com>
 <xtoocdorovfnttkgtuq6qkzaazqtszlnaa6voiphh6ofnri2w6@agad5vuhxtmx>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xtoocdorovfnttkgtuq6qkzaazqtszlnaa6voiphh6ofnri2w6@agad5vuhxtmx>

On Tue, Feb 18, 2025 at 09:18:46AM +0100, Carlos Maiolino wrote:
> On Mon, Feb 17, 2025 at 04:50:43PM +0100, Pavel Reichl wrote:
> > The function filesize() was declared with a return type of 'long' but
> > defined with 'off_t'. This mismatch caused build issues due to type
> > incompatibility.
> > 
> > This commit updates the declaration to match the definition, ensuring
> > consistency and preventing potential compilation errors.
> > 
> > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> 
> Looks good, perhaps add:
> 
> Fixes: 73fb78e5ee8 ("mkfs: support copying in large or sparse files")

Yes please!  Sorry about the discrepancy.

With that fixed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ?
> 
> Otherwise,
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> > ---
> >  mkfs/proto.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mkfs/proto.c b/mkfs/proto.c
> > index 6dd3a200..981f5b11 100644
> > --- a/mkfs/proto.c
> > +++ b/mkfs/proto.c
> > @@ -20,7 +20,7 @@ static struct xfs_trans * getres(struct xfs_mount *mp, uint blocks);
> >  static void rsvfile(xfs_mount_t *mp, xfs_inode_t *ip, long long len);
> >  static int newregfile(char **pp, char **fname);
> >  static void rtinit(xfs_mount_t *mp);
> > -static long filesize(int fd);
> > +static off_t filesize(int fd);
> >  static int slashes_are_spaces;
> > 
> >  /*
> > --
> > 2.48.1
> > 
> > 
> 
