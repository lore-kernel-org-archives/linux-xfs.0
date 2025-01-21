Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAB23208
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2025 03:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737431910; cv=none; b=nJfS2qyeQpICaoHJytixHAz6l97HGem/29hrfWffK4WAhNJb6kYjwzh5WcumgatDK0hWIx4cyIPVtt7GhJMBOB317rW/HxABty8PpIJ7wMqXftkf5t35gg50SmfaAI2+y1aHfgTrG8n58Gyassp8sBWHBpKTnlrL0Runq/+QwiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737431910; c=relaxed/simple;
	bh=g5ykeALbjuNqGhzt6tLUwpLrMVosKA+SQO0JJOKjTRc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bgH+edNkdZXBzisdjKEm1XCkW/Waj2dpY8rPwWl7kaNFHhxVQGRHvwopfNBfNVq4s7E2/gOxC5arrFUJ0dvbbO9bXMuxclyngd3O0C3DFhI2jdmuhCK241dfkwXtU5ZELpxuKvO/CSRnEmsVH09b55dULX3J/r9zpgBIPP/nA7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=itulnldQ; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="itulnldQ"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2ee8aa26415so8805576a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jan 2025 19:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1737431908; x=1738036708; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CfqNhXrX+hCCcIZ/Hh9Hk/fi46EWecf4J2iJlEP/Jx0=;
        b=itulnldQ0/rxLE5rwnAye0cTAi+2hHrY1htDmhMbD9g+xcTNl/U8ZE3oeBhX2yJFRQ
         9oCoNOVVMgf1VDsY11yhloFFmPrBtTm0MgxLWLh1sfNiAeJ0EUo8eteybvul3fCeW57Z
         UXKQXqm+vob4Pz5ZlqJDGhiAzAdjrgcZtT/m/CA9UX2qJq5wvFitjD3xZ+GXfjAu3Tiv
         N4k2hJswIqlv8YpehmKJPSSgErwiW0+Z3+A1mgEelJoLnYd3/UnAfuqGV3BGbcjPyA25
         ezy5bePDhT4sL+/SalAXOGudIjYwZYXBd6mtRZwDxUIZW+uRQ+Pja/KGYzyQ6IGHpt/2
         XhUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737431908; x=1738036708;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CfqNhXrX+hCCcIZ/Hh9Hk/fi46EWecf4J2iJlEP/Jx0=;
        b=ZridGT9ri+f1KDyAo3pCjZL2nblfvyeFr5yqAgHwCfu0GmF6ehcpd8YGj/XJ1qS7oe
         4ySdJp/X9dRrQGuwW4xzVkt8rbxLIcLca2sMdPL9sgzX4oNJX/Wt4Q+xNs1vee4cJe2L
         IxIymBgdW/0QMAnWNV+XMV1RvxgOOlPW5JyOmobW6+6oJXIACwDprkxjufmw8PrsuwtA
         lmPvOzrHk9NNC+yzPEPFZo9U4rrbp1whhMNNHw2bNhocZO8JBrgnPqbUHN+1My1ZdcUN
         zHg7v9NMTp4afydMV+8TwUAFp1kHtzYSzSKHMKLxnWs+rmzCXiJI77lWJkRqgqLuGQN0
         a88g==
X-Forwarded-Encrypted: i=1; AJvYcCVa/QS5rM/xh0elF9TDOz8w/pbDgyoo+GfppKqvA89YfGn4+Ite6IQ316U0I55zyVMA9p9x2bshHMU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw26XKTUAd71We3Ro9ChIVqFmZtee4W5czt39PWxYPYrQ1IP65p
	TJ9QpuGiNqIsD0Wy0yiDMe6nw1ADm+30la5Zf64Hy40+teDoUttRGt4kIGv3RUo=
X-Gm-Gg: ASbGncuxPLNXelaO4m515Ji3Vtx3NKnVTy/+80ZWkGpZf/W7eET+kFEC6wK4cP3Au/L
	SYpyAcbfC8H/IeXYsDjSHEWz35yH9WWBZAhQOWLJoSStU/1Hw4lL71mqS9VrK55GVftARKqcFSm
	1IXwau0Tl+dKUkbeoU0r8fvb/eu/FwdjUfbV6Nsd9Ml0JGLdnyqf/wn0/i8bTUP4n0kMIzQ1Yhs
	dFcDSkLUOGOQVffJVH3bVEBM85uH/aVqohLbWJptw/73eQFjGQEYn8318I3I0RjZISjOVeGc/1G
	9PxyNOCk2NqeaXBBx3bHzVllnpSKNywDmKeB2nJtpF21qg==
X-Google-Smtp-Source: AGHT+IH2jP1E9zsHnBAYPh/rxdtvIQDeNK3UKDHNuWBv4qxIjoJ6pR37ctNdqsz/oF3u0H+Zx6cMTA==
X-Received: by 2002:a17:90b:38d0:b0:2ee:d35c:3996 with SMTP id 98e67ed59e1d1-2f782d972f5mr22453430a91.31.1737431908703;
        Mon, 20 Jan 2025 19:58:28 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7cfcde563sm2212421a91.28.2025.01.20.19.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 19:58:28 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1ta5PF-00000008W6H-1hsb;
	Tue, 21 Jan 2025 14:58:25 +1100
Date: Tue, 21 Jan 2025 14:58:25 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/23] mkfs: don't hardcode log size
Message-ID: <Z48bYVRvWt-wPmUz@dread.disaster.area>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974228.1927324.17714311358227511791.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173706974228.1927324.17714311358227511791.stgit@frogsfrogsfrogs>

On Thu, Jan 16, 2025 at 03:27:46PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Commit 000813899afb46 hardcoded a log size of 256MB into xfs/501,
> xfs/502, and generic/530.  This seems to be an attempt to reduce test
> run times by increasing the log size so that more background threads can
> run in parallel.  Unfortunately, this breaks a couple of my test
> configurations:
> 
>  - External logs smaller than 256MB
>  - Internal logs where the AG size is less than 256MB
....

> diff --git a/common/rc b/common/rc
> index 9e34c301b0deb0..885669beeb5e26 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -689,6 +689,33 @@ _test_cycle_mount()
>      _test_mount
>  }
>  
> +# Are there mkfs options to try to improve concurrency?
> +_scratch_mkfs_concurrency_options()
> +{
> +	local nr_cpus="$(( $1 * LOAD_FACTOR ))"

caller does not need to pass a number of CPUs. This function can
simply do:

	local nr_cpus=$(getconf _NPROCESSORS_CONF)

And that will set concurrency to be "optimal" for the number of CPUs
in the machine the test is going to run on. That way tests don't
need to hard code some number that is going to be too large for
small systems and to small for large systems...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
