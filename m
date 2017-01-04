Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60260 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752861AbdADK6o (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Jan 2017 05:58:44 -0500
Date: Wed, 4 Jan 2017 11:58:40 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] Fix max_retries _show and _store functions
Message-ID: <20170104105840.mr54e3ypljphb2pd@eorzea.usersys.redhat.com>
References: <20170103175331.8089-1-cmaiolino@redhat.com>
 <7818525d-fd15-d245-a958-1648b5df3ecd@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7818525d-fd15-d245-a958-1648b5df3ecd@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 03, 2017 at 12:19:53PM -0600, Eric Sandeen wrote:
> On 1/3/17 11:53 AM, Carlos Maiolino wrote:
> > max_retries _show and _store functions should test against cfg->max_retries,
> > not cfg->retry_timeout
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> Whoever made those mistakes should be very ashamed.  ;)
> I guess it was a cut and paste error.  :(
> 
> This should probably cc: stable, too.

Yeah, I believe so,

maybe if I just forward the patch to stable might work? 
> 
> Thanks,
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> > ---
> >  fs/xfs/xfs_sysfs.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> > index 276d302..de6195e 100644
> > --- a/fs/xfs/xfs_sysfs.c
> > +++ b/fs/xfs/xfs_sysfs.c
> > @@ -396,7 +396,7 @@ max_retries_show(
> >  	int		retries;
> >  	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
> >  
> > -	if (cfg->retry_timeout == XFS_ERR_RETRY_FOREVER)
> > +	if (cfg->max_retries == XFS_ERR_RETRY_FOREVER)
> >  		retries = -1;
> >  	else
> >  		retries = cfg->max_retries;
> > @@ -422,7 +422,7 @@ max_retries_store(
> >  		return -EINVAL;
> >  
> >  	if (val == -1)
> > -		cfg->retry_timeout = XFS_ERR_RETRY_FOREVER;
> > +		cfg->max_retries = XFS_ERR_RETRY_FOREVER;
> >  	else
> >  		cfg->max_retries = val;
> >  	return count;
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
