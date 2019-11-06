Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2036CC5DF63
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 15:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3F652084D
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 15:47:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qMgwJWFc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbfKFPrV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 10:47:21 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36122 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728018AbfKFPrV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 10:47:21 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6Fk3Yk072744;
        Wed, 6 Nov 2019 15:46:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=2T/UklAL0UcI1jjLue4wpnPAqaTsKRxFxVzTpQQK5Ao=;
 b=qMgwJWFc0olbsbzBdYnHxTSMK9rLoPAkZ8ZDwDHrb1gbeYgLP8cTBGcRU9KtNfcuCOpq
 M+pn2HB2csQZvp0PyXFBHqqETf2Brexf0S8Zjya+VBugBOtPWPVKwMFLzFagil2iUeLk
 /3mSjuDe+HXSyfA8qwBxwBXyk1CSJcGtEW+YjbgGDY1u5vPnGJ9t0HIs8SUkG93YbI0x
 pVj5i0xi3ZMZw1KLuVJyBkreg112JsqJqRk/gIVaYbXZ+AqdAnizNLvZA2lZ0nkhxXEb
 1yKuXfM7chfTQAxHDohLyPOKPUHOglCm/dmzQaUDtM+2yF4+KikLGZr7uQZJhe3+ugIu BA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w11rq7kns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 15:46:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6FhaYg124682;
        Wed, 6 Nov 2019 15:46:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2w3163t024-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 15:46:14 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA6FkDdt015642;
        Wed, 6 Nov 2019 15:46:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 07:46:13 -0800
Date:   Wed, 6 Nov 2019 07:46:12 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     kaixuxia <xiakaixu1987@gmail.com>, linux-xfs@vger.kernel.org,
        newtongao@tencent.com, jasperwang@tencent.com
Subject: Re: [PATCH v2] xfs: Fix deadlock between AGI and AGF when target_ip
 exists in xfs_rename()
