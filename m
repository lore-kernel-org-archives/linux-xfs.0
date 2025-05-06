Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9A32192EB
	for <linux-xfs@vger.kernel.org>; Tue,  6 May 2025 21:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567967; cv=none; b=KTkjURMvE54kYnZwz9EJ6eLer9KbQbOyykLr7/9rwxcU0/ysypxsdYOVspW0njswjSDTgmFNVV/M6PuG8nzC35aLHNSTRHO2hlzWM1UTDvqBb5A1GN5LPrOqKOe4zj1B3AL5fb5Ky3++zQZbFsvrXVc9POI+wN05KMD63jnMkps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567967; c=relaxed/simple;
	bh=KVW/T+gm+GPCNqz7HicdG6nlwrN2CY3RP+2Ja9Vvb/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IO40LA1wICqSLxaou0oBuWvLNbm4i9gxLOxqjyJwghV6i6yqz57ZCvr7ZqfaTuABdsuKrWKPXbaQ0I36osAIa+b4kEBYXlDH9VL+vpjfTUvj40dXz4HYT8ym3KfqZzAT7Yvq7ePawA6qqyPODcpde66SbXLX4G8oDwPepAuM05s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=w/x83CS0; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="w/x83CS0"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-74068f95d9fso3254235b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 06 May 2025 14:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1746567964; x=1747172764; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yMIauxUIuW+HoqF685ItcdozcY2TEvm8DOxp+4JrKME=;
        b=w/x83CS0Vm6SW5XiyQoTWIfcfp2zGwj+A1VC5vGVkmnSqrhqtjxK1qxRSXpjzlPyZn
         J57Yc7bL2CLevK1I/TVY3SvjlmREoQ0aRSIKPDDw+uaeq9UGGM4cSQtyBJ0X9sPR9PAW
         aAQRtr+9rsjJyGzmJTF+Ehddm8pT93CLk6IVKPfVraeGNG8ucAV+FjA2vGouYRFkcICL
         AlsXlxMVUURV8q1IqAwavWRaK+eZvTvDYiIiMicKQQ4n/7pMG2XbtRI+7QFOK0ZwiQhA
         iPjVHc8TbbtSvzltvFATfYyKJvg+iQXVTXcGz/Gdy9pBGQpSbkhob7+aXmSbc6OVyU32
         1A1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746567964; x=1747172764;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yMIauxUIuW+HoqF685ItcdozcY2TEvm8DOxp+4JrKME=;
        b=EigTchduP9D1dkcCnE/yshSWTHdBodi7mNWx7TUUsyyKQsHZ5+2YJnHhxmmeDtKxpf
         7ROnd5TBHOeFNGvc1Uy9lONUtVu04AELnUBm7M2xT58pZAF6Pmg5AnUK3uYGvBI1WtVv
         ltqxVsfL1dR74EFu2T9bcYWrk8YUOvkYa4yDpYx05YX7iWpX4R4bbeRfKLeAUKL+/i4B
         lnaJjaUOiuXakN1nawE/RDxjdOeKQbOBpXB3sTL+Bj62kU2pFtMKZngRsAwEjCJN9mCu
         aYhEJmsqfv94fYnhaqmTxhi7C2+XZs6g8SVm2vouTx8T+Z/F8CayzCduL3eagO8ZGw0f
         aZKg==
X-Forwarded-Encrypted: i=1; AJvYcCU2ARkEmpqtyKtO4t3FnnVxtR5mPyTOZi7jABF9b9IlKnpZajWp4eYBD1zhOy7aojMT9OqrDpwbuhY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx29GFXMb1v9/BFNrdBglnrWZ91x1coG40UH0cfE4mInhbiQsD
	zvgnRlYej3frYazdcyzBEw1NdIBPrs7dqfutQwq5gK6vWpgkXOmG1whni+aqtdXAqTYF/aXZqWY
	n
