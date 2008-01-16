Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Jan 2008 21:00:20 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0G4xV2a010711
	for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 20:59:34 -0800
Date: Wed, 16 Jan 2008 15:59:43 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [REVIEW] Refactor xfs_repair's process_dinode_int
Message-ID: <20080116045943.GU155407@sgi.com>
References: <4782B72D.8070208@agami.com> <47833C0F.6070206@agami.com> <op.t4m0r1an3jf8g2@pc-bnaujok.melbourne.sgi.com> <478D1899.9080201@agami.com> <op.t4zzbvbs3jf8g2@pc-bnaujok.melbourne.sgi.com> <478D75C2.5010004@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478D75C2.5010004@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Barry Naujok <bnaujok@sgi.com>, Chandan Talukdar <chandan@agami.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Jan 16, 2008 at 02:10:58PM +1100, Timothy Shimmin wrote:
> Not that it is a big deal....but my 2 cents...
> 
> Barry Naujok wrote:
> >On Wed, 16 Jan 2008 07:33:29 +1100, Chandan Talukdar <chandan@agami.com> 
> >wrote:
> >
> >>Hi Barry,
> >>
> >>- In process_misc_ino_types(), dino->di_core.di_size is being accessed 
> >>without being converted to machine format.  The check is being 
> >>performed against 0; so, it should be fine.  But for better code 
> >>readability, I guess it should be accessed through be64_to_cpu().
> >
> >Yeah... sort of in two-minds about this one.
> >
> Well, traditionally we would not be endian converting it.
> We don't endian convert things which are compared to zero or
> are only 1 byte. There are a bunch of examples in the kernel
> code (many Christoph has done) and we should be consistent IMHO.
> 
> (There is, of course, no point from a code point of view -

Exactly.

As a result the kernel does not have endian types for single
byte variables (ie. there's __be16, __be32, __be64 but not __be8),
nor are there cpu_to_be8 or be8_to_cpu conversion functions.
Hence the lack of them in the XFS code ;)

> I guess you might consider that you are letting people know
> that we need to endian convert this value in general and
> that if we change the code in the future it might be needed...

Well, that should be obvious when changing the structure
that has lots of __beX types in already....

> but just say no.:)

Agreed ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
