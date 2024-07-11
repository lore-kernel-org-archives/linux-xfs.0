Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C905215531B
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 22:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720736800; cv=none; b=MWogjh8WZkMX7rVYtmmOYK19gF0zfN3dFplZuR/+TbNYhKR3XReebIpKfoXSb6TJvEXMR2PjWQdA3zrIGuoCm4aO/54ZASkqyAHZmDfy0PJDxIePrKgck/4mKA0cwULM1aRlDadERZ39zB7Sw3zZ4SlJjL9pC/I3DDgssC57Tok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720736800; c=relaxed/simple;
	bh=ZNjJ99i29mWpXemb25I6kT7UoYapxyZAsBWwprarwoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mqtc9IJji2fo8h9VUQT7tKp3fpXlCAZ2rJSGzbQ4vPbjcQUgFLVCuNjiY7tp/X0H1HdT1aJAHpxn8owykudxSNRLPnECGJ8czAScLVk0lP3+j1Bc6ZX3aYbMnI4Cax0G1P5Qk3XwxPDJwx98gbLQ670b0gl/GZEtO+aT+Ru9580=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=M3KVSzNr; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="M3KVSzNr"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1fa2ea1c443so11592255ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 15:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1720736798; x=1721341598; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YsuiOBusLRDWI99QW9bV16tHkAO5K+vCBNIughlrrA0=;
        b=M3KVSzNrQhqJcOSMP1y9X+uduW3/30NBS2Z5vPduxfSuSJ8JcxfT1AK9UYt+pLZCRL
         KbQH+NB28qc1mDG2/wUmCfSovKQiarOZYjyfrE+dclukE5/8vlFEJUxVx5JeN09Gj1UJ
         UHnXL7sDMp7YSleLIpALCvZ67sM4slDAnj+eSfSkC+pUdBwx5zGVaocnSvSZQicAkrFr
         eRyZdSj9Pk9Z5syhQt0zP4nwzDeR3yUfJ9g0CZUpqNOSR4CJAespGlhq97jiqBsVXYUs
         NS5ftshjdzk6gw9TOniThaPyRZZ1giAGyX8N4OLAvA3jvICDjEb67TauYCHtremCfqWF
         0DtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720736798; x=1721341598;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YsuiOBusLRDWI99QW9bV16tHkAO5K+vCBNIughlrrA0=;
        b=wGYtMpyRCJnf7LJ0xuBKvBIUTv8YgoQNHOM6U1l7konmNFa+Mq7aTJEiewdEETA/HK
         XQ0QGGwQ29z2rPw2xoPADPFcg3n2FX42sfk6zozhU3Zh+3os+PCgE0r8wtjtkr6nvAvi
         JbBt7cU+e3GSTG2zm/6kMjvRP1Ejn0/wW7nVj+ByOY5yV02gAolSCXoKxbqEUNSuLIBw
         OkFN6+tzaI3QKyKvY0gpQwHUMPib0ZtJckirwJTUWFeH05ggnMrPD2GcPhCb2MMGqeq5
         rqf3l/bBJv7fueUtOQE7xlfcVyzIoezceqPA4KHVCqPTF4qEFpCZikisL6fgjC/oe2UX
         IY6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUlxYTYgK659aUeF9mo9zhE1/iBe2uz+md2Dh9fwXqasYc5FUKyVvT9VJ3vv/MmeKdhbWD7W73EuOZ1pyrIBMh1Y9KwOCVN0yFb
X-Gm-Message-State: AOJu0YwJOzSaGrzfKgaujzpDxyYUfSuQ4A2iUckGIzByWuUsl6AGed/9
	7UardEe6MD2PpL3PfUIsOfCsn6xf8PHKHVQcoNdGVtm4nxkZexWICC7uaXe/v/0=
X-Google-Smtp-Source: AGHT+IET6FaCTxzISPW5bh3OZAtCu3S0k+pjz/14SbMrLU6oTB1Hrgolgk4KCNDxcuTsNlwiOwlxCA==
X-Received: by 2002:a17:902:f541:b0:1fb:8864:e20 with SMTP id d9443c01a7336-1fbb6d03e33mr82007115ad.23.1720736798082;
        Thu, 11 Jul 2024 15:26:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fbb6ac5c9fsm55037955ad.231.2024.07.11.15.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jul 2024 15:26:37 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sS2FH-00CWOQ-0I;
	Fri, 12 Jul 2024 08:26:35 +1000
Date: Fri, 12 Jul 2024 08:26:35 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andre Noll <maan@tuebingen.mpg.de>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, linux-raid@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, it+linux-raid@molgen.mpg.de
Subject: Re: How to debug intermittent increasing md/inflight but no disk
 activity?
Message-ID: <ZpBcG1HPeahYqwDd@dread.disaster.area>
References: <4a706b9c-5c47-4e51-87fc-9a1c012d89ba@molgen.mpg.de>
 <Zo8VXAy5jTavSIO8@dread.disaster.area>
 <Zo_AoEPrCl0SfK1Z@tuebingen.mpg.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zo_AoEPrCl0SfK1Z@tuebingen.mpg.de>

On Thu, Jul 11, 2024 at 01:23:12PM +0200, Andre Noll wrote:
> On Thu, Jul 11, 09:12, Dave Chinner wrote
> 
> > > Of course it’s not reproducible, but any insight how to debug this next time
> > > is much welcomed.
> > 
> > Probably not a lot you can do short of reconfiguring your RAID6
> > storage devices to handle small IOs better. However, in general,
> > RAID6 /always sucks/ for small IOs, and the only way to fix this
> > problem is to use high performance SSDs to give you a massive excess
> > of write bandwidth to burn on write amplification....
> 
> FWIW, our approach to mitigate the write amplification suckage of large
> HDD-backed raid6 arrays for small I/Os is to set up a bcache device
> by combining such arrays with two small SSDs (configured as raid1).

Which is effectively the same sort of setup as having a NVRAM cache
in front of the RAID6 volume (i.e. hardware RAID controller).

That can work if the cache is large enough to soak up bursts of
small writes followed by enough idle time for the back end RAID6
device to do all it's RMW cycles to clean the cache.

However, if the cache fills up with small writes, then slowdowns and
IO latencies get even worse than if you are just using a plain RAID6
device. Think about a cache with several million cached random 4kB
writes, and how long that will take to flush to the RAID6 volume
that might only be able to do 100 IOPS.

It's not uncommon to see such setups stall for *hours* in situations
like this. We get stalls like this on hardware RAID reported to us
at least a couple of times a year. There's little we can do about it
because writeback caching mode is being used to boost burst
performance and there's not enough idle time between the bursts to
drain the cache. Yes, they could use write-through caching, but that
doesn't improve the performance of bursty workloads.

Hence deploying a fast cache in front of a very slow drive is not
exactly straight forward. Making it work reliably requires
awareness of workload IO patterns. Special attention needs to be
paid to the amount of idle time. If there isn't enough idle time,
the cache will eventually stall and it will take much longer to
recover than a stall on a plain RAID volume.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