X-Gm-Gg: ASbGncsYbRar37OiFjGOwLg2UIp/5LZfmrVbOb/SOtPE5Pzki+BSBnmTXaAk2Bxapnt
	B/ZanBFmoBvChIiJ7wWZ+cdCQhLPwf08X8ASi3lMUq/J3J+FDwhffrm/WQ/8dGZWpla2Y0UN9Ab
	QgACBv3ec5JmrK6mmDc3GhCaOgf1/whvzXA2e7qv8BgudVMOigs8zLoK+66o5/6zH9yHed09rzL
	EUikKjUbmK+KpWdXxfDACdoITDalQOcYMcpj6aX/vyV2gkCw8fUAuurte9WC9kecfsbyQtSDqO1
	c20nwIrbuCkBDriqGZ13ZDW+Hz56IG94vfdk+l117tO772WN2ma7X4eP2fJf1l/RlUxguBGGXR7
	c+srrC8JRXsNALA==
X-Google-Smtp-Source: AGHT+IEDv1UiP/xCxZrA1w8m+KQBBlf4+RMLlDiU6bPNRxHPNwXX75ish2am3Kh1zQ+4fNgAJNLx6A==
X-Received: by 2002:a05:6a20:9e49:b0:203:becd:f98c with SMTP id adf61e73a8af0-2148bc12e8cmr1101048637.13.1746567964591;
        Tue, 06 May 2025 14:46:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590a463fsm9917368b3a.173.2025.05.06.14.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 14:46:04 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uCQ6z-00000000GTQ-0jbm;
	Wed, 07 May 2025 07:46:01 +1000
Date: Wed, 7 May 2025 07:46:01 +1000
From: Dave Chinner <david@fromorbit.com>
To: Anton Gavriliuk <antosha20xx@gmail.com>
Cc: Laurence Oberman <loberman@redhat.com>, linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: Sequential read from NVMe/XFS twice slower on Fedora 42 than on
 Rocky 9.5
Message-ID: <aBqDGY1i3RePyzaB@dread.disaster.area>
References: <CAAiJnjoo0--yp47UKZhbu8sNSZN6DZ-QzmZBMmtr1oC=fOOgAQ@mail.gmail.com>
 <aBaVsli2AKbIa4We@dread.disaster.area>
 <CAAiJnjor+=Zn62n09f-aJw2amX2wxQOb-2TB3rea9wDCU7ONoA@mail.gmail.com>
 <aBfhDQ6lAPmn81j0@dread.disaster.area>
 <7c33f38a52ccff8b94f20c0714b60b61b061ad58.camel@redhat.com>
 <a1f322ab801e7f7037951578d289c5d18c6adc4d.camel@redhat.com>
 <aBlCDTm-grqM4WtY@dread.disaster.area>
 <CAAiJnjo87CEeFrkHbXtQM-=+K9M8uEpythLthWTwM_-i4HMA_Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAiJnjo87CEeFrkHbXtQM-=+K9M8uEpythLthWTwM_-i4HMA_Q@mail.gmail.com>

On Tue, May 06, 2025 at 02:03:37PM +0300, Anton Gavriliuk wrote:
> > So is this MD chunk size related? i.e. what is the chunk size
> > the MD device? Is it smaller than the IO size (256kB) or larger?
> > Does the regression go away if the chunk size matches the IO size,
> > or if the IO size vs chunk size relationship is reversed?
> 
> According to the output below, the chunk size is 512K,

Ok.

`iostat -dxm 5` output during the fio run on both kernels will give
us some indication of the differences in IO patterns, queue depths,
etc.

Silly question: if you use DM to create the same RAID 0 array
with a dm table such as:

0 75011629056 striped 12 1024 /dev/nvme7n1 0 /dev/nvme0n1 0 ....  /dev/nvme12n1 0

to create a similar 38TB raid 0 array, do you see the same perf
degradation?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
