Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A940A34E74D
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jul 2026 15:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783436992; cv=pass; b=H9Xq8+amY/GGHhOGnZjnM5bdSoY5ad2iQJP0R9U2HLFMz/OrZyRaZOE91zAYX+nA86K3l4F6W7WZZfWaHmVTMdhfcKR007J3822SytrRIzp7/6FSWUjzm+QqWN+UBLoRMwT8iz1znqtJbKC5KNTFqmSm/ZT7kNPgHBN1oWLeIUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783436992; c=relaxed/simple;
	bh=iyaJ8UzNnkHUlCYXN10ZaLDIUqJRd4RAiuBeezC8MnU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LbreBgSuNGGUcsTUEFTrlKY6AmRiIfoxn1raDEOIvTPf32q3pcAgMaGc/+14V41N2G/mu8CL28c4KOjgkEfcKuDa/brKiNrnnQkA16Zv3VHNu6qiJbyjpQyvYj974ClUvTfBLUdusoAG23VFMbX3hvE23cTj7Y6n3Uc++Wd09OQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sUEEWFiQ; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sUEEWFiQ"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-69a0ccd9669so3740259a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 07 Jul 2026 08:09:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783436989; cv=none;
        d=google.com; s=arc-20260327;
        b=YzF467BSPPGHe08LP3PriFrCo6cf/x1jYvalCtnKXO26I+dy6QOkEjo9YShprCPGOm
         4rNHThtoEPDoxnwi6bQAT6LzWB5yQpwexMhaD+30Fyo3oglYS3Dh07/qQ/ew7RGFx6Kn
         fBQ2qOVR3LXBucBp7H2dtsbmU/it6YeirvER497aWPEetP6tEfyr2DhH0j4mIt3TZsYP
         CULbsjBCKLpMnEnpBgKm0vwKoFzmfj8hx7ezLxoOChW9wNn1Dl25LQ47a6M/rNnjeiav
         0gkc8D/ZzSY83m5U1wDHjc04MDiyP1TaSGADQ79ncFFAPT2fAl/0nrYziDto8HvSW1lQ
         roBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=EHg6g1xG0THOWrgIfT7OV47aRx5Ec6PF92pF8+vZJ3A=;
        fh=pAMtpGVDRymdvVH9k1+UoBUyhSTbQu/weGM0EXPqnyQ=;
        b=i981E+c7FvFt3hagkdGyUksf5EpU5+0bqy0snt0QEMIE/UO2mGJYL+nG50UjRBjc+n
         rtwZ3tC/asRCw7Wn11HIPElNOGNbGKYuft1AZuQpPTNLDP0bdjTvOGhXARfrcv4exvE6
         OJvFQxlRt/TXlUTXMPuIi1Tfya9h2QeUPr6eGMgcb1JhSJDzh+9z2O4wym0xaVDCZP7b
         /lRw9R4KAmrIY9xMUN5Dst+Y97RVRigdjxh25HS0U9nJTOXmZYx0sMh0ro6V9jX6ZNaj
         lKiJfh7atzjmRlSqO0KLi67mPGIW04kQo4ui8B+qxzooQmmQYFrj8lgiAdklbR5YPsoa
         lWlg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783436989; x=1784041789; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EHg6g1xG0THOWrgIfT7OV47aRx5Ec6PF92pF8+vZJ3A=;
        b=sUEEWFiQFDw8c2xafkaT6mHLEN1JwdGCPfLxBIJ6nyigkbnpquRQ3AzEYIg6p0VJpt
         atrAOffXhCQn2uPUmmaOHAVF3ilJPU8S4rYWrB//RPUDyfwlRlISpgcTvG1hN3LDPxoQ
         VLk8qdE1/zKpSHYoOjVhD+c2SOKEGhGOlzSqFWMQsKzkdTHEI3YgMl8QNUnbJSK+HCEF
         q79j51+D3qG0DFLheV6wjRGwG71renIvvBiTccIhZzDeEiSg+XDE7TOSzhi98HZhQF6n
         nDAdPGOuwl4Dtc9oyFHndD1CMNhm80SCvffWat67jjPxlIxnCRm8ByVWc2jXT+dLf1ei
         UE8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783436989; x=1784041789;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=EHg6g1xG0THOWrgIfT7OV47aRx5Ec6PF92pF8+vZJ3A=;
        b=rfRKmb47D0vVMCmV2+TlLjzUgOmFJB8IQPnilR0RdxZ1R1H8qohUl0AbIPn+6ft6AI
         mbViSl1LCiQz9zmtvhvD0qAtQUYVx5hbSgik1VfqSzBptu/qVPzYUYOWNFPQfIe9GClr
         S9km19s/kT8C0RxvnPqhgFiPbhPNUmnKFnzmvCzH80expQLNfsBohjc80YPWDseWUbe6
         CF2EgICCuhROHmUdBqi8hH9fNDq0VLo8ZsdP/bnvLbSjy8b6SX0f3fC+ZyCicF8UqPP5
         4XPR9R45Eq/zGN/CdQMzEeMD+Cdns3JmFJz34Ya4qgfJTU7KNMVYdbEgMnjM/PmcyyWN
         wpKQ==
