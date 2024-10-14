Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076D584E1C
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 17:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728928020; cv=none; b=EMmDo7s+Cw6I0KRvVsw7CkSilapzO4p7QarFhuANeDYFYgdrjTLV+13PjUsXPS0Gn50fGuWksD9KebdYQ1iUSCvnXZXxfnr3lDcDw0PJ2VSQ3hyXg26cAP7oYPH+yAntw/SlcE15ueFWXM7Yg+dCb/GCkDp4L41umuHuzZFo+iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728928020; c=relaxed/simple;
	bh=ZthASraa1ADKGzNj/1Zc6eRppKQ2ZkP9+p7QXAILArg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jSLOutkVgRm363zokxFgFy1Y2uDPPFLd9AdEKAeh1nNMhhQptSEk/SYOIDCpHQrDcp2fWLiB2xNpIJhkWroZZAO2MSR6QshYOKzlvg5/GCnS/XRgTXLtvM4RfodZosmexNLCAobDA5NbT1Q/6xsCxUAM/c/WpeSr8gfrRjLwCgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F/t5SeI9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F/t5SeI9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728928017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1ijiJwcv0mWysIzjr4tgmNyKcUe+hr0evOw7stcDpPs=;
	b=F/t5SeI9SkVsLW5ef8kOHrs/Eko5x/TVngf5GSkMyrmCn/VLzZzjkPuixE72rZ5bAR2pRV
	KTaCdiIiM9D6pI/ep747YTUNbmq7FcobnF6NyC6TLJDi+CGcuD+Uj5pDTle4sEBPdsu0Jr
	oI+gMGwc69LmJ8ztens49Y28pXMGovo=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-Sl2GvvpcMouZ06ydq56rDQ-1; Mon, 14 Oct 2024 13:46:56 -0400
X-MC-Unique: Sl2GvvpcMouZ06ydq56rDQ-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-7ea8baba4d5so1570401a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 10:46:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728928015; x=1729532815;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ijiJwcv0mWysIzjr4tgmNyKcUe+hr0evOw7stcDpPs=;
        b=cNls7EFBwWjLNqbVMtlvZHBA4Bl3VYAOyAlB4EjGoB4Zo3UMu3o/9GmzCOFTpG4d9N
         h11ULMMIqLtZfFkH8u0GBHnsVnrqT96ISDY7Y8ZU3XGKxB984IoVZrO7WqwtzSW2ASoQ
         A6giv1kt8yRBEsw2hpzbiQvxC3M4FptVnQW4dRGADoqvJInNfpFQOtYcGQ/sNeeCwvb5
         p+9MGB6e08LOh5g1OJ/3ltMwtCBnlCDFqRE3ZB3qid9NgCe8Y2ePOdV0ctPw5ubfQuMm
         84D1vbzTUsH3hHeOuYGuim4KnuL5Qs8zqF8bG1fI/127tAHJ/HWHMAFwq6CA3Iw87gM/
         qUVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUH8mGD59TdEiA2nSuH1NJyaX+ECvdE5Sr+8+1pgwWhJTeyowCtvx+OmX45Zx385/uc7xLMjhqOEfA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEkui6rjASzg7IMkaJl8+PSgx4u3ud6090/gAER8cwiXc/XA4O
	g1xVsSNX1PfrcGRAbgUO90d8FMDfScriXKKM/Gg9UFOd/m9cXaadOQOC/R2Dw/eggM7gyufg2gC
	PMaDV/35TbLVkisxKNOqm99k4BJ/rnlvMq7zBpunswsGPH/JNLSpb6hxx9w==
X-Received: by 2002:a05:6a21:9d83:b0:1d3:ed2:5375 with SMTP id adf61e73a8af0-1d8bcf3dc6cmr21600422637.27.1728928015606;
        Mon, 14 Oct 2024 10:46:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEBNZpeJZ+PYw+cAnrRjm0b0cH5WDr2GALcZhVqqVmcT4mQ191c1bUzGQ3XrVjdxOlOPeGuBg==
X-Received: by 2002:a05:6a21:9d83:b0:1d3:ed2:5375 with SMTP id adf61e73a8af0-1d8bcf3dc6cmr21600387637.27.1728928015222;
        Mon, 14 Oct 2024 10:46:55 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e6036e904sm3025844b3a.43.2024.10.14.10.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 10:46:54 -0700 (PDT)
Date: Tue, 15 Oct 2024 01:46:50 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: new EOF fragmentation tests
Message-ID: <20241014174650.wms62e3ogzilcnn5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240924084551.1802795-1-hch@lst.de>
 <20240924084551.1802795-2-hch@lst.de>
 <20241001145944.GE21840@frogsfrogsfrogs>
 <20241013174936.og4m2yopfh26ygwm@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241014060725.GA20751@lst.de>
 <20241014152428.GQ21840@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014152428.GQ21840@frogsfrogsfrogs>

On Mon, Oct 14, 2024 at 08:24:28AM -0700, Darrick J. Wong wrote:
> On Mon, Oct 14, 2024 at 08:07:25AM +0200, Christoph Hellwig wrote:
> > On Mon, Oct 14, 2024 at 01:49:36AM +0800, Zorro Lang wrote:
> > > Thanks for reworking this patch, it's been merged into fstests, named
> > > xfs/629~632. But now these 4 cases always fail on upstream xfs, e.g
> > > (diff output) [1][2][3][4]. Could you help to take a look at the
> > > failure which Darick metioned above too :)
> > 
> > What do you mean with upstream xfs?  Any kernel before the eofblocks
> > fixes will obviously fail.  Always_cow will also always fail and I'll
> > send a patch for that.  Any other configuration you've seen?
> 
> fsdax, any config with an extent size hint set, and any time
> sb_rextsize > 1 fsblock.

Even with dax=never, it's still reproducible. There's not any special config
about the extent size hint. The mkfs.xfs option is:
"-b size=4096 -m crc=1,finobt=1,rmapbt=0,reflink=0,inobtcount=1,bigtime=1"

The mkfs output is:
meta-data=/dev/pmem0             isize=512    agcount=4, agsize=655360 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=0    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=0  
data     =                       bsize=4096   blocks=2621440, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
log      =internal log           bsize=4096   blocks=300954, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

From the output we can see the sector size is 4096.
The mount option is "-o dax=always/inode/never", no more, without external
log device, no rtdev.

Thanks,
Zorro

> 
> --D
> 

