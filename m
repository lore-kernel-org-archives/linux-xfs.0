Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398303ED5A4
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2026 08:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783587110; cv=none; b=HNo8Bn3b7L/EnEIPunSYsnEfAAbO+2zMoJxaoh7itgUIps6k6fjyh9R1hwogSFo3TEF+MMkV30qVSvSBjwD/JbxInvtN2peIjP++i0Tn5tRQIH4Q7oT2MACL5WPsUUocXubBRwj/wRi4UF+vfPNvRHLRLwvH+Z+9p1UORmm+vNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783587110; c=relaxed/simple;
	bh=znq26plhwxInEG6rMm+26AmDR8mHesOo4g2XGqxnm+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RV2F31JFoDzL/+83wtf/TFWfe5vuZupqwzkQGvkIp2BzxbZ7NOAVN6TpYDzS0vLq+vl91WOHc8N1FJZEb3i/Ltt0Fd6gQ/msbU8LKT4H96Phx69LZR2gDTgbUv4Yq3BdwdVAijVCA11PfMPxf24LbwOLWsOJvBd8TQPgN9qS/Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cFiHJeVw; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WJZyI6bX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cFiHJeVw";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WJZyI6bX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783587108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eb5jDTkXBTPOE342mmNfwm5lDoBFxjZ2KPIK/Aydl/0=;
	b=cFiHJeVwYRmrYKwu4MAl2wLtjUdY01m1gUrXUvQq8JKj8jwiWDk2H/iThnakBUzj0jVUXh
	dkdVcMAhCmObCDpRHblwrbAeXZTng/yZbgGyfmoUg38un4J0qAASyV6JOJv9HdGg+dJOqA
	JOgtpxAkVdnIkBagh37fqOjz8O+oOHE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-160-xshulUSMOOqZLnY2NbCmEg-1; Thu, 09 Jul 2026 04:51:44 -0400
X-MC-Unique: xshulUSMOOqZLnY2NbCmEg-1
X-Mimecast-MFC-AGG-ID: xshulUSMOOqZLnY2NbCmEg_1783587104
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-493c55d5ce5so9840985e9.0
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jul 2026 01:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783587103; x=1784191903; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eb5jDTkXBTPOE342mmNfwm5lDoBFxjZ2KPIK/Aydl/0=;
        b=WJZyI6bXBH2/vvILVynx+GtNbmR3khzYZB4phm3GjRrJbvpTiHoouRN8+2DCzLMxC6
         PdRkuIGVEeX0C6AhiWrPW6FkQC9tlPf/e2VfMQD8UW1s1O6/kuK6V4WWdcepQxyLpLqw
         kx9HskoNwbR56G3kbwQqug2O8Z9YhaUB/5Dm7ggZfCNbYulWDUJsy0hIdbrH42Pwd3m/
         ++AWF9jw9zLOuCiZO+0mWyi+LKsd7Nak6+gm/LqlJfCHfiF1rwEOG/6ydqHTcjJE46Kf
         iLLF7aZbq5azY742cVWimJkQxtYoTfCbP00sNNkHxLSGX/YCPOMYE9z3TdPo2qjtm61Y
         YZaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783587103; x=1784191903;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eb5jDTkXBTPOE342mmNfwm5lDoBFxjZ2KPIK/Aydl/0=;
        b=hq/ehx/c9+e4gJKx/CnlqPgR7B461bLpDboOKc7tRDCug4VTZEZkPH+pPReHvjFekQ
         lTRMBgybqkH9e0Xvz7BHtHX/2P3yXf1Mx+pqLaUgIvWfBR6hs13Jp+aPxVqcPZ7bH7lB
         FYDz9ZWX13aYNO15rt6827PbtyG+ndK1nhDbAcI3QONWksWGNE5iej/TTqtdOkYGdsOz
         /dZeU+gHT8Hiq8rhcSuLlAPx43puy3LfMC7InQDKUzUPqf0VacztiE37uEP92nsjUUnV
         RXbMM1aeZxAvao0RSXMdaFKx2DICvSXxkCBr2Fh3DHCFcKOo46WM9phbaio52YbCA5N3
         7fgg==
