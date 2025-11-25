Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F3C32B9A6
	for <linux-xfs@vger.kernel.org>; Tue, 25 Nov 2025 19:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764100187; cv=none; b=a67jyYQHU5MPJXNLBDi5gsqrreqDjWt2h1ZGClxcojERokQsaKj8iohjAAOsr2jpMpu7EVOCAkYLf5mxMwevLall+iaNVVSJ3AhQmQYfsBpZuaQ9/HO4vhqIM6/0mYlFcGgDNfsKDL7SYNm/wSV2d+/LrlizsNo429agTwxn+wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764100187; c=relaxed/simple;
	bh=VMV9DcrzAHeJgG2FY3oCcj8JppK32PJcLKj8T8aN718=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uDi9M/aUFiXIS/eDUI4QJ6jlZDCxD8mLv0G6BxZ9n48fUNQMihYlhnKwcs4wREUL3UQ+vmSvB0FGN6jmUcIxCQ83mfnCJZaDoYRJ4zqDjdUO4/Fq4Lf1KffrFipfhxfCgXo7W1bEcyUBeVADAydfxiRxIo9OSyDoL99Yk8TBZ2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mW9KVjFx; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mW9KVjFx"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-42b3669ca3dso2370204f8f.0
        for <linux-xfs@vger.kernel.org>; Tue, 25 Nov 2025 11:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764100183; x=1764704983; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IHyC+1/WIQK/el22PWobBCCQXoISZK/BEV0TaUXhpAY=;
        b=mW9KVjFxjzQbig2+UfytugDt/eqI8klhRf5OdNXSzJtdLLtgrEyBQLs+YOpJLVecVo
         nO3hVQagdnEO0xXwYru7syMvhZOANMs9FEPu8DrS4vm8gf1zfKM9H3vrCQ1Gs3iV2e4z
         UrR1gmj3+k63YiLQND5boI+k47dmhPj+K2MEM4WbbNBfRoOBDlLssU+dqV1NlYR9DmLy
         4lj0PAg9fLTxWr2mhu00fwJAKnNJF5O0lpCngKBrHBysjhk7mZUSmOAB8M3d+/kAhCk6
         SvG94ZAnat/dl9PR0KwPYIX2+zbDzoeCxuyN2FPwNNDFZArhh6hXgWFaQyZPfpFfKUQw
         TRSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764100183; x=1764704983;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IHyC+1/WIQK/el22PWobBCCQXoISZK/BEV0TaUXhpAY=;
        b=tj5S4QfIN+d1GIB1zs5AZhga1+ZTo3XV6ss9Vw9vauCVZ+TZbHZbOHNKE63LbiKUhs
         ymvZSiTfA3g4EVdV0JZZO2a7mR19ZvsDZyCCALLgWuHCcyhy0maSRNgbS5arGa7bzste
         0RekNjwF4awCYD8PU9WCTzAsfMHtnzYoJrfp9bR9u+QOC2lpATMjYC74Uu/Edx4Q7dMP
         j5j/A0b8DxsXHtnUY09wGxZDjzd6vCn5SbIRFgHTy2q0YTwakX5tFvmSCXA/kKQYWATS
         VwX3lxbvswIPY9FgRh7alOnKwGW8DFoyWGZReN+QpdZxtHVLzQu4HB1kB9BCT8efqQp6
         rEpQ==
X-Gm-Message-State: AOJu0Yywmqtrq1S3umyQBDyzujIG+CyUN2ClSIrJgcF/Xphg49seSERp
	fX5b3qY5MrD+18Ypn36rtF/+KrF1lrpw7hUcCxyyyhUEmBPQA1XOEJng
X-Gm-Gg: ASbGnctfp6JSWYeQiIacRpkdHzn3yC6SJmp6XDdHXLmwC/als7iCDcKTBVFjVGQoT02
	dzWjj9HEVEuGlFQpr65VcwR3vgipMdpg5VCVtq7AIzqgZwhKHoMiCb6ruP/juwlsbSEus0sVYu9
	aBwNp3eIzYdNSztpDycaVqn6jMcr0pTd/nlMeu4B3O8joRSQPdQxqgmhidd1VHBzXNwK4Mwky3K
	QAakLrItPOZb3NmG1FraGlwJ5Q6fgzEftEJDsuwcWs8SgaFVqiW9HCPr4u6ohZEKySRBzvsoZdk
	95ZEOfo4xHCuMv1uYzD/KbqHuk01E/eWePog1NEkvHDF+Mfa87OwFRCeZV6uV2/V/QFiUm9rafK
	pAlxB+X0uUtDHSBwTtg1vIzZ864n/X5jzxh0HNWHgZc1n+QjiUgQeF9yA2J6pX84Qd28IQA6s5F
	331mY4BndB9CBfGp5/qOykpeyYl+apQR2l1NzswiE3BIdkBw==
