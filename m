Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77ADC2F43
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jul 2024 01:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722217547; cv=none; b=FWU4FoUeGEIofCeS+M7PIabaxH8a0d6Ay8AsmDrd3v1H2qg7T2VKseJ5sYjnz6B9FeWSQO+hX+bcrM7x8BCnabwnbKfv+Xm0Rdur5Klj6vH47+FgkxoFKptAxYWZzO6LS2HLsdYPCf2Aj5AUc7YuQoHIdux82IGv/xvDREBXMX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722217547; c=relaxed/simple;
	bh=CNt9bllY0xQj0HKzSE2gq+nqrSUEUpFN/if3qPXx0uk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uSX7lkMDrjdUcZGwx2SWqFavvE2pMrjCwmGQ9ibFu+e4/bR3TLxdetLmKNqL3bXdtV6q6tYt3l4yKWvf38LEjCN6WsibKN1ibN78D0M5+/eadTq7YxWBlu/EaYZJVgBzXm+VMoLSAbxfTN3sy+QbNmFPEvPNF7cuVHsZCwvFcfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=YQDCp6BQ; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="YQDCp6BQ"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-5d5ed6f51cfso270671eaf.0
        for <linux-xfs@vger.kernel.org>; Sun, 28 Jul 2024 18:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1722217544; x=1722822344; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tocNXrivHmBBtgiikgu/BuAkt4IAtb4A0MpEwkBWHe0=;
        b=YQDCp6BQsG9r8frqv8gBLD3oa06Lj9UiSzqGGOgGjdK9+h/WVT+u06fTJLcsGxUluP
         0h9Y/nFdaxKN7Yw4zTgp8E9Xrez9M63fVNeKeKnMK4g4qOGwV2o4LAhTVAn9Ji35TSf1
         aYeg3dZ7CDIeUcDAr2pN23lRbZYuvKTOzcHRBqFUyCAgNaPPH5n/UAy0xkykrfVTH1NW
         su1o/a9+nLWL8pFUwrDcPLa0w0VTnv990LJEsyo11BW3sENW7FtbzcXEqNb1X03Bv/Oa
         863q1vk/B34zGC4ZQhjth9wEbWDgZraKqRaXUUmOJmY3jEwi/r60SKVNI3fWJfePrEZU
         E/pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722217544; x=1722822344;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tocNXrivHmBBtgiikgu/BuAkt4IAtb4A0MpEwkBWHe0=;
        b=QHJfrPfKJQaq8AdoksBYbPGeEguMuo0tUf6wAQvAhNd2lEZTIgNTh+Po5XURvZdNEN
         N1uGj3bavohjhj/bfUhJbKfaNhIl91I0N+DcyEP2l3oQzuIlgoig66ljdaloKJSF+qEJ
         vg53VZAqOUY2+XQCAXMZVLFXOBSI7zqarUnJxtSNS4zLpXuA7C1D3TbSIxdAoCV98kPn
         jB+3Rbqzcj/384TRA1LIfHu9MBX7f+EQQCfDza1AWmO4TNLV5+UIIbHLdZfVQWUySAQO
         vdDbirU9U/Sks9npLYClCfGU3Br82fstOqR65DEVsq4pvPSiEWw89Ut72OQPXdSKj1uC
         +srw==
X-Forwarded-Encrypted: i=1; AJvYcCVDifq53FChAHsOS2CjMPqiZKnCuLPYb3b8w2m7hil3IxK43iw7Mi1fyxNIlNbqrmTSd12QXSSLGfSZBdbmVUjEciZt6B87IMUz
X-Gm-Message-State: AOJu0Yz23ATn8AyexFVBuQb6rdxOENSa+VYveIi9w7EPeq36Z7poJaKu
	3ziZ2InY6yHdgYVdYCRpYvouRv0KQuMBBJdE3BNS2zYIe6TyS4rpDqLpkQmbaWYoII1BRtbLjOT
	K
