Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD0B2FB2
	for <linux-xfs@vger.kernel.org>; Mon, 23 Sep 2024 02:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727060258; cv=none; b=YKbwU+DR5csOzUHt1svLHRjzN/c3zVUFD5IfxfzZz8LxJw14TsLQyrMFlRGgGzmFA5filX3FEUgHKav9PSvwE2HRiU6bj6KoNh9GiYQOeyyPatDqV4x5NC7PJAkIj95jDzEgqItSnhnStlroaOMo6uYWulVxIqLAnO+D+1mpu1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727060258; c=relaxed/simple;
	bh=KzDB2Fvw/p/tQNZGvJ2Z3UXAJ8NNDc4oQ6MvNEVQ7o0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZkIjGxKSunA4kMidMmruh1SkXvIAyi+OMX+ZCt5UTCtaHT+VVHNYQSTTQXuM+W9wky4uqBUTCXgXS0U7u75R9AjSzBMIa3laIVYkzZIknN0cKhL8NdmRF0/2HpXgG2wei4Xw8yy/pa2BuDGAvQhpGxcnN+y3TOTKZAlgOJ/V/Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=EZqy4KfT; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="EZqy4KfT"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7191f58054aso2862521b3a.0
        for <linux-xfs@vger.kernel.org>; Sun, 22 Sep 2024 19:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1727060256; x=1727665056; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eOlCfE1VvNojenYK4PaCQ7v+7xfVZi0Mlck1xQLbNPU=;
        b=EZqy4KfTnH0kksgLCD38SNwQfZ3sOJLoOUHZ4fIsL3+ZCtZpjzrlsmiGaqR47WlmKc
         KNChsJYz2cBU0CZ0NhNynMr+1ne6YDrlNWVmYdiGufXTcM7eo/wf5E0dmwf4bZsYbr/+
         mtxH3KAk9GZWM2atx+uAVQuN5vJGPejiC4H6fSTJLr9rEDjO6OYDoSL6F8cVLi8FR2HV
         c7qlnSf/EDBZE3e2T8av+0JJxt6dBb0kguEmb3deNx+N9DTLti46khE7lj1TY+tJ6DF5
         HLrZID5u0tzDGiuBUAR69mjzDlyX7P70hH08Ye/IAxbzfQP70fXTsVWsaLY+1rk0Yu4A
         8z0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727060256; x=1727665056;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eOlCfE1VvNojenYK4PaCQ7v+7xfVZi0Mlck1xQLbNPU=;
        b=KHIg3sd7JZHQ92m3YEyH5d5YLca1oA5up4o27YIRdVDLncgutE+oJfigtQJ+eEzp2q
         iZBtxuc6vDCyts8lACIw23V8Ilfj6WxfPO3cuGNrEu9EOy/Evu3E7VuIkMhJfiAnl7mt
         VG3qcsBG0doffrCyXea/podfxyt3gFLz94fQp+TJhKJuUROl+ZMPVmmbTY621xFn6OxN
         VcaGmLM8VxaL3EgTvrJUxSpmI1YXsTvzUK6a0OcLdPhkamxMv3OFcPQHKMRJgtF4aVOk
         u7k3VCXD+flDjE1ZtONmjsYv2vg8m/2l5EzJAeB7j0cXTMi63pBFStxfxOvmN1J1WK4Z
         Rsgg==
X-Forwarded-Encrypted: i=1; AJvYcCVSwhs2pJEvD+7alk42O+cWUQvMVLquYrEV5n+by5IRVbsXapqK84JLSh9rjBb9V8ZCKm0c4RheVKg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBMXOBZdrteknArrBqbGBjGcrwjAEF5zfbDoPWiP6RGUZ0SjIb
	87xWgTFobUcJK35FU+XWq2/tnEIbto59NbLjOey3Ow/xizJn3Ztuv1mL+mfySdI=
X-Google-Smtp-Source: AGHT+IH2VELuLlAU0XdfCjZH33i9dkmjucfpwNy78ly8Ug0hCYlcUNTgjVWyzhE0W5UaHWaQgWqjKA==
X-Received: by 2002:a05:6a00:2313:b0:70d:34aa:6d51 with SMTP id d2e1a72fcca58-7199c93a858mr18186642b3a.6.1727060256304;
        Sun, 22 Sep 2024 19:57:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944a980b4sm13031941b3a.34.2024.09.22.19.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Sep 2024 19:57:35 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1ssZGW-008oKf-31;
	Mon, 23 Sep 2024 12:57:32 +1000
Date: Mon, 23 Sep 2024 12:57:32 +1000
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, chandan.babu@oracle.com,
	djwong@kernel.org, dchinner@redhat.com, hch@lst.de,
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, catherine.hoang@oracle.com,
	martin.petersen@oracle.com
