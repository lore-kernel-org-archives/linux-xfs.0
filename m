Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4214D13B
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 06:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712127329; cv=none; b=hlpWNHxXSbIE2JQIAjo4pVT1mI/DW8q+nO+ACPBBWivp1bXjWTj495dpEr30TcbTiWVak9nJ+jl6dz81UqTcr2R6a2dcvN8k1snqjOslawY6vwDFdQC6F3roP1LMUeotfO6bQ4YRE045WOrlGM1SpMkyzzY1xrWRmWeqXXGrKU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712127329; c=relaxed/simple;
	bh=/ptLjQPIOge4S/S8/7Te28AQmko97mh+hmxfZtnjiJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E/9B6KzKMYwCpicyrhRARf9ns6hnBM3/hvJB3kRSvtTR+ySmXOJx4Bynjq3AMgQDGTdgbk2vtfcV2tKKMweNOzXoBOzZ5mK/Vq6Mh7YAEex/FxgkH+lsrr3HQfhXRuld5l3jep2TMxlrQAQ/s5R2RSI1s+YqWFUsZiKk5R+Yu4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=1XfEWkKj; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="1XfEWkKj"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-2282597eff5so4503763fac.3
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 23:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712127327; x=1712732127; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aUYTvlOrQBfcX/e1Fv8RTEpxQsbFg3+uejjC97rAGjI=;
        b=1XfEWkKjtA8qdbJnq8Q5Z4tMuk9EMUrjAHFbYwdPU5Xdc67XBwC7LW6ENITXZk0eJB
         b8Fe8sfv42536tHrnA6H+Cp1r9XhnVAPZcbQBaVmX7F6IWq7LAJzcI6mXdSVjx6mf79K
         8vJyhqTydUYps74GkvCUkJonI7vClFQ82jFkIvJn7H4rcswFssuTHCkJey6sO+32QafG
         ZmZgxi+CPcFxMSZ5EmhamA083JvbZcYG9sGCHj3WZf8H3/7f4dpKV9bjxyxJX1GY6JzE
         5w+9Nj6n0hsVkAVBJtm79UGZx6J1suIWxIkXmODfWxspBM7zTYDwdOdKxKkoisJ1NEym
         7B7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712127327; x=1712732127;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aUYTvlOrQBfcX/e1Fv8RTEpxQsbFg3+uejjC97rAGjI=;
        b=UYNOQ7CdYwx6IK/vJBLjyEVVh4XGvHPz0mddWNvn1RBcqnRujB+nNHqKHBENcNkc+S
         iLMSpcRj/NT8EzidVQHtiSTAZ/YWZKL2KnnpDj7OTkSF0mVZR91piVppm5vc8aAF8Vr8
         BiYs1wEaLoJ7ZUtQ2P7411KX4tx5SFX/OH10Ou1tYyjZLqGjVKtfslG/kmtHbR6CFMW0
         es8EEuqn5ofVbOl7Li78ZYU2nc310tec4e1mKAyMS+n561qACIc7a6muVAQ9OlKwMnLk
         6DVnxFvRZ717d+1LEApU8WSzH4KFKw9uIn2muMoyTwEm9mxCMHlEf++Vi63tu85sOQH3
         hQkw==
X-Gm-Message-State: AOJu0YxhDFSgRhZLDzxi8p9RlzOjuJh2t8tvkWIUqgc+c2n/MS/jvftA
	LzYaBoHklwxjd0Bo6cHKMWOzUzoUY2w8jbF8r08hMbludaI/Dx0rtz7x1cg/f+6NgJ4JgOJax+1
	W
X-Google-Smtp-Source: AGHT+IFZzyH3gkejULGpBgAUBnWhCoO4efRMUhZ+/nnuKorM2Qnb5U59rV1qUvcpJZV6j3tRAZ5EPg==
X-Received: by 2002:a05:6871:71c3:b0:221:4fe5:87cb with SMTP id mj3-20020a05687171c300b002214fe587cbmr16156001oac.42.1712127327121;
        Tue, 02 Apr 2024 23:55:27 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id fi2-20020a056a00398200b006eadfbdcc13sm10185156pfb.67.2024.04.02.23.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 23:55:26 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rruWq-002FS0-0B;
	Wed, 03 Apr 2024 17:55:24 +1100
Date: Wed, 3 Apr 2024 17:55:24 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: Re: [PATCH 4/4] xfs: validate block count for XFS_IOC_SET_RESBLKS
Message-ID: <Zgz9XG0p8vioG3UB@dread.disaster.area>
References: <20240402221127.1200501-1-david@fromorbit.com>
 <20240402221127.1200501-5-david@fromorbit.com>
 <20240403035314.GL6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240403035314.GL6390@frogsfrogsfrogs>

On Tue, Apr 02, 2024 at 08:53:14PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 03, 2024 at 08:38:19AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Userspace can pass anything it wants in the reserved block count
> > and we simply pass that to the reservation code. If a value that is
> > far too large is passed, we can overflow the free space counter
> > and df reports things like:
> > 
> > Filesystem      Size  Used Avail Use% Mounted on
> > /dev/loop0       14M  -27Z   27Z    - /home/dave/bugs/file0
> > 
> > As reserving space requires CAP_SYS_ADMIN, this is not a problem
> > that will ever been seen in production systems. However, fuzzers are
> > running with CAP_SYS_ADMIN, and so they able to run filesystem code
> > with out-of-band free space accounting.
> > 
> > Stop the fuzzers ifrom being able to do this by validating that the
> > count is within the bounds of the filesystem size and reject
> > anything outside those bounds as invalid.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_ioctl.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index d0e2cec6210d..18a225d884dd 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1892,6 +1892,9 @@ xfs_ioctl_getset_resblocks(
> >  		if (copy_from_user(&fsop, arg, sizeof(fsop)))
> >  			return -EFAULT;
> >  
> > +		if (fsop.resblks >= mp->m_sb.sb_dblocks)
> > +			return -EINVAL;
> 
> Why isn't xfs_reserve_blocks catching this?

xfs_reserve_blocks() assumes that values have already been bounds
checked and are valid, so calculations won't overflow.  Nothing in
the internal calls to xfs_reserve_blocks() will pass an out-of-range
value, but the value coming from userspace via the ioctl is
completely unbounded. Bounding checks should be done in the code
processing the unbounded input, not the internal functions.

> Is this due to the odd
> behavior that a failed xfs_mod_fdblocks is undone and m_resblks simply
> allowed to remain?

I don't know - I couldn't work out where the overflow was occurring
from reading the code, and once I realised that all the internal
calls are using sanitised values and the ioctl didn't sanitise the
user input, the fix was obvious....

> Also why wouldn't we limit m_resblks to something smaller, like 10% of
> the fs or half an AG or something like that?

Because now we bikeshed over what is a useful limit for userspace to be
setting, rather than focussing on fixing the bug. i.e. this bug fix
doesn't limit the actual usable range that userspace can reserve,
but it prevents the overflow from occurring.i

If you want to set a limit on this value and update the code,
manpages, etc to document the new behaviour and then have to change
it when someone inevitably says "I have a workflow that temporarily
reserves 75% of the disk space because ....", then do it as a
separate "new feature" patchset. In the mean time, we just need the
overflow to go away....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
