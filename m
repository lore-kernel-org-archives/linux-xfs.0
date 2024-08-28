Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329FB15C0
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 00:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724803831; cv=none; b=m+/Jq1kucgUaEL5fm68wSscLwBPzDWTJICv1WsmJQmq5d6pj/YY+Y8TGAGh6vm9klKUJl2FJtuw+aijPpjybCjFIfdgOH017MAkO3uIt9ojIDlcDHYdfROyWdyjxmpHVQzRARqx7Rwjq9VNZ7eBeaAF/vOjavefRx1efmWEiUGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724803831; c=relaxed/simple;
	bh=NjeXv5Hbs+hc9RvWNFoYV7laf1iWeVB0xhKq01Ydd6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ghrU+Wuy72oDG/jtN0T2lTQwqcGHmkptyETYYvmC2Fqi/e/HEM+qUqLtcddb0VzR21RA/vfhiONdiSsr8pRgPg9hsDteH9y6f68JOWjWEGS5bxtKb7qf66ddByiuKYd+HnGTkMypMvgpYzcMnmFHF2wQqA0KdGHcXaAjff3PTDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=0lS9ZJNt; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="0lS9ZJNt"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-270263932d5so4254421fac.2
        for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 17:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724803828; x=1725408628; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TQgg2XyUk2wavSs0L0a/r4jPswjzBSiy0kfR2NDAhTs=;
        b=0lS9ZJNtvJKJv9bMYAtMuVd4XKavq+dJ++dzpOZ9YK3a1zHkl9PQgWjdubcLchjyfp
         R4Uby8r8Cy2HSXOo49mFxqqrJiXP+NLmZGSUYLg8QZtbS5d9aVC3GUC0KeQQoHTGAhDp
         dZ1VndnjXA8TF7imUEQ8l/TG1n2fjQs/aPCpuEI6c0KBnf+IY24rTRXKdm+byqoPDzLE
         rgS68w0W3O/DxGXpJGVCktAaSJrK83zBshraQPoPsFIZmwMYJQK0vQg/C1xNaSVeT6Tq
         Pkxue+h8yDdYjMsCTH6lg6g2e4j7EFQ8feLgYfTtkM7gVs/XmdfDKnpl2HbgrRb9hwbX
         wMgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724803828; x=1725408628;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TQgg2XyUk2wavSs0L0a/r4jPswjzBSiy0kfR2NDAhTs=;
        b=WLTOXESfOcIhZTfWM6DUF+R7KRlcYmeGfLD2syXL5TuWgQ0CbCggnSqA99AGa7F1gX
         T3iPA0b+3wUp0BksCb1Hdbrt7I+8u0FTfpyil4tPpmUzuVDKpf7pBKWjLBXL1fHdiMsw
         B34wSCztsjY+3X5lYky1VQigbbyGR0BiKV4m9WqAh/szDltout9z3A2KCGBhu79gpSBh
         oBgBB+2u0XH9yKGHz1PmXOe8XAMjyBdkN7ru4ACOe/imzrDgIOpRQX26hRKyPPey/WTA
         O6VNGLnpeYrVrZsbpsQ4tijqtc5SwiEp0OlW2NV5G1GtH598GdaN0OfC6e0Ql5AVIbdc
         cxaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKfhIMILCUBuNYM02nG7oCxpsL1LJ9ejTraH+zlcn/fa52yXZkYZwEFQPxuXjvhMyRKwnmR4UC/SA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqfZTkKfNIsdvWhrM8sGcao9uXgJLGNjr3H8c3hkCeGaf993lL
	XnmgTu3AlscNj5Y8aBzT/v2sXAao5eokIBPJRwCMXnlAQVP1n5Ho2mwfO45/rYZprCUrZJPG3rO
	g