Message-ID: <20191106154612.GH4153244@magnolia>
References: <1572947532-4972-1-git-send-email-kaixuxia@tencent.com>
 <20191106045630.GO15221@magnolia>
 <20191106124932.GA37080@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106124932.GA37080@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060151
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 07:49:32AM -0500, Brian Foster wrote:
> On Tue, Nov 05, 2019 at 08:56:30PM -0800, Darrick J. Wong wrote:
> > On Tue, Nov 05, 2019 at 05:52:12PM +0800, kaixuxia wrote:
> > > When target_ip exists in xfs_rename(), the xfs_dir_replace() call may
> > > need to hold the AGF lock to allocate more blocks, and then invoking
> > > the xfs_droplink() call to hold AGI lock to drop target_ip onto the
> > > unlinked list, so we get the lock order AGF->AGI. This would break the
> > > ordering constraint on AGI and AGF locking - inode allocation locks
> > > the AGI, then can allocate a new extent for new inodes, locking the
> > > AGF after the AGI.
> > > 
> > > In this patch we check whether the replace operation need more
> > > blocks firstly. If so, acquire the agi lock firstly to preserve
> > > locking order(AGI/AGF). Actually, the locking order problem only
> > > occurs when we are locking the AGI/AGF of the same AG. For multiple
> > > AGs the AGI lock will be released after the transaction committed.
> > > 
> > > Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> > > ---
> > > Changes in v2:
> > >  - Add xfs_dir2_sf_replace_needblock() helper in
> > >    xfs_dir2_sf.c.
> > > 
> > >  fs/xfs/libxfs/xfs_dir2.c      | 23 +++++++++++++++++++++++
> > >  fs/xfs/libxfs/xfs_dir2.h      |  2 ++
> > >  fs/xfs/libxfs/xfs_dir2_priv.h |  2 ++
> > >  fs/xfs/libxfs/xfs_dir2_sf.c   | 24 ++++++++++++++++++++++++
> > >  fs/xfs/xfs_inode.c            | 14 ++++++++++++++
> > >  5 files changed, 65 insertions(+)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> > > index 867c5de..1917990 100644
> > > --- a/fs/xfs/libxfs/xfs_dir2.c
> > > +++ b/fs/xfs/libxfs/xfs_dir2.c
> > > @@ -463,6 +463,29 @@
> > >  }
> > >  
> > >  /*
> > > + * Check whether the replace operation need more blocks. Ignore
> > > + * the parameters check since the real replace() call below will
> > > + * do that.
> > > + */
> > > +bool
> > > +xfs_dir_replace_needblock(
> > 
> > xfs_dir2, to be consistent.
> > 
> > > +	struct xfs_inode	*dp,
> > > +	xfs_ino_t		inum)
> > 
> > If you passed the inode pointer (instead of ip->i_ino) here then you
> > don't need to revalidate the inode number.
> > 
> > > +{
> > > +	int			rval;
> > > +
> > > +	rval = xfs_dir_ino_validate(dp->i_mount, inum);
> > > +	if (rval)
> > > +		return false;
> > > +
> > > +	/*
> > > +	 * Only convert the shortform directory to block form maybe
> > > +	 * need more blocks.
> > > +	 */
> > > +	return xfs_dir2_sf_replace_needblock(dp, inum);
> > 
> > 	if (dp->i_d.di_format != XFS_DINODE_FMT_LOCAL)
> > 		return xfs_dir2_sf_replace_needblock(...);
> > 
> > Also, do other directories formats need extra blocks allocated?
> > 
> > > +}
> > > +
> > > +/*
> > >   * Replace the inode number of a directory entry.
> > >   */
> > >  int
> > > diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> > > index f542447..e436c14 100644
> > > --- a/fs/xfs/libxfs/xfs_dir2.h
> > > +++ b/fs/xfs/libxfs/xfs_dir2.h
> > > @@ -124,6 +124,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
> > >  extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
> > >  				struct xfs_name *name, xfs_ino_t ino,
> > >  				xfs_extlen_t tot);
> > > +extern bool xfs_dir_replace_needblock(struct xfs_inode *dp,
> > > +				xfs_ino_t inum);
> > >  extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
> > >  				struct xfs_name *name, xfs_ino_t inum,
> > >  				xfs_extlen_t tot);
> > > diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> > > index 59f9fb2..002103f 100644
> > > --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> > > +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> > > @@ -116,6 +116,8 @@ extern int xfs_dir2_block_to_sf(struct xfs_da_args *args, struct xfs_buf *bp,
> > >  extern int xfs_dir2_sf_create(struct xfs_da_args *args, xfs_ino_t pino);
> > >  extern int xfs_dir2_sf_lookup(struct xfs_da_args *args);
> > >  extern int xfs_dir2_sf_removename(struct xfs_da_args *args);
> > > +extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
> > > +		xfs_ino_t inum);
> > >  extern int xfs_dir2_sf_replace(struct xfs_da_args *args);
> > >  extern xfs_failaddr_t xfs_dir2_sf_verify(struct xfs_inode *ip);
> > >  
> > > diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> > > index 85f14fc..0906f91 100644
> > > --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> > > +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> > > @@ -945,6 +945,30 @@ static int xfs_dir2_sf_addname_pick(xfs_da_args_t *args, int objchange,
> > >  }
> > >  
> > >  /*
> > > + * Check whether the replace operation need more blocks.
> > > + */
> > > +bool
> > > +xfs_dir2_sf_replace_needblock(
> > 
> > Urgggh.  This is a predicate that we only ever call from xfs_rename(),
> > right?  And it addresses a particular quirk of the locking when the
> > caller wants us to rename on top of an existing entry and drop the link
> > count of the old inode, right?  So why can't this just be a predicate in
> > xfs_inode.c ?  Nobody else needs to know this particular piece of
> > information, AFAICT.
> > 
> > (Apologies, for Brian and I clearly aren't on the same page about
> > that...)
> > 
> 
> Hmm.. the crux of my feedback on the previous version was simply that if
> we wanted to take this approach of pulling up lower level dir logic into
> the higher level rename code, to simply factor out the existing checks
> down in the dir replace code that currently trigger a format conversion,
> and use that new helper in both places. That doesn't appear to be what
> this patch does, and I'm not sure why there are now two new helpers that
> each only have one caller instead of one new helper with two callers...

Aha, got it.  I'd wondered if that had been your intent. :)

--D

> Brian
> 
> > > +	struct xfs_inode	*dp,
> > > +	xfs_ino_t		inum)
> > > +{
> > > +	int			newsize;
> > > +	xfs_dir2_sf_hdr_t	*sfp;
> > > +
> > > +	if (dp->i_d.di_format != XFS_DINODE_FMT_LOCAL)
> > > +		return false;
> > 
> > This check should be used up in xfs_dir2_replace_needblock() to decide
> > if we're calling xfs_dir2_sf_replace_needblock(), or just returning
> > false.
> > 
> > > +
> > > +	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
> > > +	newsize = dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIFF;
> > > +
> > > +	if (inum > XFS_DIR2_MAX_SHORT_INUM &&
> > > +	    sfp->i8count == 0 && newsize > XFS_IFORK_DSIZE(dp))
> > > +		return true;
> > > +	else
> > > +		return false;
> > 
> > return inum > XFS_DIR2_MAX_SHORT_INUM && (all the rest of that);
> > 
> > > +}
> > > +
> > > +/*
> > >   * Replace the inode number of an entry in a shortform directory.
> > >   */
> > >  int						/* error */
> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > index 18f4b26..c239070 100644
> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -3196,6 +3196,7 @@ struct xfs_iunlink {
> > >  	struct xfs_trans	*tp;
> > >  	struct xfs_inode	*wip = NULL;		/* whiteout inode */
> > >  	struct xfs_inode	*inodes[__XFS_SORT_INODES];
> > > +	struct xfs_buf		*agibp;
> > >  	int			num_inodes = __XFS_SORT_INODES;
> > >  	bool			new_parent = (src_dp != target_dp);
> > >  	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
> > > @@ -3361,6 +3362,19 @@ struct xfs_iunlink {
> > >  		 * In case there is already an entry with the same
> > >  		 * name at the destination directory, remove it first.
> > >  		 */
> > > +
> > > +		/*
> > > +		 * Check whether the replace operation need more blocks.
> > > +		 * If so, acquire the agi lock firstly to preserve locking
> > 
> >                                                "first"
> > 
> > > +		 * order(AGI/AGF).
> > 
> > Nit: space between "order" and "(AGI/AGF)".
> > > +		 */
> > > +		if (xfs_dir_replace_needblock(target_dp, src_ip->i_ino)) {
> > > +			error = xfs_read_agi(mp, tp,
> > > +					XFS_INO_TO_AGNO(mp, target_ip->i_ino), &agibp);
> > 
> > Overly long line here.
> > 
> > --D
> > 
> > > +			if (error)
> > > +				goto out_trans_cancel;
> > > +		}
> > > +
> > >  		error = xfs_dir_replace(tp, target_dp, target_name,
> > >  					src_ip->i_ino, spaceres);
> > >  		if (error)
> > > -- 
> > > 1.8.3.1
> > > 
> 
