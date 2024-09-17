Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EBD1862B9
	for <linux-xfs@vger.kernel.org>; Tue, 17 Sep 2024 22:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726611150; cv=none; b=TjlAB4MAKdPVvJ458X8Im2j1K7z61VRmectJ1z1D45J4+FbWVES5yhyA86ezlCQv98pqZ6QaPWyiuFI1mW2knyfZc4MsgWzoMxVK9QNAQ6HDbu54WnR4JTlenVC1rToPXGYg2Nry9N2f5HivMCAbx0XzpBvQpmnhAcMWAUCY9pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726611150; c=relaxed/simple;
	bh=WWQPzPB6XklDRgv0vLVv5iItdWfgdPNrU/E2toBl9zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gd8w2LEH4EAsuyW9q0ucdf3sgVRcPMLiJPB/ppvP68s1CvH9rcQd37+lyHNgM3CuxLEHX+36+K9X+NktW3pMTgmrBAFgZPzMhQyNLusQTq+ABMLQr8oBKQTaQ66vuOHMPl5eSU8MXfEEHQFnVCZv7+MZcUecjf+ieOIrBNZIZmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=nwn1BEkr; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="nwn1BEkr"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-205659dc63aso59894335ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 17 Sep 2024 15:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1726611148; x=1727215948; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vph46MtSHnTYp0ntwJB5uF+q0djCNtjTNx1dscTaD4I=;
        b=nwn1BEkrIrSzdFObK+hiyyUqX9cx6OabUE4iEyYx8MgS4emwyS5FfYo/ZG/EDGQusO
         oLk/wt65kVGbDcBsF1LGQM+pfFEM8DoS8559Ke0FDflAxZ3wCdSKdcLPoJvWSqwTT8g5
         flwJPkKk1CZ6eMDVlJfjNqY6CHIts75Cj416XIHSbJVS5uyXJ2fCS6KrGDE+cLoMRcDq
         yU+XbfoHA1C4/25IX9S6j8qb8oP4aRIDdeNqs+ZKdWgyIYHDemYXzkQdyfufqTbtoo6k
         puW2UC8oPcWCYpVQwhn3oEJ0M7NFuuyRykMvqC/XvIKftdG797Kw7Lsj+W9ULY4cJrC/
         M/YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726611148; x=1727215948;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vph46MtSHnTYp0ntwJB5uF+q0djCNtjTNx1dscTaD4I=;
        b=bRC2Tu1uPxP+97KMRZKHa+pBgdeoLWTCwe2UnSMCxAMpivQbizbn5Durkbgy+JBt/q
         3oCsU4owsV4KcjQjoKfvZ3u6nImQmrFGTfF/1nTb34ohc+bRbIMkF+83RKj8b3eZNs6V
         w8c8NenbpUOWa0su3LKy+KKeEenUFMVV2WVyCuoBXVqsee3tE6lUB+ekjse4zxMGrHF1
         YYKjePW/lLdvme8Qm4us+zvbvsx/5XdwK5F8nWAn8Yxm1yjB0i+Jl+vd+EdMcc2mpiIU
         BuzcpeAy9FwH6f+8spzDHkJ0aKJUN90j8mAxnR30LhJu49wogy/7onCY4LbLrdRbZoAl
         fOmQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7zhg1lIpgETp7nTXfQrZlK5+cbxoWTof54XYsuN6CBiWH5vl5gO+Kly2DGOaqCofpr4XNFqCIPag=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOUtl+cJtUn8oEt9AfhWpmYu6iqE5UiiC4Oin8QozOCPwlfFWQ
	MIVwqxsI/wmyXqweL4vvB/+y6rUZJ+Ua25ubivL1gSQ+ZzbYCkh+MtKlw5yHWHg=
X-Google-Smtp-Source: AGHT+IEFU5lXa7bN+x6NP0rB51iaOBq6eYNCKDJAX7u54ocjAxzPQV7qI/M7WvKTTKiqWid16LuRUg==
X-Received: by 2002:a17:902:e5d1:b0:206:c2e3:68ef with SMTP id d9443c01a7336-2076e3c2048mr307007945ad.22.1726611148438;
        Tue, 17 Sep 2024 15:12:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20794731627sm54665565ad.266.2024.09.17.15.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2024 15:12:28 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sqgQr-006Xav-0U;
	Wed, 18 Sep 2024 08:12:25 +1000