X-Google-Smtp-Source: AGHT+IFlU2EJx+js/4Fq6LQJKiFGkYCYsRA1uiBI/UBeb5LJUfmtNCsBOgXmjJzTfwH1+xjs426kRg==
X-Received: by 2002:a05:6870:c6a2:b0:260:ff24:fb32 with SMTP id 586e51a60fabf-273e63d0d32mr16876860fac.1.1724803828153;
        Tue, 27 Aug 2024 17:10:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-65.pa.nsw.optusnet.com.au. [49.179.0.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71434252454sm9083098b3a.75.2024.08.27.17.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 17:10:27 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sj6GW-00F7kl-01;
	Wed, 28 Aug 2024 10:10:24 +1000
Date: Wed, 28 Aug 2024 10:10:23 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: bugzilla-daemon@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [Bug 219203] New: xfsprogs-6.10.0: missing cast in
 /usr/include/xfs/xfs_fs.h(xfs_getparents_next_rec) causes error in C++
 compilations
Message-ID: <Zs5q79AQcimOBeZB@dread.disaster.area>
References: <bug-219203-201763@https.bugzilla.kernel.org/>
 <Zs5Hvxzxiq3wQGU7@dread.disaster.area>
 <20240827223052.GD1977952@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827223052.GD1977952@frogsfrogsfrogs>

On Tue, Aug 27, 2024 at 03:30:52PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 28, 2024 at 07:40:15AM +1000, Dave Chinner wrote:
> > On Tue, Aug 27, 2024 at 09:07:03PM +0000, bugzilla-daemon@kernel.org wrote:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=219203
> > > 
> > >             Bug ID: 219203
> > >            Summary: xfsprogs-6.10.0: missing cast in
> > >                     /usr/include/xfs/xfs_fs.h(xfs_getparents_next_rec)
> > >                     causes error in C++ compilations
> > >            Product: File System
> > >            Version: 2.5
> > >           Hardware: All
> > >                 OS: Linux
> > >             Status: NEW
> > >           Severity: normal
> > >           Priority: P3
> > >          Component: XFS
> > >           Assignee: filesystem_xfs@kernel-bugs.kernel.org
> > >           Reporter: kernel@mattwhitlock.name
> > >         Regression: No
> > > 
> > > C allows implicit casts from void* to any pointer type, but C++ does not. Thus,
> > > when including <xfs/xfs_fs.h> in a C++ compilation unit, the compiler raises
> > > this error:
> > > 
> > > /usr/include/xfs/xfs_fs.h: In function 'xfs_getparents_rec*
> > > xfs_getparents_next_rec(xfs_getparents*, xfs_getparents_rec*)':
> > > /usr/include/xfs/xfs_fs.h:915:16: error: invalid conversion from 'void*' to
> > > 'xfs_getparents_rec*' [-fpermissive]
> > >   915 |         return next;
> > >       |                ^~~~
> > >       |                |
> > >       |                void*
> > > 
> > > 
> > > The return statement in xfs_getparents_next_rec() should have used an explicit
> > > cast, as the return statement in xfs_getparents_first_rec() does.
> > > 
> > > --- /usr/include/xfs/xfs_fs.h
> > > +++ /usr/include/xfs/xfs_fs.h
> > > @@ -912,7 +912,7 @@
> > >         if (next >= end)
> > >                 return NULL;
> > > 
> > > -       return next;
> > > +       return (struct xfs_getparents_rec *)next;
> > >  }
> > 
> > We shouldn't be putting static inline code in xfs_fs.h. That header
> > file is purely for kernel API definitions. Iterator helper functions
> > aren't part of the kernel API definition - they should be in some
> > other exported header file if they are needed at all. The helpers
> > could be defined in the getparents man page in the example code that
> > uses them rather than exposing the C code to the world...
> > 
> > I note that we've recently added a static inline function type
> > checking function to xfs_types.h rather than it being an external
> > function declaration, so there's more than one header file that
> > needs cleanup....
> 
> XFS has been exporting tons of static inline functions via xfslibs-dev
> for ages:
> 
> $ grep static.*inline /usr/include/xfs/ | wc -l
> 103

Yes, but have you looked at what they are?

$ grep -Rl static.*inline /usr/include/xfs/
/usr/include/xfs/linux.h
/usr/include/xfs/xfs_arch.h
/usr/include/xfs/xfs_da_format.h
/usr/include/xfs/xfs_format.h
/usr/include/xfs/xfs_fs.h
/usr/include/xfs/xfs_log_format.h
/usr/include/xfs/xfs_types.h
$

