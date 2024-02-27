Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7B81E86C
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 23:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709077572; cv=none; b=m8Xp6tzPTIj1pIkgNtFKvpbopymNw6U0fM/0MgJpCf6m4xjlGYMooVwT803voAm9KvTjqyS7WvXJF+WzEPUzQRdZ8iHZc7sBMINdGVu/t3Avdj0ZVTSTGsMt+hSknLg7H2Ze33Mr6Jy3hHU3w7i0bfiuMc9IxLkwyQbtTarDdJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709077572; c=relaxed/simple;
	bh=05y20ylw63Jp1XqpyS0hDAMF7jD069gsedUHFYisPC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cv1YeJYm/NB2psm9Ov5pnBvZw7JKOhqbDATTWWzda0/GOPvxNloYSrw2yEPMLt9aw2F6erYurX51fVRSNVb6Xgrb5/OpC5GlHt207nO326L2gLwMroUL/DGBhAg8sJSVLjuNyJpf/SRC0B71J2cYcjjgUVWT1xcsuLd0fyb3BMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=aOhuGBIQ; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="aOhuGBIQ"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1d7881b1843so37111185ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 15:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1709077570; x=1709682370; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2J0nG5bx4RWetieNgdHsq0BhUr6Alc5BaFD0GmCSBJo=;
        b=aOhuGBIQuPV5Cs3yAMIKBc9OUtkAiAsR5pCdlixqbhqpC41z/FQFWVNeiKdqgE+wh/
         zBV+g2LLQ3AKHc1rC22P0KHdeXsi3thn7ao0Ns52kBne8HdPSYtm49dpA6V5SXBkTA7r
         RTgBdy5t4NT576MIMWKrRec2dNb1haedG4Qdg+EXuYKKfbFBOz2j37eyZUUkf0DMR/OK
         mKHY1gScrTrl48jSvFsXKtfUHrIvCCwtoiGQgrkmBiU0o1VtbVTcAhi1Q/qxy2E0S9YZ
         h1euWDL9YmdVh9/q0/sCHY7bOhOn0sJ58gy83KPABTXQANTwOvppoIHEsj4MpNYMvXAd
         I2HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709077570; x=1709682370;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2J0nG5bx4RWetieNgdHsq0BhUr6Alc5BaFD0GmCSBJo=;
        b=d+o1ZjCbpDsuvFLXQaIX7TTYZiBGNHlrHtCmORqp5RCFf9l9Phs7X7M2hCeLb/1quj
         s4o/yd5v/8L8vYWkFbrlXJBrL1a69wlF+GqJSWlAEWO1Ximma0SE2UU1PSAk7cHDCJC+
         e2Lma7u07tToPED1XHTJwmBGs8zJKoabIWiHWth0QmXqTyEIgwgtbvmVcuRRjegYg/2Z
         GTvK9Tacp569WWf7JdS776RHUDXqN+5gimxqlkzf6yR3Fcwxri+PKC5JML1Y1CHgR9sU
         +FVc5+snzeItBeajCdmaTFUia0jP5q1ehwiEjhZ/JOLugNbduWKeiVoCBzVfJ6gc3nE1
         gQOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNR89mD1a2O3NJbfnV2ZUROhaQ+B2Ftb9DTBnat+03xp7FwXT1VXh/sy0qgmcbD1+rhrMCh4l0E44ABcUPT6ELM7oFMQNNLXpi
X-Gm-Message-State: AOJu0YzatzgewhIecX7UxRJS0HsIVdhCk8gY1ZXrCGZpIw6surnujqLw
	db6fvbGgAz5PVynMv5xgDkbuDbZNI+LRKVZBGdDiOlARBemW7Ggzw3tR29Flavo=
X-Google-Smtp-Source: AGHT+IEQgyeIOKDvQf9gUz/EKh5crZ2gQ6znIYOA6BpSh1GdmClgFwwK28Z95oRnqBXCWyNwbsQk9Q==
X-Received: by 2002:a17:902:6806:b0:1dc:8508:8e35 with SMTP id h6-20020a170902680600b001dc85088e35mr665302plk.68.1709077570175;
        Tue, 27 Feb 2024 15:46:10 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id jg3-20020a17090326c300b001d9a41daf85sm2054477plb.256.2024.02.27.15.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 15:46:09 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rf79D-00CPwL-0R;
	Wed, 28 Feb 2024 10:46:07 +1100
Date: Wed, 28 Feb 2024 10:46:07 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jeff Layton <jlayton@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCHSET v29.4 03/13] xfs: atomic file content exchanges
Message-ID: <Zd50P9TH5TAdqFyU@dread.disaster.area>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
 <CAOQ4uxh-gKGuwrvuQnWKcKLKQe2j9s__Yx2T-gCrDJMUbm5ZYA@mail.gmail.com>
 <4e29a0395b3963e6a48f916baaf16394acd017ca.camel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e29a0395b3963e6a48f916baaf16394acd017ca.camel@kernel.org>

On Tue, Feb 27, 2024 at 05:53:46AM -0500, Jeff Layton wrote:
> On Tue, 2024-02-27 at 11:23 +0200, Amir Goldstein wrote:
> > On Tue, Feb 27, 2024 at 4:18 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > And for a new API, wouldn't it be better to use change_cookie (a.k.a i_version)?

Like xfs_fsr doing online defrag, we really only care about explicit
user data changes here, not internal layout and metadata changes to
the files...

> > Even if this API is designed to be hoisted out of XFS at some future time,
> > Is there a real need to support it on filesystems that do not support
> > i_version(?)
> > 
> > Not to mention the fact that POSIX does not explicitly define how ctime should
> > behave with changes to fiemap (uninitialized extent and all), so who knows
> > how other filesystems may update ctime in those cases.
> > 
> > I realize that STATX_CHANGE_COOKIE is currently kernel internal, but
> > it seems that XFS_IOC_EXCHANGE_RANGE is a case where userspace
> > really explicitly requests a bump of i_version on the next change.
> > 
> 
> 
> I agree. Using an opaque change cookie would be a lot nicer from an API
> standpoint, and shouldn't be subject to timestamp granularity issues.
> 
> That said, XFS's change cookie is currently broken. Dave C. said he had
> some patches in progress to fix that however.

By "fix", I meant "remove".

i.e. the patches I was proposing were to remove SB_I_VERSION support
from XFS so NFS just uses the ctime on XFS because the recent
changes to i_version make it a ctime change counter, not an inode
change counter.

Then patches were posted for finer grained inode timestamps to allow
everything to use ctime instead of i_version, and with that I
thought NFS was just going to change to ctime for everyone with that
the whole change cookie issue was going away.

It now sounds like that isn't happening, so I'll just ressurect the
patch to remove published SB_I_VERSION and STATX_CHANGE_COOKIE
support from XFS for now and us XFS people can just go back to
ignoring this problem again.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
