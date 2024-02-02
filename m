Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DEB67C51
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 12:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706876629; cv=none; b=F7ql4TlaHUyhIOnRjz8oTvviHAcdyReJHhBlQ0pslAQ9Dgz5kFwZwx4Uc/w9vcrg0KkIhd7TeBDPRjjZMgJGf7xNj4yhuUh3RxYXD7amOfX3KVu7nwYY8tezRJ5EQUaKI5fkKchWLXFLsF5NRn7qb7c/MkIARGKdv1XyQBM0EQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706876629; c=relaxed/simple;
	bh=tbUgsLnQ7tCYKSHEJs8dUrJVARjPoAYzZRQBPOe9Ah0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tvmVf6/Bt0SR0hU/0GDF2ndvaI/oB4SnQ2biSIuyynjoW9VwhfKdMtdQXhIAiZ8ls71qKcJzN9B5AHjJ3xhmq0EszD5eFZuYCqIiUcU77RSvhq2W5EXFuLDsfqoav3FxpuJNd34HHHDKjQti2ASL5LGzk+TfHRnLXn12uYQvqRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J2HnKnQ0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J2HnKnQ0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706876627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b/Ys/bWaRqUUFILelFUwnEQZl9VEljCHwt/nwq2h8Gc=;
	b=J2HnKnQ0is3LNhf9gqdoV3KiA0/qw7A+UrOPcgldLnlDyd1mAAAXQyAeHVPv19yDnw2IXD
	qHqCdkXnMPXJSogNwSE/CBm2cJ/0esPzz12m/WOFj0JeKv1BvwmBjV02BwhZ00zux4VJeo
	1FO9aJkPOTf9GDEW/6JqRnSXRuLAzmM=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-505-I-fU2GFNMomuZM05MOvNoA-1; Fri, 02 Feb 2024 07:23:46 -0500
X-MC-Unique: I-fU2GFNMomuZM05MOvNoA-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-5cf555b2a53so2564759a12.1
        for <linux-xfs@vger.kernel.org>; Fri, 02 Feb 2024 04:23:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706876625; x=1707481425;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b/Ys/bWaRqUUFILelFUwnEQZl9VEljCHwt/nwq2h8Gc=;
        b=uvjgEGXbrP3qqEnmuG+sR43V9h2Fkkm3p7yl3XhjnQBdzb2OHIv7DMmmL7ywMY7Ubh
         RWL4g7FWdgPc09prGn8YY0pkMCP6B1RXE13ZVtbJKE96pZfIow8ZbYFpWlw2psereMJl
         ucf+UUEIfYNB9YuSPbTDhoJ3JXadcOeIfIQCj8Q8MdyAHcC3SspHyAJLpqGFD1MSDuzD
         uLDuTkanxIhBPpy8rj9GWmurT9LCscmYd3UXLfxzEC8+YYK/3iCVJ4DOFR4WkSqS9vLt
         Ubl3hn5e4etNoTvzeBTulpZ0BX/Hsi386pTd+N3lllnBSChXS949G1Dp61qU2Kk+44GC
         THyw==
X-Gm-Message-State: AOJu0Yyd4W8vpTKD4UBmazwqthlBa548Gr33k47TPQSrtwrdk02XIqEi
	chPaoMYtWBKpMPKCWj1Ezx5C0NR88mcdZhe704YgDgXHfgtUZyOBEnu1zHKA9fFHweL4uwsMViH
	R429ynjPmjSBMsSO/JC5r2O2ALTVieq1QfjBefDIloOctPPiq6FP17AU7Kg==
X-Received: by 2002:a05:6a20:3625:b0:19e:3391:343b with SMTP id r37-20020a056a20362500b0019e3391343bmr2313691pze.27.1706876624989;
        Fri, 02 Feb 2024 04:23:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF/tRczJHCwRf107wwO8GuY10/e2hWMjilaEXprtmw1nSsnD7tt0z7zeyjiGjntn886hBnk9g==
