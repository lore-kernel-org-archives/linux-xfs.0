Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3D0A67F5F
	for <xfs@oss.sgi.com>; Fri, 13 Jun 2014 10:02:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 120A3304039
	for <xfs@oss.sgi.com>; Fri, 13 Jun 2014 08:02:12 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id FCIpLcdwSxsiuOAe (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Jun 2014 08:02:10 -0700 (PDT)
Date: Fri, 13 Jun 2014 17:02:07 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] xfs: Fix rounding in xfs_alloc_fix_len()
Message-ID: <20140613150207.GA24615@quack.suse.cz>
References: <1401900833-25485-1-git-send-email-jack@suse.cz>
	<20140604184440.GC55624@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140604184440.GC55624@bfoster.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: dchinner@redhat.com, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Wed 04-06-14 14:44:40, Brian Foster wrote:
> On Wed, Jun 04, 2014 at 06:53:53PM +0200, Jan Kara wrote:
> > Rounding in xfs_alloc_fix_len() is wrong. As the comment states, the
> > result should be a number of a form (k*prod+mod) however due to sign
> > mistake the result is different. As a result allocations on raid arrays
> > could be misaligned in some cases.
> > 
> > This also seems to fix occasional assertion failure:
> > 	XFS_WANT_CORRUPTED_GOTO(rlen <= flen, error0)
> > in xfs_alloc_ag_vextent_size().
> > 
> > Also add an assertion that the result of xfs_alloc_fix_len() is of
> > expected form.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> 
> Looks good to me. Thanks Jan.
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
  Ping Dave? Are you going to pick up this patch?

							Honza
 
> >  fs/xfs/xfs_alloc.c | 18 ++++++++----------
> >  1 file changed, 8 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
> > index c1cf6a336a72..1351a24d3cdc 100644
> > --- a/fs/xfs/xfs_alloc.c
> > +++ b/fs/xfs/xfs_alloc.c
> > @@ -257,16 +257,14 @@ xfs_alloc_fix_len(
> >  	k = rlen % args->prod;
> >  	if (k == args->mod)
> >  		return;
> > -	if (k > args->mod) {
> > -		if ((int)(rlen = rlen - k - args->mod) < (int)args->minlen)
> > -			return;
> > -	} else {
> > -		if ((int)(rlen = rlen - args->prod - (args->mod - k)) <
> > -		    (int)args->minlen)
> > -			return;
> > -	}
> > -	ASSERT(rlen >= args->minlen);
> > -	ASSERT(rlen <= args->maxlen);
> > +	if (k > args->mod)
> > +		rlen = rlen - (k - args->mod);
> > +	else
> > +		rlen = rlen - args->prod + (args->mod - k);
> > +	if ((int)rlen < (int)args->minlen)
> > +		return;
> > +	ASSERT(rlen >= args->minlen && rlen <= args->maxlen);
> > +	ASSERT(rlen % args->prod == args->mod);
> >  	args->len = rlen;
> >  }
> >  
> > -- 
> > 1.8.1.4
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
