Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DE636AAE4
	for <linux-xfs@vger.kernel.org>; Mon,  5 May 2025 22:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485781; cv=none; b=Lrt88nlUMEso6GYrMCo9qeHdcuZcvVYwcp1qLcHCQm2R9yjlVsrCv14sX+qXSvPb79cz9sgVsfg+s+YZqk2Z1uURB3o/u5fU2tR5/m+xl+ZHUSqwl8+5I2yDhmIdPTvtMOMNUuIJinuEr1ojIadawRv432VZ6wEdGd2RS/zWtPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485781; c=relaxed/simple;
	bh=wHRy5AQPRQxiU54IBvGuKaPKDlgm5NQZxV6K6w1Qve0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I2Me5uWGMugXw5sSFfRbuefWONWIujVW9mjPfiJkslNnS/DNCkAZl+jTOfj0yEXg4cnPwChuUyL92flCRtgRsLnt9yu0IKCZi+EF19Ix5R58YBd9d0jW6g50Zkx0WISPsE1DE1Y2FiNwOVP2pvxXZPKyaCGyxysm8EAq5iFCLK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=sFlCGbSi; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="sFlCGbSi"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-736b98acaadso4755256b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 05 May 2025 15:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1746485777; x=1747090577; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TZtudP8whc5JWyiBQCvGvrdC2CkTXwDmcdreRv5eyPQ=;
        b=sFlCGbSihnoYn+Kn6Ve0Gh8tuPRq1NcVQO2MQUIv+qmjUC3NmvPzE7viNKog5tDLZ+
         ef+tNdSxOUt4ulpPQlh06Vgvll1qBPPgxa2WhC9W5hNViNNwfPfcaduA3iOUtuncKOMA
         M1fNiPLON5L5Xsje0BSrNVkykZyTVwl3CK8bEB/TEXykNXuECeJG5EgoK84jlorpYPNP
         STpGGXncQR5ljQ0Vx7J26PvhGYGDWrU74vUTcVPyaqyVE9lO5Z3ZcmdBnnpuqPx/0JEU
         3Zh4NjfBW87ron4uEOvysJuKRHDq79F21+0eExMuABzRsIED8r89PtVmd+pkrkuFupwP
         I6fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746485777; x=1747090577;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TZtudP8whc5JWyiBQCvGvrdC2CkTXwDmcdreRv5eyPQ=;
        b=HJ4EekgMrNfiZYvjVfaEqtwy4ds5ER9gybkM2mOwAA3lfRo26dUEjyEmSVsEIb/qAn
         K27Q9KDziib4YWydYpikUDR8y8Zc88QhWQSviopHyl7ePsQTU6BZB54PZ1u7UXWlN4uo
         PfFvyVbbx1m/sXNcMlsx2eIti0chNPCywVnauk7gbXrz+YD3TMlYsFdTaUVy+k/AO2vc
         pRRtf4GRY8lYLP+zEHQq9EkGLsdl/CUUrnf15ShpbhzgR6c5P7Qu6+SLDOOoTKiKcMYe
         yFr5JmWcHxmn6IZJsZnHDvn1fQhvMZ2vSJsJ2MNlK2YtC7vScwK1oMQgfL8h/AXRWu2z
         sFQA==
X-Forwarded-Encrypted: i=1; AJvYcCWnv214RFQXaRJfTnhu5rVP1H8dS4wt4oKq9dTF7VcRMFBCDlnE4WR1exIlb8sJtuCu6Jy31t4ZyiM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgrvQa627gJcuJOa0IaI+OR9qSeCZqXTPkwKWkqu8wB1kj7IjV
	cv4Qlaw+PMYJxvxKEsj1zoFObimomtEZPiyiZRCrdhvql+PyJhjUPLqfHryzNA4=
