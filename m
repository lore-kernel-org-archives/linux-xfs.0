Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A1A18C018
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838627; cv=none; b=RQ+kjyQyTyfa98inYkzoMfTZqPLRMVBZ1Ar0Xmn/TjDYwYMYCZoEjIMZ/ev4Zqoz3tnJiXsabju+7sQJJlrxeKyUfaLbLiD1K5zWtvtORga1TxCgRa6qcCVIPlBVWzDpazrV3/5kWDVeBeKr065mTIoFahiyZGtR5cNBSnoUCD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838627; c=relaxed/simple;
	bh=nQq2QvaclSfntj/G9zIMNGgbmmuQSEhBX8jIqNGALoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uy5/bnbvEgMg75uDjSXHDxncStvS8ouBvU4TcaUE+XZmudBTYUugU5WVzVMkvpsIGbFc/3h4qjPs6ac/ezTyzC0iFNOgJjfQOnlFvfRI+gFy++h8Ok9nwfEhbr0HilExjMvRcIvieg7Y8Rv0Hyz8Ye7FMEkZROvoJWPWT3TM2dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=T45QlCYm; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="T45QlCYm"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-71e467c3996so1265692b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 24 Oct 2024 23:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1729838624; x=1730443424; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jaqpmns3LH1iP3YH6luYP6PQNY/LTYrSJAovgOC/eEk=;
        b=T45QlCYmaBQGgjGQ3piGOwpDgK7//DOg+cj7/LuEo5RxZ0ab5LKjO0BQAS44IdaAzx
         GhimqWZabgihOH8Lc+Ew6LdrQ5pUYf4TxVIjxGEiHAl8m+/I5hyVaOWpJ223NxUdg5lH
         rpKKD+hm0hreygnQIiVM/gSIWo2LHferEgDz7uSPPhWeNYz3qQzSfi3vcCiuJujRBXll
         60A6D6oGz4srutnPrjU5wR/7MMg9jBeKeTYxW+rVIvTwwQqicoBLbfi2sZXF5JpWJRwv
         INulYEyj+Q3c2zBuxwVpO+2M0lfYam/fdwsMMQsZ30DAlUZupgn7yL50BN/ByVOGes7f
         9xsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729838624; x=1730443424;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jaqpmns3LH1iP3YH6luYP6PQNY/LTYrSJAovgOC/eEk=;
        b=f2D7o9ugMhcQdx9Ru9v7rfarFjg4+I02UVB6szQ5V+aORei81NcAFYTtV8Es1GFF+V
         dEFjPvTKQ1QuUT8XwgBdGpq2lop/bAtbLTElx+5yqWFlcKsnMI4Ym3l4Vy0ylDoSzPS8
         HqWbkE8O8hR+zD9EngfR2xwT0Zu9Erohh9+KjedbTMbaSIJgJf3Ij4FuRUEgAy8MS5sR
         iXkISpMLNzojbzoGxvBqovz6dbk0MfqjLSf5ZFOiKiquvGOAsLtq6muhTpGNQnUp5uql
         Jp+XlmVqrQtPxMkViSAI+aHGHRCWsESG+yJ2sRS6NiebyZBJPGDXy71jWAPtN2JDMBOj
         Mn3A==
X-Gm-Message-State: AOJu0YxTV01sD0VVZgY3NY1tO3PuFjmDVC9CPHpiknTyQg4cYT1hfzNy
	bL5gov6N396xKLJCPO7wCZKPdNgZLn6cqWNCCFNroIGHdwO3jKb7vGXw6SsFUTNCCvCV+GokufT
	H
X-Google-Smtp-Source: AGHT+IHNu8pS94Z7Qn+a1xYy0vONTD7Sm0vnbWHZbaFkvFVcHskBL3jABX6OpMqiqhdyBsWCiSmHFw==
X-Received: by 2002:a05:6a00:1255:b0:71e:659:f2e7 with SMTP id d2e1a72fcca58-72045e456b6mr5895019b3a.8.1729838624273;
        Thu, 24 Oct 2024 23:43:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72057950457sm448551b3a.95.2024.10.24.23.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 23:43:43 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t4E2v-005TYZ-1H;
	Fri, 25 Oct 2024 17:43:41 +1100
Date: Fri, 25 Oct 2024 17:43:41 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: allow sparse inode records at the end of runt
 AGs
Message-ID: <Zxs+HQGuJziECU5i@dread.disaster.area>
References: <20241024025142.4082218-1-david@fromorbit.com>
 <20241024025142.4082218-3-david@fromorbit.com>
 <20241024170038.GJ21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024170038.GJ21853@frogsfrogsfrogs>

On Thu, Oct 24, 2024 at 10:00:38AM -0700, Darrick J. Wong wrote:
> On Thu, Oct 24, 2024 at 01:51:04PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Due to the failure to correctly limit sparse inode chunk allocation
> > in runt AGs, we now have many production filesystems with sparse
> > inode chunks allocated across the end of the runt AG. xfs_repair
> > or a growfs is needed to fix this situation, neither of which are
> > particularly appealing.
> > 
> > The on disk layout from the metadump shows AG 12 as a runt that is
> > 1031 blocks in length and the last inode chunk allocated on disk at
> > agino 8192.
> 
> Does this problem also happen on non-runt AGs?

No. The highest agbno an inode chunk can be allocated at in a full
size AG is aligned by rounding down from sb_agblocks.  Hence
sb_agblocks can be unaligned and nothing will go wrong. The problem
is purely that the runt AG being shorter than sb_agblocks and so
this highest agbno allocation guard is set beyond the end of the
AG...

> If the only free space
> that could be turned into a sparse cluster is unaligned space at the
> end of AG 0, would you still get the same corruption error?

It will only happen if AG 0 is a runt AG, and then the same error
would occur. We don't currently allow single AG filesystems, nor
when they are set up  do we create them as a runt - the are always
full size. So current single AG filesystems made by mkfs won't have
this problem.

That said, the proposed single AG cloud image filesystems that set
AG 0 up as a runt (i.e. dblocks smaller than sb_agblocks) to allow
the AG 0 size to grow along with the size of the filesystem could
definitely have this problem. i.e. sb_dblocks needs to be inode
chunk aligned in this sort of setup, or these filesystems need to
be restricted to fixed kernels....

-Dave.

-- 
Dave Chinner
david@fromorbit.com
