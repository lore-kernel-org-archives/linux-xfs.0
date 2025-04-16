Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A061F4611
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 06:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785548; cv=none; b=o0W+NgGIU9QTH94lbAgjAhSt+0AvEg6N7kxSJebRGX8EMqc+647hZmqkhvAYJbjysUedMUZprOKKsLqRbVH0VkKVD1jsvmG4eSExpR5aSuKr12plTSBk7JELSHRWHphvTkhKUa65/nQfTffbG1lKPlsqL1p9k3rhPssUc2jW844=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785548; c=relaxed/simple;
	bh=/6spnS5wrCegEkRgCHukL/c4jKm672TfFB9WUvN5sJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JUFuuGJYzXkJn8/5avkHcCV/7yJwVXBYq0OeLFa0Sq+HDC+E6KXtXKIAJ2+XQ6g0OXH1Vldz13OBY7caebHPRS8WSm94IPyf8nWH31mxHVS+0NwX0xoNsS9Bf6U1Al5clRNuupcVaOpbAqo+zhNAlz+erWS9h3NpSzKsohvOs4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=BWaVnGuC; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="BWaVnGuC"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-af589091049so4418518a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 23:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1744785546; x=1745390346; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5bqMSV0bBILi86H5fZMTCW99FZys22KmgSLLsp1qj0Y=;
        b=BWaVnGuCgPtPnPLi2ednwoHtazk0C5JCH/HihxvGJ25lY6Xj5MVFCDF3ZqhBICDwg6
         6XbQacOV5EGswCNzk+NeVbFytZO9l5IVRFYS/RTm8gqPIPR2sNjawpE/39ZAdDO3xN/W
         w/M6GK4237JXMXfcg11AwnlB8GpyJ2J3D03iG7GYjEvMnQ8hYVQnhGSikQV1bK4jLifm
         YZeAL11fgIl4I3ED28Xw7cpvT7pquvKAymM4pndI+kTn2rCBwnv0w8XJOJPEMJmTgav8
         ZembugEAYkpWoTY7u7IvQrSotRHiLFsxDLqFINv/IN+hPLQV/KZzPzxNw2a/TyUJrDN+
         srhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744785546; x=1745390346;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5bqMSV0bBILi86H5fZMTCW99FZys22KmgSLLsp1qj0Y=;
        b=opugIjEySOSw1E7kUBWSQMAFlZ6SpYbNUFVmKMbL7Hfgjr9VSAyPOzdngX3oCYYspy
         VIB7gJZM72qZmrZOMKiE/z70zAo52/AqQb64WSIoMAO5CjP/M1VGxpWU6gFScmJgtcuu
         1seoTpVKKulIlQeW8D5qkVGLmBTpAIHyJeVl9kqjoGYk2u2Cg7QXJ2o9wJxsaM06iDgk
         4QXnQ7rKyqBrYQkHb5upO0/QiybAVujjTE4pCHAWZgGhu67pPz25YmILB4slwn5twdc3
         5D/8wiSh0SIFY6Fx+4sMRhcZAmFmMLL9yenKyUyrirDl0VHPjS8V8jYfnjmf9C/dx55Y
         ka6g==
X-Gm-Message-State: AOJu0YxIoEJle8BhSyEUA5X/iQsi2qxAUtFNLzb+NxXisNuscy3DSLOd
	qbJLaAmHWCQlqLRznFg3xpXhZxP9myfcFP1VQyfxjbgdTSs5cTdM57ndGFIavmM=
X-Gm-Gg: ASbGncsMi0RUU6PIi8bFQeKMqWKjcIptH5kJIaG0JjS1K4ALfDuu5M0oZZAT0Lb/39X
	9BHlMSxv8MP/azzl8h7AntFRxtybCFhmEGRuqvej8v91L3JzLfMBlwS+4JUvvDTYxeMLX7cbYit
	jci2BF0ibb/j0VWm0/Fn1Id54QxdLulSYCwzWPbMQtmzYjmlHsgRxYD4Nz/OYXs1VSYULXhtYbI
	s/XQ53Q9d+/ziudNuzCfjE+0ggHia1hcLpqmerQX951r5z4eAxsJRJFNvnwPqX1sZY65d4TzxFJ
	GsfuLzbN88dq90IUCyx9U/C3mjo8zkqQ9LpWmy1en25no329+CiuHHn3LZLqSoDMXAmPN34LBEX
	wusA=
X-Google-Smtp-Source: AGHT+IH4UYKS3+z5IvvGAyLAAcflKEKi1o3UgIjxouB3FcHHr0/lT1CylJuRC65BC11FXAMKbya+gA==
X-Received: by 2002:a17:90a:dfc5:b0:2fa:228d:5af2 with SMTP id 98e67ed59e1d1-30863f2c739mr1077980a91.15.1744785545889;
        Tue, 15 Apr 2025 23:39:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c33f1c20esm6436605ad.76.2025.04.15.23.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Apr 2025 23:39:05 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1u4wQI-00000009CfP-3QcE;
	Wed, 16 Apr 2025 16:39:02 +1000
Date: Wed, 16 Apr 2025 16:39:02 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [6.15-rc2 regression] xfs: assertion failed in inode allocation
Message-ID: <Z_9QhvYYhFP7Zk74@dread.disaster.area>
References: <Z_829MY9Ob63Xg-M@dread.disaster.area>
 <20250416053006.GD25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416053006.GD25675@frogsfrogsfrogs>

On Tue, Apr 15, 2025 at 10:30:06PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 16, 2025 at 02:49:56PM +1000, Dave Chinner wrote:
> > Hi folks,
> > 
> > After upgrading to ia current TOT kernel from 6.15-rc1, I'm now
> > seeing these assert failures during inode allocation when running
> > check-parallel:
> > 
> > [  355.630225] XFS: Assertion failed: freecount == to_perag(cur->bc_group)->pagi_freecount, file: fs/xfs/libxfs/xfs_ialloc.c, line: 280
> 
> I haven't seen this assertion tripping any more than it has in the past.
> 
> But I will say that I've seen a number of other problems, like page
> state corruption, null pointer derefs from the block layer, and weird
> behavior from the rest of the kernel.  Turning off LBS support fixes a
> lot of it.  -rc2 doesn't seem to have fixed anything over -rc1.

Yeah, that's pretty much my experience with the current TOT kernel -
it seems to be randomly corrupting block devices, failing to detect
filesystem features correctly (e.g. generic/577 seems to think that
XFS supports fsverity, then it fork bombs the machine with thousands
of child processes that never get reaped), stuff hanging in weird
places (e.g. udevadm getting stuck waiting on things that have
already happened) and so on.

I would not be running 6.15-rcX on anything important right now...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
