Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9665676E
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 11:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711451654; cv=none; b=j5u8GeqLVnVhfXMuFIEJNViR6PrnoVgMS6EDj7iodoD8tvIwDoJ2hSN70cuttc/H2unrtrFsrq20rNr7oM9liqxzZ8ahGUOcC/lvYs3ZVz3D3Q0Leca5X/uy587RTeZ8BZVaLtEEXsLHUOZ9U7r0LzM0LI8TNUyGi538ir6wuKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711451654; c=relaxed/simple;
	bh=TYMtfvN2vUnRHd6EWkh9ZqTFU7JiBbIR99/HAjSX77k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ag5PdntCx+D/92gUZ1t3rmucq8B/05AeV3yrGrtwOMW7TWRjzjpJFPzL4u9O+jySIEWSzvJG6rZ/NM4Q90MfmYn+P9mz33Z3ZxjywMXKqWU17MNRHCiNT9fpuxYPwqODuCMVrvfOdvb07/fVPqATTghi6oTPRXlu4vXRu+QigEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fIDMocMw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fIDMocMw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711451652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4gvtX7ytW1UnmTr6oylQHGYU56ln9d+44kJej9o2BNg=;
	b=fIDMocMws8XBF7mDet05F9WnNfRFXXwf7Q4wY7iitd497TBD5mqCIrPmWDDOsa3ZbJyaCH
	0VyMmZ2HUVmszoRJHD+cm7tJLp0qaf9RRBdMKiYxM89Qq2e8IQ7Upimh3fOaWzs3q0O0iD
	lcyj6ZBbpg01e/ZzeNhcCFOafVz56PM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-427-ju5VqdQANq-C3y0BQO8mjA-1; Tue, 26 Mar 2024 07:14:10 -0400
X-MC-Unique: ju5VqdQANq-C3y0BQO8mjA-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-56c1c344fe0so703349a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 04:14:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711451649; x=1712056449;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4gvtX7ytW1UnmTr6oylQHGYU56ln9d+44kJej9o2BNg=;
        b=iGbRnMkujBi9qDPdsEvrUgAJwsj77M0X2VoT0c1mh7yJdYxTPaP6JZU+4Hi3yR5ete
         oywTCw9FDk2prOIiRzZkwXeiuwoIDPAt7i/O+m46Y/86DshWXU76FLPl78x8QBo5EyIH
         Qh7Q5xITnK374pqJPeqHd7LDqfVdbfEkgqrwamK+0hYh2BO2MaKuWnlgjPiBtAUBNbJp
         OupofbAG+mqBmb3TdpIoF2ThCzhDB/JmKrJAep2yD3oG0SofaWWFqkj6crbX0fK6o6tH
         MtYMehG92Xh7fm5THjgteIVGS7J9qNKYRY36ECAzULkKiIbrrWeOw/uDrFOpDJbZsskq
         XItA==
X-Forwarded-Encrypted: i=1; AJvYcCX6Jw04fFJC6h0YG/qQg6tOSwjPmDgLJb4KNY9huJTwh0aYTAsHkZXqTS1curt++m9dPN62ceLsfFXDA1IEC6IYcjGG4drxaGhQ
X-Gm-Message-State: AOJu0YzE+TjVQAaU7COS8zPGjNg/eg1FZnFa/LfDiOJJyOleolVfkZIl
	clKkXFfKEAkl4WkxqgHg+VIDaZv4juqCdgysmmPXHmWIiyiMPDLEk5psLTLB2yGwbKp5rYm2bIh
	r1YXr/YiR3uIGK1Zkd13lA9L5UO8Gc8o4lS/IrQE/OgTl0dmrhWaJJX1H
X-Received: by 2002:a50:d5cb:0:b0:56b:cbb6:f12b with SMTP id g11-20020a50d5cb000000b0056bcbb6f12bmr6394796edj.41.1711451649264;
        Tue, 26 Mar 2024 04:14:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH9G+oAGBajKHJGKZJ1BqUzj64gXzHas8/hLl8OK59dXzf5a7WIti2wmaIWM9kOtnJxdLgd7A==
X-Received: by 2002:a50:d5cb:0:b0:56b:cbb6:f12b with SMTP id g11-20020a50d5cb000000b0056bcbb6f12bmr6394764edj.41.1711451648622;
        Tue, 26 Mar 2024 04:14:08 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id n1-20020aa7c781000000b0056bb65f4a1esm4015250eds.94.2024.03.26.04.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 04:14:08 -0700 (PDT)
Date: Tue, 26 Mar 2024 12:14:07 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: dchinner@redhat.com, djwong@kernel.org, hch@lst.de, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, mark.tinguely@oracle.com
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to f2e812c1522d
Message-ID: <s2kxdz3ztpuptn3o2znqpsbskra5yqxqnjhisfjxyc3cqw33ct@k6bvhr2il2sn>
References: <874jcte2jm.fsf@debian-BULLSEYE-live-builder-AMD64>
 <wdc2qsq3pzo6pxsvjptbmfre7firhgomac7lxu72qe6ard54ax@fmg5qinif62f>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wdc2qsq3pzo6pxsvjptbmfre7firhgomac7lxu72qe6ard54ax@fmg5qinif62f>

On 2024-03-26 12:10:53, Andrey Albershteyn wrote:
> On 2024-03-26 15:28:01, Chandan Babu R wrote:
> > Hi folks,
> > 
> > The for-next branch of the xfs-linux repository at:
> > 
> > 	https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
> > 
> > has just been updated.
> > 
> > Patches often get missed, so please check if your outstanding patches
> > were in this update. If they have not been in this update, please
> > resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
> > the next update.
> > 
> > The new head of the for-next branch is commit:
> > 
> > f2e812c1522d xfs: don't use current->journal_info
> > 
> > 2 new commits:
> > 
> > Dave Chinner (2):
> >       [15922f5dbf51] xfs: allow sunit mount option to repair bad primary sb stripe values
> >       [f2e812c1522d] xfs: don't use current->journal_info
> > 
> > Code Diffstat:
> > 
> >  fs/xfs/libxfs/xfs_sb.c | 40 +++++++++++++++++++++++++++--------
> >  fs/xfs/libxfs/xfs_sb.h |  5 +++--
> >  fs/xfs/scrub/common.c  |  4 +---
> >  fs/xfs/xfs_aops.c      |  7 ------
> >  fs/xfs/xfs_icache.c    |  8 ++++---
> >  fs/xfs/xfs_trans.h     |  9 +-------
> >  6 files changed, 41 insertions(+), 32 deletions(-)
> > 
> 
> I think [1] is missing
> 
> [1]: https://lore.kernel.org/linux-xfs/20240314170700.352845-3-aalbersh@redhat.com/

Should I resend it?

-- 
- Andrey

