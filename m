Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1E0507F7D
	for <xfs@oss.sgi.com>; Fri, 24 Jan 2014 16:31:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 00F548F8054
	for <xfs@oss.sgi.com>; Fri, 24 Jan 2014 14:31:19 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	HDmDinE2RXSswOMH for <xfs@oss.sgi.com>;
	Fri, 24 Jan 2014 14:31:18 -0800 (PST)
Date: Sat, 25 Jan 2014 09:30:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V3] xfs_repair: add support for validating dirent ftype
	field
Message-ID: <20140124223053.GC26397@dastard>
References: <1390517573-29898-1-git-send-email-david@fromorbit.com>
	<52E26DD2.5020808@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52E26DD2.5020808@redhat.com>
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
Cc: xfs@oss.sgi.com

On Fri, Jan 24, 2014 at 08:42:42AM -0500, Brian Foster wrote:
> On 01/23/2014 05:52 PM, Dave Chinner wrote:
> > @@ -2189,6 +2238,59 @@ out_fix:
> >   * shortform directory v2 processing routines -- entry verification and
> >   * bad entry deletion (pruning).
> >   */
> > +static struct xfs_dir2_sf_entry *
> > +shortform_dir2_junk(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_dir2_sf_hdr	*sfp,
> > +	struct xfs_dir2_sf_entry *sfep,
> > +	xfs_ino_t		lino,
> > +	int			*max_size,
> > +	int			*index,
> > +	int			*bytes_deleted,
> > +	int			*ino_dirty)
> > +{
> > +	struct xfs_dir2_sf_entry *tmp_sfep;
> > +	int			tmp_len;
> > +	int			tmp_elen;
> > +
> > +	if (lino == orphanage_ino)
> > +		orphanage_ino = 0;
> > +	if (no_modify) {
> > +		do_warn(_("would junk entry\n"));
> > +		return NULL;
> 
> Argh, sorry I missed this last time. ;) This looks like a problem. In
> the no_modify case, we return NULL and 'continue' in the caller, which
> skips the loop end logic and leads to bad things.
> 
> We could calculate and return the next entry here, but it might be
> cleaner to use a goto instead of continue in the callers and not
> duplicate the logic.

Argh, my bad. I missed that too. As it is, we already calculate the
next entry in this function - tmp_sfep

> 
> > +	}
> > +
> > +	tmp_elen = xfs_dir3_sf_entsize(mp, sfp,
> > +					sfep->namelen);
> > +	tmp_sfep = (xfs_dir2_sf_entry_t *)
> > +		((__psint_t) sfep + tmp_elen);
> > +	tmp_len = *max_size - ((__psint_t) tmp_sfep
> > +				- (__psint_t) sfp);
> > +	*max_size -= tmp_elen;
> > +	*bytes_deleted += tmp_elen;
> > +
> > +	memmove(sfep, tmp_sfep, tmp_len);

What this code is doing is moving all the subsequent entries after
the one being junked down over the entry we are junking...

> > +
> > +	sfp->count -= 1;
> > +	memset((void *)((__psint_t)sfep + tmp_len), 0,
> > +			tmp_elen);

And then zeroing the remaining bytes of the region that is no
longer used.

So the no modify check needs to happen after calculating tmp_sfep
and return that...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
