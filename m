Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740392E2DF2
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 18:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754937814; cv=none; b=fQRCI33knCJKXZ+K6bLrSXY4b+0TJMAzLxelVGnlofb58kkawLS/+NWPxU/Bfe5DpWJ7Mt4pn8yaF73VV5WhB6Bvd16zOr3pzqUN/XGQbW4BLa7x3OSDweOu9beWns+ri4t3mFk6ZtaH9AieLWW1xtaYwf+fkx3LKKBZmEFznH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754937814; c=relaxed/simple;
	bh=SqhdOnIF7QxUtEixPp9BXh1H/128h/L0jgTrJEJihww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kDWLEjZfupsHvT7Ag9EDTSRD9SZ06h8RlVoEa0oQw8LOALREDdDWknsssapmfDiYtbyjJ7c50KXxOtFShYcPygx3072nl+nm/Y+yjbvBIkD5obl6a7ZIS0PSjtTjMUxM8ESNH9uiARwRE5LgHExT0H9LMRJDAmg0/iMGM/hJtjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GITHwwDb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GITHwwDb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754937811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wIo57RPl/YXM2GjIrmDZTWpdW2C1u6bkxhIh8YLOef4=;
	b=GITHwwDbRsqSwtBCLyovbbI2AtlCXv8pKS/i3PZWqmkTVKl1IzxsUEjqZgkDGcUGWlJWcJ
	ZF+AiZ+fkHRwzndQZLUNDdOSblTNTObgGrxyGBty1dqdShZEXUJ9CYwqP+7hdwvl+KwlIa
	PlfYkGjFhk6eKWcF3kxfxhDTUWIYHEM=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-eHzsz75JP8eJnav2GFsBBw-1; Mon, 11 Aug 2025 14:43:29 -0400
X-MC-Unique: eHzsz75JP8eJnav2GFsBBw-1
X-Mimecast-MFC-AGG-ID: eHzsz75JP8eJnav2GFsBBw_1754937809
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-76c115731eeso8858455b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 11:43:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754937808; x=1755542608;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wIo57RPl/YXM2GjIrmDZTWpdW2C1u6bkxhIh8YLOef4=;
        b=wYa5JfToZM3tYUCdKsqtwuL9OwAykC8pwiz2jj5VvQ/XpFhVsG3gl84m72y2+n7MUv
         c/njl6S40Yy1hL36dqJBgQJ3BQ9igTk3CQ/4mUq3Xyib+ynUgBM2gQEl7F7267QMfvTx
         /EYBY8T7pamr4phk1I3JEPcSbvh8oWXO/Ds5ucvPadxnUSXisd7ZqX5ehQdiEqr/pLrY
         4g5/8/xX3sS6+qFgj6EnUnQYFCHA/oIEk1ksdhjhQL1nLfJvoGzpAhMNfrGqBQxuIEr+
         ZJjHXHjHZCeLC1on8bVoiLxigCa0t6B7g+fZLWhmMmiPnyDUWIuGw5fDnfrqhza8D9c1
         EfBA==
X-Forwarded-Encrypted: i=1; AJvYcCXWSVuPXHifTJGFWYzB21MzgR9mvsg8exdRlV3sP/XtOEqUFiLzreCtdTS6IzBi6F23cSUF88LVHf4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqHsTUbz8sl5k0LcEVrdaRa5BQuH9xJysI89iWql58Rl5psTpU
	09oHufRVYeSKGtgDiMdM4Qv0lj6t9pMzwOXTx12kweJMCUmMcWkmut21usKjIQxBACcX6DSLX2Q
	y8D2okmmWlrb3Q52SMFUrFOriDfTLei6uuQVITpIInsIYaisVHJ8kUqGkG96oHw==
