Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6664320A0C
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 09:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771579749; cv=none; b=cvsQXrKnOBBlOU2cRHPNdkIAcKSGSd42Ca9D+Th6+PYrBDH+gcc39pW+HwEOa4NitLXlw10eB6NhFvMRSlsxyRELr0J7p0cXBMkT/VaIx+ARxYB14bPvdA2qaN3X9X3v57FOotw0FBw0Tjmxq6QPBxzPF/t0wxGSF0X7yNfILYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771579749; c=relaxed/simple;
	bh=VMTBZ2q1fGVoYGSyCRvcMqoocE6gyf2zzmG18jf+qEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p2X8pKxKpYvqOEzkfQYBY+wNkrKj0q6jT5z4U4B+XibYq3hepXIFw1LYt1HgPMR+mfdfM0R05RTmbGEjamMenTuUz8mJzjdn7WSuaWcDIBGWnKfbxxpQjs812daCZkwL19fL5eOd1BP8c/v6qWNxgnKHcL8pS+Z3hMuaKi6Q8VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KlTFmDB7; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KlTFmDB7"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48329eb96a7so10838095e9.3
        for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 01:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771579746; x=1772184546; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MKuFWwKHCyFD8XdrAqu0nelXgub1Q7mxMeJGT4NfFh0=;
        b=KlTFmDB7obw7FGej/1wrFPUp7yfGoMMm8Tko+4K2RYbb0tfFS2nFXqCteFeUowiCFu
         LlqJaB0WZyGFVSblO6wmblI914NWBoxezXQd23YDsk5PRbLxO7fXECeBIWl/SqyTNMhd
         JxQe5Ic4T1WzvthVvWzgn3o7T3oZTBkCf+V1DpHqopWyoBNR8iRNk5+GJ+Uj5BEmrGHz
         w4yYsigbAZEUX2wIyN56mydqIBNwV90irkfr+fOwfJ3tFfuDqB08HT+x0vF3psvGuWct
         De/dgNCeMd1N4lFfoCtC+8W156iQlDE32L3jVlsGfwoH3/6dgqyGnt6bbQNeogg3mxdw
         vvTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771579746; x=1772184546;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MKuFWwKHCyFD8XdrAqu0nelXgub1Q7mxMeJGT4NfFh0=;
        b=iD/xrnjV9ki9xiaCCWpW6UGL0s9zJiyBuHbIIfjsnVDpHQG1UhS2PuQZWZBaPTzq+4
         hU40g5J5qNkw+Kn7otb836UdD9/ewgifExIKBTzJuKRshg8/BUjbnKGiuy4q+WMSjo8A
         2QIdn+8A8rxxDz7o7FQtH0q11dt0UjBc4OAjyQuheatpSezIiR6ESiKTD78teUhqGgv5
         QmRflIGiDmIYZKK1jMX7wU9z/KxdMzLktEv/O/WHMsUrlfVh6y9roShlphXIja3SRfUu
         m5SvVpPmGFCFMhVubm6ipwvMCVnoAHDxygZsRe2uH8lufILTCpK7GDpGVEdg7nQNI2OK
         6LFg==
X-Forwarded-Encrypted: i=1; AJvYcCXeejpDGGbiXwGDvYe8bsc0CPIk/felJJLtJ3df830B5RvcGuvtTR29jv/gY+AAWPexmKZkGjk4j8U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmN5zXNvtqn5lz89kKMRJk+ey/c5k2ZgTWMk1VwrIAyAqig4v7
	w1Y2LkLovz+e0dLT2Re3/Rm1g/LU48UN9R2oeMEbA273k1prR0bjfGfv+fpnAfHC0mc=
X-Gm-Gg: AZuq6aK5fO3RC82fSd5Jepiej8WZZ4ahy4aT3ZEM1R0VOGaPLHcGva1e69C0lTrbyNc
	NGWqJgil+m5JZ+J/+kFtYomyOguJKd0OTGT4VLPq18EbUpl8gto2kxaisXVoVJ7uGl+uXK0ZMB+
	3zcJvqnEhWdfR/Gp4DSqVlRPVcPk0A12lVsgeb3ovPNqY/FbmCvB9eeJi4gIWRsxEY/20OdyP1Q
	R6KfyY6fQ6LW36Jt10gcydec+n/z86h7Y5OXPTWIrmg2tGI+ePfhLfVBMzXNf5GyWJSPmic1S1Y
	NYKH0IbwOBmzG87TCaq5pQ16LgSPCmoxrIIFy/xS1sb3Q38p5LPNRQ3lvTQMzSvnJqeB+0arB18
	C7gxtWAwvK9VPiA1mpwmtv/zS16NgvaxyYfqrat15y+xB2fypMt1rxJjcQwHg17i3J7KaLryaNQ
	9hxU7xui+YJPxQF/yrP/k0rIZEPG/BH58=
X-Received: by 2002:a05:600c:4744:b0:480:6852:8d94 with SMTP id 5b1f17b1804b1-4839e668216mr90509835e9.27.1771579745884;
        Fri, 20 Feb 2026 01:29:05 -0800 (PST)
Received: from localhost (109-81-84-7.rct.o2.cz. [109.81.84.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a316eb08sm66105105e9.0.2026.02.20.01.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 01:29:05 -0800 (PST)
Date: Fri, 20 Feb 2026 10:29:04 +0100
From: Michal Hocko <mhocko@suse.com>
To: Dave Chinner <dgc@kernel.org>
Cc: Marco Crivellari <marco.crivellari@suse.com>,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Anthony Iliopoulos <ailiopoulos@suse.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH] xfs: convert alloc_workqueue users to WQ_UNBOUND
Message-ID: <aZgpYJW-za1O30jG@tiehlicka>
References: <20260218165609.378983-1-marco.crivellari@suse.com>
 <aZZmVuY6C8PJMh_F@dread>
 <aZbV9tqatNGbKRqF@tiehlicka>
 <aZeNG4CcIGtmy5Fx@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZeNG4CcIGtmy5Fx@dread>

On Fri 20-02-26 09:22:19, Dave Chinner wrote:
> On Thu, Feb 19, 2026 at 10:20:54AM +0100, Michal Hocko wrote:
[...]
> > The usecase is that isolated workload needs to perform fs operations at
> > certain stages of the operation. Then it moves over to "do not disturb"
> > mode when it operates in the userspace and shouldn't be disrupted by the
> > kernel. We do observe that those workers trigger at later time and
> > disturb the workload when not appropriate.
> 
> Define "later time".

After workload transitions to the "do not disturb" operation. 

> Also, please explain how the XFS work gets queued to run on these
> isolated CPUs?  If there's nothing fs, storage or memory reclaim
> related running on the isolated CPU, then none of the XFS workqueues
> should ever trigger on those CPUs. 

I do not have full visibility in the workload (i.e. access to the code)
so we only rely on tracing data. We know that the workload operates on
the set of isolated cpus and each component is consuming a dedicated
CPU. We also do see (among others) XFS workers interfering. I am not
able to link exact syscalls to those worker items but we pressume those
are result of prior workload execution as not much else is running on
those CPUs.

> IOWs, if you are getting unexpected work triggers on isolated CPUs,
> then you need to first explain how those unexpected triggers are
> occurring. Once you can explain how the per-cpu workqueues are
> responsible for the unexpected behaviour rather than just being the
> visible symptom of something else going wrong (e.g. a scheduler or
> workqueue bug), then we can discussion changing the XFS code....

Understood.

Thanks!
-- 
Michal Hocko
SUSE Labs
