Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958E9A92F
	for <linux-xfs@vger.kernel.org>; Sat,  2 Mar 2024 11:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709379886; cv=none; b=cVExNSewXiTk0FVh6Wq01345EPCr2zU1jDdjEP4tfew74C6RcfBkKKzOyWAUEHjU8Mycxxi8tTIe1JhDjhwGQR7joK31j0W4hWitK7FfFpyTwrwLG8Nm6AqnFZQXLJZDRvZtgvOAhlGftweQ6BWvvKxqVHzYdjzjh/mRw4d6D4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709379886; c=relaxed/simple;
	bh=kISp3bhCOxt0BYZt0fgu021JmRNiNY8HUqznGoI7dls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=InT/VxR8jK90HO0HPzQmWEEGXo5jpSlddEE1MORVZWsn5XLmpg2YAl4xMGPZI5yJJi4ri5G6TUWOPsmR7H23bRqxMBNynfz5z9nX5erPMgSMSavonTfAVa8dMX88MzLBxPxoBSoP+wXP2RM4IVhRPQWy2WoCMlPDP/cpEaN6k3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CAvKCgpg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CAvKCgpg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709379883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=waoeQMshhPIHP+ysFHgEEpI9xz6MLHl2AVo370Y4TEs=;
	b=CAvKCgpgHJRtKRIU8jzKyaKAPl/0EUFZAuUCZIuUvK5GGguVIFiIiXaKImZcqQn/CphBHU
	xqjvzwN6BZTMfN4AUR4cmk6mwKx0rz/z+ktEdkxEgaVwVxzoNxGIjcg7dFw8H3M9fjWZ0/
	nhP9KPOJa3sDv0BHOf36Ag2KuoBL/Dg=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-42-D9xJ_TLLOQ24t2kpFZrxRw-1; Sat, 02 Mar 2024 06:44:42 -0500
X-MC-Unique: D9xJ_TLLOQ24t2kpFZrxRw-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-29ade776a78so2652436a91.1
        for <linux-xfs@vger.kernel.org>; Sat, 02 Mar 2024 03:44:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709379881; x=1709984681;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=waoeQMshhPIHP+ysFHgEEpI9xz6MLHl2AVo370Y4TEs=;
        b=dpVmNejoJ/H6iQn3AmzZ5OlH7rlq+E+Jy6d87lFThtw8w3B+R33HBdqtsu3Q70zjmn
         YIzRwkgy5SDc1A7PweMyx3u4rI+0RKsaCnbyaFFoc2sucuodimJhwToDWcOnMpmQhyyo
         Vabe7KVGFCtdpjD+nEricmSVPQMUyi4w6sK04P7PWcJfCku5bK81IyAz7IHtYrOBxHrp
         g2FA+GDwo9sZL245D3+CIKJmBhc4ioYssyxzR4PeC5uhdB0Rgb2hkzkubKJIiqw3SaZ2
         i1LzsXrWaVY9zVtPCuZ2r2O472N9l9RJbUlPWKvLh6gtqNobcEZWYwKkwcB6Dpc4GvIe
         G6/g==
X-Forwarded-Encrypted: i=1; AJvYcCVsM8Hxd6/X5+4Kbl3UhSyoDL5k5OSPp7HR6M+ZMn44oaVB0LkBIfoBD08Ikilbb5/XhAfatSE/G9zCr2auVxS0IZFd8HqTLZRj
X-Gm-Message-State: AOJu0YwL8lVQ1skI6/skvgvjNuQrgTfznAwiVRfdzylg0uxeGPzHh0eM
	GbRuTN1JSqtsM2xt37EJgh80vNTbviJxULZ8V5ZGgxA9W0MChSrAdNFokygZ9nxLt3oFTxkk0TJ
	KMub6bHeuEHPz+Od/JN0mGuvrQ4p9MIpIVtxyWmhpRpQyXGvYiNUB0MhIvg==
X-Received: by 2002:a17:902:e843:b0:1dc:faab:3452 with SMTP id t3-20020a170902e84300b001dcfaab3452mr1879661plg.28.1709379881007;
        Sat, 02 Mar 2024 03:44:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEUnvhW4EKTQeqfQmf34Bk3BSz0xt/dD6vf2DGxsnWnbr6pkJuov5yH5lvHz7vkqxYTKZAKmQ==
X-Received: by 2002:a17:902:e843:b0:1dc:faab:3452 with SMTP id t3-20020a170902e84300b001dcfaab3452mr1879646plg.28.1709379880622;
        Sat, 02 Mar 2024 03:44:40 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id kw13-20020a170902f90d00b001dc90ac1cecsm5048923plb.284.2024.03.02.03.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Mar 2024 03:44:40 -0800 (PST)
Date: Sat, 2 Mar 2024 19:44:36 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH v1.1 1/8] generic/604: try to make race occur reliably
Message-ID: <20240302114436.wb6uw3w7yrqnozf4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915233.896550.17140520436176386775.stgit@frogsfrogsfrogs>
 <20240227044021.GT616564@frogsfrogsfrogs>
 <Zd33JY8qn7urdMjB@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd33JY8qn7urdMjB@infradead.org>

On Tue, Feb 27, 2024 at 06:52:21AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 26, 2024 at 08:40:21PM -0800, Darrick J. Wong wrote:
> > This test will occasionaly fail like so:
> > 
> >   --- /tmp/fstests/tests/generic/604.out	2024-02-03 12:08:52.349924277 -0800
> >   +++ /var/tmp/fstests/generic/604.out.bad	2024-02-05 04:35:55.020000000 -0800
> >   @@ -1,2 +1,5 @@
> >    QA output created by 604
> >   -Silence is golden
> >   +mount: /opt: /dev/sda4 already mounted on /opt.
> >   +       dmesg(1) may have more information after failed mount system call.
> >   +mount -o usrquota,grpquota,prjquota, /dev/sda4 /opt failed
> >   +(see /var/tmp/fstests/generic/604.full for details)
> > 
> > As far as I can tell, the cause of this seems to be _scratch_mount
> > getting forked and exec'd before the backgrounded umount process has a
> > chance to enter the kernel.  When this occurs, the mount() system call
> > will return -EBUSY because this isn't an attempt to make a bind mount.
> > Slow things down slightly by stalling the mount by 10ms.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> > v1.1: indent commit message, fix busted comment
> > ---
> >  tests/generic/604 |    8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/tests/generic/604 b/tests/generic/604
> > index cc6a4b214f..00da56dd70 100755
> > --- a/tests/generic/604
> > +++ b/tests/generic/604
> > @@ -24,10 +24,12 @@ _scratch_mount
> >  for i in $(seq 0 500); do
> >  	$XFS_IO_PROG -f -c "pwrite 0 4K" $SCRATCH_MNT/$i >/dev/null
> >  done
> > -# For overlayfs, avoid unmouting the base fs after _scratch_mount
> > -# tries to mount the base fs
> > +# For overlayfs, avoid unmouting the base fs after _scratch_mount tries to
> 
> s/unmouting/unmounting/ ?

Sure, I've changed that when I merged it. Thanks for pointing out that.

> 
> 