Date: Wed, 18 Sep 2024 08:12:25 +1000
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, chandan.babu@oracle.com,
	djwong@kernel.org, dchinner@redhat.com, hch@lst.de,
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, catherine.hoang@oracle.com,
	martin.petersen@oracle.com
Subject: Re: [PATCH v4 00/14] forcealign for xfs
Message-ID: <Zun+yci6CeiuNS2o@dread.disaster.area>
References: <20240813163638.3751939-1-john.g.garry@oracle.com>
 <87frqf2smy.fsf@gmail.com>
 <ZtjrUI+oqqABJL2j@dread.disaster.area>
 <877cbq3g9i.fsf@gmail.com>
 <ZtlQt/7VHbOtQ+gY@dread.disaster.area>
 <8734m7henr.fsf@gmail.com>
 <ZufYRolfyUqEOS1c@dread.disaster.area>
 <c8a9dba5-7d02-4aa2-a01f-dd7f53b24938@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8a9dba5-7d02-4aa2-a01f-dd7f53b24938@oracle.com>

On Mon, Sep 16, 2024 at 11:24:56AM +0100, John Garry wrote:
> On 16/09/2024 08:03, Dave Chinner wrote:
> > OTOH, we can't do this with atomic writes. Atomic writes require
> > some mkfs help because they require explicit physical alignment of
> > the filesystem to the underlying storage.
> 
> If we are enabling atomic writes at mkfs time, then we can ensure agsize %
> extsize == 0. That provides the physical alignment guarantee. It also makes
> sense to ensure extsize is a power-of-2.

No, mkfs does not want to align anything to "extsize". It needs to
align the filesystem geometry to be compatible with the underlying
block device atomic write alignment parameters.

We just don't care if extsize is not an exact multiple of agsize.
As long as extsize is aligned to the atomic write boundaries and the
start of the AG is aligned to atomic write boundaries, we can
allocate hardware aligned extsize sized extents from the AG.

AGs are always going to contain lots of non-aligned, randomly sized
extents for other stuff like metadata and unaligned file data.
Aligned allocation is all about finding extsized aligned free space
within the AG and has nothing to do with the size of the AG itself.

> However, extsize is re-configurble per inode. So, for an inode enabled for
> atomic writes, we must still ensure agsize % new extsize == 0 (and also new
> extsize is a power-of-2)

Ensuring that the extsize is aligned to the hardware atomic write
limits is a kernel runtime check when enabling atomic writes on an
inode.

In this case, we do not care what the AG size is - it is completely
irrelevant to these per-inode runtime checks because mkfs has
already guaranteed that the AG is correctly aligned to the
underlying hardware. That means is extsize is also aligned to the
underlying hardware, physical extent layout is guaranteed to be
compatible with the hardware constraints for atomic writes...

> > Hence we'll eventually end
> > up with atomic writes needing to be enabled at mkfs time, but force
> > align will be an upgradeable feature flag.
> 
> Could atomic writes also be an upgradeable feature? We just need to ensure
> that agsize % extsize == 0 for an inode enabled for atomic writes.

To turn the superblock feature bit on, we have to check the AGs are
correctly aligned to the *underlying hardware*. If they aren't
correctly aligned (and there is a good chance they will not be)
then we can't enable atomic writes at all. The only way to change
this is to physically move AGs around in the block device (i.e. via
xfs_expand tool I proposed).

i.e. the mkfs dependency on having the AGs aligned to the underlying
atomic write capabilities of the block device never goes away, even
if we want to make the feature dynamically enabled.

IOWs, yes, an existing filesystem -could- be upgradeable, but there
is no guarantee that is will be.

Quite frankly, we aren't going to see block devices that filesystems
already exist on suddenly sprout support for atomic writes mid-life.
Hence if mkfs detects atomic write support in the underlying device,
it should *always* modify the geometry to be compatible with atomic
writes and enable atomic write support.

Yes, that means the "incompat with reflink" issue needs to be fixed
before we take atomic writes out of experimental (i.e. we consistently
apply the same "full support" criteria we applied to DAX).

Hence by the time atomic writes are a fully supported feature, we're
going to be able to enable them by default at mkfs time for any
hardware that supports them...

> Valid
> extsize values may be quite limited, though, depending on the value of
> agsize.

No. The only limit agsize puts on extsize is that a single aligned
extent can't be larger than half the AG size. Forced alignment and
atomic writes don't change that.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
