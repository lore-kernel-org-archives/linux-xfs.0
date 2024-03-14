Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30C474BFC
	for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 17:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710436569; cv=none; b=SF2SaZcX9YLVWsIlD3Y8Yu4QQrSGwCaHYIq35h7yn0i9wKIwlIHOBIyfFrnNBLVx5DpUpFUhVdUFdZzMakzpTqUxjWq69no/yeoIaQapLrzxOl5ahmfQmt5jfw/I1+02d+1EoaqtYZuiUt1ki6sRZ6D3z880zy4jw+TbSaFNdCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710436569; c=relaxed/simple;
	bh=yJ9lhppTwYft3uAXsPtQ9JakH3AP/Ec6HHHPVz1Rbgs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QIatvBmhGFYrEqqoL9GQz+l4en9cE6cMUVeq9R4HsyMVHNY886nPtWeCmXY+BRogLc/kDgC5c3Njnc+ORmPQvOe3qWJZPSRSikNkwBdrjXDpYhu49rzngjUu4gz/xeWYFZGJQZ/g9+Dr2qrTfnDf0UCA2yJciEXYjAaobxK9apw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CYQW8/Ls; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CYQW8/Ls"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710436566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Yo3wkqTGWc513kM6wvuDHFlEJRGidugW7GVqad1jST8=;
	b=CYQW8/Lsxke5sAFHwCIOSsen2vK7NDXu1Ez77Ne08THBzDuZocWe4KLrzyKSGFhE8AhiuE
	WvPNcYD2Ut+2UVPqbu/fu6VXp6yC8ZL0cTETaBh0gnjkcfYlVdZ9/6e8Q/9Mul/nyzrwks
	QuJT9MEfF6hnpJb3xqjM9p2R8NwEjlE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-250-FBl6s3nKPAiod0CmWWYDZw-1; Thu, 14 Mar 2024 13:16:05 -0400
X-MC-Unique: FBl6s3nKPAiod0CmWWYDZw-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5688bbfa971so970703a12.3
        for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 10:16:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710436564; x=1711041364;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yo3wkqTGWc513kM6wvuDHFlEJRGidugW7GVqad1jST8=;
        b=rdI+S1slfs4sBvNNOB/UMedOkBRN6JAvFtmeTPSry4eOdCIDS/2fgl4v+lRcUrcUaN
         TRexPKl7YYGOGCHGTUS1vKHPKDvOqxuks/vXwbbp47440TgeL9OduBiXyVQ4G0lMqMzk
         T5zFlDo1vGI9GKGNiXbcY+2eQh5YiM3wHhCxBMYViz4lSl7D6ulbVlHO6KmPp//npJRa
         /JSgyM+bY4sH2MmUUmPVF8PpNxpPKiEvlTa1eK1LhGBIxUjDjdR+zcYJOlYzCUm3K1Lk
         XvWTjBsDfwAAESoyXVrY3RTWCxMm6aWY1zSdVXStfAZ/RdB7bmI9JKeX771HUK85rMPx
         bbZA==
X-Forwarded-Encrypted: i=1; AJvYcCX9UyCXxi+o2gSbHXlcYrz9EC3JxlZCRBCaQKkkn1ZMxIpzr/iDWD+HSJG80qMg+uY4iyDF0M9M1Af5dhY5a0UTBkJ9Fds7EmA4
X-Gm-Message-State: AOJu0YwEBZW1M8buwvmOfYgwDFaqupmRMXTSULTl+fgab6X6G2Kwfvm9
	rFW9j3mGNPxQcmU33aflCtU75jSVpCrYB3WsEfADgq13dl2dlVdphDZ/6hIygRspvGiC/uLNguV
	Gax2ugbIugftvjE6QhF1w6BfondvmTDrp68c5t8NrV5CmtLAHAPiNICgD
X-Received: by 2002:a05:6402:5d3:b0:565:c814:d891 with SMTP id n19-20020a05640205d300b00565c814d891mr2108653edx.0.1710436563927;
        Thu, 14 Mar 2024 10:16:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHpiQiYtlVEkMxL0Um6412Pz19nDaf4h9YSERjM68EoccsOsNTvC2KFnAl6vcMHFJMKQA9igw==
X-Received: by 2002:a05:6402:5d3:b0:565:c814:d891 with SMTP id n19-20020a05640205d300b00565c814d891mr2108591edx.0.1710436563299;
        Thu, 14 Mar 2024 10:16:03 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id g17-20020aa7d1d1000000b00568a44036a2sm546147edp.46.2024.03.14.10.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 10:16:02 -0700 (PDT)
Date: Thu, 14 Mar 2024 18:16:02 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/29] xfs: add fs-verity support
Message-ID: <lveodvnohv4orprbr7xte2c3bbspd3ttmx2e5f5bvtf3353kfa@qsjqrliz4urs>
References: <171035223299.2613863.12196197862413309469.stgit@frogsfrogsfrogs>
 <171035223693.2613863.3986547716372413007.stgit@frogsfrogsfrogs>
 <20240314170620.GR1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240314170620.GR1927156@frogsfrogsfrogs>

On 2024-03-14 10:06:20, Darrick J. Wong wrote:
> On Wed, Mar 13, 2024 at 10:58:03AM -0700, Darrick J. Wong wrote:
> > From: Andrey Albershteyn <aalbersh@redhat.com>
> > 
> > Add integration with fs-verity. The XFS store fs-verity metadata in
> > the extended file attributes. The metadata consist of verity
> > descriptor and Merkle tree blocks.
> > 
> > The descriptor is stored under "vdesc" extended attribute. The
> > Merkle tree blocks are stored under binary indexes which are offsets
> > into the Merkle tree.
> > 
> > When fs-verity is enabled on an inode, the XFS_IVERITY_CONSTRUCTION
> > flag is set meaning that the Merkle tree is being build. The
> > initialization ends with storing of verity descriptor and setting
> > inode on-disk flag (XFS_DIFLAG2_VERITY).
> > 
> > The verification on read is done in read path of iomap.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > [djwong: replace caching implementation with an xarray, other cleanups]
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> I started writing more of userspace (xfs_db decoding of verity xattrs,
> repair/scrub support) so I think I want to make one more change to this.

Just to note, I have a version of xfs_db with a few modification to
make it work with xfstests and make it aware of fs-verity:

https://github.com/alberand/xfsprogs/tree/fsverity-v5

-- 
- Andrey

