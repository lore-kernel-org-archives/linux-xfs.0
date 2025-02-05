Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7943173
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 00:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738714053; cv=none; b=cVIhsQYVewLTt02yEayl+mRilpeX2llSnnGt+mK6uiW8cygGZDw/uLQNuROVz+Sa6jMO0vUpuJzX4408ccjol1QulVa0ladLWQFW3+YA4+wRIQktns6VhtNhgnf7QcNx8+mpcRjImSI8SWesZ5LWb8kghHbrnn3Rf1eyraJPLJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738714053; c=relaxed/simple;
	bh=ANtLj6RIbWy6XzHdQEw3GfN8T4f5//7k96FZf/3F7So=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N2eR01lgHzjOOuVAVV/hUatjCgeryJYbg5ZJkXhPpD0DiOQzzW5t6/OntMDBLWKUyCZGAY2lPU9H3wGS0Ux4H7MpLE1x1AyL/2IzCsJ0AZsPFC6YZo6Gsi+KHa0nlZBn/MPSLbryDwvQUKSclbpdM3FV3Kwzk/RhwK+BSMvZfL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=rCAxfnHv; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="rCAxfnHv"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-21644aca3a0so144875935ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 04 Feb 2025 16:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738714050; x=1739318850; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8fj0rH4qbIkbkk6TgTl2qCvtRslxxK8xPGVrgdKhZjE=;
        b=rCAxfnHvPdR0vo3kXcxfW/zLi3c+XXf0pRtyiw9+f2xzHD1biIB3L7yeTsZRiUqMT2
         1jBuufEuRqWaRXkylKDpOxXmrWBY2lW0EaaLSuIRRkLspDJ2YFhWngiluELFrP2HWKUL
         tifgmfKUMy+9t1WSGmPIjhoQCsFKLjs0HeegqHYBOQZ4SBlCyyQu/8traO04ohfBHJx3
         l6+cmBeFk4Uqw2UbJlmVd6mNPsdq2gdD5R6Ov8GhMIyF5ETinZZFwPB5AZg6bxBfghE1
         nJyP4jUpwlhNUeSwiEimu17ax9kyoSiaJ0yaVjD5odJxY6N7l2oUjwNCFLObp3/nfVRP
         WmXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738714050; x=1739318850;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8fj0rH4qbIkbkk6TgTl2qCvtRslxxK8xPGVrgdKhZjE=;
        b=dKW+Qg0hfXkMRy7eY4ijC/dw7J7jVW5Urt+uaqP11imRtDmDfaEEmSrj/F+0Y0+uQ6
         5v2QJncPMMn6gsHB81G40xdkbD/S2UR49C1k2fS0Lnc6rfDg1Etgy+1JDuN0BI0pTWNs
         zefzpSYnxeX15FhsH3Eeq4QoR7KXgky+F7gJppW13neCda3oF5Ro5c07P7U+gQcIwoNU
         ya5P6o1O+OVMn1WL9pQBb+tMBYt7L3z7rzcROgNY+7F1pxkVoCw8jQ8eWUagOXyN8mc2
         niDJiNG2TUoYXQf/VooLhvm8A6NO00WdymZgycSULRMPtWTsBHOt6u+6UYql22AOBB/j
         721g==
X-Forwarded-Encrypted: i=1; AJvYcCUkQ/rfZBFRlDwKwoTPYYep/MiXbQS5lvF7dijmDPy0dbdNAMkIO0JKyLQ112mMr+XZe6ggL4MIP1Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLbQE7edg+VgVPYA9cElOxqTZCVrpZodLUro0PdLQYdalQ3YJP
	8QzuevShTkQ49UPhKlDKt2Uc9uQVcoLGuyscP5YRML5xORObRqJ0qqiCh+K4ShyqEjqVMRedSWD
	F
X-Gm-Gg: ASbGncvscYEn7fPW9PZXZ+CXS+rllfuOERqg2iBLB0pvR3wMv0mwgvoMjcoc+6jc7kY
	5/Fo+qAaIbBaDLA7A4/7fMU2f+KIHghlii8SiT8AlNrzAWaGjqCxzEv8+0P9amTxyKZFgwYNuO6
	jy9oEROQhJsdsKPz+h6CJ7xHtaZHyxGbybWJ27K5waqrhiHGT8U85FN5VHwyrJBO3FdNb2EUIRy
	L46A5FvBaY7i1lDQh25JH8MZLQF6l8JLHxkjR/XzXRGPnEfUexYzRpY1xQlWDIVYNVcnQu4BhI0
	ZBAJCdgOwxK6b5wuAMexD68fU3JxpNTwjR1vzSSpl1gzne7haOSoQYJf
