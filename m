Return-Path: <SRS0+050ae81fe5823cd14c68+1254+infradead.org+hch@pentafluge.srs.infradead.org>
Date: Mon, 29 Jan 2007 07:01:03 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [xfs-masters] [PATCH} XFS: Remove placeholders for unimplemented functionality.
Message-ID: <20070129070103.GA32274@infradead.org>
References: <Pine.LNX.4.64.0701281557410.11046@CPE00045a9c397f-CM001225dbafb6> <45BD7F0A.1000004@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BD7F0A.1000004@sandeen.net>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-masters@oss.sgi.com, Linux kernel mailing list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, dgc@sgi.com
List-ID: <xfs>

On Sun, Jan 28, 2007 at 10:58:50PM -0600, Eric Sandeen wrote:
> >-#else
> > #define xfs_cap_vset(v,p,sz)	(-EOPNOTSUPP)
> > #define xfs_cap_vget(v,p,sz)	(-EOPNOTSUPP)
> > #define xfs_cap_vremove(v)	(-EOPNOTSUPP)
> > #define _CAP_EXISTS		(NULL)
> >-#endif
> >
> > #endif	/* __KERNEL__ */
> 
> By the time you do this, probably may as well remove the whole file; the 
> leftover 4 definitions never seem to be used.
> 
> The same may go for xfs_mac.h.

Agreed.  As Dave said if we get this functionality on Linux it will most
likely be handled at a different level, so keeping the old IRIX-style hooks
is rather pointless.