X-Google-Smtp-Source: AGHT+IGIMvfKyaIUsXHMatvMux1T8em1l2Y3fYtajLlwfQiPAHORz/9MhcEmxcALk6l2Zb+nHL5m+g==
X-Received: by 2002:a05:6000:240b:b0:42b:3b8a:3090 with SMTP id ffacd0b85a97d-42cc1cbd456mr17583933f8f.23.1764100183293;
        Tue, 25 Nov 2025 11:49:43 -0800 (PST)
Received: from localhost (dhcp-91-156.inf.ed.ac.uk. [129.215.91.156])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fb919bsm35949025f8f.34.2025.11.25.11.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 11:49:42 -0800 (PST)
Date: Tue, 25 Nov 2025 19:49:42 +0000
From: Karim Manaouil <kmanaouil.dev@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Karim Manaouil <kmanaouil.dev@gmail.com>
Subject: Too many xfs-conv kworker threads
Message-ID: <20251125194942.iphwjfx2a4bw6i7g@wrangler>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

I have four NVMe SSDs on RAID0 with XFS and upstream Linux kernel 6.15
with commit id e5f0a698b34ed76002dc5cff3804a61c80233a7a. The setup can
achieve 25GB/s and more than 2M IOPS. The CPU is a dual socket 24-cores
AMD EPYC 9224.

I am running thpchallenge-fio from mmtests (its purpose is described
here [1]). It's a fio job that inefficiently writes a large number of 64K
files. On a system with 128GiB of RAM, it could create up to 100K files.
A typical fio config looks like this:

[global]
direct=0
ioengine=sync
blocksize=4096
invalidate=0
fallocate=none
create_on_open=1

[writer]
nrfiles=785988
filesize=65536
readwrite=write
numjobs=4
filename_format=$jobnum/workfile.$filenum

I noticed that, at some point, top reports around 42650 sleeping tasks,
example:

Tasks: 42651 total,   1 running, 42650 sleeping,   0 stopped,   0 zombie

This is a test machine from a fresh boot running vanilla Debian.

After checking, it turned out, it was a massive list of xfs-conv
kworkers. Something like this (truncated):

  58214 ?        I      0:00 [kworker/47:203-xfs-conv/md127]
  58215 ?        I      0:00 [kworker/47:204-xfs-conv/md127]
  58216 ?        I      0:00 [kworker/47:205-xfs-conv/md127]
  58217 ?        I      0:00 [kworker/47:206-xfs-conv/md127]
  58219 ?        I      0:00 [kworker/12:539-xfs-conv/md127]
  58220 ?        I      0:00 [kworker/12:540-xfs-conv/md127]
  58221 ?        I      0:00 [kworker/12:541-xfs-conv/md127]
  58222 ?        I      0:00 [kworker/12:542-xfs-conv/md127]
  58223 ?        I      0:00 [kworker/12:543-xfs-conv/md127]
  58224 ?        I      0:00 [kworker/12:544-xfs-conv/md127]
  58225 ?        I      0:00 [kworker/12:545-xfs-conv/md127]
  58227 ?        I      0:00 [kworker/38:155-xfs-conv/md127]
  58228 ?        I      0:00 [kworker/38:156-xfs-conv/md127]
  58230 ?        I      0:00 [kworker/38:158-xfs-conv/md127]
  58233 ?        I      0:00 [kworker/38:161-xfs-conv/md127]
  58235 ?        I      0:00 [kworker/8:537-xfs-conv/md127]
  58237 ?        I      0:00 [kworker/8:539-xfs-conv/md127]
  58238 ?        I      0:00 [kworker/8:540-xfs-conv/md127]
  58239 ?        I      0:00 [kworker/8:541-xfs-conv/md127]
  58240 ?        I      0:00 [kworker/8:542-xfs-conv/md127]
  58241 ?        I      0:00 [kworker/8:543-xfs-conv/md127]

It seems like the kernel is creating too many kworkers on each CPU.

I am not sure if this has any effect on performance, but potentially,
there is some scheduling overhead?!

Is this a healthy amount of kworkers? Is this even needed? Even if we
are trying to write to ~80k small files by four parallel threads?

[1] https://lwn.net/Articles/770235/
-- 
~karim