X-Forwarded-Encrypted: i=1; AHgh+RoVeK7hddIuWQklSoO5LvnyaLvuqyCsTxCOYNcL7J/497hKkDW4EHeLX9AVHqsNhdfIvv5sYNipm84=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQERTY/xfL24nw+FxxiHls16JsZXV13Gcon4DT5taRssrKqmct
	fs0rxTbnXzOxHNDO/Um6/k7peyUU4TCe2v/UfVsWfOkzH/kdqdcF0u9v0+ns9jQ0rCV+qH6R+m/
	nQgvZpmxY6xw6tG3K1KBz/9NcbQlAYTe9TLM4fLQ=
X-Gm-Gg: AfdE7ckw/8zmVngObKYC9Z/IkoHKCpq9uSRF6fgpjC03ZnLerQc7U3/6r1Hlv9OZhip
	2icvxypKEe42e0ov6iod3vpKPFOaCl/kKAxAuNyY0xsjjEW/ZCXOMafUZ2p4Cfwb0MMYf4QBjhK
	UZbmUGwYbN0FsJ7wje3OiKT9r3tXtB7/fwzPO9plNMQGhm0zFxX+AtQM2H8HJfQp5CXHJv2JDsN
	hDvjw7DYew6xiSWzRB3u5IHl1cC/7yrblJ8H6dNmDXmD8bgkRrRCUaQsddUUOUpxgE2DvGzcg==
X-Received: by 2002:a05:6402:1590:b0:698:50ea:2d97 with SMTP id
 4fb4d7f45d1cf-69a85c19075mr2795096a12.20.1783436988737; Tue, 07 Jul 2026
 08:09:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAFnufp2NJj=eXCpfoU4ZzPwSX31oUbsUr=Kstz6NedTZ3dsqZA@mail.gmail.com>
 <20260707055651.GX9392@frogsfrogsfrogs> <akyaqGkBmxt2JG5n@infradead.org>
In-Reply-To: <akyaqGkBmxt2JG5n@infradead.org>
From: Matteo Croce <technoboy85@gmail.com>
Date: Tue, 7 Jul 2026 17:09:11 +0200
X-Gm-Features: AVVi8Cc2nSs0R7P4LoC5G53SZci5oNTryUtjAOagRdAYjANCfGPb9nOAJkxMbeY
Message-ID: <CAFnufp0Y2bqiJE7Zxpt+SgTNgU09E6mw=t7oBM5PX+PtpUfhzA@mail.gmail.com>
Subject: Re: ftruncate() after FICLONERANGE costs 300-600us/file, ~10x more
 than the clone itself
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Il giorno mar 7 lug 2026 alle ore 08:20 Christoph Hellwig
<hch@infradead.org> ha scritto:
> I wonder if we hit the filemap_write_and_wait_range case in
> xfs_vn_setattr_size due to a non-uptodate i_disk_size for this
> workload somehow?  Although reflink should update i_disk_size
> properly.

Possibly related datapoint, from the write-trunc mode of my
benchmark (write of the size rounded up to the block, then
ftruncate to the real size): the truncate synchronously flushes the
delalloc data even when it does not change the file size at all. A
no-op ftruncate at a block-aligned 65536 costs 514us on a freshly
written file, versus 7us for the same no-op on a freshly cloned
file, and the syncfs time of the run drops accordingly, so the
deferred writeback cost moves into the truncate. If a tracepoint or
counter would help pinpointing where the time goes, I am happy to
run it.

> >
> > Assuming src.dat is the fully written 90000 byte file, can you
> >
> > $ xfs_io -c "reflink src.dat 86016 86016 0" dest.dat
> >
> > to link only the eof-block into dest.dat and keep its file size at
> > 90000?
>
> Only doing the reflink block aligned and copying data for partial
> blocks should indeed always be faster.  But I wonder if we have
> some dragons lurking in the truncate down path.
>

That is the plan for tar: clone the whole blocks and write the
final partial block, avoiding the truncate entirely. In my
prototype this turns the 3.4x slowdown into a 1.6x speedup on XFS,
with the small cost that the tail block of each member is no longer
shared with the archive.

Regards,
-- 
per aspera ad upstream
