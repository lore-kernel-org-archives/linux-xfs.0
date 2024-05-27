Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2442232A
	for <linux-xfs@vger.kernel.org>; Mon, 27 May 2024 09:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716802997; cv=none; b=hDUr797joYXHXk8FMFqpS5ptA2IXDqOfqt4y6SfVkA/Ieoi1EZ+miRap8dZ6msVOaftE3zbB9KcZ+zf4Bv9P4WWhbsd/lzmymdEl6INL5YN+lMRjWTiBY9Uv8pA1ZBStIRihsmHwFFq+hDk2KbWXFYhfQOzGgBHVdZ570DmvZIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716802997; c=relaxed/simple;
	bh=4TAnsgRU3FqL2CVyRoWPdi38cUzoxU0puszdnE0/8Ng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JfFGpPYTCvMqsCfGStldkGq392jOfj9C8lbk3H2IQb74SISc6hDwAfzc3tKPiLSvOjrsPxgdTk2KI5R437rRiuBurhaFEmhOdyWBRy+gOgHnHX6H36kKlSSNAfVto29KqDhwJ1wStZAewMydEBry7zbxWXYv02TJtKY00A8F7pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=agHRxBwL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="agHRxBwL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716802994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=01xQt1pVX53eXZ63Wy8mqsxhl6WWb+Dr6WxWNznAp/Y=;
	b=agHRxBwL95uduC8PSNN4k+gJHKN/U5ly2nl9OAZhBU2kDKaogvHfOL+Sw2qdrpTFeX6R/x
	DODEKlQiYR6bOQb/XdnELUdT39CyupFC2kIW81kTyBmmkCzNYFJX9IJdLWYu5XtqVhaQJ+
	zLubmVvKrQotG/eLrIt8zP6YazRkjus=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-jUaNE34OMOq3tZTkvlc1gA-1; Mon, 27 May 2024 05:43:12 -0400
X-MC-Unique: jUaNE34OMOq3tZTkvlc1gA-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-529aa3f32ecso915352e87.1
        for <linux-xfs@vger.kernel.org>; Mon, 27 May 2024 02:43:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716802991; x=1717407791;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=01xQt1pVX53eXZ63Wy8mqsxhl6WWb+Dr6WxWNznAp/Y=;
        b=vs0G8oRgfDCTpvmV1x34hap3ajKzlzwAB+PFMjpVWtahjL3l/9XVEO6+WvKrbgOXfM
         wCnTfA/J/4Nudnk9z3UzM9VgyfAOfqQNWm1lO3uOsoyj9GSlZx2MxdCyjVblhd2tsXs4
         S+jFBcDQYg+qJ4UHRgVlxk9AE81vxHMuNvIiXUjTlgdBysl8euNhLwjn6KrBp8nitzda
         LbpTQ8/LWsGf18Oyi9cDSwgt+Uf6jeNpoWnZwealKloQ/UGb94BlwNX8xfwiz17uTpPL
         cuEzjN26KBQeQhGe1fPak6Xi0Jw9o1+QwGRF37PN4dsTmiviqyybVjLrX2CTw+xuLcHT
         YkAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbNijUwyd1w1Hvm3CVJD5eOBzAtk7hAo3qcB8Ofqm/0hPnliRQBL6fmlWWR7rZ/O1eWakbRmug48C2ObhJexSlbQdtyrLYpYPx
X-Gm-Message-State: AOJu0YzMPuefWfIJz35MuVwxQOXqZzxZbIOU+pUiVBmaGvmqRo1VOUxo
	fL9T06HGgUHD3k56SJFxU4MC0i7rdR6DFMkAThMpDm0EHWqJAjNFamthCyt7lZUzfkxJiYTLs62
	+LepQ2kyakA08jlv23enSgQQJ09ZfZ7d51LzzweIF6EwW/SERZMWmM8vFtt/yn/Kn
X-Received: by 2002:a05:6512:31cb:b0:520:9df8:f245 with SMTP id 2adb3069b0e04-529645e242bmr7086626e87.1.1716802990745;
        Mon, 27 May 2024 02:43:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCnOgy3AuFG33Flx9qdZtJBuvSL+1Xt7c4UsRxuEMsXwXtDIVjTu+tqu5MCRpdme2hgS0KZw==
