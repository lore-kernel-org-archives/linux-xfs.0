Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A1823DE
	for <linux-xfs@vger.kernel.org>; Sat, 11 May 2024 08:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715415569; cv=none; b=FIth8VUEfX9Kp56YhDLYgSIdx1+/r5xb7ebe0IpYybLkSiMs1oNuWV2iCYZ5u8Y65lSCT15FbXLHU0WcioalRHXWGLfh5cgI6Z5TrYFBQX7ni+N9sJcV0WtMWkRlovTSJmez8WeHcSmbhU3C4iyAaKp/IHGUPxOSrxmazdR5v3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715415569; c=relaxed/simple;
	bh=2OZMXGB6WmM+eQ090KLbEMT1YAST6FDOek74sNJLFLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IWg77RR0kxmp9PXlpKZiBhDhDuWnXybHs7ppgPVqD/sKyDB7wlLVzTYdIDRDpMDsQE6AgebQUUI5WQ5BVX4NPXGsMiflAp+Ceh7haP0DwBhJNZ16Kjg8X83Ar9aCcezDYiTNlwupPFxrSO6kKFFZvO/X5vP24I1Cc0nfFLVldi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=2pfo+utF; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="2pfo+utF"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1ecddf96313so24460905ad.2
        for <linux-xfs@vger.kernel.org>; Sat, 11 May 2024 01:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1715415567; x=1716020367; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MUthQUqcUjWgQsTtDQ43vX6F+m8ZU5WTSdlKExiUawI=;
        b=2pfo+utFQDvugBPAc4iaEbbPKCpkoXvZ76tSYEtLsbrMwqwPvqnL+ljOHCRwK2NAOs
         afI1U4L9u8GYzOZD/U6HXrCrJDQS+Kq0xWmHp4cbMRQa9mLKanCOKMOjbEXrKyG8IIO6
         lY+DcM+u2lft+GgN4Ttm0UPK0TZucREocJWftu4rhaMFmHT1uDxcPkbcthuoPAp/xfD3
         DenY74NQfPh8ENWFdyDl2aGA+bOo3ucgMpmQXr0tu7umghZmFF33CHeHPkW3eQbKqXhc
         JgSZF8ftFY0OIKzxucfnfNgaLSlT9GJQeTWJ0AgqMtN5lu43BBIS0aw7X8X+q3ulwZ3O
         nyYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715415567; x=1716020367;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MUthQUqcUjWgQsTtDQ43vX6F+m8ZU5WTSdlKExiUawI=;
        b=whsWG1F921d0hQOMcQx2vKvplU2aGz8a1/l3rHVfxaXEcP6mf+Yk9vyVxvv2pQ58cM
         yJmHCk1HnSCwuI9UtC/z2K5mAn6/lyZ+ILZIkzjll5VSIdsAoHQZdnq3FnxQT2IchwpF
         msBFwyyeGkapsIaYkWBVlu8wQCmqsu98uf1ApxL6t5ejW7tmOusjL2avleSyvMX/wCOt
         TirqW6agZ3yB/P8bVra4d6+yeVi0QkUTYCZm00iiLSlFAlk8YBVHVYjOEXYezIUUJRC9
         cpRUa+havFRJXhJ7EzVZAoygpy3juvST5FEVB0JEjNS/q6IWoOYj5Ujx+v7vfxKbl5Hi
         XFSA==
X-Forwarded-Encrypted: i=1; AJvYcCUbHrbDly6eDg0qVv8rUgGiqoXuBG+7pwsxb0leDfEMnDO229T+3Ogvn426GtlbGBAhjbLGT6ivFqD+iHBDSt2jlSOjGILNkoPl
X-Gm-Message-State: AOJu0YzCwMaJQctqyB7fAWqZtOlYHwJBpNiUpf/135s/j5/oacT1TrJT
	P2B4M1xEM+3E3cTYLoDR+7kXj/6a/FqJMGm7PBqgfK+Unr+dIk93HDB32ysIWNQ=
