Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE25E27A12B
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 17:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764956014; cv=none; b=KKFC/O9A+U53bQyGtVMBfBSHLXlLmIFvcr82WaxTo0yN6VSTa3XWerB0n0Rq83QA+OJ0kEuCVNJek0399TfwgNrmiV5NSAp1hSNWQmoIS96w8qs7ZvI90AGsaCO49yVcwkGUM2dVzHdP+GfpO90DVHpbfzBwkOMLBhHQB7SVE34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764956014; c=relaxed/simple;
	bh=MXvU6wy8kiRw1rLT3BxJwWykSlf/19Z105D5vDBStVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lZqyQyfxP5F8wepQn2F5IGhCr4doW+INM3OWyaBBxNBeWCYuoJG1j50Js4FDaDuOo2cDSvd4BzBPMSzJxaSgCP0mx00egoyLrwNWzrOByLs8KejCwhyARgJc/wxlxgGePXkCHoSt+PL5Gddnp4NmXYnvC4ADyLmLlaawuVRL3bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZDqmfp+D; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WEfP7rbQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZDqmfp+D";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WEfP7rbQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764956011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1hXp+e5OOMkLppC6GEnYNdX5VZITKOpXjupoN3ddJOw=;
	b=ZDqmfp+D4W5fnnMapCIOqiW25QmnVXQSTkPRYjwTWfw1XvLW8nICoyifUXqwGzkyOtwqdr
	IwM2wlvo4LpQkVVD4DlGyh1VlGlqpACBxXK3djx8K4y1n64FkvIzTNrNb7JRGcHY9eOv+9
	erIXPcurpBlYYJKQyPEfJknEEPYL8zc=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-cXfV-Lz4OwGSn4r_p_BNRg-1; Fri, 05 Dec 2025 12:33:23 -0500
X-MC-Unique: cXfV-Lz4OwGSn4r_p_BNRg-1
X-Mimecast-MFC-AGG-ID: cXfV-Lz4OwGSn4r_p_BNRg_1764956002
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-297d50cd8c4so63332575ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 09:33:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764956001; x=1765560801; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1hXp+e5OOMkLppC6GEnYNdX5VZITKOpXjupoN3ddJOw=;
        b=WEfP7rbQ/yeA9h0fZBMhEthvq5hSA8vqMdUPQccvpe0mZf/iU9+/ud9Bm+HLWSeCBn
         pRRImujW3/K67ZefMYljPmsh7EnEP6uYIaLvHr/skTLinZh1Sp5W6OP6YCgr37wcyoC6
         3tuf/rV6vZ56FR3opwks+8WIg9W62njTLf57jeoMNpxBJvW/LU7Kp1J0vyt4vnILNj5Q
         FLDddYb7/yF48MGlA/l3yfOWOW880WmMxaZmGpZbPNagGE+DANr6yRhvPMwWAgfNZNDF
         Mvvo38f+BLxQC4JGi07huUy0RJ0QAyTHCTQ0ZPh1T1+RvXolZgB2AqjObVAGvU75LIX5
         nHWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764956001; x=1765560801;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1hXp+e5OOMkLppC6GEnYNdX5VZITKOpXjupoN3ddJOw=;
        b=E1Sfhl4mL/Shwn97x3YtYtTsMpST+ExrvZhDcvDxofNiPXPDPkGqqYuL9B+lgwm3kE
         M0g/k+U25YRNm2Zr12F25ZfilJO6xYNb0dwieR2Oh0jbl3d1AFcfbY+IbusSbjiVlObk
         c2hbv6e3FKhCdBanttc8M8yb8A7DKCXkYlYhVSNAE72TbSE82SjYmjhNuEtyWSbtnFUY
         6mCOCbzvqaphL4LCcqnBefPZsN1tIFeEbcOmz4CwUtNZ78kiroY3LaClzgR6SVCZkC6R
         HydIrp8nRoh93qY7wU6SSrbs8lzECoGqjOfDfyMsyAuSFPFBmYksxNkIwtWnpb5l+mHn
         GhOw==
