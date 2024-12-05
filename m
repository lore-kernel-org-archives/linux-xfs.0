Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139CD1CD2B
	for <linux-xfs@vger.kernel.org>; Thu,  5 Dec 2024 16:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733414971; cv=none; b=BotikkcCGqONu0gjr3dKb0ieKszvauysXTpeaKbqNbR07WfGdq04+9YE04J/3oXlB4xLXBF0RnWPuEbbOXCKTeFZi4RPmy8oAgcb7JEPnGYrC80sI5AjQcSrAlurS0nFcb2hQWAw+q9/nTjnXxTH2kB9qFmWd+s6me6oHu7IDKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733414971; c=relaxed/simple;
	bh=nM6g6wJecpGHtNi8nX7hFuSeXLXDPeW7NvHPaP6i07w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hqWhx7IYRznfMa+yANG0FjLNjfVtJowoY1TSAQcny9WcVELIQCfr/f5fCkxsefkZI5uu6OPGpkTSyWI3NuvtSxJ8vTUedrz6vdZriJvJEtEE/dbBbsLGKO3yVSuDsspkVqoCNvINoObih83CRfS9mp5XK3fH2Vv9B7zCwHl4SX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jL1P4BIT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jL1P4BIT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733414969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jkagOK3j1f2NQix4odZgTybgDSUIcdsqFxB2+UfE0B8=;
	b=jL1P4BITxXr8MLYuI3Us8DHGs9DXBSL/GTE9M0VdShOdmNJLHA46ogSGKVK3o6nwzrjVm5
	Rdox87BTbhx4iXxES4EYgwg3YtNmxrDlmrGNnwr4TKl8uyMhRM1tx3t8XcitTI28/e4p3P
	RzqGN64D6rd/BHnL/6qfKHBEs4unOlw=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-yuwU_-Y6P12duEKk5NoXow-1; Thu, 05 Dec 2024 11:09:27 -0500
X-MC-Unique: yuwU_-Y6P12duEKk5NoXow-1
X-Mimecast-MFC-AGG-ID: yuwU_-Y6P12duEKk5NoXow
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2ee8ced572eso1304589a91.0
        for <linux-xfs@vger.kernel.org>; Thu, 05 Dec 2024 08:09:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733414966; x=1734019766;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jkagOK3j1f2NQix4odZgTybgDSUIcdsqFxB2+UfE0B8=;
        b=lz6AJC1iDFQIdG1zO9kGlZpmN9SQBQmSum7jomeEaG7p4Bi6jSJIk1kofHQJZOu+vu
         iA4e1ETXpm6YguADqSd5qgW2Egt45RqFBFSCQUZcBUwCrijyurA296xnhVh9DwVILM/O
         Mohg7im2wabc1DPnaF1SmnG1rZdY7ibHKFfiClJzAaaOHNCcw3dmSoSTDQKPZbdFV4iI
         PbYDwXBbMXRLsUC8S8NiObDr5Ovd7l1iY8dhiipNAHF+aFQl6R72rdRLUUedlUrEkr/T
         MOXG8Ce+Toij1qbXtqW5aLRFNGfJTluBFITI4WtC7iSZE4sjqaBZGPGdRb5KTOfB9nhJ
         sPuA==
X-Gm-Message-State: AOJu0YxLGAuJihQANVpkxlux1fHVUApWrbITG3Cs9fL3RngBcBLw08TD
	FJs4/+ZGT2rSlbMFS2hC9YyBETLNY7tUDj3xNARGCPNIBApwHGeCenX88dgi+HBmQpf8HagTrix
	s6jzJW0vh/GT5mzmFYgU3ebbYdzQnEb43Nlx3t1o22rIXWHxSHXcPERIA4K3jfGcTyu2O