X-Gm-Gg: ASbGncvREyIjgDHjV1F0a17y+UQAIWfXw2ZlMAOweaRh21qy8NtHF7zI4uvtf2jWSPc
	41cKY1eOSuCXzOw5m14bETOvlYkQJhJDQ3vfQSwGxLSKpA2lMi1SFkwUcj3HzTWRed6n4KNdqTu
	4HtpajAicx3qm+r5vpqfx3m179HyJtks5HsfhwDk2gXmkBF8LbXQljLifR5tHE159beVSbrddZ/
	zUyJoCKVBsLYTstTIODKmhhPxVxfRwl7tXPebu5WKH+tuEbKqNg7GkDeembOTEJvvi/U9FyZgQv
	SSsQWmzz8xHRscND6qYqLhGyQKPARLIRjjdk7ThL8smHNf/l5Vtx37pswfDyYW8/tD5ZjIn6/NH
	DwJ4TLoOqjMBRUA==
X-Google-Smtp-Source: AGHT+IG0junclw7g29Tiqwx2VjZpghoTqY/gPZ70p9955vnBkCywMNmCzZAK8v7YO3Z5zsZcGqWWmQ==
X-Received: by 2002:a05:6a20:cf90:b0:1f5:64a4:aeac with SMTP id adf61e73a8af0-21182ec067cmr1039329637.33.1746485777257;
        Mon, 05 May 2025 15:56:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74058db9200sm7423761b3a.42.2025.05.05.15.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 15:56:16 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uC4jN-0000000HT0R-0Pro;
	Tue, 06 May 2025 08:56:13 +1000
Date: Tue, 6 May 2025 08:56:13 +1000
From: Dave Chinner <david@fromorbit.com>
To: Laurence Oberman <loberman@redhat.com>
Cc: Anton Gavriliuk <antosha20xx@gmail.com>, linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: Sequential read from NVMe/XFS twice slower on Fedora 42 than on
 Rocky 9.5
Message-ID: <aBlCDTm-grqM4WtY@dread.disaster.area>
References: <CAAiJnjoo0--yp47UKZhbu8sNSZN6DZ-QzmZBMmtr1oC=fOOgAQ@mail.gmail.com>
 <aBaVsli2AKbIa4We@dread.disaster.area>
 <CAAiJnjor+=Zn62n09f-aJw2amX2wxQOb-2TB3rea9wDCU7ONoA@mail.gmail.com>
 <aBfhDQ6lAPmn81j0@dread.disaster.area>
 <7c33f38a52ccff8b94f20c0714b60b61b061ad58.camel@redhat.com>
 <a1f322ab801e7f7037951578d289c5d18c6adc4d.camel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1f322ab801e7f7037951578d289c5d18c6adc4d.camel@redhat.com>

On Mon, May 05, 2025 at 09:21:19AM -0400, Laurence Oberman wrote:
> On Mon, 2025-05-05 at 08:29 -0400, Laurence Oberman wrote:
> > On Mon, 2025-05-05 at 07:50 +1000, Dave Chinner wrote:
> > > So the MD block device shows the same read performance as the
> > > filesystem on top of it. That means this is a regression at the MD
> > > device layer or in the block/driver layers below it. i.e. it is not
> > > an XFS of filesystem issue at all.
> > > 
> > > -Dave.
> > 
> > I have a lab setup, let me see if I can also reproduce and then trace
> > this to see where it is spending the time
> > 
> 
> 
> Not seeing 1/2 the bandwidth but also significantly slower on Fedora42
> kernel.
> I will trace it
> 
> 9.5 kernel - 5.14.0-503.40.1.el9_5.x86_64
> 
> Run status group 0 (all jobs):
>    READ: bw=14.7GiB/s (15.8GB/s), 14.7GiB/s-14.7GiB/s (15.8GB/s-
> 15.8GB/s), io=441GiB (473GB), run=30003-30003msec
> 
> Fedora42 kernel - 6.14.5-300.fc42.x86_64
> 
> Run status group 0 (all jobs):
>    READ: bw=10.4GiB/s (11.2GB/s), 10.4GiB/s-10.4GiB/s (11.2GB/s-
> 11.2GB/s), io=313GiB (336GB), run=30001-30001msec

So is this MD chunk size related? i.e. what is the chunk size
the MD device? Is it smaller than the IO size (256kB) or larger?
Does the regression go away if the chunk size matches the IO size,
or if the IO size vs chunk size relationship is reversed?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
