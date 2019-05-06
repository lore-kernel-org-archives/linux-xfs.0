Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58221 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726063AbfEFWvF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 May 2019 18:51:05 -0400
Date: Tue, 7 May 2019 08:51:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] db/malloc: Use posix_memalign instead of deprecated
 valloc
Message-ID: <20190506225101.GN29573@dread.disaster.area>
References: <20190506210326.29581-1-rosenp@gmail.com>
 <b85f5489-70ed-3145-3989-592ee1de3899@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b85f5489-70ed-3145-3989-592ee1de3899@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Rosen Penev <rosenp@gmail.com>, linux-xfs@vger.kernel.org

On Mon, May 06, 2019 at 05:20:11PM -0500, Eric Sandeen wrote:
> 
> 
> On 5/6/19 4:03 PM, Rosen Penev wrote:
> > valloc is not available with uClibc-ng as well as being deprecated, which
> > causes compilation errors. aligned_alloc is not available before C11 so
> > used posix_memalign.'
> > 
> > Signed-off-by: Rosen Penev <rosenp@gmail.com>
> > ---
> >  db/malloc.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/db/malloc.c b/db/malloc.c
> > index 77b3e022..38fe0b05 100644
> > --- a/db/malloc.c
> > +++ b/db/malloc.c
> > @@ -44,8 +44,7 @@ xmalloc(
> >  {
> >  	void	*ptr;
> >  
> > -	ptr = valloc(size);
> > -	if (ptr)
> > +	if(!posix_memalign(&ptr, sysconf(_SC_PAGESIZE), size))
> 
> 
> I'll stick a space after the 'if' but otherwise, seems fine, thanks.
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Can we just get rid of db/malloc.[ch]? They are just a set
of wrappers that exit() when malloc fails, largely used by the
deprecated xfs_check functionality we still have hidden inside
xfs_db. Be a useful code self-documentation exercise to get rid
of them to indicate that the callers don't actually handle malloc
failures at all....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
