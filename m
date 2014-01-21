Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1C0D529DF8
	for <xfs@oss.sgi.com>; Tue, 21 Jan 2014 15:15:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 032258F8040
	for <xfs@oss.sgi.com>; Tue, 21 Jan 2014 13:15:33 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	8BQJJ7fitUkJXvAE for <xfs@oss.sgi.com>;
	Tue, 21 Jan 2014 13:15:28 -0800 (PST)
Date: Wed, 22 Jan 2014 08:14:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: add support for validating dirent ftype field
Message-ID: <20140121211427.GA27606@dastard>
References: <1390267813-8781-1-git-send-email-david@fromorbit.com>
	<52DEAA4F.9020509@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52DEAA4F.9020509@redhat.com>
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

On Tue, Jan 21, 2014 at 12:11:43PM -0500, Brian Foster wrote:
> On 01/20/2014 08:30 PM, Dave Chinner wrote:
> > diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
> > index 96a3c1d..4c8c836 100644
> > --- a/libxfs/xfs_dir2.c
> > +++ b/libxfs/xfs_dir2.c
> > @@ -20,6 +20,22 @@
> >  
> >  struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
> >  
> > +/*
> > + * @mode, if set, indicates that the type field needs to be set up.
> > + * This uses the transformation from file mode to DT_* as defined in linux/fs.h
> > + * for file type specification. This will be propagated into the directory
> > + * structure if appropriate for the given operation and filesystem config.
> > + */
> > +const unsigned char xfs_mode_to_ftype[S_IFMT >> S_SHIFT] = {
> > +	[0]			= XFS_DIR3_FT_UNKNOWN,
> > +	[S_IFREG >> S_SHIFT]	= XFS_DIR3_FT_REG_FILE,
> > +	[S_IFDIR >> S_SHIFT]	= XFS_DIR3_FT_DIR,
> > +	[S_IFCHR >> S_SHIFT]	= XFS_DIR3_FT_CHRDEV,
> > +	[S_IFBLK >> S_SHIFT]	= XFS_DIR3_FT_BLKDEV,
> > +	[S_IFIFO >> S_SHIFT]	= XFS_DIR3_FT_FIFO,
> > +	[S_IFSOCK >> S_SHIFT]	= XFS_DIR3_FT_SOCK,
> > +	[S_IFLNK >> S_SHIFT]	= XFS_DIR3_FT_SYMLINK,
> > +};
> >  
> 
> Using a larger array than technically necessary, but not a big deal I
> suppose.

Same as the kernel code, and it's really not that big given:

#define S_IFLNK  0120000

and so 0120000 >> 12 = 0xa000 >> 0xc = 0xa

So it's an array of 11 entries, of which 8 are used. And given that
it means the conversion code is just an array lookup, the simplicity
is more than worth the 3 wasted bytes in the array...

> > @@ -2381,7 +2430,8 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
> >  		 */
> >  		if (!dir_hash_add(mp, hashtab, (xfs_dir2_dataptr_t)
> >  				(sfep - xfs_dir2_sf_firstentry(sfp)),
> > -				lino, sfep->namelen, sfep->name)) {
> > +				lino, sfep->namelen, sfep->name,
> > +				xfs_dir3_sfe_get_ftype(mp, sfp, sfep))) {
> >  			do_warn(
> >  _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
> >  				fname, lino, ino);
> > @@ -2403,11 +2453,11 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
> >  			 * the .. in the child, blow out the entry
> >  			 */
> >  			if (is_inode_reached(irec, ino_offset))  {
> > -				junkit = 1;
> >  				do_warn(
> >  	_("entry \"%s\" in directory inode %" PRIu64
> >  	  " references already connected inode %" PRIu64 ".\n"),
> >  					fname, ino, lino);
> > +				goto do_junkit;
> >  			} else if (parent == ino)  {
> >  				add_inode_reached(irec, ino_offset);
> >  				add_inode_ref(current_irec, current_ino_offset);
> > @@ -2423,12 +2473,41 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
> >  				add_dotdot_update(XFS_INO_TO_AGNO(mp, lino),
> >  							irec, ino_offset);
> >  			} else  {
> > -				junkit = 1;
> 
> That's the last place we ever set junkit to 1. We have several blocks of
> code that are skipped over in the junkit case via the goto. The final
> "don't execute this if junkit" block is skipped by virtue of jumping
> into the if block. Why not just turn the junkit block into an inline and
> use a next_sfep label or some such? E.g.,

Yeah, I could probably do that. I didn't want to rearrange the code
too much, that's all. I'll have to post another version anyway,
because I realised that I'm not freeing the ftype array in the
irec...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