X-Received: by 2002:a05:6512:31cb:b0:520:9df8:f245 with SMTP id 2adb3069b0e04-529645e242bmr7086602e87.1.1716802989968;
        Mon, 27 May 2024 02:43:09 -0700 (PDT)
Received: from thinky ([2a02:6bf:fff0:6300:6263:2b90:eac8:9097])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42100ee7edbsm136396605e9.5.2024.05.27.02.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 May 2024 02:43:09 -0700 (PDT)
Date: Mon, 27 May 2024 11:43:06 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test quota's project ID on special files
Message-ID: <amb432qfsbrvbtfrs5zeqif7ddbzauktmm5xn7hiszpuftw7qg@7rtsuoqznx5t>
References: <20240520170004.669254-2-aalbersh@redhat.com>
 <20240525054252.2h55e2oer65mpy6s@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240525054252.2h55e2oer65mpy6s@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On 2024-05-25 13:42:52, Zorro Lang wrote:
> On Mon, May 20, 2024 at 07:00:05PM +0200, Andrey Albershteyn wrote:
> > With addition of FS_IOC_FSSETXATTRAT xfs_quota now can set project
> > ID on filesystem inodes behind special files. Previously, quota
> > reporting didn't count inodes of special files created before
> > project initialization. Only new inodes had project ID set.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > ---
> > 
> > Notes:
> >     This is part of the patchset which introduces
> >     FS_IOC_FS[GET|SET]XATTRAT:
> >     https://lore.kernel.org/linux-xfs/20240520164624.665269-2-aalbersh@redhat.com/T/#t
> >     https://lore.kernel.org/linux-xfs/20240520165200.667150-2-aalbersh@redhat.com/T/#u
> 
> So this test fails on old xfsprogs and kernel which doesn't support
> above feature? Do we need a _require_xxxx helper to skip this test?
> Or you hope to fail on old kernel to clarify this feature missing?
> 
> As this test requires some new patches, better to point out:
>   _wants_kernel_commit xxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxx
>   _wants_git_commit xfsprogs xxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxx

Sure, thanks, will add it.

> 
> > 
> >  tests/xfs/608     | 73 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/608.out | 10 +++++++
> >  2 files changed, 83 insertions(+)
> >  create mode 100755 tests/xfs/608
> >  create mode 100644 tests/xfs/608.out
> > 
> > diff --git a/tests/xfs/608 b/tests/xfs/608
> > new file mode 100755
> > index 000000000000..3573c764c5f4
> > --- /dev/null
> > +++ b/tests/xfs/608
> > @@ -0,0 +1,73 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2024 Red Hat.  All Rights Reserved.
> > +#
> > +# FS QA Test 608
> > +#
> > +# Test that XFS can set quota project ID on special files
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quota
> > +
> > +# Override the default cleanup function.
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -r -f $tmp.*
> > +	rm -f $tmp.proects $tmp.projid
>                       ^^^^
>                    projects? (same below)
> 
> And won't "rm -f $tmp.*" help to remove $tmp.proects and $tmp.projid ?
> If it does, we can remove this _cleanup, just use the default one.
> 
> > +}
> > +
> > +
> > +# Import common functions.
> > +. ./common/quota
> > +. ./common/filter
> > +
> > +# Modify as appropriate.
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_xfs_quota
> > +_require_user
> 
> Does this patch use "fsgqa" user/group?
> 
> > +
> > +_scratch_mkfs >/dev/null 2>&1
> > +_qmount_option "pquota"
> > +_scratch_mount
> 
> If there's not special reason, we generally do all _require_xxx checking
> at first, then mkfs & mount.
> 
> > +_require_test_program "af_unix"
> > +_require_symlinks
> > +_require_mknod
> 
> So you might can move above 3 lines over the _scratch_mkfs, looks like
> they don't need a SCRATCH_DEV with $FSTYP.
> 
> > +
> > +function create_af_unix () {
> 
> We generally don't use "function", but that's fine if you intend that :)
> 
> Thanks,
> Zorro
> 

Thanks, will apply all your suggestions above.

-- 
- Andrey