The platform functions (linux.h) are explicitly
shipped as static inlines to avoid needing a compiled library to
use.

The byte swapping (xfs_arch.h) is a mess of macros and static
inlines that have no external dependencies. They are simply byte
swapping functions.

The on-disk format headers contain some helper functions. We try to
keep them out of htose headers because of the wide includes they get
in kernel and that creates header dependency hell. Hence the only
static inline code in them allowed is code that only uses structures
already specifically defined in the on-disk format header functions.
This avoids the dependency hell that these foundational header files
might otherwise create.

Further, they have nothing to do with the actual kernel API or
fundamental XFS type definitions, so very few applications are
actually using these header files. Hence it's not critical to keep
code out of them, and we -never- care if they fail to compile with
c++ compilers because they are aren't for general application
usage....

That leaves xfs_fs.h and xfs_types.h:

$ grep static.*inline libxfs/xfs_fs.h libxfs/xfs_types.h
libxfs/xfs_fs.h:static inline uint32_t
libxfs/xfs_fs.h:static inline struct xfs_getparents_rec *
libxfs/xfs_fs.h:static inline struct xfs_getparents_rec *
libxfs/xfs_types.h:static inline bool
$

There are -four- functions in 6.10, up from 2 in 6.9. These 2 new
helper functions are the source of the problem. IOWs, our general
rule to keep code out of these two files has largely worked over the
years...

> And the kernel itself has been doing that for years:
> 
> $ grep static.*inline /usr/include/linux/ | wc -l
> 348

Direct kernel uapi header includes are a different issue and the
policy for them is not in our control at all.

> ...most of which don't trip g++ errors.  This was the first thing that
> broke a build somewhere, because neither the kernel nor xfsprogs use
> the C++ compiler.
> 
> Shouldn't code review have caught these kinds of problems? Why wasn't
> there any automated testing to identify these issues before they got
> merged?  How many more guardrails do I get to build??

We've used the "no code in xfs_fs.h and xfs_types.h" rule to avoid
these problems in the past. The whole point of xfs_types.c existing
is to provide a location for type verifier code that isn't
xfs_types.h. The verification code has dependencies on xfs_mount,
xfs_perag, etc, and we simply cannot put such code in xfs_types.h
because it creates circular header file dependencies.

IOWs, xfs_fs.h and xfs_types.h are foundational definitions for both
kernel and userspace code. Adding static inline code into them leads
to external header dependencies, and that is something we have
always tried our best to avoid.  Hence the general rule is no static
inline code in these header files.

Clearly this was missed in review - it's a tiny chunk of code in the
massive merges that have recently occurred, and so it's no surprise
that little things like this get missed when reviewing tens of 
thousands of lines of new code.

> Or: should we add a dummy cpp source file to xfsprogs that includes
> xfs.h so that developers have some chance of finding potential C++
> errors sooner than 6 weeks after the kernel release?

Put whatever thing you want in place to catch header compilation
issues in userspace, but the basic, fundamental principle is that no
static inline code should be placed in xfs_types.h and xfs_fs.h.

> So far as I can tell, this fixes the c++ compilation errors, at least
> with gcc 12:
> 
> diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
> index 0613239cad13..8fc305cce06b 100644
> --- a/libxfs/xfs_fs.h
> +++ b/libxfs/xfs_fs.h
> @@ -971,13 +971,13 @@ static inline struct xfs_getparents_rec *
>  xfs_getparents_next_rec(struct xfs_getparents *gp,
>                         struct xfs_getparents_rec *gpr)
>  {
> -       void *next = ((void *)gpr + gpr->gpr_reclen);
> +       void *next = ((char *)gpr + gpr->gpr_reclen);
>         void *end = (void *)(uintptr_t)(gp->gp_buffer + gp->gp_bufsize);
>  
>         if (next >= end)
>                 return NULL;
>  
> -       return next;
> +       return (struct xfs_getparents_rec *)next;
>  }

Sure, that fixes the compilation problem, but that's not the bug
that needs to be fixed. This code should not have been added to this
file in the first place.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
