Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53626 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbeJCUta (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Oct 2018 16:49:30 -0400
Received: by mail-wm1-f66.google.com with SMTP id b19-v6so5841618wme.3
        for <linux-xfs@vger.kernel.org>; Wed, 03 Oct 2018 07:00:58 -0700 (PDT)
Date: Wed, 3 Oct 2018 16:00:54 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] xfs: Add new constant to mark start of xqmstat
Message-ID: <20181003140054.5kjzhfuit35zldkl@odin.usersys.redhat.com>
References: <20181003123537.30965-1-cmaiolino@redhat.com>
 <20181003123537.30965-3-cmaiolino@redhat.com>
 <eacf197c-98d7-4507-a40f-cf32d49bb5eb@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eacf197c-98d7-4507-a40f-cf32d49bb5eb@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 03, 2018 at 07:51:43AM -0500, Eric Sandeen wrote:
> On 10/3/18 7:35 AM, Carlos Maiolino wrote:
> > xqmstat information under __xfsstats is used directly by the
> > /proc/fs/xfs/xqmstat show method, which makes use of struct offsets to
> > print out the values.
> > 
> > Currently, the function is setup to start printing values from the offset of
> > the last marker before xqmstat, so, an update to __xfsstats structure
> > may also require an update of xqmstat_proc_show() function.
> > 
> > By adding a new constant, we concentrate any updates do __xfsstats
> > structure fields locally to the file xfs_stats.h, reducing the
> > likelyhood of future bugs if an update to xqmstat_proc_show is
> > forgotten as have happened before.
> 
> did 
> 
> BUILD_BUG_ON(offsetof(struct __xfsstats, xs_qm_dqreclaims)/sizeof(uint32_t)) != XFSSTAT_START_XQMSTAT);
> 
> and/or
> 
> #define XFSSTAT_START_XQMSTAT	(offsetof(struct __xfsstats, xs_qm_dqreclaims)/sizeof(uint32_t))

Yup, it worked, although, it still doesn't really close the possibility for
mistakes here, the first field may change for example and we may end up in the
same situation.

I think only the 2nd option (defining START via offsetof), doesn't differ much
from the approach in the patch, and, using the 1st option (BUILD_BUG_ON), will
require an update to xqmstat_proc_show() if by any reason we change the quota
values, so, I thought the simpler version as the patch would suffice and be a
bit less confusing. But well, feel free to disagree, it's my opinion only and
not written on stone :P

> 
> not work out?
> 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  fs/xfs/xfs_stats.c | 2 +-
> >  fs/xfs/xfs_stats.h | 1 +
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> > index 740ac9674848..09121c36a062 100644
> > --- a/fs/xfs/xfs_stats.c
> > +++ b/fs/xfs/xfs_stats.c
> > @@ -119,7 +119,7 @@ static int xqmstat_proc_show(struct seq_file *m, void *v)
> >  	int j;
> >  
> >  	seq_printf(m, "qm");
> > -	for (j = XFSSTAT_END_REFCOUNT; j < XFSSTAT_END_XQMSTAT; j++)
> > +	for (j = XFSSTAT_START_XQMSTAT; j < XFSSTAT_END_XQMSTAT; j++)
> >  		seq_printf(m, " %u", counter_val(xfsstats.xs_stats, j));
> >  	seq_putc(m, '\n');
> >  	return 0;
> > diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
> > index 130db070e4d8..102e794addac 100644
> > --- a/fs/xfs/xfs_stats.h
> > +++ b/fs/xfs/xfs_stats.h
> > @@ -147,6 +147,7 @@ struct __xfsstats {
> >  	uint32_t		xs_rmap_2[__XBTS_MAX];
> >  #define XFSSTAT_END_REFCOUNT		(XFSSTAT_END_RMAP_V2 + __XBTS_MAX)
> >  	uint32_t		xs_refcbt_2[__XBTS_MAX];
> > +#define XFSSTAT_START_XQMSTAT		XFSSTAT_END_REFCOUNT
> >  #define XFSSTAT_END_XQMSTAT		(XFSSTAT_END_REFCOUNT + 6)
> >  	uint32_t		xs_qm_dqreclaims;
> >  	uint32_t		xs_qm_dqreclaim_misses;
> > 

-- 
Carlos
