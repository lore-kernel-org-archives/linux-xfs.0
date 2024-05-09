Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7132512838D
	for <linux-xfs@vger.kernel.org>; Thu,  9 May 2024 23:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715298941; cv=none; b=V1aWZSfTLYl2sff3hxLWoGEMV+hxq1sKuGqJRtLgN6jpPLSP3zH0rBGTyI/vhvfEyj55Dygur3RcMSIbfp6DRXdJqyGQRCx/Cvp+OAaTjSeH02RfBoLNGo61GKNnYxEFdoimfYbyP3q9XVhR1dEw6Ag7gpwEt6z+9OtPbifq0/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715298941; c=relaxed/simple;
	bh=Ul7WOgsDHvpS+MEMu5IPMkjPvsDYPZ5bQeOuPOz7u/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U5OUsFp6fRvuWIY7GbWGzdiSlc9a8CeW3Hw+9QMGexLBHh0/OKD8kUQURWl9UmAYr68NXhRhxBMCHnS1LKczCJoHhDpBh3ejRTxdCQOpa3RxcVd6X0exhBLALFNHfJbN3bDChFyqmqG4gRoyU0P31maV137C9dyKmL8jFS5HfYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=fepZsJ/5; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="fepZsJ/5"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1ec41d82b8bso13189905ad.2
        for <linux-xfs@vger.kernel.org>; Thu, 09 May 2024 16:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1715298938; x=1715903738; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dRx1Bh8jsqURe9oYzdfY8r6TtvDzTymI8KoZRpomEtM=;
        b=fepZsJ/54t79V/hTeCEy9ODVe3lhkTccD5FWh1m8eJHoy3Ml4BwETHfF49FNHNTTIl
         nrHj4uzFXNGrGeW2dGXxcopxatXDsoC63z3+tMwmvfg5b3tBFTkw209NhCsAXNPY/gOb
         /lCTMkApamdyvaUlxy9NpK9ecpzjTOgJTEt6i4VIHncApf74+4+J2IHjzOHMxTt92fvy
         05qIhuvC+rr8DZtNgas7C1Xvux/gEfgK7POcGtLiZlL5A6FnbP5ilLyQFU4O9bsmAVQU
         Le3udEweqihHrb2Ps77C8J3umTwW1MC2SA2MFd17ZJpjEW//fWdsdT9jbsepJ7M8OHFL
         +wtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715298938; x=1715903738;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dRx1Bh8jsqURe9oYzdfY8r6TtvDzTymI8KoZRpomEtM=;
        b=kAZJMuGVn63XWoB2VA10UwdiLZ31VoL8VCu1vMSfcTiPjuaA0g15A9t/6FilDKHT9N
         Jl0gc1LDsLdD6F50BvbmQ3fxGSP3DOIAsU2YYs/4fsTuQJ5IF4jibx75s4vzBCI3O4zz
         8/qa35M+nEIPtKghgkq3LmuGahiH+J160YVh45/tBkn3dAo6cCNsdKfyRvplfsoPS5lK
         n+yBKcjs899HZ4hmpVHhQyoGsmP0P8Coingyu0dkpnVTfdRonMC8DW11eItxKqOe381c
         3HlW1VDLktMWb/2QXebgJGrXBw/dw8r03FOBjtYj23rhv4ArosihTWt6I5Y3c34uUdvr
         UvZg==
X-Forwarded-Encrypted: i=1; AJvYcCUNxNOWv8jxBh84X1QcsKdZZZez9v+6DCmpmraWKIpeiR4QB7AWW/u3yzQlSdKRTDAxrUnbORLvkpKYubNC29N817SVpZ56DNg9
X-Gm-Message-State: AOJu0Yy1wLuDU3xWLnRKuJgjZNvz5pcQkwRyT07086FAX1cbcu3RFo9E
	c9YkXbazp6s3DPuD792jBZgbk3C5a8cvnAlP67QlMm1hJSq3eEyFe7iCeDsb+Ks=
X-Google-Smtp-Source: AGHT+IFwz2GABdkOkLSmPd78+IHOWE3dD0JNX+/3IRsyD9bMbCkArnQMrFpZNuoa7Ta9vsR8ecS7+w==
X-Received: by 2002:a17:903:1d2:b0:1eb:2ee2:43bd with SMTP id d9443c01a7336-1ef43d0acc1mr15586555ad.7.1715298938420;
        Thu, 09 May 2024 16:55:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0c137e7esm19584195ad.257.2024.05.09.16.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 16:55:37 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1s5Dbr-009aLr-0v;
	Fri, 10 May 2024 09:55:35 +1000
Date: Fri, 10 May 2024 09:55:35 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-fsdevel@vgre.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: add XFS_IOC_SETFSXATTRAT and
 XFS_IOC_GETFSXATTRAT
Message-ID: <Zj1id6YGbEn4mUcg@dread.disaster.area>
References: <20240509151459.3622910-2-aalbersh@redhat.com>
 <20240509151459.3622910-6-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240509151459.3622910-6-aalbersh@redhat.com>

On Thu, May 09, 2024 at 05:15:00PM +0200, Andrey Albershteyn wrote:
> XFS has project quotas which could be attached to a directory. All
> new inodes in these directories inherit project ID.
> 
> The project is created from userspace by opening and calling
> FS_IOC_FSSETXATTR on each inode. This is not possible for special
> files such as FIFO, SOCK, BLK etc. as opening them return special
> inode from VFS. Therefore, some inodes are left with empty project
> ID.
> 
> This patch adds new XFS ioctl which allows userspace, such as
> xfs_quota, to set project ID on special files. This will let
> xfs_quota set ID on all inodes and also reset it when project is
> removed.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>

This really should be a VFS layer file ioctl (like
FS_IOC_FSSETXATTR). Path resolution needs to be done before we call
into the destination filesystem as the path may cross mount points
and take us outside the filesytem that the parent dir points to.

IOWs, there should be no need to change anything in XFS to support
FS_IOC_[GS]ETFSXATTRAT() as once the path has been resolved to a
dentry at the VFS we can just call the existing
vfs_fileattr_get()/vfs_fileattr_set() functions to get/set the
xattr.

The changes to allow/deny setting attributes on special files
then goes into fileattr_set_prepare(), and with that I don't think
there's much that needs changing in XFS at all...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
