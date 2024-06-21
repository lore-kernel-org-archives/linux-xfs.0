Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A886D15D5CD
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 15:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718985081; cv=none; b=fhg0IA8o+46YSQ2bY+RacvAZ5WnnZ+LjCAbUIXWF6KfUe95oqkLH+KYOMERYRx2s/aBxgybAKAKIPIbSeMEDd35uJO6bUG0/T/ZXTHvlmawtnYmsBnlXXbd1UJ5162cWc0lX6AQ5G/L2zcm0Hea4bX7Zi9/yJ3IvvGtk8349kwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718985081; c=relaxed/simple;
	bh=Q4JeixHt095+wHwE6exyIhpYWKk1DKaTAnNiLr2llZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l+LiWZZZcq786KdErXWcKe+7gtnJmX4X+OzglN1qKWWXWXLooxQvt5QExqKEX2xMAAi191xKlptCXYMO0ndUD+zWPdblLqL/uJjWfN5/wGq0N3GsTVu1cka34sc/a8v88ho7PQHpkXX1X8leA/g98Y4nZB2XSTvNXkqUTv7pPC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fzUDwFhy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fzUDwFhy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718985078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9aJsinrpnEoi0dQhdnv8mnMovyrI1s2WrKlR7ZpEdJE=;
	b=fzUDwFhylVHflaer3QIhS31/6ODRDWNHxQ6j2z5pFkf6coh5z1kRZ51Hg44yos8KX4TiMq
	zl193uOXLRvYbdSxVxGnQP6DPRAvXsiNQfr++8kVuoLvlPEs3Fyi1THu2yeiVOasxBlZtN
	qUlnDm6bxLeHqc0dpd2+/wlW22J39O8=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-PY1nWJeLMhuplu3j1bIDCw-1; Fri, 21 Jun 2024 11:51:15 -0400
X-MC-Unique: PY1nWJeLMhuplu3j1bIDCw-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-705bebaac2cso2051124b3a.3
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 08:51:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718985074; x=1719589874;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9aJsinrpnEoi0dQhdnv8mnMovyrI1s2WrKlR7ZpEdJE=;
        b=hVsENJ1jjtgmhIH6RNZtPVzSm3OAC3/IO1XSeVh1kP0lBqlkH/Tkb++VC8MiUzxXhK
         NeXXYqEYM/cariFRduFYMgTh+3jV6ykT5s2tB9/jBEcUMmDlfzexDMNo73Gyx5SNlJ7a
         Xjlg9m09mqkgaMDpeLFalvJHLtxvV/PnK4pwTk1o4Sg5CXM8yUotAvpsoNnjQdX2jp/2
         crU7znGl/wzT/oLxMGfuh1XWScUt0seDXGn2sEcQ9qhUYc+xZcZosEW2dDrKJEQCHsdq
         tc27sa9mDL7/o2qqyyadBUGcwKwEVyTN0KB8ozGb16JLUUnf27EfegTCURLX0NONbNy8
         79/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVh9IYZez73KARwD1tamikQuODA+vd76s7i1bxEb9GKWlJSWGPyzZtHYWYvQtge+KyLmMSS1ARErNseL873AQhSqOI5MG6MnsVd
X-Gm-Message-State: AOJu0YzzPbRdxh8JoHYWLgdpMcDCALK+ibwH+wB+yfpsNIX2/QB8z2zK
	jHGTOdYiyiuhVLEehGKghBtinAEX8Jam6abbFWhEopvA+K5J5AkGjlbvVdlj3vf9tTrbvbX7d5F
	wBunezl5v+ZEV19FEevvSghnH7FmWZpr6pKM1ekLG77iL3/AOWokNsfy44w==
X-Received: by 2002:aa7:80cb:0:b0:705:b922:280c with SMTP id d2e1a72fcca58-7062c0d8a6dmr8706769b3a.18.1718985073603;
        Fri, 21 Jun 2024 08:51:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGLPAgqnXqB16whRL57ynbbybQgiy2QW4UGSNGoba344QeMOOBsJkjsH946c2CHWnsyoILDIQ==
X-Received: by 2002:aa7:80cb:0:b0:705:b922:280c with SMTP id d2e1a72fcca58-7062c0d8a6dmr8706731b3a.18.1718985073046;
        Fri, 21 Jun 2024 08:51:13 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7065130078dsm1554019b3a.204.2024.06.21.08.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 08:51:12 -0700 (PDT)
Date: Fri, 21 Jun 2024 23:51:09 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, zlang@kernel.org,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs/073: avoid large recurise diff
Message-ID: <20240621155109.6ckzs7mfzgsej442@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240620124844.558637-1-hch@lst.de>
 <20240620152306.GV103034@frogsfrogsfrogs>
 <20240621050416.GA15463@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240621050416.GA15463@lst.de>

On Fri, Jun 21, 2024 at 07:04:16AM +0200, Christoph Hellwig wrote:
> Looking at the reply I noticed I misspelled recursive in the subject,
> so maybe this can get fixed up when applying the patch?

Sure, I've noticed that and have changed it in my local branch :)

Thanks,
Zorro

> 
> 

