Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38855 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752338AbdDHQIB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Apr 2017 12:08:01 -0400
Date: Sat, 8 Apr 2017 09:07:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] libxfs: fix xfs_extent_busy_flush macro definition
Message-ID: <20170408160753.GQ4864@birch.djwong.org>
References: <20170408025255.GP4864@birch.djwong.org>
 <585a3bce-22f8-e162-87a7-bfa6e57ffad5@sandeen.net>
 <8860c7c7-4972-521c-44ec-c710136e2b49@sandeen.net>
 <20170408160533.GN4874@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170408160533.GN4874@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Sat, Apr 08, 2017 at 09:05:33AM -0700, Darrick J. Wong wrote:
> On Sat, Apr 08, 2017 at 09:41:54AM -0500, Eric Sandeen wrote:
> > On 4/8/17 9:26 AM, Eric Sandeen wrote:
> > > On 4/7/17 9:52 PM, Darrick J. Wong wrote:
> > >> xfs_extent_busy_flush is a void function, so don't reduce it to zero.
> > >> This shuts up gcc warnings about do-nothing statements.
> > >>
> > >> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Whoops, thanks.  Need to test w/ newer gcc I guess, sorry!
> > > 
> > > Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> > 
> > Oh, actually it seems that we use ((void) 0) pretty consistently
> > for these, i.e. -
> > 
> > #define xfs_extent_busy_reuse(mp,ag,bno,len,user)       ((void) 0)
> > 
> > and many others.  Probably best to be consistent; I may "fix" it to
> > that on commit, ok?
> 
> That works too.
> 
> You might consider fixing xfs_icsb_reinit_counters while you're at it,
> because that's where I picked up that idio[mt].
> 
> Oh, nobody calls xfs_icsb_reinit_counters.  Get rid of it then.

Oh, you already did.  Ho hum.

--D

> 
> --D
> 
> > 
> > -Eric
> > 
> > >> ---
> > >>  libxfs/libxfs_priv.h |    2 +-
> > >>  1 file changed, 1 insertion(+), 1 deletion(-)
> > >>
> > >> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> > >> index c2d4494..167786e 100644
> > >> --- a/libxfs/libxfs_priv.h
> > >> +++ b/libxfs/libxfs_priv.h
> > >> @@ -419,7 +419,7 @@ roundup_64(__uint64_t x, __uint32_t y)
> > >>  	*(busy_gen) = __foo;					\
> > >>  	false;							\
> > >>  })
> > >> -#define xfs_extent_busy_flush(mp,pag,busy_gen)		(0)
> > >> +#define xfs_extent_busy_flush(mp,pag,busy_gen)		do { } while(0)
> > >>  
> > >>  /* avoid unused variable warning */
> > >>  #define xfs_alloc_busy_insert(tp,ag,b,len)	({	\
> > >> --
> > >> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > >> the body of a message to majordomo@vger.kernel.org
> > >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >>
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
