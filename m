Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAA62F5312
	for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 23:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750204276; cv=none; b=hk1p3M56POEZdJ7dD0OhPC8m9gj8Mpn0jTcLRtFi5l9y4uNvkGu6yxN5OaKLFRslCgwoOawKslbhYwBeZidajPqdZMVoQH5Ther9NuEjZthIvaX5F3Y1F5I8yGNDgbEqJSMrNLuqqDE4vArD6+iUQzszv/hY2CWqn9uTlZOdPsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750204276; c=relaxed/simple;
	bh=WfIiNtqBx+eYQVnE0AUaiZXotf9QrdAd3XjrrPoF6gM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IKY7fMQwbUqPFYTC86yRU+qTPRgQ9vJ3GEgKaicIUE/dOqJFXGtPcXvyvOclJZeLnFtY5jb7EHo7QX0V+4qb7vrpH4jDKTPYjRjSSbi4CQ6Ydq6d2KNJZSup1GGf3SaB8v0CBsY68kPqcnyPZDjIL4HFtmq3QpFQuWpvPT03Uac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=tbOUCQxF; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="tbOUCQxF"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3122a63201bso5931942a91.0
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 16:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1750204274; x=1750809074; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zzMC4AQfmnTG8jlAP1KM95nq5XLaB/g9t5ih1eXLPt4=;
        b=tbOUCQxFthMnmRswD9fB/Im0eqxBG/Z2Cl6pGQvRXX/kypQsvC+O9YN57PFx8Hr9mi
         6JvSKd85mW2tog6pGfOr8MNQeBNU8OiNmBZBxX+Cw7hstfRKfOBdTVq8mWkvsCxjpqLV
         0AqHxWwaL1BpCi1UlMXz66A02cObYJvc7QPmN3MCYkAHv2DLsMpQY7BYhC/LXIF3vUJP
         4nC+/pr3WTKvbV1+tBwLqqr0M8kM0JXGsCoX5G5AVAouvGsVSBXek8hRg9ZPT7iPgPUW
         NyPlBnZ3A6JG9/MhO/RSUksgmQKA/ivrFfp88x+TTcjDzErUX1cnC/WzXuZOj7gGAwpF
         Y+og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750204274; x=1750809074;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zzMC4AQfmnTG8jlAP1KM95nq5XLaB/g9t5ih1eXLPt4=;
        b=QVjmSlsOuunb6ePm4P6Qq0IHdrUqO79qgTh0jXVKdgNSL7ZBKSUS8Xnq3MF6vwd7xj
         K9xMPSHqbYUWPEp2MNyGV7KYmcd1FARFJ18Dzssw6cYTCFHbMDYjYLvxY2/FYWfbh85B
         iJ/xKPrLjra+9LvNZpg3ekqlo9EbYsEJr7WR/ONN+2RE0TJU291h4nN8QkiUAGLk3jaU
         xIhNU1JQfMH6ZIQsxyRjlW2ZjstHAMVjPZWsowIoLiICu39lL7yEJWFncZf+D2mIBKrZ
         fA7LELAgw2K/FsieXvu3DK8BwwGx5lSKLZMlVdjrA463yPqHPkuHvizF/xrGvvLVgswx
         5sAg==
X-Forwarded-Encrypted: i=1; AJvYcCUF813GBZWlAQex9mXAduxTaADIRXiLkB79bGUuYf1LJyA85Ihf5L5qiHxArdumtXQfZ0JgaFFj/fQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBRmLXpreKORFb35ZlU5PmG6s50RpaL3y0Tj4Q5hqh51YAN+0t
	FjEDCpqjR4sW1i4K1Bu1xUW6b2zwNu+UVQqp7GnsLyVmxOf8qfzf5L/n8S0zMX48E5E=
X-Gm-Gg: ASbGncsLxcKY4qE4c6u6g1tgdU8kvf4xyyOA32jqeR1l2J/Apuhnic5AG/LLthCH8Qs
	lIy8eetvhueCpV+eJuzg+SWzHmKy7Bmn+XvfoeQD52+USe+rWWNcqa5zv4F1fYYKjy2ex22k4jR
	LHnoxP5TmQw1lef9/zQ4Uliw3FHcY5BRsORc4SYRtYVoXzz1oWOyODrMwReAF4CtVPJ3nIQJswx
	N6E3VqLL3fDfKPZUblGEd/0Qn2qspaRtwFz2ZN8gy7LJvyYi4WmhtLt/RP2ZJrtMx+bAWOLbraH
	o/X/h0yYN6PXd1aK5CrLRmgK/z4JQ+ggxieLjJVLtsKSD5gPGjft4s1g0it9+d+lGAmv+zHF05D
	yH5s3wZeW9sJ+pf/U+ceVNVZZ4NOhUkudvytcfA==
X-Google-Smtp-Source: AGHT+IFufnwnD4he0HJf0CEEIzXqYB5dxbYWIz7TDmBTCp69VBQmzOg//Htr8J80KhCRKscuyKGFsw==
X-Received: by 2002:a17:90b:4e84:b0:313:dcf4:37bc with SMTP id 98e67ed59e1d1-313f1dd74acmr18733102a91.34.1750204274200;
        Tue, 17 Jun 2025 16:51:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-313c1b59ed4sm11344283a91.39.2025.06.17.16.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 16:51:13 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uRg58-00000000CFT-3E0p;
	Wed, 18 Jun 2025 09:51:10 +1000
Date: Wed, 18 Jun 2025 09:51:10 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: remove the bt_meta_sectorsize field in struct
 buftarg
Message-ID: <aFH_bpJrowjwTeV_@dread.disaster.area>
References: <20250617105238.3393499-1-hch@lst.de>
 <20250617105238.3393499-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617105238.3393499-8-hch@lst.de>

On Tue, Jun 17, 2025 at 12:52:05PM +0200, Christoph Hellwig wrote:
> The file system only has a single file system sector size.

The external log device can have a different sector size to
the rest of the filesystem. This series looks like it removes the
ability to validate that the log device sector size in teh
superblock is valid for the backing device....

At minimum, the series description needs to be more than "this is
just a code cleanup" because it really changes the way block devices
are opened, configured and validated against the on-disk information
in the superblock....

-Dave.

-- 
Dave Chinner
david@fromorbit.com
