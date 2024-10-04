Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CD51862
	for <linux-xfs@vger.kernel.org>; Fri,  4 Oct 2024 00:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728002793; cv=none; b=eOhYJvbeaAKc2L6ZgjnFUz4G4cjRP2CgKHm3CkTs162m5PvozWDdTXleV2H9pUomm9UVFIykVQKlAd8wPw0tnmy7u5WasgMsrf7+lfeYSw34TuWTgWh0KHBRjkLYh35euB9GdpKYt+MsB4Uwplw125P5jxQ8ieADcqzyxCL6bFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728002793; c=relaxed/simple;
	bh=Gd8MWtiHNW0MP5r1VtRnLKSyPvxQq14CoCngTLSmOdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JsIbj7+DpJ86mpu27D9lffmh4UCiQwpfTYy0+fzDH2row/Lrx/n3PwsCcV5kQd6nxo+VhaPjfj7zZglYlEuW8H6HUlTlNCe3gnLKrYyEHUV+V0NAUuJ5I8gjrVyd9jwtcQzXl4/EXlfwZCa+F2k9G4L2+bMZQEed/m0uU+DJxeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=M8+tPrBw; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="M8+tPrBw"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-20b5affde14so12119825ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 03 Oct 2024 17:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1728002792; x=1728607592; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5oL7aA9ZouY5ZFpXF1+6PljZFIX5q9qbYeaK5yp3f5o=;
        b=M8+tPrBwYIbphBh7sXBhSafwnM3UJX4rDEmRugHziIwF4Tpyc1ODaKoHunejPU8JzC
         7KAC4DPp1NnsZ8wtyct3AagloaNoKMOAoo5iUaN7q0PIazO5JJKWG0VN/E5xJYs24lui
         ztgvePCmTvzmOWeVX807LHuGY84DuhDSHQ/ypEiGjPMba6VJdjEg7TxsO58Gx5XCabpE
         MVQrkz+dX0DlWWQUoxT2mbjqqzgv57rR5M+w645KsK9V4+Y37n1kLXGRqxSRUEbBF3H5
         p93N41+ivMvv6NJEKsA8S4ZhjJMzWmqqLSbxSDF8GeC+blgPM7G+aePkT9VcIZO7jBxC
         pKGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728002792; x=1728607592;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5oL7aA9ZouY5ZFpXF1+6PljZFIX5q9qbYeaK5yp3f5o=;
        b=m1Bx+SzMpV2cN3LfESdTS+5og9KRt0jIsq2Vy9nYQyH3oVPCssK8FKcxKcLzmsm3Rb
         ljK3Yxlzh6YdwfRDaFKfQ2R1yGJZ09XGDVYTn8LZm6jWXynK7BYHcNXTr7zvWQqIDPUF
         FMTeSgvQdZjuCsOz7bb4OZs4hzNekHTfwcVUvE3mDrvOnaRpVLlFuUsKRE5ITtVR9ojh
         TVaosvTRkY057+ocmyQljBeHaPaNK+aVojSE8mvBpPC/ovNul2pg2xzfp4asy/Cjd8mT
         Goy5TzS+gWkTGbIwx4zPc6Pn6BFKbu8AxKpwTZx+DPNWTLiAlyEEX340Sv86+tpZqNAh
         YUcg==
X-Forwarded-Encrypted: i=1; AJvYcCWKDyrykeqYfPKFp7DuHuTVseWGBILwcmMPi/ASB8j3PDWwRqDBOzqFc/+L/j0AOViMfzJGZGPhEB8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLGfjdufmUJX4rN0GbXba+KWpuxhXMceahoRiWNArmG+CP8kHu
	XgQNm3LMmwDqmqhTPOLOP4ofkeuiIKb4ljOLWAJYNp3SvuA6aeRvEHhmSBnMdXY=
X-Google-Smtp-Source: AGHT+IGYTOOZ0nv/cNl+WLKR+qQb6xrz41gIx2II56JGm8tfocsfbkKKQHENHQ+D1/d4e6k46fplVQ==
X-Received: by 2002:a17:903:2443:b0:20b:61c0:43ed with SMTP id d9443c01a7336-20bfe181244mr12642925ad.30.1728002791570;
        Thu, 03 Oct 2024 17:46:31 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20beeca1989sm14559075ad.118.2024.10.03.17.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 17:46:30 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1swWSh-00Dbsy-2p;
	Fri, 04 Oct 2024 10:46:27 +1000
Date: Fri, 4 Oct 2024 10:46:27 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org,
	kent.overstreet@linux.dev, torvalds@linux-foundation.org,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>,
	Jann Horn <jannh@google.com>, Serge Hallyn <serge@hallyn.com>,
	Kees Cook <keescook@chromium.org>,
	linux-security-module@vger.kernel.org,
	Amir Goldstein <amir73il@gmail.com>
Subject: Re: lsm sb_delete hook, was Re: [PATCH 4/7] vfs: Convert
 sb->s_inodes iteration to super_iter_inodes()
Message-ID: <Zv8648YMT10TMXSL@dread.disaster.area>
References: <20241002014017.3801899-5-david@fromorbit.com>
 <Zv5GfY1WS_aaczZM@infradead.org>
 <Zv5J3VTGqdjUAu1J@infradead.org>
 <20241003115721.kg2caqgj2xxinnth@quack3>
 <Zv6J34fwj3vNOrIH@infradead.org>
 <20241003122657.mrqwyc5tzeggrzbt@quack3>
 <Zv6Qe-9O44g6qnSu@infradead.org>
 <20241003125650.jtkqezmtnzfoysb2@quack3>
 <Zv6jV40xKIJYuePA@dread.disaster.area>
 <20241003161731.kwveypqzu4bivesv@quack3>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241003161731.kwveypqzu4bivesv@quack3>

On Thu, Oct 03, 2024 at 06:17:31PM +0200, Jan Kara wrote:
> On Thu 03-10-24 23:59:51, Dave Chinner wrote:
> > As for the landlock code, I think it needs to have it's own internal
> > tracking mechanism and not search the sb inode list for inodes that
> > it holds references to. LSM cleanup should be run before before we
> > get to tearing down the inode cache, not after....
> 
> Well, I think LSM cleanup could in principle be handled together with the
> fsnotify cleanup but I didn't check the details.

I'm not sure how we tell if an inode potentially has a LSM related
reference hanging off it. The landlock code looks to make an
assumption in that the only referenced inodes it sees will have a
valid inode->i_security pointer if landlock is enabled. i.e. it
calls landlock_inode(inode) and dereferences the returned value
without ever checking if inode->i_security is NULL or not.

I mean, we could do a check for inode->i_security when the refcount
is elevated and replace the security_sb_delete hook with an
security_evict_inode hook similar to the proposed fsnotify eviction
from evict_inodes().

But screwing with LSM instructure looks ....  obnoxiously complex
from the outside...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