X-Forwarded-Encrypted: i=1; AHgh+Rr1+EODY+Ae1EyX+l8uiuYC5oB3gvhyDGFBuSKEJUYysjja/E1aC52PPjIRPssyMSyt+S4bD1RpsTo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8m/j4NCH9lDoV+JN/idf4TjiB+gE7WmA2XpdEc/82empaYMGv
	i+pCuoZI6hEGumOYAg0FeTC4zBmfsEI/eifFrkFOOM/R3CyOAECY0tseOuab8qM0DPK34J3Cqfd
	x6qsrBmVKX6CME6cqupIQn24K9ibMCvd31RJkImbMNovzEK2pZYjPZSfoanh/
X-Gm-Gg: AfdE7ckR8WE5P5fBiRE+H+f67pel6P/1PzQb7cRJzEHzgiJusMzHD5GTr86vcj/db6c
	dedpLXjhYKPpZ485A9tsnminyOP8Ry8tjtx/chsmaWpKNcH2CHiPevdPd9wovdNoFX050at1F5G
	jPDqlLinBwe8QYUFamg8CjYcCwqGR/MGQXLvPJxEBUJO7fLBgpOho1K1XAbCudoMRTf5Zyfr/oI
	iJBxsmLWN+O/elkKOGMmB0J+TxMNr//KZ1N+fbHmxhh9a4nlsGpPgHiCefLY+7bJqSEZ1nDXE4u
	a5N2Ne6FSSQNH5VVZEYYuIp6gmPXL2vXICPRpmZadCeEIVbQWUdAoSBacWdduFA8/TF1cD+g4fY
	7YezfmYpzLBTUL2ve8tYRGFstsIFIiqHdY02WK1KtTHE6nQ==
X-Received: by 2002:a05:600c:628d:b0:493:bcef:5646 with SMTP id 5b1f17b1804b1-493e6862b68mr57369705e9.12.1783587103533;
        Thu, 09 Jul 2026 01:51:43 -0700 (PDT)
X-Received: by 2002:a05:600c:628d:b0:493:bcef:5646 with SMTP id 5b1f17b1804b1-493e6862b68mr57369285e9.12.1783587102989;
        Thu, 09 Jul 2026 01:51:42 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e5a5d174sm144100205e9.2.2026.07.09.01.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 01:51:41 -0700 (PDT)
Date: Thu, 9 Jul 2026 10:51:39 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, jack@suse.cz, 
	brauner@kernel.org, cem@kernel.org, jaegeuk@kernel.org, aalbersh@kernel.org, 
	tytso@mit.edu, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH] fs: report direct io constraints through file_getattr
Message-ID: <ak9f0CXSegLq8l5w@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260708011843.1036846-1-kbusch@meta.com>
 <20260709071352.GA20180@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709071352.GA20180@lst.de>

On 2026-07-09 09:13:52, Christoph Hellwig wrote:
> On Tue, Jul 07, 2026 at 06:18:43PM -0700, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > Memory alignment constraints for direct io can vary depending on the
> > backing storage hardware. Provide support through file_getattr to report
> > the attributes necessary for applications to know how to construct valid
> > read and write requests.
> 
> This probably wants to be split in one patch for the new UAPI,
> one for the helper and one for each user.
> 
> And especially the UAPI one needs a much more detailed commit log
> explaining it, including why this duplicates some of the informastion
> already in statx and documenting the semantics for all the fields.
> 
> Andrey, is there a man page or other official documentation for
> file_setattr/file_getattr?

No, I had a draft in cover letter but haven't got to sending it to
man-pages. I will prepare a man page.

-- 
- Andrey