Subject: Re: [PATCH v4 00/14] forcealign for xfs
Message-ID: <ZvDZHC1NJWlOR6Uf@dread.disaster.area>
References: <20240813163638.3751939-1-john.g.garry@oracle.com>
 <87frqf2smy.fsf@gmail.com>
 <ZtjrUI+oqqABJL2j@dread.disaster.area>
 <877cbq3g9i.fsf@gmail.com>
 <ZtlQt/7VHbOtQ+gY@dread.disaster.area>
 <8734m7henr.fsf@gmail.com>
 <ZufYRolfyUqEOS1c@dread.disaster.area>
 <c8a9dba5-7d02-4aa2-a01f-dd7f53b24938@oracle.com>
 <Zun+yci6CeiuNS2o@dread.disaster.area>
 <8e13fa74-f8f7-49d3-b640-0daf50da5acb@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e13fa74-f8f7-49d3-b640-0daf50da5acb@oracle.com>

On Wed, Sep 18, 2024 at 08:59:41AM +0100, John Garry wrote:
> On 17/09/2024 23:12, Dave Chinner wrote:
> > On Mon, Sep 16, 2024 at 11:24:56AM +0100, John Garry wrote:
> > > > Hence we'll eventually end
> > > > up with atomic writes needing to be enabled at mkfs time, but force
> > > > align will be an upgradeable feature flag.
> > > 
> > > Could atomic writes also be an upgradeable feature? We just need to ensure
> > > that agsize % extsize == 0 for an inode enabled for atomic writes.
> > 
> > To turn the superblock feature bit on, we have to check the AGs are
> > correctly aligned to the *underlying hardware*. If they aren't
> > correctly aligned (and there is a good chance they will not be)
> > then we can't enable atomic writes at all. The only way to change
> > this is to physically move AGs around in the block device (i.e. via
> > xfs_expand tool I proposed).
> > > i.e. the mkfs dependency on having the AGs aligned to the underlying
> > atomic write capabilities of the block device never goes away, even
> > if we want to make the feature dynamically enabled.
> > 
> > IOWs, yes, an existing filesystem -could- be upgradeable, but there
> > is no guarantee that is will be.
> > 
> > Quite frankly, we aren't going to see block devices that filesystems
> > already exist on suddenly sprout support for atomic writes mid-life.
> 
> I would not be so sure. Some SCSI devices used in production which I know
> implicitly write 32KB atomically. And we would like to use them for atomic
> writes.

Ok, but that's not going to be widespread. Very little storage
hardware out there supports atomic writes - the vast majority of
deployments will be new hardware that will have mkfs run on it.

A better argument for dynamic upgrade is turning on atomic writes
on reflink enabled filesystems once the kernel implementation has
been updates to allow the two features to co-exist.

> 32KB is small and I guess that there is a small chance of
> pre-existing AGs not being 32KB aligned. I would need to check if there is
> even a min alignment for AGs...

There is no default alignment for AGs unless there is a stripe unit
set. Then it will align AGs to the stripe unit. There is also no
guarantee that stripe units are aligned to powers of two or atomic
write units...

> > Hence if mkfs detects atomic write support in the underlying device,
> > it should *always* modify the geometry to be compatible with atomic
> > writes and enable atomic write support.
> 
> The current solution is to enable via commandline.

Yes, that's the current proposal.  What I'm saying is that this
isn't a future proof solution, nor how we want this functionality to
work in the future.

We should be looking at the block device capabilities (like we do for
stripe unit, etc) and then *do the right thing automatically*. If
the block device advertises atomic write support, then we should
automatically align the filesystem to atomic write constraints, even
if atomic writes can not be immediately enabled (because reflink).

I'm trying to describe how we want things to work once atomic write
support is ubiquitous. It needs to be simple for users and admins,
and it should work (or be reliably upgradeable) out of the box on
all new hardware that supports this functionality.

> > Yes, that means the "incompat with reflink" issue needs to be fixed
> > before we take atomic writes out of experimental (i.e. we consistently
> > apply the same "full support" criteria we applied to DAX).
> 
> In the meantime, if mkfs auto-enables atomic writes (when the HW supports),
> what will it do to reflink feature (in terms of enabling)?

I didn't say we should always "auto-enable atomic writes".

I said if the hardware is atomic write capable, then mkfs should
always *align the filesystem* to atomic write constraints.  A kernel
upgrade will eventually allow reflink and atomic writes to co-exist,
but only if the filesystem is correctly aligned to the hardware
constrains for atomic writes. We need to ensure we leave that
upgrade path open....

.... and only once we have full support can we make "mkfs
auto-enable atomic writes".

-Dave.
-- 
Dave Chinner
david@fromorbit.com
