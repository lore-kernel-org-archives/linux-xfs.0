Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BE313C667
	for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 09:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724665374; cv=none; b=RNs8WnXB0ghl7RWm9WBt7L6eg5qXsPpQPeapwv8JvFiwHSEgjNVRMPbj8Ywb4w77TX//cV7eEFCBNG7pX0W5jX+Q7lgZElxa/34KWhlF0fWNRpQ9OhQeWZ97B6xwqbrW7p8WZC3xy22vNXnHRS2noaHnYjuXy/DcuavtA9tS8L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724665374; c=relaxed/simple;
	bh=WhujLT9+cvQDyip0qJh47vU9kUYgj9X20xbFGMJuG0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b8I3LYdMfjcbl41n3MHLii+HjrC9h8ekvZw3pBQT7xQKnCMsf2lvjPhs5sx2Q230jEmiA83gCXOXQs4SbJUiFCoXSg4deflWf/AsBYHN+hGipMHWX2pgtT9Ix87Q5sk3T26D4u6NFKEtzLZRsa/ffXnAXw2j4m1TyMJnUH2UOKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=bP82Vvr4; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="bP82Vvr4"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-2702ed1054fso3084208fac.3
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 02:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724665371; x=1725270171; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FieVp2NpdQx3W96ALlMB3MhRsxFOnNzVHEXE/daoO9I=;
        b=bP82Vvr468CecW1GMEeP7U+jeDZq2SMSLc5uB0ptlP/9TjjDxm3bP7TsB4MLNttZnr
         0O4FXuQj1kAl/GR5tDa+nXkzPZmdN6G/lz8Wc3lEoZIXVDm+j+RXHAEkeoPxwriuvkZL
         3a9bw7SR0srRKRc5gDQQJUC+fW/wjvU17jsD6DdtVCxWoMxmEoXoVAosbLFMBufZY97u
         v8WzZHwh5wUDFMNWZXTzPew6+a6bPrL+l3N0tc1id+45NUhMDOS7TwNqED0+zIZqzQdC
         01Pxq6sJ3n3NJF09csxMu++Gd27BEDiKmNj0fTz7of2gAv+X0Ff7rZ4jILoIuwcM5z+c
         bhxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724665371; x=1725270171;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FieVp2NpdQx3W96ALlMB3MhRsxFOnNzVHEXE/daoO9I=;
        b=M0lCDSKt5xFjb/+V5B+n0BI+zjgfK54xCx/oX7y6zLtn2ZQVXLwHsgTWn+GX5JkIr9
         j9FuaEyiFxw1FjoQHK2u30L+C3Ff1iwgaTJQHbyZdR1F+tkU+sLHyHr+ngVR03jjF0Pw
         I9hfoBavXyk0at7XjUQ9zDvbieerSWRumdVLfv5eZrJ5vlaLh5JWVHioq1rm7fbdDI4Q
         5EH5PGYoYH7H1ukgpIcG2WLjw9PUChd4J1S8Ox0iYMt3iMNM95kIQcumg0M/g+tIyjGV
         ydgDdBeprkhjsPC5nwOKHt5J3uA95xxrAXrUZYlffRGdha4lA1MfdmyeKPNriHSjRJXq
         O4Kw==
X-Forwarded-Encrypted: i=1; AJvYcCVPmE4lFtXxxwZOT1sk72yDuZRK86pG/UcLxgG6PLXRzcOE5BTtBIaPudIvQtZEwwFWkN6Nw12qwEA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyShbYAJ589HisEPQR6aGStmwhEYvZUqzZVjWrrNybvlKyPJIQG
	IaNAfN5G3ct5LaTo9WBmUeiz2pSI6CyfKwu5ePEeK8VCQ+yqdQPkU2zj8NOHDq0=
X-Google-Smtp-Source: AGHT+IFALMVcYJOkGctJDZHsxz/TmOz5J65MfG5udLBDJJ8gle0uuI6zbmdoN5EWGZQsoowWe1+0Cw==
X-Received: by 2002:a05:6870:3313:b0:261:d43:3eef with SMTP id 586e51a60fabf-273e66201abmr10623128fac.31.1724665371329;
        Mon, 26 Aug 2024 02:42:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71434230d1dsm6715092b3a.37.2024.08.26.02.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 02:42:50 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1siWFM-00DDjA-1M;
	Mon, 26 Aug 2024 19:42:48 +1000
Date: Mon, 26 Aug 2024 19:42:48 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: persist quota flags with metadir
Message-ID: <ZsxOGGFb1oa7IEXB@dread.disaster.area>
References: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
 <172437089432.61495.8117184114353548540.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437089432.61495.8117184114353548540.stgit@frogsfrogsfrogs>

On Thu, Aug 22, 2024 at 05:28:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> It's annoying that one has to keep reminding XFS about what quota
> options it should mount with, since the quota flags recording the
> previous state are sitting right there in the primary superblock.  Even
> more strangely, there exists a noquota option to disable quotas
> completely, so it's odder still that providing no options is the same as
> noquota.
> 
> Starting with metadir, let's change the behavior so that if the user
> does not specify any quota-related mount options at all, the ondisk
> quota flags will be used to bring up quota.  In other words, the
> filesystem will mount in the same state and with the same functionality
> as it had during the last mount.

This means the only way to switch quota off completely with this
functionality is to explicitly unmount the filesystem and then mount
it again with the "-o noquota" option instead of mounting it again
without any quota options.

If so, this will need clear documentation in various man pages
because users will not expect this change of quota admin behaviour
caused by enabling some other unrelated functionality (like
rtgroups).....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
