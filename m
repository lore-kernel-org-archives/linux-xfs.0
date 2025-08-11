Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773672D6E66
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 18:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754935964; cv=none; b=b9bJBLBtmbaTdf37fRKUIDBU5377puf9ZlUJo2G+2CEewcLWW2TMVLIL92W43VB0Zvd5ckrtX3u+MttJk7ViBp5DPdbeq6S9G5Xqq/PqK/KB2yg0O2+Wh20PeiflUcALS6+63iBbVKImUmmQrW2CxFKU8CbigR8PfeLlLlMIbME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754935964; c=relaxed/simple;
	bh=T1TbY2V3duINVsRmkHpfxRcOte3eOWw8A/E06eTbPow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wc8v7OtYlQG0Dt9svgon0tTHZPNLICSQouC0DfHsbcVnULqRx0uKiEury0kjO5+YtiVkgy5RyGl8rsSiuX9S2jKisP7YvGec9XEBWp/l+CPsf4EGlaNWUyVnH7BXUE9YTAC+aTy3t9W79n/mOogvgolYNqkewxQW2AARdx/gIo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a1wW98Sv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a1wW98Sv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754935962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=81uqlJiu3KKJ+tPXBfJ9HETxELLjgevjOQyrFQtsQWA=;
	b=a1wW98SvIrjOOjtnF6ZrMW1QyBo9jjiusl/bUIxlXKQTfEor1F2jwDfcYv3EtCK2P8itAk
	aTIebc3W8JvB2703aE/tGpXb7Hu+O+HOsNTUreVxY8GdlzaZkuznpPlclaeqbp/LjXdfts
	G4S52RtQo2a5/3Us0pWpvcVUJnkY/QQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-cD6kQu8HNbKQJx_8lImitQ-1; Mon, 11 Aug 2025 14:12:39 -0400
X-MC-Unique: cD6kQu8HNbKQJx_8lImitQ-1
X-Mimecast-MFC-AGG-ID: cD6kQu8HNbKQJx_8lImitQ_1754935958
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b7892c42b7so3228796f8f.0
        for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 11:12:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754935958; x=1755540758;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=81uqlJiu3KKJ+tPXBfJ9HETxELLjgevjOQyrFQtsQWA=;
        b=PnxzeKBid3H533kQ6Fj8t/sIzB30BVJm4gzjpuTo0mppE1Jp5QYvXnP/6+5hnPkIFe
         7IddCcLYL1b3QQvXFPNUnD0Jx+KMDfrxlU8MjkzCADo+QP6IycOSfEpGHd7dPDhAV5lt
         NUwb09/aFScvXvmf0MR8njWE5qvu/asWPoJD2s5Z+7fEPIb8a0vwq1awU/Zv+UjaAVIo
         Lh1VHbydWhRxnh9JOosn6nc64wlQoOepiNfIVHWHTk6grdcmn574GlnU+iSiJbKM3lzf
         fGbHIw36ffqyp0EKEQAuog3wlbKrC99bg7JgkobfTY1O21wvcIdjjujqZyPY7lqm2a3I
         7iaw==
X-Forwarded-Encrypted: i=1; AJvYcCVD2KAHs03+4gRNv/Zh/uVFEraIoGpwqMwBRnR4DktjbpmaTAlaGsdIYtvK3HarfrWIXi2/N7c3g6s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaEl2YbmiRU1HmKsn7itTct6xOO2ZWty8MG1YT79/gwFkNQMdL
	sM5a4uKXoy+IBV2JpS0qqQ5j8HVoG30ZoujFVs1P0Hz/Qa015C25ZGYIiSeFWPnRCnwLtYkz+is
	x/W4yMrHLNSpJwV0blGvORrhM/qM5wtnNZBGo4spsr5j8ygsBH9SbTPWIsfN7
X-Gm-Gg: ASbGncvBq6/m+57agAo8VOm8AIvnxuKoMSg98CK+dFTVVJtwj/mwfO+msAeWT84FMaD
	OKSklFdFwJF9z9yXyqci9/UAFQZNN1WPjcez7KmLOD5xH0KfruCZkzWJ8in8kmbXaDMV50qnLG/
	KdhRyjPE3+wJ37SKVZHRHMOABJlWIYLOXDv/dKkKOJ2beZ6EGfQPtzNInwJU6RFXK9ed0zMOGLr
	NJlqI1hlPIFD/nIIFSjwJ0yrr3sIJYgzVCQrB6eKQdF9DxeswC7uiwrOoSvTvh3N7ikk0K1O5qe
	MaiORUfX8FOHpd5sy+AFn8ljMhiOiCRMH2uwLjc45+fa4feDUzDPAkWQ/jU=
X-Received: by 2002:a05:6000:4387:b0:3a4:f72a:b18a with SMTP id ffacd0b85a97d-3b900b52958mr12107085f8f.26.1754935957773;
        Mon, 11 Aug 2025 11:12:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMlgmyhItfKunlp7MS1hsmVXPdcoGXFCSQWd0jOrnBuISzKtEDYAL3EkLU5AqA2dr0zaPDQg==
X-Received: by 2002:a05:6000:4387:b0:3a4:f72a:b18a with SMTP id ffacd0b85a97d-3b900b52958mr12107060f8f.26.1754935957372;
        Mon, 11 Aug 2025 11:12:37 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459c58ed0ecsm183736025e9.4.2025.08.11.11.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 11:12:37 -0700 (PDT)
Date: Mon, 11 Aug 2025 20:12:36 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH 1/3] file_attr: introduce program to set/get fsxattr
Message-ID: <4lvrb3s5nrch3bas53ig72d5aqlc3tnvtfbnrvgvattxsftdrk@utdtay3kavej>
References: <20250808-xattrat-syscall-v1-0-6a09c4f37f10@kernel.org>
 <20250808-xattrat-syscall-v1-1-6a09c4f37f10@kernel.org>
 <20250811175107.gxarqqcsftz5b6m4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811175107.gxarqqcsftz5b6m4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On 2025-08-12 01:51:07, Zorro Lang wrote:
> On Fri, Aug 08, 2025 at 09:31:56PM +0200, Andrey Albershteyn wrote:
> > This programs uses newly introduced file_getattr and file_setattr
> > syscalls. This program is partially a test of invalid options. This will
> > be used further in the test.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  .gitignore            |   1 +
> >  configure.ac          |   1 +
> >  include/builddefs.in  |   1 +
> >  m4/package_libcdev.m4 |  16 +++
> >  src/Makefile          |   5 +
> >  src/file_attr.c       | 277 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  6 files changed, 301 insertions(+)
> > 
> > diff --git a/.gitignore b/.gitignore
> > index 4fd817243dca..1a578eab1ea0 100644
> > --- a/.gitignore
> > +++ b/.gitignore
> > @@ -210,6 +210,7 @@ tags
> >  /src/fiemap-fault
> >  /src/min_dio_alignment
> >  /src/dio-writeback-race
> > +/src/file_attr
> 
> I'm wondering if xfsprogs/xfs_io would like to have this command :)

it has chattr/lsattr, but this one also generates quite a few
invalid arguments for these syscalls, I don't think it would be
useful in xfs_io

-- 
- Andrey

