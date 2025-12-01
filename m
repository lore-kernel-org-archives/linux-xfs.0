Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E45626ED5C
	for <linux-xfs@vger.kernel.org>; Mon,  1 Dec 2025 06:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764570185; cv=none; b=DxsWcliK1oQf1NE7jaZPEHCmydOXJTE4wF8AReq48u5gnkSdEa4bBsX+p+GX2oKPA2Ru+Rk1/3dntPgqlsQOFBt/DtAnt7axSb70OHEj3H39wepYtQGbqiFvBN/PFSfI5vJK1TH0psxaqIKgpgbxBD3ul9kKTNqdlwt4XcmHnms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764570185; c=relaxed/simple;
	bh=eOG3xeZUxFdltvqv74482mkg365NUAHdJIm7RjO8y/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oum97iRSsLL5IghKd9PY9FYurha8RnLCmRcY8Ab+KRpFLMU2j/1QuzFDnIh+xLs6izg69A7DfRgITOFLPTX2p3iPZk70e4KAysi003hm3Ce4rs4Pbs/Re2GgwBmbUP3y4ETMN8aGB8CqfYH/gIg1/mIypO+eavhQDEdrnSnqzYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1D7AE6732A; Mon,  1 Dec 2025 07:23:01 +0100 (CET)
Date: Mon, 1 Dec 2025 07:23:00 +0100
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] repair: add canonical names for the XR_INO_
 constants
Message-ID: <20251201062300.GB19310@lst.de>
References: <20251128063719.1495736-1-hch@lst.de> <PkROJYgxikcR723QVoiHcf9IdPujc43prjwQuZH2Fs6gkkraq53H1Ae-Rz1uWFfbvV0E60UCWAU6DCX5F-Pt1g==@protonmail.internalid> <20251128063719.1495736-3-hch@lst.de> <z4sbdrflefzmzgshjhynq3mrvospl5mkipp4ogajqp44sntazc@cot4zzdmnqql>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <z4sbdrflefzmzgshjhynq3mrvospl5mkipp4ogajqp44sntazc@cot4zzdmnqql>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 28, 2025 at 09:00:59AM +0100, Carlos Maiolino wrote:
> On Fri, Nov 28, 2025 at 07:37:00AM +0100, Christoph Hellwig wrote:
> > Add an array with the canonical name for each inode type so that code
> > doesn't have to implement switch statements for that, and remove the now
> > trivial process_misc_ino_types and process_misc_ino_types_blocks
> > functions.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > -
> 
> 
> >  static inline int
> >  dinode_fmt(
> >  	struct xfs_dinode *dino)
> > @@ -2261,16 +2180,20 @@ _("directory inode %" PRIu64 " has bad size %" PRId64 "\n"),
> >  	case XR_INO_BLKDEV:
> >  	case XR_INO_SOCK:
> >  	case XR_INO_FIFO:
> > -		if (process_misc_ino_types(mp, dino, lino, type))
> > -			return 1;
> > -		break;
> > -
> >  	case XR_INO_UQUOTA:
> >  	case XR_INO_GQUOTA:
> >  	case XR_INO_PQUOTA:
> > -		/* Quota inodes have same restrictions as above types */
> > -		if (process_misc_ino_types(mp, dino, lino, type))
> > +		/*
> > +		 * Misc inode types that have no associated data storage (fifos,
> > +		 * pipes, devices, etc.) mad thus must also have a zero size.
> 
> 		Perhaps is my non-native English, but this sentence
> 		doesn't make much sense to me. Not sure if 'mad' has
> 		some special meaning in this context?

that should be an "and"