X-Gm-Gg: ASbGnculIZnjqw9zqRkAcoy6hJrEgekAuZ3ic+zV9eLiBz0IvZlibK0p9QCZP9Sq/zv
	uQbTXy/8PmE9+Qf8QCosQRW39oINjybcWfkSBHw+kAAvrIhv9xjlyZ7qCRCtUYfK+HwermUDKnk
	5XeNM/Ub1nxpPxxkrVqDyQ10zpyMN6A8l5OzQGvvI7/vcKuz/QvdMoKUNFoVcrThm+WqnV/nZ6A
	F0Lpuc2L+Yh7h70I3S91novBzciu2THdhxYroxXSfIKYO1LBHK7l/vSI8YQXqpfgflq2nF9duT7
	Fc0Go43FfjCRrFM=
X-Received: by 2002:a17:90b:390e:b0:2ee:c4f2:a77d with SMTP id 98e67ed59e1d1-2ef0121557emr13136171a91.21.1733414966370;
        Thu, 05 Dec 2024 08:09:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IErNma+B/Pq/aUy5AgYwZ86nNECP6nHkJqArJaIUhxoTY+xBsGFw6lIuAXKVxShfLq/9sGHJg==
X-Received: by 2002:a17:90b:390e:b0:2ee:c4f2:a77d with SMTP id 98e67ed59e1d1-2ef0121557emr13136127a91.21.1733414965901;
        Thu, 05 Dec 2024 08:09:25 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-725a2ca6747sm1460887b3a.149.2024.12.05.08.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2024 08:09:25 -0800 (PST)
Date: Fri, 6 Dec 2024 00:09:22 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: 64k blocksize xfs can't be mounted
Message-ID: <20241205160922.psn4htlpthfhyjb6@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20241205152920.ptesvhhxvq2tcxif@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241205154015.GM7837@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241205154015.GM7837@frogsfrogsfrogs>

On Thu, Dec 05, 2024 at 07:40:15AM -0800, Darrick J. Wong wrote:
> On Thu, Dec 05, 2024 at 11:29:20PM +0800, Zorro Lang wrote:
> > Hi,
> > 
> > Recently all my 64k blocksize xfs tests fail [1] on latest mainline
> > linux (HEAD=feffde684ac29a3b7aec82d2df850fbdbdee55e4) with
> > latest xfsprogs (for-next branch, HEAD=409477af). Do I miss something?
> 
> Most probably this:
> https://lore.kernel.org/linux-xfs/Z0l5OezlOv7QGCeT@infradead.org/T/#m0e8676370031255c7b198565d34ae597cef908bc

Great! Thanks for your quick response. This regression cause LBS test fail, I'll
skip LBS test temporarily.

Thanks,
Zorro

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > [1]
> > # mkfs.xfs -f -b size=65536 /dev/nvme0n1p5
> > meta-data=/dev/nvme0n1p5         isize=512    agcount=4, agsize=61440 blks
> >          =                       sectsz=512   attr=2, projid32bit=1
> >          =                       crc=1        finobt=1, sparse=1, rmapbt=1
> >          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
> >          =                       exchange=0  
> > data     =                       bsize=65536  blocks=245760, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=65536  ascii-ci=0, ftype=1, parent=0
> > log      =internal log           bsize=65536  blocks=32608, version=2
> >          =                       sectsz=512   sunit=0 blks, lazy-count=1
> > realtime =none                   extsz=65536  blocks=0, rtextents=0
> > Discarding blocks...Done.
> > 
> > # mount -t xfs /dev/nvme0n1p5 /mnt/test
> > mount: /mnt/xfstests/test: wrong fs type, bad option, bad superblock on /dev/nvme0n1p5, missing codepage or helper program, or other error.
> >        dmesg(1) may have more information after failed mount system call.
> > 
> > # dmesg
> > [  459.450856] XFS (nvme0n1p5): Sparse inode alignment (0) is invalid. 
> > [  459.458090] XFS (nvme0n1p5): SB validate failed with error -22. 
> > 
> > 
> 

