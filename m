Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B86A3C46B
	for <linux-xfs@vger.kernel.org>; Wed, 20 Mar 2024 10:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710929770; cv=none; b=J3RmAQSAtF3s8u/94X55+rZ/ezk6Dzdh0b7Oo3oN+G3absexRHs7KU2KNbKRvADWrmIM2mg2rj8CTIbp1jM1l7xY7SyqyS+nDu6Qv0seKjd9zP3qwgayul9Y1PU9EGhIu9dgb8ICnvyNT3NUGhHJdjpvCXbRmgMGzEuey4AZlRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710929770; c=relaxed/simple;
	bh=rPa9t11DkjZ8Ed7kwM28DoTQ4P507YzandJi5vcUYHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RAyGaQqL2A3ND/BuvBo98KAK4dEeiLIc+M0zGjGbzCRRgK47Bzs2ywXkhWhElhUfxvNnwVmsMWThVXBeNmkY/mviDL0muUu4HzFAzFeVfH/sgIwXPjYmbuEniuaxjkh9++RaFSvWIcsdrdYI+GVhqhqTOzbQK3fk4pV4xCn4cuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ajzGFEgO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ajzGFEgO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710929767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t44WkNVUoNO+QtPNbszmzeZBcjv/Mxh37EetmY3mq4g=;
	b=ajzGFEgO+2bG5quG+zn5rkdjD2h0OMwHcizVFdqsRrN8zShppv01wUrdHv29S3B6X6PSXu
	ZGHiNWqm5imRdNJVLvDDljPoANFju443IRVHZdnPORG3A05bNBFfZE1UgBueua4Ru+h+Pq
	YY2j+bHqYyAPVYZIMLfRSM6vO/6Gc6E=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-33--owxrrYTOU2NR5tOAvo4Dw-1; Wed, 20 Mar 2024 06:16:05 -0400
X-MC-Unique: -owxrrYTOU2NR5tOAvo4Dw-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-56b7f548d3dso1614897a12.2
        for <linux-xfs@vger.kernel.org>; Wed, 20 Mar 2024 03:16:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710929764; x=1711534564;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t44WkNVUoNO+QtPNbszmzeZBcjv/Mxh37EetmY3mq4g=;
        b=iTBBhehoWsxJDTC7dETiw9cpSURnH0B5CRCr/6+W8aCXk17zFUbL8genilet2bqrLz
         Uq/0qQ7tut77oBv2dJQbobduLQmM9LMrEOmHssMcmL97nYe8FXeq1a/TM4EoQsEjvLdM
         rY8cp2prfTHqL69Ej2C3CLcAkElP5C8VZZyQzOmavXw2hyKtItXo4NU5nOlCBStLv5Nc
         oqq8brLrj/3II3GPZMiTtBdqqbFGO/HklRWLobKUh/RZw8dWR2JPPd+ObT55gqSMxobf
         gFGPNsYT2Nax6qhqazfrWDzB7i/at/oi9j59TNPDQS2eTbVxIAlpRly19rXUcG0tL1sg
         MSfw==
X-Forwarded-Encrypted: i=1; AJvYcCVp3Awx4FAHOZOATv4010CPxkoeMDX26Q2ZM+rjDMlPtID+P800xzzk2lM4AJxRYKfvm/g3ix5XBDIJ6XfF3Apkotf1ieQOwOy6
X-Gm-Message-State: AOJu0Yy0S5eQIUSOJcbMT3CPWbXGScv4AGaq+N5wgZ/6lJ9opl6X/ooq
	knrCNoX/e7zFQAxTPweYekU9E8sZDBw6QRJnXQ7WrGAVd+vkuzA4/+wiHf0XyCnLXelKxYEA/Jy
	qNo+B99GI8OKfs7QuVyMCILq8f9JaoZ3ots1thnOyTEtRvqQzUSij04zd
X-Received: by 2002:aa7:c402:0:b0:568:99fa:26c with SMTP id j2-20020aa7c402000000b0056899fa026cmr10205687edq.11.1710929764182;
        Wed, 20 Mar 2024 03:16:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG7TqJtJpn6F0nyXq620kFUM+OS+Yv9phf2USDD8d0KiBXDmdTBFbx3kb2cefQw/Lig8fvKUQ==
X-Received: by 2002:aa7:c402:0:b0:568:99fa:26c with SMTP id j2-20020aa7c402000000b0056899fa026cmr10205662edq.11.1710929763564;
        Wed, 20 Mar 2024 03:16:03 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id n13-20020a05640204cd00b00569aed32c32sm3327689edw.75.2024.03.20.03.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 03:16:03 -0700 (PDT)
Date: Wed, 20 Mar 2024 11:16:01 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, 
	Allison Henderson <allison.henderson@oracle.com>, Christoph Hellwig <hch@lst.de>, 
	Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-xfs@vger.kernel.org, mark.tinguely@oracle.com
Subject: Re: [PATCHSET v5.3] fs-verity support for XFS
Message-ID: <7ov4snchmjuh6an7cwredibanjjd6zvwcwyic6un6lafjt5e3i@kgt75bq3q56t>
References: <20240317161954.GC1927156@frogsfrogsfrogs>
 <171069245829.2684506.10682056181611490828.stgit@frogsfrogsfrogs>
 <20240318163512.GB1185@sol.localdomain>
 <20240319220743.GF6226@frogsfrogsfrogs>
 <20240319232118.GU1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319232118.GU1927156@frogsfrogsfrogs>

On 2024-03-19 16:21:18, Darrick J. Wong wrote:
> [fix tinguely email addr]
> 
> On Tue, Mar 19, 2024 at 03:07:43PM -0700, Darrick J. Wong wrote:
> > On Mon, Mar 18, 2024 at 09:35:12AM -0700, Eric Biggers wrote:
> > > On Sun, Mar 17, 2024 at 09:22:52AM -0700, Darrick J. Wong wrote:
> > > > Hi all,
> > > > 
> > > > From Darrick J. Wong:
> > > > 
> > > > This v5.3 patchset builds upon v5.2 of Andrey's patchset to implement
> > > > fsverity for XFS.
> > > 
> > > Is this ready for me to review, or is my feedback on v5 still being
> > > worked on?
> > 
> > It's still being worked on.  I figured it was time to push my work tree
> > back to Andrey so everyone could see the results of me attempting to
> > understand the fsverity patchset by working around in the codebase.
> > 
> > From your perspective, I suspect the most interesting patches will be 5,
> > 6, 7+10+14, 11-13, and 15-17.  For everyone on the XFS side, patches
> > 27-39 are the most interesting since they change the caching strategy
> > and slim down the ondisk format.
> > 
> > > From a quick glance, not everything from my feedback has been
> > > addressed.
> > 
> > That's correct.  I cleaned up the mechanics of passing merkle trees
> > around, but I didn't address the comments about per-sb workqueues,
> > fsverity tracepoints, or whether or not iomap should allocate biosets.
> 
> That perhaps wasn't quite clear enough -- I'm curious to see what Andrey
> has to say about that part (patches 8, 9, 18) of the patchset.

The per-sb workqueue can be used for other fs, which should be
doable (also I will rename it, as generic name came from the v2 when
I thought it would be used for more stuff than just verity)

For tracepoints, I will add all the changes suggested by Eric, the
signature tracepoints could be probably dropped.

For bioset allocation, I will look into this if there's good way to
allocate only for verity inodes, if it's not complicate things too
much. Make sense for systems which won't use fsverity but have
FS_VERITY=y.

-- 
- Andrey