X-Google-Smtp-Source: AGHT+IHCwwZbtfTWmULr9Mh0erj+EYuxFa+MYYEo/S8Xmajrq2CUmsDT8p9k4yr/VOeEyB9xFkUA9w==
X-Received: by 2002:a17:902:e808:b0:1eb:4a72:91ff with SMTP id d9443c01a7336-1ef43f4e4c3mr80525005ad.49.1715415567393;
        Sat, 11 May 2024 01:19:27 -0700 (PDT)
Received: from destitution (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0bf30fb1sm44160135ad.177.2024.05.11.01.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 May 2024 01:19:27 -0700 (PDT)
Received: from dave by destitution with local (Exim 4.97-RC0)
	(envelope-from <david@fromorbit.com>)
	id 1s5hwy-00000000XW0-24OY;
	Sat, 11 May 2024 18:19:24 +1000
Date: Sat, 11 May 2024 18:19:24 +1000
From: Dave Chinner <david@fromorbit.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Chandan Babu R <chandanbabu@kernel.org>, djwong@kernel.org,
	Christoph Hellwig <hch@infradead.org>, brauner@kernel.org,
	Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Subject: Re: [BUG REPORT] generic/561 fails when testing xfs on next-20240506
 kernel
Message-ID: <Zj8qDHJBL5igjVrJ@destitution>
References: <87ttj8ircu.fsf@debian-BULLSEYE-live-builder-AMD64>
 <6c2c5235-d19e-202c-67cf-2609db932d5a@huaweicloud.com>
 <Zj7pzTR7QOSpEXEi@dread.disaster.area>
 <966892ef-9b47-3891-e2d2-48889d46223d@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <966892ef-9b47-3891-e2d2-48889d46223d@huaweicloud.com>

On Sat, May 11, 2024 at 03:43:17PM +0800, Zhang Yi wrote:
> On 2024/5/11 11:45, Dave Chinner wrote:
> > On Sat, May 11, 2024 at 11:11:32AM +0800, Zhang Yi wrote:
> >> On 2024/5/8 17:01, Chandan Babu R wrote:
> > It might actually be easiest to pass the block size for zeroing into
> > iomap_truncate_page() rather than relying on being able to extract
> > the zeroing range from the inode via i_blocksize(). We can't use
> > i_blocksize() for RT files, because inode->i_blkbits and hence
> > i_blocksize() only supports power of 2 block sizes. Changing that is
> > a *much* bigger job, so fixing xfs_truncate_page() is likely the
> > best thing to do right now...
> > 
> 
> Thanks for the explanation and suggestion, I agree with you. However,
> why do you recommend to pass block size for zeroing in to
> iomap_truncate_page()? It's looks like we could fix xfs_truncate_page()
> by using iomap_zero_range() and dax_zero_range() instead and don't use
> iomap_truncate_page() and dax_truncate_page().

Fair question. Yes, we could just fix it in XFS.

But then any other filesystem that uses iomap might have the same
problem where the allocation block size (and hence the range that
needs zeroing) is different to the filesystem block size (e.g. ext4
with bigalloc?). At that point, those filesystem developers need to:

	a) be aware of the issue; and
	b) implement their own iomap_zero_range() wrapper for the
	same function.

If the iomap infrastructure doesn't assume block sizes are always
i_blocksize() (which is clearly a bad assumption!), then the API
itself informs the filesystem developers of the fact they really
have to care about using the correct allocation block sizes during
EOF zeroing.

At the moment, only XFS uses iomap_truncate_page(), and only ext2
and XFS use dax_truncate_page(). It seems pretty simple to change
the infrastructure and document why we don't use i_blocksize() at
this point. Especially considering we have forced alignment stuff in
XFS coming up which further decouples allocation unit (and hence
zeroing range) from the filesystem block size....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
