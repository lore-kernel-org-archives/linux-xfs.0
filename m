Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EED26AC7
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 20:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="n58jq0HD"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-28c93513462so3530292a91.2
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 12:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705004221; x=1705609021; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rT2x4y2ebv2oPX4ti9HsDbnA2dvYDOyMcUyFn2RzObw=;
        b=n58jq0HDHndfNpDiGfd/lrixaw8EkZE/3ql/5Y8nVsJllVHX1YjacORDC+DLgsm9FH
         Es7LyXaF8mH17/FN3Y05bh5TwzV+NivHXy8fb+djQ3MQqkyvc6+zDuQ2f42KnpPd7wqA
         n4iqZtSHrNxrjgOJdljeoP40t6RA7BKC7okx5VDO0Aa14ymBWVtI3qjB1kGR+EP4ND87
         z6Uu2Wbm74Da634tX0EHLmRnfvx6CZYVh2NdelBFG2IG+fToKNJyAFuwcU09JHI0d3P6
         M+q13/z+H6HKsGqw+yI9/J9aEphrywRPrY9DOEUtRqegaGfpY1nA03txVIW3vRdua59d
         LoGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705004221; x=1705609021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rT2x4y2ebv2oPX4ti9HsDbnA2dvYDOyMcUyFn2RzObw=;
        b=TlATzfWeqPZx9hPnuUPDAPLI/SDs3L8+VEk/4WYYXCeGVwpSTkTnsGu0F8i0D5u07U
         FMIa9YdkQi7FCEUXe+g3Bc1zBpWoQ690FaqnS0JTOJXAefgydaBEIZdN/QOlV0s6cebm
         rQUOFs5b8f8BV+43KB2X19urMGBC+fJ83UJ6SvHih1IyO8vVjlaivl8CopYenSUdHMbf
         qIXqhBAEJT3HvtDwfauUIieEaM7b1O1/idYjpxELFRUr4v1dDhMs3NSYMK6aGxPkxrjU
         uhGBa6BhPVRNbgUcIKmqnNSQkQFU1AwVX3owyqN4PBfIL4U31fg+fC0oEoHdtaxMJ4pw
         v/mQ==
X-Gm-Message-State: AOJu0Yz69ooUV4zE4IE7HaRkFryBpgtsUMgb5+ATZQubtIc2gCJ9QKVI
	ncWauolizubG/Bk9dWysDNR/BFUASr3ZjQ==
X-Google-Smtp-Source: AGHT+IEIUjO4YVUxg2h8IL2WXOfR99JrAbutFiRwdiitKvtn5NWN1DEx9wg3vhPcPdBtihyeK5FeZw==
X-Received: by 2002:a17:90b:1c86:b0:28c:b450:a3e6 with SMTP id oo6-20020a17090b1c8600b0028cb450a3e6mr328161pjb.72.1705004221127;
        Thu, 11 Jan 2024 12:17:01 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id sm2-20020a17090b2e4200b0028d134a9223sm4397430pjb.8.2024.01.11.12.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jan 2024 12:17:00 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rO1U1-0095ek-1v;
	Fri, 12 Jan 2024 07:16:57 +1100
Date: Fri, 12 Jan 2024 07:16:57 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jian Wen <wenjianhn@gmail.com>, linux-xfs@vger.kernel.org, hch@lst.de,
	dchinner@redhat.com, Jian Wen <wenjian1@xiaomi.com>
Subject: Re: [PATCH] xfs: explicitly call cond_resched in
 xfs_itruncate_extents_flags
Message-ID: <ZaBMuWGAo3E6+HWj@dread.disaster.area>
References: <20240110071347.3711925-1-wenjian1@xiaomi.com>
 <20240110174501.GH722975@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240110174501.GH722975@frogsfrogsfrogs>

On Wed, Jan 10, 2024 at 09:45:01AM -0800, Darrick J. Wong wrote:
> On Wed, Jan 10, 2024 at 03:13:47PM +0800, Jian Wen wrote:
> > From: Jian Wen <wenjianhn@gmail.com>
> > 
> > Deleting a file with lots of extents may cause a soft lockup if the
> > preemption model is none(CONFIG_PREEMPT_NONE=y or preempt=none is set
> > in the kernel cmdline). Alibaba cloud kernel and Oracle UEK container
> > kernel are affected by the issue, since they select CONFIG_PREEMPT_NONE=y.
> > 
> > Explicitly call cond_resched in xfs_itruncate_extents_flags avoid
> > the below softlockup warning.
> > watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [kworker/0:13:139]
> 
> Wowwee, how many extents does this file have, anyway?

IIRC, extent removal runs at about 50,000 extents/s on a typical
modern CPU on a production kernel build when everything is cached.
23s then equates to a bit above a million extents....

> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index c0f1c89786c2..194381e10472 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -4,6 +4,7 @@
> >   * All Rights Reserved.
> >   */
> >  #include <linux/iversion.h>
> > +#include <linux/sched.h>
> >  
> >  #include "xfs.h"
> >  #include "xfs_fs.h"
> > @@ -1383,6 +1384,8 @@ xfs_itruncate_extents_flags(
> >  		error = xfs_defer_finish(&tp);
> >  		if (error)
> >  			goto out;
> > +
> > +		cond_resched();
> 
> Is there a particular reason why truncation uses a giant chained
> transaction for all extents (with xfs_defer_finish) instead of, say, one
> chain per extent?

IIUC the question correctly, extent removal for a given range ibeing
truncated has to been seen externally as an atomic change so the
ILOCK has to held across the entire removal operation.

This means it has to be executed as a single rolling transaction as
transaction reservation cannot be done with the ILOCK held and the
atomicity of extent removal prevents the ILOCK from being dropped.

This atomicity only really matters for active operations
like truncate, hole punching, etc when other operations may also be
trying to act on the extent list. However, in inodegc, we are
essentially guaranteed that nobody else will need to access the
extent list whilst we are truncating them away, so it could be done
as a bunch of fine grained transactions.

However, this doesn't solve the problem the CPU never being yeilded
if everything is cached and no locks or transaction reservations are
ever contended. It will still hold the CPU for the same length of
time. Hence I'm not sure changing the way the transactions are run
will really change anything material w.r.t. the issue at hand.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