X-Received: by 2002:a05:6a20:3625:b0:19e:3391:343b with SMTP id r37-20020a056a20362500b0019e3391343bmr2313680pze.27.1706876624646;
        Fri, 02 Feb 2024 04:23:44 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCX/AxacwBZXYAmg044iBLStcSka1bI+4147SJTqLAu06z9xT8LaVcpXf0+VxTeIdXfpoRDXOBiDVK3BUNO2u730rIvN/r0kftV99Ah1OJIVY4OL03OrJaPhNT7DmY7FLIpl0Q==
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id b19-20020a63eb53000000b005cda7a1d72dsm1450697pgk.74.2024.02.02.04.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Feb 2024 04:23:44 -0800 (PST)
Date: Fri, 2 Feb 2024 20:23:40 +0800
From: Zorro Lang <zlang@redhat.com>
To: David Disseldorp <ddiss@suse.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test xfs_growfs with too-small size expansion
Message-ID: <20240202122340.z2k2ka535fqkmdsh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240128155653.1533493-1-zlang@kernel.org>
 <20240129150247.54c7a27a@echidna>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240129150247.54c7a27a@echidna>

On Mon, Jan 29, 2024 at 03:02:47PM +1100, David Disseldorp wrote:
> Looks fine.
> Reviewed-by: David Disseldorp <ddiss@suse.de>

Thanks for reviewing :)

> 
> A couple of minor comments below...
> 
> On Sun, 28 Jan 2024 23:56:53 +0800, Zorro Lang wrote:
> 
> > This's a regression test of 84712492e6da ("xfs: short circuit
> > xfs_growfs_data_private() if delta is zero").
> > 
> > If try to do growfs with "too-small" size expansion, might lead to a
> > delta of "0" in xfs_growfs_data_private(), then end up in the shrink
> > case and emit the EXPERIMENTAL warning even if we're not changing
> > anything at all.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> >  tests/xfs/999     | 53 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/999.out |  2 ++
> >  2 files changed, 55 insertions(+)
> >  create mode 100755 tests/xfs/999
> >  create mode 100644 tests/xfs/999.out
> > 
> > diff --git a/tests/xfs/999 b/tests/xfs/999
> > new file mode 100755
> > index 00000000..09192ba3
> > --- /dev/null
> > +++ b/tests/xfs/999
> > @@ -0,0 +1,53 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2024 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 999
> 
> I'll assume 999 is just a placeholder...

Yeah, I'll replace it when I merge it.

> 
> > +#
> > +# Test xfs_growfs with "too-small" size expansion, which lead to a delta of "0"
> > +# in xfs_growfs_data_private. This's a regression test of 84712492e6da ("xfs:
> > +# short circuit xfs_growfs_data_private() if delta is zero").
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick growfs
> > +
> > +_cleanup()
> > +{
> > +	local dev
> > +        $UMOUNT_PROG $LOOP_MNT 2>/dev/null
> > +	dev=$(losetup -j testfile | cut -d: -f1)
> > +	losetup -d $dev 2>/dev/null
> > +        rm -rf $LOOP_IMG $LOOP_MNT
> > +        cd /
> > +        rm -f $tmp.*
> 
> nit: tabs and spaces mixed above

Oh, mistake, I'll change all of them to tabs.

> 
> > +}
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_fixed_by_kernel_commit 84712492e6da \
> > +	"xfs: short circuit xfs_growfs_data_private() if delta is zero"
> > +_require_test
> > +_require_loop
> > +_require_xfs_io_command "truncate"
> 
> nit: it doesn't seem common for growfs, but you might want to add a:
>   _require_command "$XFS_GROWFS_PROG" xfs_growfs

Sure, will do it. If you don't need to check V2, I'll merge this patch
directly with above changes, as you've given a RVB :)

Thanks,
Zorro

> 

