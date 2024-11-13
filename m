Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741FA382
	for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 01:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731460204; cv=none; b=Favc9Y9yXLABw06OIoB+FnMgAJQS/N7gaNSegdy/yr1iOpShkH5w64dfoXzr5hfzDl+6Q3C4CMqXWxVJN2qj225LcAK5xUsJA0Wx1FhFRI/hjs+4zCOcE3EMIAyjZzkxhZjDtJhJrjfjKKsgiPUp41Ws+VI4/GmaCaJz1GtmKqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731460204; c=relaxed/simple;
	bh=BjxCzGBxGpYLG0CarhhUmQHntdRVxtQ1aH+hhp9WGWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dFm6oXUUdAvzg3kScyTpH4zgwtBU5hKYBPSQD/qxR/efj1TBz6LGabxD/Iqmjej2jyRcVRBTKNNUhVBxv+MHkifIuefYAWmBXBtoc52Hdbd/Ch3MAAF57Mkj9xIRGcZ4nha3Sa2o8WOLC4n88jLFfx5kY9uFhrL6S/WLg1Odqv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=EmkkPDcu; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="EmkkPDcu"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-720b2d8bb8dso4626436b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 17:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1731460203; x=1732065003; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KudbANySWeu7heFMK6xmw2c6w008z8e1Q4nYoxXGQrQ=;
        b=EmkkPDcu/K4ll8cuKuiOAZT9KLJSZMBZGZd59hMSkozSfUV3JmC6s6To+0Mk7QW8IG
         jC3t4ZFwG72WHbU1xwAbWnsCLzh3rZjvsQOxTXANYOTOH7N0RzbytTMDZdE4AEfwOmbl
         iZR/23YcSTpV7a17vgJrPh8oXgkZA4Deq+BM+c7WsOtOOywcAhVz/KnhD/qHYaCBJVZ/
         4DJuU9ujQBr3hniQwzC6QTAzP9UT+xnaKPGLa3oBFz2X6pF/I+1EinlZ/ed832EQPWwz
         G8xN5ytLN87XSWJYQpwpKMY4SJyH34r/JUnrcq2rdFnEJVmPP9h5XCiuVvcKIM6NCb+x
         +DVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731460203; x=1732065003;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KudbANySWeu7heFMK6xmw2c6w008z8e1Q4nYoxXGQrQ=;
        b=l+oU15MMjIp3YwOIbVC7e145QC/n/gwzQtJGxS/5n4guDKTMzLwJTNsFeVPMlCWMMs
         La2FWypuMXc9jGxozpV52UD7ESCXzonHoGS9H7NdLqHcGuyO4F5IjqZTXLchkhtpVghY
         9PIIiSmPRrhsqyNd0f57SLX/Ft++5DRSMf52ED8kqxFwzB93mlS+zuOmGNdfu9EqfGdC
         xGWmB9NeBPJvxBQwUSiICjyEQ3ZcjEi0w6UhKhx3VuIYpAyGmpUKA9Z/kmgmlQylqags
         vDgqIo6ruAFj4Rky9vnkzDYOU6XbWGW/Zd91RCxBj4yJcNfZNRseCaMt2Q9RYNn0Z3MD
         7XSA==
X-Gm-Message-State: AOJu0YzMIBUjBhjzOo4bRVukKlg1K6GsRSMHNcFAjlGq53MRfZn9pw3Q
	G54GU3scl3hXaZ+CsnQO/p875xgcSOvksfRaZ+SMf8HktsWLsN6fZ5neGuVyzFJCFuOtLJJEp1j
	2
X-Google-Smtp-Source: AGHT+IGe8ReH6I7tziG8Pz7wH+uwtDCaP/1QaDWanjzlRzORxZLcTeOzz6EsBiWRirefAUbmpv7X4g==
X-Received: by 2002:a17:902:db0a:b0:20b:79cb:492f with SMTP id d9443c01a7336-2118359cb17mr222451015ad.43.1731460202763;
        Tue, 12 Nov 2024 17:10:02 -0800 (PST)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177dc7df5sm100454225ad.19.2024.11.12.17.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 17:10:02 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1tB1tO-00DsDA-2c;
	Wed, 13 Nov 2024 12:09:58 +1100
Date: Wed, 13 Nov 2024 12:09:58 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 0/3] xfs: miscellaneous bug fixes
Message-ID: <ZzP8ZkVpa3S3G8v8@dread.disaster.area>
References: <20241112221920.1105007-1-david@fromorbit.com>
 <20241112235946.GJ9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241112235946.GJ9438@frogsfrogsfrogs>

On Tue, Nov 12, 2024 at 03:59:46PM -0800, Darrick J. Wong wrote:
> On Wed, Nov 13, 2024 at 09:05:13AM +1100, Dave Chinner wrote:
> > These are three bug fixes for recent issues.
> > 
> > The first is a repost of the original patch to prevent allocation of
> > sparse inode clusters at the end of an unaligned runt AG. There
> > was plenty of discussion over that fix here:
> > 
> > https://lore.kernel.org/linux-xfs/20241024025142.4082218-1-david@fromorbit.com/
> > 
> > And the outcome of that discussion is that we can't allow sparse
> > inode clusters overlapping the end of the runt AG without an on disk
> > format definition change. Hence this patch to ensure the check is
> > done correctly is the only change we need to make to the kernel to
> > avoid this problem in the future.
> > 
> > Filesystems that have this problem on disk will need to run
> > xfs_repair to remove the bad cluster, but no data loss is possible
> > from this because the kernel currently disallows inode allocation
> > from the bad cluster and so none of the inodes in the sparse cluster
> > can actually be used. Hence there is no possible data loss or other
> > metadata corruption possible from this situation, all we need to do
> > is ensure that it doesn't happen again once repair has done it's
> > work.
> 
> <shrug> How many systems are in this state?

Some. Maybe many. Unfortunately the number is largely
unquantifiable. However, when it happens it dumps corruption reports
dumped in the log, so I'd say that there aren't that many of them
out there because we aren't getting swamped with corruption reports.

> Would those users rather we
> fix the validation code in repair/scrub/wherever to allow ichunks that
> overrun the end of a runt AG?

Uh, the previous discussion ended at "considering inode chunks
overlapping the end of the runt AG as valid requires an incompat
feature flag as older kernels cannot access inodes in that
location". i.e. older kernels will flag those inodes as corrupt if
we don't add an incompat feature flag to indicate they are valid.

At that point, we have a situation where they are forced to upgrade
userspace tools to do anything with the filesytsem that the kernel
added the new incompat feature flag for on upgrade.

That's a much worse situation, because they might not realise they
need to upgrade all the userspace tools and disaster recovery
utilities to handle this new format that the kernel upgrade
introduced....

The repair/scrub/whatever code already detects and fix the issue by
removing the bad cluster from the runt AG. We just need to stop the
kernel creating the bad clusters again.

IOWs, it just simpler for everyone to fix the bug like this and
continue to consider the sparse inode cluster at the end of the AG
is invalid.

Alternatively, if users can grow the block device, then they can
simply round up the size of the block device to a whole inode
chunk. They don't need to run repair to fix the issue; the cluster
is now valid because a whole chunk will fit at end of the runt AG.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