X-Forwarded-Encrypted: i=1; AJvYcCVbRW0doTcw72WWoz9SM0XxdQm4MYq5LRnOsc0XiVmeBKAr52RhsARJ2HgwliU+CQI+P2e0pLvmHSQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yywl+IrXxElnOH2sj9DKgr1F1ey5KfKaHCFlEETc+/EYkdP/D6U
	DEi86hMHdmWQk6IaBOwNzJPg1jgDJTXgz56VontV06Hcwi5CSVWd/JBVn0WucrEAN8WubI96xUS
	ZwgZeAv5UpdYzrNwqfW1zTMZa9kfTRP5nYn44Y5+E0eXaU/Vet84BktU3+32ytg==
X-Gm-Gg: ASbGncsx4LXX8aj7pj5X7CsV9xZbryFeFWNCR+9HiFa7CItT3Pn5psVgeJDzqdS5pyi
	f9SrjXXU4pAQTEmzbKUSzy3zNEPjG8yUc2bFOWXzgCQrPjE99SyyqLkLTVfG3eE+dYXdUgvq+OD
	2XrBe+085yf//AgVWpzposwzJgmQR5mOuVeMAghLeOfFx/eP2AEWrF6XKzdbeD52nY0kOtHYu77
	zGNAWRVJ+BCMBwnloG5yyvooFhR+MigiNMvukyD1PNC2xmAJLmAVrCRBFetrqh3CU8eDkBW/1Fy
	/D+ERxLSQU/ZdmL1kQQACVv6sIRbdp4bBmrfWtxNN1Sr/R9IdAsyRVEyeCmCO36kFxLE69E1vGv
	ULvHUY875GMB9LoJ/dM8h+YsCqKasgs19Ztj/Cf/OEEE8aeaxBQ==
X-Received: by 2002:a17:902:ebc4:b0:26d:d860:3dae with SMTP id d9443c01a7336-29d9f67d6ffmr90274645ad.3.1764956001403;
        Fri, 05 Dec 2025 09:33:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHXSAcxY7YjQ2lRI1nGPuunb+yTEFSA4OqkCp4H3r1VZMT2FFkora3jNK6GzgmAw9mg23K+8A==
X-Received: by 2002:a17:902:ebc4:b0:26d:d860:3dae with SMTP id d9443c01a7336-29d9f67d6ffmr90274365ad.3.1764956000922;
        Fri, 05 Dec 2025 09:33:20 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29daeaabfdcsm54033305ad.75.2025.12.05.09.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 09:33:20 -0800 (PST)
Date: Sat, 6 Dec 2025 01:33:15 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/158: _notrun when the file system can't be
 created
Message-ID: <20251205173315.y44ddyjknco4ji3z@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20251121071013.93927-1-hch@lst.de>
 <20251121071013.93927-4-hch@lst.de>
 <20251205073125.tddypzbg7lyrzwna@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20251205080811.GA21212@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205080811.GA21212@lst.de>

On Fri, Dec 05, 2025 at 09:08:11AM +0100, Christoph Hellwig wrote:
> On Fri, Dec 05, 2025 at 03:31:25PM +0800, Zorro Lang wrote:
> > > +_scratch_mkfs -m crc=1,inobtcount=0 || \
> > > +	_notrun "invalid feature combination" >> $seqres.full
> > 
> > Hi Christoph,
> > 
> > BTW, shouldn't we do ">> $seqres.full" behind the _scratch_mkfs, why does that
> > for _notrun?
> > 
> > Two patches of this patchset have been acked. As this patchset is a random fix,
> > so I'd like to merge those 2 "acked" patches at first, then you can re-send
> > the 3rd patch with other patches later. Is that good to you?
> 
> Please drop it.  I have some ideas to attack the whole set of issues with
> combining flags in a more systematic way, but I'll need some time to try
> and test them.

OK, thanks Christoph, I'll merge other 2 patches in next fstests release.

> 

