Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC7B846F
	for <linux-xfs@vger.kernel.org>; Wed, 21 Feb 2024 02:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708482769; cv=none; b=Aty23JsIGY13l4om5o9diNCP3X06pynA26nxRBesutiCICeUCEjSxfqU0p79GhhbBCpaBxfEnUhFzAazmm6EMmCPwBb2S+ovuSPRw7/xR6+V7V5K9mvdCWuN6w2ySihAAQRRLLG3ts/rbq9D8shWI2h3BPXcBNPqIg3cIv3o6bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708482769; c=relaxed/simple;
	bh=EiluumSS0uTK1Np03P/QzFn5bYMf/ol7H6DkwdXzDjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nLCb76Gxr6LRTHlZcARrI51YVaRW6wQW4sH4+lC8QNgMnZ0CmMiRwh2wYGvNQfTNYGq0HgrR+ZSu/FoCMH/AwEeksw4Abl+k2lGGdvW0F6DZP/G/xymyD8Mlo7/o+I9P+efVozzIo5SY3oCq8C2Bzr3g3fJsFMzcd6V+0QD69NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=VXlyzWo8; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="VXlyzWo8"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1d51ba18e1bso1240925ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2024 18:32:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1708482767; x=1709087567; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9PLRjgjhJ2NI8gPGpZzNacq474mnO9iX1V8ydAVxOrU=;
        b=VXlyzWo88WSWPjheYA0pyez2dRcr/G5ssePcGh+mtKX4MeKU//unG/tO7CfzRjXxkI
         Fc+PFQX2W/qqZEnF5yEAPFs/V8raK51vbV60uyJmPVzNRvrSMd3BXOhqcRRvvTGyZCBr
         P6b0fubk7CYnS15EPpLTbXWoj4FbwULlmTnPlAB/Bx0jctv9oP3twlp7BveaZrjfaFgt
         08KJb8/8Nt/QqAsSMgf9PqCHpmqfUgoIo4aMuDUM7uouvgUrFc6w/qbmYH4rQoU5INnC
         FKtKHgYXOQR51lrT0W7BqMRPKCSCrX+l/cwUfixgx9bqy3q5VYweWVbcNQ+mmOTh/GP9
         pCkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708482767; x=1709087567;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9PLRjgjhJ2NI8gPGpZzNacq474mnO9iX1V8ydAVxOrU=;
        b=CCjRtpQE3JTgXy5OJbp61DVpzJho8QE5RE/MhrWBjKjoYNWuC8O6Ub/GigxToCygJE
         2XnKJyF15+QBNBm4FgC9FbqpLQD5Acb5tmdTBTDzg3bk/jz+moVwvxMegFoNEAX7356m
         1RZ+05x9A+I99Sf+29Of3RrgNTo49F3HjEH0hnfNMiPou2wfFiMGXQMJWDCK8/8hokdJ
         skLsUdp6jACNDbpClsv9v/SWs/GrArpxQ3I8fZKvOr75jlv9iL3+kHGBmnkJeDj6KuhL
         LwYVwqTaHOCD/B9B6boQp+lrPiAdcj4QHZLtGYhpAx6a/J7G5k0Mjoh9rVU5pH3vWLZ1
         1Lkg==
X-Gm-Message-State: AOJu0Yy9Trimb4jSjSBz7yboPZ/K5OaBfjSCraS7vIhdQlf7XcJAmCCp
	2hbsBsPVEwxUhwGE0RGoOS11nwIGQZlxh+ivDE9E8KBXrwwDL8+Yl9uO+0vLh8Vxfmy08o/MMG6
	j
X-Google-Smtp-Source: AGHT+IHc1DHotgN6cwfZ6dsZit9hXYK8rRGZDoU8kIbYQkHcmHe1YOvpBxWLf6pvZQlF7gjmSxnpeQ==
X-Received: by 2002:a17:902:d48e:b0:1dc:2070:892a with SMTP id c14-20020a170902d48e00b001dc2070892amr3431156plg.36.1708482767030;
        Tue, 20 Feb 2024 18:32:47 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id kj4-20020a17090306c400b001db9c3d6506sm6986207plb.209.2024.02.20.18.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 18:32:46 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rccPb-009KRF-1p;
	Wed, 21 Feb 2024 13:32:43 +1100
Date: Wed, 21 Feb 2024 13:32:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, chandan.babu@oracle.com
Subject: Re: [PATCH] xfs: fix SEEK_HOLE/DATA for regions with active COW
 extents
Message-ID: <ZdVgy1ojJWmygPBE@dread.disaster.area>
References: <20240220224928.3356-1-david@fromorbit.com>
 <20240221021625.GC616564@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240221021625.GC616564@frogsfrogsfrogs>

On Tue, Feb 20, 2024 at 06:16:25PM -0800, Darrick J. Wong wrote:
> On Wed, Feb 21, 2024 at 09:49:28AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > A data corruption problem was reported by CoreOS image builders
> > when using reflink based disk image copies and then converting
> > them to qcow2 images. The converted images failed the conversion
> > verification step, and it was isolated down to the fact that
> > qemu-img uses SEEK_HOLE/SEEK_DATA to find the data it is supposed to
> > copy.
> > 
> > The reproducer allowed me to isolate the issue down to a region of
> > the file that had overlapping data and COW fork extents, and the
> > problem was that the COW fork extent was being reported in it's
> > entirity by xfs_seek_iomap_begin() and so skipping over the real
> > data fork extents in that range.
> > 
> > This was somewhat hidden by the fact that 'xfs_bmap -vvp' reported
> > all the extents correctly, and reading the file completely (i.e. not
> > using seek to skip holes) would map the file correctly and all the
> > correct data extents are read. Hence the problem is isolated to just
> > the xfs_seek_iomap_begin() implementation.
> > 
> > Instrumentation with trace_printk made the problem obvious: we are
> > passing the wrong length to xfs_trim_extent() in
> > xfs_seek_iomap_begin(). We are passing the end_fsb, not the
> > maximum length of the extent we want to trim the map too. Hence the
> > COW extent map never gets trimmed to the start of the next data fork
> > extent, and so the seek code treats the entire COW fork extent as
> > unwritten and skips entirely over the data fork extents in that
> > range.
> > 
> > Link: https://github.com/coreos/coreos-assembler/issues/3728
> > Fixes: 60271ab79d40 ("xfs: fix SEEK_DATA for speculative COW fork preallocation")
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_iomap.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index 18c8f168b153..055cdec2e9ad 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -1323,7 +1323,7 @@ xfs_seek_iomap_begin(
> >  	if (cow_fsb != NULLFILEOFF && cow_fsb <= offset_fsb) {
> >  		if (data_fsb < cow_fsb + cmap.br_blockcount)
> >  			end_fsb = min(end_fsb, data_fsb);
> > -		xfs_trim_extent(&cmap, offset_fsb, end_fsb);
> > +		xfs_trim_extent(&cmap, offset_fsb, end_fsb - offset_fsb);
> 
> Doh.  Is there a reproducer we can hammer into a fstests regression test?
> Sure would be nice if the type system actually caught things like this
> for us.

Eric has been trying to create one, but it's not obvious how to
create the speculative delalloc extent on the COW fork that covers
existing data fork extents. If you know how to do that easily,
then all you need to then do is create that state and run
"xfs_io -c 'seek -ra 0' <file>" and you'll see the seeks skip over
the regions we know data fork extents cover.

> Anyway thanks for fixing this,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-Dave.

-- 
Dave Chinner
david@fromorbit.com
