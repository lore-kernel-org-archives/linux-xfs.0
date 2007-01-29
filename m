Return-Path: <rpjday@mindspring.com>
Date: Mon, 29 Jan 2007 03:06:51 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [xfs-masters] [PATCH} XFS: Remove placeholders for unimplemented
 functionality.
In-Reply-To: <45BD7F0A.1000004@sandeen.net>
Message-ID: <Pine.LNX.4.64.0701290305240.12287@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0701281557410.11046@CPE00045a9c397f-CM001225dbafb6>
 <45BD7F0A.1000004@sandeen.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-masters@oss.sgi.com, Linux kernel mailing list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, dgc@sgi.com
List-ID: <xfs>

On Sun, 28 Jan 2007, Eric Sandeen wrote:

> Robert P. J. Day wrote:
> >   Remove a couple kernel config variables (FS_POSIX_CAP and
> > FS_POSIX_MAC) that represent placeholders for unimplemented
> > functionality.
> >
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> >
> > ---
>
> ...
>
> > diff --git a/fs/xfs/xfs_cap.h b/fs/xfs/xfs_cap.h
> > index 7a0e482..cfedfd1 100644
> > --- a/fs/xfs/xfs_cap.h
> > +++ b/fs/xfs/xfs_cap.h
>
> ...
>
> > -#else
> >  #define xfs_cap_vset(v,p,sz)	(-EOPNOTSUPP)
> >  #define xfs_cap_vget(v,p,sz)	(-EOPNOTSUPP)
> >  #define xfs_cap_vremove(v)	(-EOPNOTSUPP)
> >  #define _CAP_EXISTS		(NULL)
> > -#endif
> >
> >  #endif	/* __KERNEL__ */
>
> By the time you do this, probably may as well remove the whole file;
> the leftover 4 definitions never seem to be used.
>
> The same may go for xfs_mac.h.
>
> -Eric

good point.  david chinner (dgc) already mentioned that he'd prefer to
run this through the XFS tree so i'll leave this in his capable hands.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