X-Gm-Gg: ASbGncsm3npKz5vqZcBV+q6W9JwGaoW8uTbnMqlD8dQ0iNXQaXRkyReXfxffWK5ahlR
	nWK402EnCfxODDs7bPi9z9wBjK/dkNnSQxmabzaSRnTvNFZigOT4mLzxZXFGnSa+sjLh4ghD/Xz
	ChqwcS4krjoncVgGoCR2wzFKB75vMF9cx1KABpfnJ3dXiGkh3X2RKT+8YADlRMuSdX16OEbs+PG
	JJqjlyByof+vML8UhbAm6fRQekoOp/xmpB5FKj5FmimKeNfLHMdv1mCzJl0Bz8L+8sbBHVIB+dd
	jApmNPRYiKEzqeLmNHh8vm1PaHjiaZ2t2rEoXQpnvAdMJV+qD2LrepqXUcRyFnUNfG4sEZ3aMim
	7mIHn
X-Received: by 2002:a05:6a20:7d9a:b0:240:15d2:aa7c with SMTP id adf61e73a8af0-2409a9714f5mr708655637.36.1754937808519;
        Mon, 11 Aug 2025 11:43:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEgfevIUInZJv6WvEhFsjhLINeXTt8yC+nI2ofBCEUPjRblEgI2+ESpuTZJgu3DvteP+hHh/w==
X-Received: by 2002:a05:6a20:7d9a:b0:240:15d2:aa7c with SMTP id adf61e73a8af0-2409a9714f5mr708626637.36.1754937808128;
        Mon, 11 Aug 2025 11:43:28 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b42b93391e0sm7185239a12.11.2025.08.11.11.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 11:43:27 -0700 (PDT)
Date: Tue, 12 Aug 2025 02:43:23 +0800
From: Zorro Lang <zlang@redhat.com>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH 2/3] generic: introduce test to test
 file_getattr/file_setattr syscalls
Message-ID: <20250811184323.fibycyccfh4qpzpp@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250808-xattrat-syscall-v1-0-6a09c4f37f10@kernel.org>
 <20250808-xattrat-syscall-v1-2-6a09c4f37f10@kernel.org>
 <20250811175541.nbvwyy76zulslgnq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ydu5kha77suh2sn4jmyh4xxj2eiw3g72qvf3b7hy2k5xoh33eu@2vconk3marrs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ydu5kha77suh2sn4jmyh4xxj2eiw3g72qvf3b7hy2k5xoh33eu@2vconk3marrs>

On Mon, Aug 11, 2025 at 08:18:24PM +0200, Andrey Albershteyn wrote:
> On 2025-08-12 01:55:41, Zorro Lang wrote:
> > On Fri, Aug 08, 2025 at 09:31:57PM +0200, Andrey Albershteyn wrote:
> > > Add a test to test basic functionality of file_getattr() and
> > > file_setattr() syscalls. Most of the work is done in file_attr
> > > utility.
> > > 
> > > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > > ---
> > >  tests/generic/2000     | 113 +++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/2000.out |  37 ++++++++++++++++
> > >  2 files changed, 150 insertions(+)
> > > 
> > > diff --git a/tests/generic/2000 b/tests/generic/2000
> > > new file mode 100755
> > > index 000000000000..b4410628c241
> > > --- /dev/null
> > > +++ b/tests/generic/2000
> > > @@ -0,0 +1,113 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2025 Red Hat Inc.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 2000
> > > +#
> > > +# Test file_getattr/file_setattr syscalls
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto
> > > +
> > > +# Import common functions.
> > > +# . ./common/filter
> > > +
> > > +_wants_kernel_commit xxxxxxxxxxx \
> > > +	"fs: introduce file_getattr and file_setattr syscalls"
> > 
> > As this's a new feature test, I'm wondering if we should use a _require_
> > function to check if current kernel and FSTYP supports file_set/getattr
> > syscalls, and _notrun if it's not supported, rather than fail the test.
> 
> hmm, I don't see where _require_function is defined

There's not that _require_ function, you need to write a new one to check
if current kernel and FSTYP supports file_set/getattr syscalls:) e.g. name
as _require_file_setattr.

You can use your src/file_attr to check that, or update src/feature.c for that.
refer to _require_aio or _require_scratch_shutdown.

> 
> Anyway, the _notrun makes more sense, I will look into what to check
> for to skip this one if it's not supported
> 
> -- 
> - Andrey
> 

