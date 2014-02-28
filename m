Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 627127F4E
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 22:46:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F1B30AC001
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 20:46:21 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	rfnyC3DWXdLjLDgw for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 20:46:20 -0800 (PST)
Date: Fri, 28 Feb 2014 15:46:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, V2] metadump: don't verify metadata being dumped
Message-ID: <20140228044617.GK30131@dastard>
References: <1393548825-16499-1-git-send-email-david@fromorbit.com>
	<20140228025138.GJ30131@dastard> <53100B2D.8000509@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53100B2D.8000509@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, Feb 27, 2014 at 10:06:05PM -0600, Eric Sandeen wrote:
> On 2/27/14, 8:51 PM, Dave Chinner wrote:
> > @@ -1374,6 +1384,7 @@ process_single_fsb_objects(
> >  		o++;
> >  		dp += mp->m_sb.sb_blocksize;
> >  	}
> > +	iocur_top->need_crc = 1;
> 
> in the 
> 
> default:
> 
> case we don't obfuscate.  Should it still get need_crc?

Ah, right. I looked at the "dont_obfuscate" jump, not the switch
statement. Will fix.

> > +/*
> > + * when we process the inode, we may change the data in the data and/or
> > + * attribute fork if they are in short form and we are obfuscating names.
> > + * In this case we need to recalculate the CRC of the inode, but we should
> > + * only do that if the CRC in the inode is good to begin with. If the crc
> > + * is not ok, we just leave it alone.
> > + */
> >  static int
> >  process_inode(
> >  	xfs_agnumber_t		agno,
> > @@ -1729,17 +1748,28 @@ process_inode(
> >  	xfs_dinode_t 		*dip)
> >  {
> >  	int			success;
> > +	bool			crc_ok = false; /* don't recalc by default */
> > +	bool			need_crc = false;
> 
> I might do
> 
> +	bool			crc_was_ok = false; /* don't recalc by default */
> +	bool			need_new_crc = false;
> 
> for clarity...? 

*nod*

> >  	success = 1;
> >  	cur_ino = XFS_AGINO_TO_INO(mp, agno, agino);
> >  
> > +	/* we only care about crc recalculation if we are obfuscating names. */
> > +	if (!dont_obfuscate)
> > +		crc_ok = xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
> > +					  offsetof(struct xfs_dinode, di_crc));
> > +
> >  	/* copy appropriate data fork metadata */
> >  	switch (be16_to_cpu(dip->di_mode) & S_IFMT) {
> >  		case S_IFDIR:
> >  			success = process_inode_data(dip, TYP_DIR2);
> > +			if (dip->di_format == XFS_DINODE_FMT_LOCAL)
> > +				need_crc = 1;
> 
> I wish this were closer to the point of obfuscation, but oh well.

It means carrying a tristate or extra varaible through the stack,
which doesn't make it any simpler to understand because we have to
do the CRC here once we know we've finished all the modifications to
the inode....

> 
> >  			break;
> >  		case S_IFLNK:
> >  			success = process_inode_data(dip, TYP_SYMLINK);
> > +			if (dip->di_format == XFS_DINODE_FMT_LOCAL)
> > +				need_crc = 1;
> >  			break;
> >  		case S_IFREG:
> >  			success = process_inode_data(dip, TYP_DATA);
> > @@ -1754,6 +1784,7 @@ process_inode(
> >  		attr_data.remote_val_count = 0;
> >  		switch (dip->di_aformat) {
> >  			case XFS_DINODE_FMT_LOCAL:
> > +				need_crc = 1;
> >  				if (!dont_obfuscate)
> >  					obfuscate_sf_attr(dip);

And this one kind of forces us to do it here if we want to only have
one place where we recalc CRCs...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
