Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904D2227B85
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 00:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738716057; cv=none; b=HWFPiYRg2mv4MrCfGE+8Xyzffa1uzUoay+7J2hRxMmpS+zEG8twdCcdlKW/yZUE08IHSgz4pCVznAn+XF1XhFxoxxoPZ3SAANdsZVClgaLpY+pg4AP4TAablX1KbHZD84PJszCJUc2onq81UvfrngnX8czCWHdWNslkRrCnoGYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738716057; c=relaxed/simple;
	bh=YN3+HnQn2NejvimYU3LpKaNu+zbenPR2dEZbFkEn+HA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hPt6M9cpQDyji3t2a8l91BVd8DiCHxyDKwX/h+S5pGILHOzgqIxkPYlyxwArXFHkrVTAey1VHEr58lWgIyn/g7gAOYmOiHnWAL72d+3U2V/ZTLVXWZcvPTRZvDiw/nBKIFokMZ8HGR91o+Pgvtl1p37pIz6/IXNlxFgpm4gsI44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=F6BwvSXp; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="F6BwvSXp"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-21654fdd5daso108417855ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 04 Feb 2025 16:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738716055; x=1739320855; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cqPW76/W/hk1LhmC1dcBZb8i0N5+TPsumQm1aV5x6t0=;
        b=F6BwvSXpqmXNqWckoZe6WqHjoWcKzp8wBSsRGcXkXyen6anGAzob/fj5MJ0NusND+c
         xnAaZohVi9T1OkBI1NA18ts2RCKAx2GaG273BWnYPw88Na2msKjN0AtivSS5bEG2Zl95
         N21lv23KFBa2Htt2HrQLDWSTpnojp6hpzgWA4neh115Y8KqJ7nnVvH2V4h3dUqxBnJv2
         XefDNE5O8O1ERiDNu3qr0Wp1YwkBfZrfjY9yL/7J/VmsISS+Vzt54+rqEk7jOUGv7jVR
         j/uckxAOWzYbvW4r2tn52DPqGVnjKdHYZFGHgfU46TDCZenfQAYV/8XqvlM1KnVOWdtz
         xCCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738716055; x=1739320855;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cqPW76/W/hk1LhmC1dcBZb8i0N5+TPsumQm1aV5x6t0=;
        b=tfcv8oRa+yrKtgzoGK7BIj2TEbFPwnru+NeIekcF4uUHiFtxafMQAmE6xwnvfyijOd
         rH0gDUB/NOSUtevceBM9OVm9tnRSXltdpbFEwEyEc+XVwSG8UPyFfjldhuY296Wl8kUP
         dX1QH46pdT5dXcAVHUN6cH/QgmvB7GJzCVss16goBpZcAvEQpQHqTMu2FFO3svU2eI5Y
         rEWDhpkLm2OrMSzX4W4ZKO8+DrMAy/kGLyYmC5zlrNrdTB2r7UAPXsbEaIr9BuKHi6lE
         QnTTO/HANIRnlxLC/Q1MjI7ARKKg/dYNc6SP6WzK4cmKfAXkRGCPqMToR4x9ZgxnKynH
         bwfg==
X-Forwarded-Encrypted: i=1; AJvYcCU+M7ZMuyoc8fFK1DPzrl9k5Iq9vKm1LOoey6f25nyxYfNW+Ptrt26H5JLcJ0ya3ZLVkHQSEcfEmvY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHsB4zdOl7oyT4Qq/HCdYhhCLDiBRxWlpk41Vfhq28ip8QcKpF
	b6WspHJdt+vsDOQuUUCj8SSgrE9ymZ76SVoNis8H1GF+/WM5LgXldumzG8p+OaU=
X-Gm-Gg: ASbGnctcqfa8DglJoLv9nCwI2OFWUnarWlzq/ap/PnklV/OZPaUyEN29Q1PAxIxBW9l
	Ho2Bi/R2hXEaaOUI4ulW9NUJ8TUTZxHMG2AMr92544xBGXDONAB+ZxoSq8sqLyOUp0ejrN/J6So
	Zs7hycGbsbXtxh1kMqrWzjVJwCg601cg3z2i3O+Bji6+tUbTJrNU+jST+GthYauB2yFnEHUW1/c
	c4vVv59oCpTrgVQilQ2FQeyYLY1gMzM9cfg4LfrMmfARJAFiD9VJbxJscmmwwOEECxkQsu5j1k/
	EEOKFryRNCiAaE+9XpRI9oYkjvpj+C1U8wgFXpTcS5UNrDpvAL8k0vLj
X-Google-Smtp-Source: AGHT+IGaDDo97z+At67026Hz1JTKlODOrMD6FoRl+fq2lze2FUcwq2WBOJ3fIceehSwJVfBy7t+fMA==
X-Received: by 2002:a17:902:ec8f:b0:216:7926:8d69 with SMTP id d9443c01a7336-21f17f2f955mr12675835ad.47.1738716054802;
        Tue, 04 Feb 2025 16:40:54 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de331ea14sm102972975ad.212.2025.02.04.16.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 16:40:54 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tfTTI-0000000EjLS-16IQ;
	Wed, 05 Feb 2025 11:40:52 +1100
Date: Wed, 5 Feb 2025 11:40:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/34] mkfs: don't hardcode log size
Message-ID: <Z6KzlEjfe-QmlY4u@dread.disaster.area>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406396.546134.3531267570648312988.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173870406396.546134.3531267570648312988.stgit@frogsfrogsfrogs>

On Tue, Feb 04, 2025 at 01:27:15PM -0800, Darrick J. Wong wrote:
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
> 
> For example, here's seqres.full from a failed xfs/501 invocation:
> 
> ** mkfs failed with extra mkfs options added to " -m metadir=2,autofsck=1,uquota,gquota,pquota, -d rtinherit=1," by test 501 **
> ** attempting to mkfs using only test 501 options: -l size=256m **
> size 256m specified for log subvolume is too large, maximum is 32768 blocks
> <snip>
> mount -ortdev=/dev/sdb4 -ologdev=/dev/sdb2 /dev/sda4 /opt failed
> umount: /dev/sda4: not mounted.
> 
> Note that there's some formatting error here, so we jettison the entire
> rt configuration to force the log size option, but then mount fails
> because we didn't edit out the rtdev option there too.
> 
> Fortunately, mkfs.xfs already /has/ a few options to try to improve
> parallelism in the filesystem by avoiding contention on the log grant
> heads by scaling up the log size.  These options are aware of log and AG
> size constraints so they won't conflict with other geometry options.
> 
> Use them.

Good solution to the problem.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
