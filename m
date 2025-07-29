Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D558CA4B
	for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 15:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753804215; cv=none; b=NdF05sYA8fcwQ97H+3pHPVyKBjaTe0DUhorGnlRXHBmYwLuXxQM6H8XjPmEsq073wHn0H3ky5ZB+PflNZ5d8lCxkm7FHPw4n5vXfVIkKFLqXtY1GxETYMxPE45ot1p6TkaT5+OYjyDnXV34atEnbYeYf5aEW+32/mLIwK8ru+rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753804215; c=relaxed/simple;
	bh=rW9Z4ZyoAK+RHOECxaujpg8pAfbvWdq31hpZER0K8AE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tASA4Q18QmcAogbxdHyQo+I3mSvRTs4nNnhCf+Nzp5E5uYxntSaiivPSB99g89RLIhq3O00D/LQDBoQQUvvrf2sXcCeZcGicaTbkCDty3Vs0hrcYupmH/a1cwa6WHRXnOQ48owd30+LeYV99hvc3TtZmy3H/zy1DHp9R3JUJXpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b2PUsOpg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b2PUsOpg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753804212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AUJo+uiLFiqfc0U72Y26OLr9d2m3KKZMF7FWcln1o3Q=;
	b=b2PUsOpgyZu5c/O417uW0JgR4oq3OTkekeJ9av99bl3Pmv+BqujBsL/LP2X/eFYR8zBmbP
	9qJSbf0Va9J9osKWdtUG7DS57nDLuBAd8K0+zo4Cib/LAKeWsjeYEMMErRdEemykYb1cug
	aC5E6riLdQlZUDdTi6QgUeIO3T0aNDI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-hA4llvjNOd2ppSgyV3Kyug-1; Tue, 29 Jul 2025 11:50:10 -0400
X-MC-Unique: hA4llvjNOd2ppSgyV3Kyug-1
X-Mimecast-MFC-AGG-ID: hA4llvjNOd2ppSgyV3Kyug_1753804210
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6149374a4c8so15105a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 08:50:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753804209; x=1754409009;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AUJo+uiLFiqfc0U72Y26OLr9d2m3KKZMF7FWcln1o3Q=;
        b=D8LQb9ChcCB5CC59M9sLeURBY8It74XvMAqNg2NESLFA70IN1qiy6kDdCznuKEAWIO
         aclN9rDi/v4qHnRYmuuzZPZyZAJ5DcH59iTHnDyuleUvhUx5hi9+RAL8uOvaSJhfFJhI
         vGbI7GEbdX4SBi8Wqn51f+mjEQpO3E8AASnk81ldgxcCXYeXyblDSmvDkulPUCXqp1kO
         enpMWh1TLObqjRLKUJYj2TbJJUSDgnkNCe2X4ViP2P8iFPPU0nPMVwWX9G3KzA+kkF2D
         kAWFUb3n2860uBJXhCCpfMtKgjQ7Sp3Mv9kwF8/ttMXk59VdJDqSkwMywuZWzICr+YIZ
         G5yQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4h2F7PEhXRykI36dj0bc9tHbxMXi+V+iP2oRsldtpQ2rLoXzKkEu/EdvkSZny4Q3XbIEWGxhVcAE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9OxQcM6s6CrVDLqS6uYKhuwR9PRShr5m4Y0weXqW1abr7TrPT
	9sTemPJZzoyBywP+kdM6C0hSddL+ZI1Nqn8TvC0D5JbgEIaOi+XPGNhdNdAGzQ5LEXgvMAn2gnY
	ziKzfVnYCoKWMgB1YbBpY0lAWL8yi3Qd6zBSpWfzWbDI+SeEPo+JrDoAjtVmg
X-Gm-Gg: ASbGncvT2nBGVaKASuZW/nKAgEgXsKVBGfOn5ss/20sUEIDm3geEIKY06PfeWFZRPi7
	tCTj/p0veF0G6TjF+fQ+C/vLRYsk0t8W5ZFK7VdldtA943rn+N76qxnyoITgmqrSCBCJJVgQv81
	p9tHQzv+Epcb6ecVNlFsvy3sJ/0zIdnSczh0Swzxn6yvBUv3SnEORcPfdFZniwwl7zGWqkp+SBN
	HKESfQPwsbMFnsM2EdwYq48JTKs7N7BCp2uWpLLc/zvMWuAbDLMfdq7hBBCyONe2v99+Z9o/BiF
	+jFF1OR38JLFJp5BRF0teuAtv5r5OCv9BraXZVzqCBMMUpTR8rCS6Lue49U=
X-Received: by 2002:a17:907:d716:b0:ad8:959c:c567 with SMTP id a640c23a62f3a-af8fd043e1cmr6155266b.10.1753804209518;
        Tue, 29 Jul 2025 08:50:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH3vZZEpsKNE918LrfYMVtWSM3PRy714B1v8/F+Aoi0E4/uzXAYjijZAiT0rJMelnNd9XVcoQ==
X-Received: by 2002:a17:907:d716:b0:ad8:959c:c567 with SMTP id a640c23a62f3a-af8fd043e1cmr6151666b.10.1753804209129;
        Tue, 29 Jul 2025 08:50:09 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af8f1b17329sm63652866b.83.2025.07.29.08.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 08:50:08 -0700 (PDT)
Date: Tue, 29 Jul 2025 17:50:08 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/3] Use new syscalls to set filesystem inode attributes
 on any inode
Message-ID: <5jw4nzpg26faxkzyeo3n2yczqxjczyq5c7qukfvqkx5e254m4k@tafsr7bdstcd>
References: <20250729-xfs-xattrat-v1-0-7b392eee3587@kernel.org>
 <20250729143411.GA2672049@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729143411.GA2672049@frogsfrogsfrogs>

On 2025-07-29 07:34:11, Darrick J. Wong wrote:
> On Tue, Jul 29, 2025 at 01:00:34PM +0200, Andrey Albershteyn wrote:
> > With addition of new syscalls file_getattr/file_setattr allow changing
> > filesystem inode attributes on special files. Fix project ID inheritance
> > for special files in renames.
> > 
> > Cc: linux-xfs@vger.kernel.org
> > 
> > ---
> > Darrick, I left your reviewed-by tags, as the code didn't changed, I just
> > updated the commit messages. Let me know if you have any new feedback on
> > this.
> 
> It all looks ok except for s/(file| )extended attribute/fileattr/
> 
> Seeing as the VFS part just went in for 6.17 this should probably get
> merged soonish, right?

Without this special files won't be able to use these syscalls, but
otherwise, for regular files nothing changes. So, I think it not
necessary for this to get into this merge window.

> 
> --D
> 
> > ---
> > Andrey Albershteyn (3):
> >       xfs: allow renames of project-less inodes
> >       xfs: allow setting xattrs on special files
> >       xfs: add .fileattr_set and fileattr_get callbacks for symlinks
> > 
> >  fs/xfs/xfs_inode.c | 64 +++++++++++++++++++++++++++++-------------------------
> >  fs/xfs/xfs_ioctl.c |  6 -----
> >  fs/xfs/xfs_iops.c  |  2 ++
> >  3 files changed, 36 insertions(+), 36 deletions(-)
> > ---
> > base-commit: 86aa721820952b793a12fc6e5a01734186c0c238
> > change-id: 20250320-xfs-xattrat-b31a9f5ed284
> > 
> > Best regards,
> > -- 
> > Andrey Albershteyn <aalbersh@kernel.org>
> > 
> > 
> 

-- 
- Andrey

