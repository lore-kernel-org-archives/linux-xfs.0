Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA251F941D
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 06:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728628151; cv=none; b=DSyLozX1iPXRzU5XmwJLGqf+ELax3ZdigfMZqbmHBSalGl6DzKEoiwtptzFM5NW0TOAT75NLStZa8QjowvTHsG7ow4nSRhIk4GaD56JCcbbUf42SrsmkEff2qTIGpiEfbxUU/S+cR8tGe4Pqq77jELboXZV4LYOBRDv3SlJ31gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728628151; c=relaxed/simple;
	bh=S1uYo3WnGJi+Jm48AgUOswFGK5Q+oevpIGDBNBT2njk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hTRk4xcU8qHZvOgM3CIGieW6rg3P3qMtjId/y2b7I9qwP47Lz14rpKzJeHXZ4A590rF+7kj9ZNc+T4guB0h6k9yw4vBXyE3tZiUYSDcOx5BfJizbmDOqD9u9fVSsD72ORCypCl5OgMizFsq/VJDhWNVSRTs573Uovi6GmX2Atn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PRrIIVZu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PRrIIVZu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728628148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tAX77JpkXj1IgOtJYAmPdVmTE+e6K2CbINuswBO6u2A=;
	b=PRrIIVZuueb6QT34gbtruYgEQ2gn2y2OParn8TfD+RH4f9LE+wwqhpx+scBwRYnjrVYbIX
	Yq0b3GqD44lmSD0sbbTZQtEBTNsm7MxFs9ok+FsjT1hAmwP8ZhkV6oFOUPdWOL67DIFZWm
	fxQn24sWDU8STIbb6zI6g+nh48LjYDk=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-379-klhSntdQM7iaWWBCTM_CbA-1; Fri, 11 Oct 2024 02:29:05 -0400
X-MC-Unique: klhSntdQM7iaWWBCTM_CbA-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-20c5ebadcf1so14997945ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 10 Oct 2024 23:29:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728628144; x=1729232944;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tAX77JpkXj1IgOtJYAmPdVmTE+e6K2CbINuswBO6u2A=;
        b=U1M94krQ1Oi9l1gcII1ZUobmBu5GBx6x6WrE2MooS5dAnrp6+jBTXxQHRAg04HJ3GY
         pjqSOVpx6D1DMiYo45dR8RzhgbP2A9RKX7lnQzq6VTghFtD0t2d7rMnorUp7trCgHBlr
         UVewjwORPVyYy07DDTfoEffJLUDhUez/ujFI6lGVxvqeiGk9oQGLXb0UktzqbZ2bqy7r
         7vdk73v4ica1VxED5u/skoYCbVILSuXKZfa8J7rWXXd5MrtHDrvkakdKlmx1JR3noxTh
         ndIlEArlBnVvRWVofWU0NNx7KQIMGy/8ilhvSDh5/xbNZjQXnKKeVWhz750SBZ5jP6hV
         F2uw==
X-Forwarded-Encrypted: i=1; AJvYcCWMonrV1RebJ7tVChBpdFg6SizVFwoKIVK0kzJ9a0YpBqTOno7F1J3ZF9rZ3/g8WM0J6A1KSqXmex0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyX+dcjjTWaRlivUilCA5hT0AxuJZUn5oykwXWJfAEpcdHwaka0
	AhFK354vzP/CGcBZmXDM/KocxHfj8gYjRleqqIypWJF8MVzF0m0Dwgg0EXDiDxQ8awosOh4uytR
	CvTGuIo7Gc3zYIvP/s+2r/TXtK9yZY8PjClWOXKU6ta6C+wMWFiEDB9Oafg==
X-Received: by 2002:a17:902:e5ca:b0:20b:bad4:5b6e with SMTP id d9443c01a7336-20ca16c34c3mr27422375ad.38.1728628144349;
        Thu, 10 Oct 2024 23:29:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJNnNXr7UM6hcRJCznLeV7hNtS79wfhSBqPzU6T1ga/7uC5Y2WiZKiDGCciCyZiVqLRbtqrA==
X-Received: by 2002:a17:902:e5ca:b0:20b:bad4:5b6e with SMTP id d9443c01a7336-20ca16c34c3mr27422135ad.38.1728628143999;
        Thu, 10 Oct 2024 23:29:03 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c311f3dsm18119745ad.234.2024.10.10.23.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 23:29:03 -0700 (PDT)
Date: Fri, 11 Oct 2024 14:28:58 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/122: add tests for commitrange structures
Message-ID: <20241011062858.p5tewpiewwgzpzbo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <172780126017.3586479.18209378224774919872.stgit@frogsfrogsfrogs>
 <172780126049.3586479.7813790327650448381.stgit@frogsfrogsfrogs>
 <ZvzeDhbIUPEHCP2D@infradead.org>
 <20241002224700.GG21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241002224700.GG21853@frogsfrogsfrogs>

On Wed, Oct 02, 2024 at 03:47:00PM -0700, Darrick J. Wong wrote:
> On Tue, Oct 01, 2024 at 10:45:50PM -0700, Christoph Hellwig wrote:
> > On Tue, Oct 01, 2024 at 09:49:27AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Update this test to check the ioctl structure for XFS_IOC_COMMIT_RANGE.
> > 
> > Meh.  Can we please not add more to xfs/122, as that's alway just
> > a pain?  We can just static_assert the size in xfsprogs (or the
> > xfstests code using it) instead of this mess.
> 
> Oh right, we had a plan to autotranslate the xfs/122 stuff to
> xfs_ondisk.h didn't we... I'll put that back on my list.

Hi Darrick,

Do you want to have this patch at first, or just wait for your
next version which does the "autotranslate"?

Thanks,
Zorro

> 
> --D
> 

