Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BEEA17F3F
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 11:33:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3F6F3AC00B
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 09:32:57 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sxscNffXbCoC9lAQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Nov 2014 09:32:56 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sACHWtR4032443
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 12:32:55 -0500
Date: Wed, 12 Nov 2014 15:32:48 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] Add support to RENAME_EXCHANGE flag V3
Message-ID: <20141112173245.GA32185@hades.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141111192922.GC38867@bfoster.bfoster>
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
To: xfs@oss.sgi.com
Cc: Brian Foster <bfoster@redhat.com>

Hi Brian

> >  {
> >     xfs_trans_t     *tp = NULL;
> >     xfs_mount_t     *mp = src_dp->i_mount;
> >     int             new_parent;             /* moving to a new dir */
> >     int             src_is_directory;       /* src_name is a directory */
> > +   int             tgt_is_directory;
>
> There's an unused variable warning for this.

Thanks for catching this!!!

>
> >     int             error;
> >     xfs_bmap_free_t free_list;
> >     xfs_fsblock_t   first_block;
> > @@ -2706,6 +2708,7 @@ xfs_rename(
> >     cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
> >     spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
> >     error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, spaceres, 0);
> > +
> >     if (error == -ENOSPC) {
> >             spaceres = 0;
> >             error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, 0, 0);
> > @@ -2756,143 +2759,155 @@ xfs_rename(
> >     }
> >
> >     /*
> > -    * Set up the target.
> > -    */
> > -   if (target_ip == NULL) {
> > +    * Handle RENAME_EXCHANGE flags
> > +   */
> > +   if (flags & RENAME_EXCHANGE) {
> > +           error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
> > target_dp,
> > +                                    target_name, target_ip, &free_list,
> > +                                    &first_block, spaceres);
> > +           if (error)
> > +                   goto abort_return;
{
>
> The factoring of xfs_rename() looks much better, but we could probably
> avoid all the extra indentation in the else branch that follows by using
> a label. It does look like that indentation creates a bunch of 80+ char
> lines in xfs_rename(). E.g., something like:
>
>       if (flags & RENAME_EXCHANGE) {
>               ...
>               goto complete_tp;
>       }
>       ...
> complete_tp:
>       ...
>       return xfs_trans_commit(...);
>
> ... and then kill the else above and leave the rest of xfs_rename() as
> is.

I don't think it's a bad idea at all. I particularly don't like the use of
labels for flow control like this, in this case though, it's a simple
"skip this bunch of code", and I'd not object to use it, it would make the
code more clear IMHO too.

>
> >             /*
> > -            * If there's no space reservation, check the entry will
> > -            * fit before actually inserting it.
> > +            * Set up the target.
> >              */
> > -           if (!spaceres) {
> > -                   error = xfs_dir_canenter(tp, target_dp, target_name);
> > -                   if (error)
> > +           if (target_ip == NULL) {
> > +                   /*
> > +                    * If there's no space reservation, check the entry will
> > +                    * fit before actually inserting it.
> > +                    */
> > +                   if (!spaceres) {
> > +                           error = xfs_dir_canenter(tp, target_dp, target_name);
> > +                           if (error)
> > +                                   goto error_return;
> > +                   }
> > +                   /*
> > +                    * If target does not exist and the rename crosses
> > +                    * directories, adjust the target directory link count
> > +                    * to account for the ".." reference from the new entry.
> > +                    */
> > +                   error = xfs_dir_createname(tp, target_dp, target_name,
> > +                                                   src_ip->i_ino,
> > &first_block,
> > +                                                   &free_list, spaceres);
> > +                   if (error == -ENOSPC)
> >                             goto error_return;
> > -           }
> > -           /*
> > -            * If target does not exist and the rename crosses
> > -            * directories, adjust the target directory link count
> > -            * to account for the ".." reference from the new entry.
> > -            */
> > -           error = xfs_dir_createname(tp, target_dp, target_name,
> > -                                           src_ip->i_ino, &first_block,
> > -                                           &free_list, spaceres);
> > -           if (error == -ENOSPC)
> > -                   goto error_return;
> > -           if (error)
> > -                   goto abort_return;
> > +                   if (error)
> > +                           goto abort_return;
> >
> > -           xfs_trans_ichgtime(tp, target_dp,
> > -                                   XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> > +                   xfs_trans_ichgtime(tp, target_dp,
> > +                                           XFS_ICHGTIME_MOD |
> > XFS_ICHGTIME_CHG);
> >
> > -           if (new_parent && src_is_directory) {
> > -                   error = xfs_bumplink(tp, target_dp);
> > +                   if (new_parent && src_is_directory) {
> > +                           error = xfs_bumplink(tp, target_dp);
.
.
.
> > +/* xfs_cross_rename()
> > + *
> > + * responsible to handle RENAME_EXCHANGE flag
> > + * in renameat2() sytemcall
> > + */
> > +int
> > +xfs_cross_rename(
>
> xfs_cross_rename() is only used by xfs_rename() so it can be defined
> static. Somewhat of a nit, but I'd also expect to see it implemented
> above xfs_rename() as it is a helper for the latter. That could be a
> matter of personal taste, however. Otherwise, just stick a declaration
> at the top of the file.
>

I agree, as you said, although it's a matter of taste, making it static and
moving it above xfs_rename() will save us from some extra code.

.
.
.
> > +   /*
> > +    * Update ".." entry to match the new parents
> > +    *
> > +    * In case we are crossing different file types between different
> > +    * parents, we must update parent's link count to match the ".."
> > +    * entry of the new child (or the removal of it).
> > +    */
> 
> The logic of the subsequent block looks Ok to me, but I would probably
> split up the comment to be more specific. Something like the following
> just as an example:   
> 
>       /*
>        * If we're renaming one or more directories across different parents,
>        * update the respective ".." entries (and link counts) to match the new
>        * parents.
>        */
Can't argue here, I'm not a native english speaker, so, it should be much more
readable in this way than mine :)
.
.
.
> > +   if (new_parent) {
> > +           xfs_trans_ichgtime(tp, target_dp, XFS_ICHGTIME_MOD |
> > XFS_ICHGTIME_CHG);
>
> Long line.
>
I think there is no reason to break this line. We should avoid 80+ columns per
line, but it's not a must, break this line will hurt readability of the code in
exchange of just a few chars more than 80. I don't think it's worth.
.
.
.
> > +out_abort:
>
> The name out_abort doesn't really mean much here. We don't abort
> anything. Perhaps just 'out?'
>
Agree, it doesn't mean an abort anymore, remains of the integration of the old
cross_rename version, 'out' is much better here.
.
.
.
> > @@ -340,7 +340,12 @@ int            xfs_link(struct xfs_inode *tdp, struct
> > xfs_inode *sip,
> >  int                xfs_rename(struct xfs_inode *src_dp, struct xfs_name
> >  *src_name,
> >                        struct xfs_inode *src_ip, struct xfs_inode
> >                        *target_dp,
> >                        struct xfs_name *target_name,
> > -                      struct xfs_inode *target_ip);
> > +                      struct xfs_inode *target_ip, unsigned int flags);
> > +int                xfs_cross_rename(struct xfs_trans *tp, struct xfs_inode
> > *src_dp,
> > +                            struct xfs_name *src_name, struct xfs_inode
> > *src_ip,
> > +                            struct xfs_inode *target_dp, struct xfs_name
> > *target_name,
> > +                            struct xfs_inode *target_ip,struct
> > xfs_bmap_free *free_list,
> > +                            xfs_fsblock_t *first_block, int spaceres);
>
> There's no need for this once xfs_cross_rename() is static.
>
> Brian
>
Will vanish on the next version as soon as I make it static



Thanks the review Brian

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
