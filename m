Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Nov 2007 21:19:05 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA75Isf5024386
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2007 21:18:57 -0800
Date: Wed, 7 Nov 2007 16:18:48 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: use is_power_of_2() macro?
Message-ID: <20071107051848.GI995458@sgi.com>
References: <Pine.LNX.4.64.0711061026210.9329@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711061026210.9329@localhost.localdomain>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: xfs@oss.sgi.com

On Tue, Nov 06, 2007 at 10:28:44AM -0500, Robert P. J. Day wrote:
> 
>   given this in fs/xfs/xfs_inode.c:
> 
> /*
>  * xfs_iroundup: round up argument to next power of two
>  */
> uint
> xfs_iroundup(
>         uint    v)
> {
>         int i;
>         uint m;
> 
>         if ((v & (v - 1)) == 0)
>                 return v;
>         ASSERT((v & 0x80000000) == 0);
>         if ((v & (v + 1)) == 0)
>                 return v + 1;
>         for (i = 0, m = 1; i < 31; i++, m <<= 1) {
>                 if (v & m)
>                         continue;
>                 v |= m;
>                 if ((v & (v + 1)) == 0)
>                         return v + 1;
>         }
>         ASSERT(0);
>         return( 0 );
> }
> 
>   is there any reason that can't be rewritten with simply
> roundup_pow_of_two() as defined in include/linux/log2.h?
> 
> #define roundup_pow_of_two(n)                   \
> (                                               \
>         __builtin_constant_p(n) ? (             \
>                 (n == 1) ? 1 :                  \
>                 (1UL << (ilog2((n) - 1) + 1))   \
>                                    ) :          \
>         __roundup_pow_of_two(n)                 \
>  )
> 
>   just curious.

No - patch please.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
