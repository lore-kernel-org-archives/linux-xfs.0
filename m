Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D22A2E3AFD
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 18:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754936499; cv=none; b=QO5PMt9npPDk6UzojVTzrylCjUgoPubNGMZBlsJqtMyZaDrD9it+nWZJlD44fiGmAMikP3mQACOq4lnHgfi9hOXLnzXCwxuOLsh1HvyeNrETE6ZNYUaj6ZDQjqLA1NZS4DUk0wDkZB2UhCEen9e4fRx4MRhkLrw8DRuGzb0LBpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754936499; c=relaxed/simple;
	bh=s2bacoZ80gq553nMZNXudTEIwsP2I7+dIcU0QZgpf6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LWm95/Hw/3Aopd80hBgzseElPbZ+h6O/zYzjy8JHuoqBUtyijWVkWlea9prDTa2ETKQh/7AnCSuHJFqTKLYaY+t192VVfL/3Q/nd4jvdACcdsbZf4dzOdHoHLsTEY4UjunHPYPwlolKYnPuHvY0IA/n38TrCcNenloxAgknAfKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dKaSY2eB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dKaSY2eB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754936496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fwTrd0+dO6n2K9dOFuwOVngF2++TGNcYuAwM4GZHZDU=;
	b=dKaSY2eBOzEOOZwhOnvWOyuXj/A20PV+q1xGCa40qnqznCncYHuMNHRKylRZHeSfuX1P07
	n6IuG4dsVkK/8nqx5sgqkN8B+mGvc2+0dD6r/g0L/GiKnietTcjNOLK1vQrYjugIGwbDIk
	rnjBcqLgx3E2np1gMLGC7TgkuaOHJ4U=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-nxcaLprnOoCZ-z53SeW6Vg-1; Mon, 11 Aug 2025 14:21:35 -0400
X-MC-Unique: nxcaLprnOoCZ-z53SeW6Vg-1
X-Mimecast-MFC-AGG-ID: nxcaLprnOoCZ-z53SeW6Vg_1754936494
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-451d3f03b74so26801135e9.3
        for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 11:21:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754936494; x=1755541294;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fwTrd0+dO6n2K9dOFuwOVngF2++TGNcYuAwM4GZHZDU=;
        b=ivMF/ssPToBPLpx68FW0NwSoe++jnT4uvOWaHmssfrg4bTS33rsQCXGfaKGd40Ldpm
         B+TZSovptsVq6dy2YPEdPrM82A1kHBl0XDVQ+vFu104YorbWc7SIIECaH6mULBh4RI4b
         6a0D4vjV5YQBViLgMpALPEk6RDYa+jwCley/RLpL6Ya/WZkJQQH+CACFOxsFU/Slr00C
         VOlhqJ0K2qhJpMvWSKB78kaosUqAgiiirQpD3kmUN+BP4m3+atyjOW/uq7vlGph6JMp2
         ZM6KcdfK477meaFqSueJJoBnlCaSa2BHG9PfeILpxL0rl69RKczGMZa8NXjoyNAWtkxa
         av1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXLM2T4iG/n30HanvsE6gGuauSuR3UlwVR40F4mwyurWKRo55jUSjjr2gyGaagL+YbvVXQBeXZiltA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVELtHsDj+enFqBltsrIn4uw3qYlKt5dxdh+23oKYaVvdIUFUN
	EYbL9jmOegEDShcHlc3qzFZJ34kHp4QDYTfFN3CE0+bj38F7QGRziG3UCs1oUcsm5uMiyHupMJL
	xe5L8jzWJUvbLfei8pqRsR3oVBVxDZZDhsP+dsgCuXiUCq65PQUbyIH0ihwuh
X-Gm-Gg: ASbGncuqm2tXnvCkcg8Bn961sXjBWe6+v5N2fSGJ1cTm8e1g4iVLF2tO7isZxroyut7
	2no+cy0DAz74qtvCvYOeb7NySNxLosBPv/rt81xMYCDl142U6V1tGw0smDm6vvm5F1TH19LeG0B
	1FtwjIayMPgxEk74hlzrIFfNPG24Ny0wjEzSHck0auvaRK2wrRLkOGtwFYJfoaU3vrDERQfE+mD
	MlHKI0NR8XhRKLfdOdPzZP0DUjg3vm97cbVBE77M3Bid1nt/qptMXc/9msM3dtc7WlQGcqhqRDr
	SyZDHxWgp5Jr0ObFVF/YrEP1d83MwI2CnJ5BQYRvRM3sKDAlMOVwN/2eX/U=
X-Received: by 2002:a05:6000:2f86:b0:3a5:39bb:3d61 with SMTP id ffacd0b85a97d-3b911007af1mr404467f8f.27.1754936493832;
        Mon, 11 Aug 2025 11:21:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGB8j2u3EX4ITM1fOLXGqpgPLkv5CcVqBQNtd//Kju257Gmpgop9iCOpmn/23WDZQFXeta5Ng==
X-Received: by 2002:a05:6000:2f86:b0:3a5:39bb:3d61 with SMTP id ffacd0b85a97d-3b911007af1mr404458f8f.27.1754936493441;
        Mon, 11 Aug 2025 11:21:33 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e5852e28sm260580235e9.9.2025.08.11.11.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 11:21:33 -0700 (PDT)
Date: Mon, 11 Aug 2025 20:21:32 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, zlang@redhat.com, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH 3/3] xfs: test quota's project ID on special files
Message-ID: <gyajh6rvjyqq5z4acrk2um4bwkarxztu5ptuyyehrh3xqcffwg@q3nh34dkdpwo>
References: <20250808-xattrat-syscall-v1-0-6a09c4f37f10@kernel.org>
 <20250808-xattrat-syscall-v1-3-6a09c4f37f10@kernel.org>
 <20250811152109.GF7965@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811152109.GF7965@frogsfrogsfrogs>

On 2025-08-11 08:21:09, Darrick J. Wong wrote:
> On Fri, Aug 08, 2025 at 09:31:58PM +0200, Andrey Albershteyn wrote:
> > From: Andrey Albershteyn <aalbersh@redhat.com>
> > 
> > With addition of file_getattr() and file_setattr(), xfs_quota now can
> > set project ID on filesystem inodes behind special files. Previously,
> > quota reporting didn't count inodes of special files created before
> > project initialization. Only new inodes had project ID set.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  tests/xfs/2000     | 77 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/2000.out | 17 ++++++++++++
> >  2 files changed, 94 insertions(+)
> > 
> > diff --git a/tests/xfs/2000 b/tests/xfs/2000
> > new file mode 100755
> > index 000000000000..26a0093c1da1
> > --- /dev/null
> > +++ b/tests/xfs/2000
> > @@ -0,0 +1,77 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2024 Red Hat.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 2000
> > +#
> > +# Test that XFS can set quota project ID on special files
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quota
> > +
> > +# Import common functions.
> > +. ./common/quota
> > +. ./common/filter
> > +
> > +_wants_kernel_commit xxxxxxxxxxx \
> > +	"xfs: allow setting file attributes on special files"
> > +_wants_git_commit xfsprogs xxxxxxxxxxx \
> > +	"xfs_quota: utilize file_setattr to set prjid on special files"
> 
> These syscalls aren't going to be backported to old kernels, so I think
> these two tests are going to need a _require_file_getattr to skip them.
> 
> --D
> 

will replace it here and in generic/ test

-- 
- Andrey

