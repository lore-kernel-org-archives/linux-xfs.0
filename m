Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7DF1552ED
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 22:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724797853; cv=none; b=aaJahkUwIMNkHJuUtPcMuDlCf43i8tL4mZzvtLo04lpbuLxG3U+FctkZVGtm0ed44qqkeJ0CAd3lQoY6gdcmP4XKIs3hxAMcUYshEQiZJ6Ky9TZBeaGpbbS99ywTDcIuO1vSGsuUS6Zg8uJtfTxI3q3VPj3R8khjSSs20/1yVOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724797853; c=relaxed/simple;
	bh=XoGOlXKl3isWVW74oyKsTV53WPs3PxekAJ7ykI40VVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lh4oZsqUvoNKDIGDzSWm64IHuiATXHvdJM7YmCar9crKXA2qvXjRIDW1yfuz8yKoM6Bx+cASyFipxeRUQ0biWEmZe+vvnAH6V9fvW5J4agE/muHUdWh8S6df8K2JSBlWJgxcuE5X7ZrWdtTkWpj5Txh5s7VPWMEKHVFj+nzd6Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W9cis3jx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W9cis3jx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669C2C4DDF8;
	Tue, 27 Aug 2024 22:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724797853;
	bh=XoGOlXKl3isWVW74oyKsTV53WPs3PxekAJ7ykI40VVU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W9cis3jxYsIdL4xbK2LEOIAdPYW+E8Am61spDOXwr7A7gTBhWEO0yUwVideodo+R3
	 6J/fM2SanmYGz5K1GSw5RwD7WUMvmt+a+qbhYoh3w6Y2V2NGbGs291y43BaWjahbrL
	 Pu4tFjqjtmGxddSGTBAgFoY55ehYcO1CVv0N0JfRhzXRQtog17dmZpatKZUrEE2tMY
	 HC43U0nfyHBjO7xena2Qrjbh0wB5nzu0B4zrKbP5NUw5PlR8UQepqAHwE8zRv+shcg
	 +siq5skCh+AI9N4DI/hRanomeyCdZJPTK7C6Ck+YWpDAQj3CTYIBq8Ht+5llJh9t4L
	 EQMkJmm7ZKvdg==
Date: Tue, 27 Aug 2024 15:30:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: bugzilla-daemon@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [Bug 219203] New: xfsprogs-6.10.0: missing cast in
 /usr/include/xfs/xfs_fs.h(xfs_getparents_next_rec) causes error in C++
 compilations
Message-ID: <20240827223052.GD1977952@frogsfrogsfrogs>
References: <bug-219203-201763@https.bugzilla.kernel.org/>
 <Zs5Hvxzxiq3wQGU7@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs5Hvxzxiq3wQGU7@dread.disaster.area>

On Wed, Aug 28, 2024 at 07:40:15AM +1000, Dave Chinner wrote:
> On Tue, Aug 27, 2024 at 09:07:03PM +0000, bugzilla-daemon@kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=219203
> > 
> >             Bug ID: 219203
> >            Summary: xfsprogs-6.10.0: missing cast in
> >                     /usr/include/xfs/xfs_fs.h(xfs_getparents_next_rec)
> >                     causes error in C++ compilations
> >            Product: File System
> >            Version: 2.5
> >           Hardware: All
> >                 OS: Linux
> >             Status: NEW
> >           Severity: normal
> >           Priority: P3
> >          Component: XFS
> >           Assignee: filesystem_xfs@kernel-bugs.kernel.org
> >           Reporter: kernel@mattwhitlock.name
> >         Regression: No
> > 
> > C allows implicit casts from void* to any pointer type, but C++ does not. Thus,
> > when including <xfs/xfs_fs.h> in a C++ compilation unit, the compiler raises
> > this error:
> > 
> > /usr/include/xfs/xfs_fs.h: In function 'xfs_getparents_rec*
> > xfs_getparents_next_rec(xfs_getparents*, xfs_getparents_rec*)':
> > /usr/include/xfs/xfs_fs.h:915:16: error: invalid conversion from 'void*' to
> > 'xfs_getparents_rec*' [-fpermissive]
> >   915 |         return next;
> >       |                ^~~~
> >       |                |
> >       |                void*
> > 
> > 
> > The return statement in xfs_getparents_next_rec() should have used an explicit
> > cast, as the return statement in xfs_getparents_first_rec() does.
> > 
> > --- /usr/include/xfs/xfs_fs.h
> > +++ /usr/include/xfs/xfs_fs.h
> > @@ -912,7 +912,7 @@
> >         if (next >= end)
> >                 return NULL;
> > 
> > -       return next;
> > +       return (struct xfs_getparents_rec *)next;
> >  }
> 
> We shouldn't be putting static inline code in xfs_fs.h. That header
> file is purely for kernel API definitions. Iterator helper functions
> aren't part of the kernel API definition - they should be in some
> other exported header file if they are needed at all. The helpers
> could be defined in the getparents man page in the example code that
> uses them rather than exposing the C code to the world...
> 
> I note that we've recently added a static inline function type
> checking function to xfs_types.h rather than it being an external
> function declaration, so there's more than one header file that
> needs cleanup....

XFS has been exporting tons of static inline functions via xfslibs-dev
for ages:

$ grep static.*inline /usr/include/xfs/ | wc -l
103

And the kernel itself has been doing that for years:

$ grep static.*inline /usr/include/linux/ | wc -l
348

...most of which don't trip g++ errors.  This was the first thing that
broke a build somewhere, because neither the kernel nor xfsprogs use
the C++ compiler.

Shouldn't code review have caught these kinds of problems?  Why wasn't
there any automated testing to identify these issues before they got
merged?  How many more guardrails do I get to build??

Or: should we add a dummy cpp source file to xfsprogs that includes
xfs.h so that developers have some chance of finding potential C++
errors sooner than 6 weeks after the kernel release?

So far as I can tell, this fixes the c++ compilation errors, at least
with gcc 12:

diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 0613239cad13..8fc305cce06b 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -971,13 +971,13 @@ static inline struct xfs_getparents_rec *
 xfs_getparents_next_rec(struct xfs_getparents *gp,
                        struct xfs_getparents_rec *gpr)
 {
-       void *next = ((void *)gpr + gpr->gpr_reclen);
+       void *next = ((char *)gpr + gpr->gpr_reclen);
        void *end = (void *)(uintptr_t)(gp->gp_buffer + gp->gp_bufsize);
 
        if (next >= end)
                return NULL;
 
-       return next;
+       return (struct xfs_getparents_rec *)next;
 }


--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