X-Google-Smtp-Source: AGHT+IHXO7zsYiJyUWA6veo4CkBdMJ4bZgYoVxiXas5q5VihMEqIHZpi2+foecp6LW+7wkfLxZ0ztw==
X-Received: by 2002:a05:6358:9045:b0:1aa:a19e:f1a4 with SMTP id e5c5f4694b2df-1adb243b8ddmr888879055d.1.1722217544418;
        Sun, 28 Jul 2024 18:45:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7a9fa5a35e4sm6205230a12.88.2024.07.28.18.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jul 2024 18:45:43 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sYFSG-00F0x0-1g;
	Mon, 29 Jul 2024 11:45:40 +1000
Date: Mon, 29 Jul 2024 11:45:40 +1000
From: Dave Chinner <david@fromorbit.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: filesystem expansion design documentation
Message-ID: <Zqb0RABbeVvs1nKX@dread.disaster.area>
References: <20240721230100.4159699-1-david@fromorbit.com>
 <345207bd-343a-417c-80b9-71e3c8d4ff28@sandeen.net>
 <20240724221233.GB612460@frogsfrogsfrogs>
 <5ccb5a51-75c0-41eb-92ff-a2ce5674ac0f@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ccb5a51-75c0-41eb-92ff-a2ce5674ac0f@sandeen.net>

On Wed, Jul 24, 2024 at 05:38:46PM -0500, Eric Sandeen wrote:
> On 7/24/24 5:12 PM, Darrick J. Wong wrote:
> > On Wed, Jul 24, 2024 at 05:06:58PM -0500, Eric Sandeen wrote:
> >> On 7/21/24 6:01 PM, Dave Chinner wrote:
> >>> +The solution should already be obvious: we can exploit the sparseness of FSBNO
> >>> +addressing to allow AGs to grow to 1TB (maximum size) simply by configuring
> >>> +sb_agblklog appropriately at mkfs.xfs time. Hence if we have 16MB AGs (minimum
> >>> +size) and sb_agblklog = 30 (1TB max AG size), we can expand the AG size up
> >>> +to their maximum size before we start appending new AGs.
> >>
> >> there's a check in xfs_validate_sb_common() that tests whether sg_agblklog is
> >> really the next power of two from sb_agblklog:
> >>
> >> sbp->sb_agblklog != xfs_highbit32(sbp->sb_agblocks - 1) + 1
> >>
> >> so I think the proposed idea would require a feature flag, right?
> >>
> >> That might make it a little trickier as a drop-in replacement for cloud
> >> providers because these new expandable filesystem images would only work on
> >> kernels that understand the (trivial) new feature, unless I'm missing
> >> something.
> > 
> > agblklog and agblocks would both be set correctly if you did mkfs.xfs -d
> > agsize=1T on a small image; afaict it's only mkfs that cares that
> > dblocks >= agblocks.
> 
> Yes, in a single AG image like you've suggested.
> 
> In Dave's proposal, with multiple AGs, I think it would need to be handled.

So in looking into this in more detail, there is one thing I've
overlooked that will absolutely require a change of on-disk format:
we encode the physical location (daddr) of some types of metadata
into the metadata.

This was added so that we could detect misdirected reads or writes;
the metadata knows it's physical location and so checks that it
matches the physical location the buffer was read from or is being
written to.

This includes the btree block headers, symlink blocks and
directory/attr blocks, and I'm pretty sure that the locations
recorded by the rmapbt's are physical locations as well.

To allow expansion to physically relocate metadata, I think we're
going to have to change all of these to record fsbno rather than
daddr so that we can change the physical location of the metadata
without needing to change all the metadata location references. We
calculate daddr from FSBNO or AGBNO everywhere, so I think all the
info we need to do this already available in the code.

Daddrs and fsbnos are also the same size on disk (__be64) so there's
no change to metadata layouts or anything like that. It's just a
change of what that those fields store from physical to internal
sparse addressing.

Hence I don't think this is a showstopper issue - it will just
require verifiers and metadata header initialisation to use the
correct encoding at runtime based on the superblock feature bit.
It's not really that complex, just a bit more work that I originally
thought it would be.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
