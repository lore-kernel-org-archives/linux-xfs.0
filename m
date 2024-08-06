Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF9D1C4606
	for <linux-xfs@vger.kernel.org>; Tue,  6 Aug 2024 13:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722950381; cv=none; b=n9b7AelTHk34OLxyE9En4SWzHQHaXiYM7Qiw+J1oUNxydvTTbu6KtDFi95rC7afpy8YzB95YH/VANhnyQ3GcWJBbg6CtL9UvGXSfTDiyYjXNuxEwSDnKpEmYIRvsa6lwcZ2MIzlWv8Hozrokub08By0RdZphvkeWsz2rHlF2U/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722950381; c=relaxed/simple;
	bh=2YFegVZ7DeX8QMMK9t9WVGrcnQljBFZZUgoJsTL1ZTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mL0++AsY1Avuw9ZAdQaVLGy7nB/FTFuo/nn/ZP6Fm2XELl43tmOcZzDIwwzjoIGXIWUoMpkNstBg1eLi/bTbnupec4BZF3GDlz63+L2Z+kzvOGWfYcD7EBJZ3xSjQS2PYakwn2bwNGy7qqL8zsUyEFX4NV9mIlhmdQaEOtCaKgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dbzsDgBo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dbzsDgBo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722950379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cixuuGbkMA6yaMpI6jjVrU5LyqvaYsgiRl1qhjQ30oU=;
	b=dbzsDgBoaI5KxJTzxAtmGQJLMtTd9dkCFtAQem75yC211RinVrA8BBKslX8OLSv2hmqRaV
	YkF7dZswhSj8MdJtx1c1T0ZNUH+aeCuIa0GqRE5aC83UAu17RjVvSp27Y+TQEjxQuxCJqP
	GipKPWqiuVZdw3FI/ggpK942YpmN9QI=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-345-mU_QzgQXNzq3mk_dzjHziQ-1; Tue, 06 Aug 2024 09:19:09 -0400
X-MC-Unique: mU_QzgQXNzq3mk_dzjHziQ-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1fc5acc1b96so6241395ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 06 Aug 2024 06:19:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722950348; x=1723555148;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cixuuGbkMA6yaMpI6jjVrU5LyqvaYsgiRl1qhjQ30oU=;
        b=CQAoKWJQIecnW/Wj9LNHxqg3Erg7X2wOlHfErWR2Z2whNcjMpsUFnat0P/Y8PL31MJ
         iFO2gZYHe4eIU59BIiHFfzdxo9nlWhxnDczdhz5jtPovmIsWFCcA4vn+nmpUl9pwsNeN
         /0BYjEbiiAEtB6yqVgTO3nXO7rh/g6fWbkqsKFQiNBO5LhIvJ9p55OUZ9vC6dTWvbpsY
         6Ez4vBgnxYSpW65Nb6e8G6wCwg++0Of1mNB8UTM5W5cr0wrxyNbPtSFyjVpTs9qJKbW7
         cjvuGKDlQIyMI8UtP59nlkaqqbaxYhp7cwFl8p88N9YltP5ISfkZyTDulr6rWXogrJft
         eh/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWsIFEmwwDZ9cjOHcV/ojutxvx7RuzrpT4ANvqJvfHdiHF7Y1433xKuB/i7k95sxtiimGCWN9o0oahBI6NN12bui2qKKl3yne34
X-Gm-Message-State: AOJu0YyV8Y7mCU40hHlcVYEMxMa4PjVUosRdteF1FTrYd2bkG5llo6tp
	Pc7mabw6AB+PEq/CBmolT9enapeP4WcP6lGxdU76BWVUsPwPMQTSDzOBwwaWCzhUuniibP3kFc4
	zpkMsmJF85a0TMkyo7HMTEvenYxV1JSO1ZjpXhqz1/2xukEfzvlx8NWRECQ==
X-Received: by 2002:a17:903:22c6:b0:1fa:b7ea:9f0f with SMTP id d9443c01a7336-1ff5722de89mr204600105ad.7.1722950348721;
        Tue, 06 Aug 2024 06:19:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFR515oIevwUJCV9tQOjwme0syulKNxuN4y6MiirE7B/BeskCAk8KLGTo9dg3FzdFiCZMxoag==
X-Received: by 2002:a17:903:22c6:b0:1fa:b7ea:9f0f with SMTP id d9443c01a7336-1ff5722de89mr204599795ad.7.1722950348329;
        Tue, 06 Aug 2024 06:19:08 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cffaf6a6d0sm9082996a91.6.2024.08.06.06.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Aug 2024 06:19:07 -0700 (PDT)
Date: Tue, 6 Aug 2024 21:19:03 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Ma Xinjian <maxj.fnst@fujitsu.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [PATCH] xfs/348: add _fixed_by tag
Message-ID: <20240806131903.h7ym2ktrzqjcqlzj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240730075653.3473323-1-maxj.fnst@fujitsu.com>
 <20240730144751.GB6337@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240730144751.GB6337@frogsfrogsfrogs>

On Tue, Jul 30, 2024 at 07:47:51AM -0700, Darrick J. Wong wrote:
> On Tue, Jul 30, 2024 at 03:56:53PM +0800, Ma Xinjian wrote:
> > This test requires a kernel patch since 3bf963a6c6 ("xfs/348: partially revert
> > dbcc549317"), so note that in the test.
> > 
> > Signed-off-by: Ma Xinjian <maxj.fnst@fujitsu.com>
> > ---
> >  tests/xfs/348 | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/tests/xfs/348 b/tests/xfs/348
> > index 3502605c..e4bc1328 100755
> > --- a/tests/xfs/348
> > +++ b/tests/xfs/348
> > @@ -12,6 +12,9 @@
> >  . ./common/preamble
> >  _begin_fstest auto quick fuzzers repair
> >  
> > +_fixed_by_git_commit kernel 38de567906d95 \
> > +	"xfs: allow symlinks with short remote targets"
> 
> Considering that 38de567906d95 is itself a fix for 1eb70f54c445f, do we
> want a _broken_by_git_commit to warn people not to apply 1eb70 without
> also applying 38de5?

We already have _wants_xxxx_commit and _fixed_by_xxxx_commit, for now, I
don't think we need a new one. Maybe:

  _fixed_by_kernel_commit 38de567906d95 ..............
  _wants_kernel_commit 1eb70f54c445f .............

make sense? And use some comments to explain why 1eb70 is wanted?

Thanks,
Zorro

> 
> --D
> 
> > +
> >  # Import common functions.
> >  . ./common/filter
> >  . ./common/repair
> > -- 
> > 2.42.0
> > 
> > 
> 