X-Google-Smtp-Source: AGHT+IHdE2VVS12iE2YllVRBGqqkFrNxzGLqng7/tVH3iPmFSttAe7R4c7qJJmfD+/aCeMdUxJNKCg==
X-Received: by 2002:a17:903:8c4:b0:215:a3fd:61f5 with SMTP id d9443c01a7336-21f17dde0c8mr12110915ad.5.1738714050013;
        Tue, 04 Feb 2025 16:07:30 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de31f6f74sm102391075ad.67.2025.02.04.16.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 16:07:29 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tfSww-0000000EikI-2nFd;
	Wed, 05 Feb 2025 11:07:26 +1100
Date: Wed, 5 Feb 2025 11:07:26 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/34] common/rc: revert recursive unmount in
 _clear_mount_stack
Message-ID: <Z6KrvoW3kgLJeZuP@dread.disaster.area>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406199.546134.3521494633346683975.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173870406199.546134.3521494633346683975.stgit@frogsfrogsfrogs>

On Tue, Feb 04, 2025 at 01:23:51PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Zorro complained about the following regression in generic/589 that I
> can't reproduce here on Debian 12:
....

> > Orignal _clear_mount_stack trys to umount all of them. But Dave gave -R option to
> > umount command, so
> >   `umount -R /mnt/test/589-dst/201227_mpC` and `umount -R /mnt/test/589-src/201227_mpA`
> > already umount /mnt/test/589-dst and /mnt/test/589-src. recursively.
> > Then `umount -R /mnt/test/589-dst` shows "not mounted".
> 
> I /think/ this is a result of commit 4c6bc4565105e6 performing this
> "conversion" in _clear_mount_stack:
> 
> -		$UMOUNT_PROG $MOUNTED_POINT_STACK
> +		_unmount -R $MOUNTED_POINT_STACK
> 
> This is not a 1:1 conversion here -- previously there was no
> -R(ecursive) unmount option, and now there is.  It looks as though
> umount parses /proc/self/mountinfo to figure out what to unmount, and
> maybe on Zorro's system it balks if the argument passed is not present
> in that file?  Debian 12's umount doesn't care.

Ah, I think I added that whilst trying to work out the weird
shenanigans that the mount namespace cloning that these tests did
caused. It was cloning a shared mount namespace that many tests
interacted and so any changes to the mount namespace inside that
test were visible everywhere.

If two of these mount namespace tests ran at the same time, they
stepped on each other and they failed to unmount their own stack
cleanly because of "mount busy at unmount" errors. This would then
cascade into other test failures because the test/scratch devices
couldn't be unmounted.

The fix I came up with was to run a recursive unmount for the stack,
which seemed to clear all the mounts the test made regardless of
whatever other test could see them. It didn't through any errors on
my test machines (debian unstable) so I promptly forgot about it.

> Regardless, there was no justification for this change in behavior that
> was buried in what is otherwise a hoist patch, so revert it.  The author
> can resubmit the change with proper documentation.

I suspect that changes made later on (i.e. private mount namespaces
per runner instance) fixed the underlying namespace interaction
problem and made the recursive unmount unnecessary. The lack of
errors from it meant I likely forgot about it before I posted the
initial RFC that was merged...

> 
> Cc: <fstests@vger.kernel.org> # v2024.12.08
> Fixes: 4c6bc4565105e6 ("fstests: clean up mount and unmount operations")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  common/rc |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/common/rc b/common/rc
> index 4658e3b8be747f..07646927bad523 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -334,7 +334,7 @@ _put_mount()
>  _clear_mount_stack()
>  {
>  	if [ -n "$MOUNTED_POINT_STACK" ]; then
> -		_unmount -R $MOUNTED_POINT_STACK
> +		_unmount $MOUNTED_POINT_STACK
>  	fi
>  	MOUNTED_POINT_STACK=""
>  }

<tests>

That doesn't appear to cause any problems on my current
check-parallel stack, so I think the above explains how it got
there.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
