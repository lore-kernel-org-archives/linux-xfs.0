Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7502F43
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 00:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738716681; cv=none; b=KsLuJFtztPiC0IPN4L1k+rc1JyAyApXbHlyPMcHk9b2/vPJZr6wiSN56HMxoO2VSe2wedew83ym8OvWE6ys1NNMW5BxPQcPRNYhmTiOKR6IX8/2zeknD/xhocaXwlgixyHhEIfMxMUoNKWvVMxn8hcA5FQTEC9wQC6tcGZE5Opc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738716681; c=relaxed/simple;
	bh=/AtgtQ8IPhd7L68CwGyGLaeZIglXYsQBPfmdEkxGx6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YU+mfUImd6TKnjBBti5XmqDIdaSbPX8TsV3+evYkdfe0ZRaLxgXxJr04eFi70/NQGZdqpuAmAvOCVDHqh9NKOVSYY/idb+bC4PNnFgJuJEQ7AfjjoLnZRd+eQ8nF5vkaa/W6vtFeVYSrIWe8fufBFjrHWc57WlnnJQL6cmaHFGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=bvyKkb+j; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="bvyKkb+j"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-21ddab8800bso88621985ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 04 Feb 2025 16:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738716679; x=1739321479; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PAsnY+nlDO3nRpSeeGhgqs8qS4Uvut1OrISgkBK4P7o=;
        b=bvyKkb+jMwr3p3BLfsOljexGxg0V1BITZpPi6AY/EaNyn0QCo3San6aov5v/9FMvPj
         +2itRpV0k7dypWnm4Tqsik8ZB5HYpg+5HRBUceVzXvLyULhlF2RbDgtzH5hPpVUwPLmB
         WIrbcHqTM2e3vPkEnnv9pUC1YvynBdElI2llgxx2fs4iWGedRgt0AxcJ5gzDqDWt29PL
         VnwSzZLyC76WYGZDiwmbxdlEtdBiiNHr3CahiPuKCzUlq16d8Qov4kqIw2Nx3BWnN4Hz
         tBXa5OyWI6CX2uVcI99fGUrCYD1OuzMM8Rhhcs9JFhBh3QgHFF5gbHHW/i42r2GCVPa9
         ZB4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738716679; x=1739321479;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PAsnY+nlDO3nRpSeeGhgqs8qS4Uvut1OrISgkBK4P7o=;
        b=aRAmRts0wAkMoLIhl6eNnl7hoWvol/EZG4Av4i2TIwsu8mHH6u76hS7TdbPPfag5Ca
         u8YQQfS1dXZt2BgzsatSrn2ivVqvMT8/h8e/syQ7xPS3sRl47VLYTLXAJFRR0f+eUC/3
         16yyOn6K4kPYzvzGM1UzNag7IQQjWgxatqjfBvAJYqQ5lvdWh7Ff25R6EyRfkFncE3Vm
         A4b+dLUH7Uq0wzsmt6phwAof/fvS4SUAXxrwKQP86jyVYOK97cHEsUl0gy2DfjveQsl4
         3p+HeouIjDK3Bx1fjFzFR4jQKz+/VlpqNcUHOm6fMccRV79lTKp/sIYmpqKxbiIPBt6N
         AkYg==
X-Forwarded-Encrypted: i=1; AJvYcCUS4qEO9sDjCUUxjdvyGmD5Yo4sl2qmRCozEM5RcxR6UQLPkfctqoQkGN8abF4xMQlZGx1lM7jYlQM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ6gB5W+6sRoFOZYYmGlsYM8XL0z4iB7ZiNCRrcct9inDRSuce
	LEF18XpF6ImWtCXW/dClav7iwWygV6V5rbq0uWTSeePQuOrryxTHpTu6SqCfMo4=
X-Gm-Gg: ASbGncvf0W0HClpvsoaLpbyoFQuMfkmeSg9Ilth3p8cuuvc0/4eKgZTAd94dpjjKuSw
	WRD/EmxNAVI2kXE+KaFoyss7DR1dysno+Sihl13BUrOk4qLpAi1t0072+AGY5ODbpyuakizLt6B
	e9tHc+u4zXmVe2kmpi1LdWJzJJ/GtVHFfg2sGf5sekaGMeIFp0/yn3usrJFu8KnDytftoEeGIkR
	nBSBQk+Zp76zwPKWjs1EYzjP+4B7m8SVM2dAwmFfA8WZcfyguSVUeXq8ZwVhwbbtFjQxWGwYlyb
	rDwnzEA9SXbIQZtMGtsaedW/u31l5TlV249hk87CspwWnkCvE+vX+M7K
X-Google-Smtp-Source: AGHT+IHDxx96xJS7XiJBfUdwibT+jxahT16cifX6K0m2MkrcGOtIWJ4SzFbaX07lUyeEkPfCX44+Rw==
X-Received: by 2002:a17:903:440b:b0:206:9a3f:15e5 with SMTP id d9443c01a7336-21f17edda66mr11902215ad.32.1738716679146;
        Tue, 04 Feb 2025 16:51:19 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de31f5c72sm103563805ad.66.2025.02.04.16.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 16:51:18 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tfTdM-0000000EjTG-2ZtR;
	Wed, 05 Feb 2025 11:51:16 +1100
Date: Wed, 5 Feb 2025 11:51:16 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/34] fix _require_scratch_duperemove ordering
Message-ID: <Z6K2BJlaFve5mcjk@dread.disaster.area>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406534.546134.14642160815740463828.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173870406534.546134.14642160815740463828.stgit@frogsfrogsfrogs>

On Tue, Feb 04, 2025 at 01:29:36PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Zorro complained that generic/559 stopped working, and I noticed that
> the duperemove invocation in the _require_scratch_duperemove function
> would fail with:
> 
>  Error 2: No such file or directory while getting path to file /opt/file1. Skipping.
>  Error 2: No such file or directory while getting path to file /opt/file2. Skipping.
>  No dedupe candidates found.
>  Gathering file list...
> 
> The cause of this is the incorrect placement of _require_scratch_dedupe
> after a _scratch_mount.  _require_scratch_dedupe formats, mounts, tests,
> and unmounts the scratch filesystem, which means that it should not come
> between a _scratch_mount call and code that uses $SCRATCH_MNT.
> 
> Cc: <fstests@vger.kernel.org> # v2024.12.22
> Fixes: 3b9f5fc7d7d853 ("common: call _require_scratch_dedupe from _require_scratch_duperemove")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
