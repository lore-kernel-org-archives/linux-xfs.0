Return-Path: <SRS0=iKFT=ED=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9610C4363A
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 22:51:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DA2720732
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 22:51:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xwE9XbWT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389547AbgJ1Wu4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 18:50:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41596 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389620AbgJ1Wu4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 18:50:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09SMnR0w005440;
        Wed, 28 Oct 2020 22:50:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=s3e4V6YLmy6qJowDKLYLwA1fNt+vde7/p+6v9e0B1LI=;
 b=xwE9XbWTx3flx84KU3v/1XNbDUclM6++Owhve3TegJccaDPhlYoaeQmKb9vbNNRvHd02
 RF6sGQl3nauOgKX/8X37h8/LSZ1HUCj+F6Zw4ldNy+oqjexe2826Qt99Db0IMbu/PS6j
 c1z08BfZb09cXjZzdCzMdtNeRJKJCMD2IpDG5r5t9k0HSR/a25cT69wwkMM10ACn2spo
 h+wcyvftcNIy/rwiPA5jn3k74O9GtcepWTwmxo0oRVxORGEaYff9ctOHS558CfqtRpJK
 XyY7QIzUqb++KUGL92lYGMLI70meZqj4iF4/a/yotSaL3ZGsfWaMOZjq35we8KqwXUQp sA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34cc7m2387-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 28 Oct 2020 22:50:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09SMZN7X061868;
        Wed, 28 Oct 2020 22:50:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34cx6xt0h0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Oct 2020 22:50:49 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09SMolmf018509;
        Wed, 28 Oct 2020 22:50:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Oct 2020 15:50:47 -0700
Date:   Wed, 28 Oct 2020 15:50:46 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_db: add an ls command
Message-ID: <20201028225046.GF1061252@magnolia>
References: <160375514873.880118.10145241423813965771.stgit@magnolia>
 <160375516100.880118.14555322605178437533.stgit@magnolia>
 <20201028012703.GA7391@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028012703.GA7391@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010280139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=1
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010280140
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 28, 2020 at 12:27:03PM +1100, Dave Chinner wrote:
> On Mon, Oct 26, 2020 at 04:32:41PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add to xfs_db the ability to list a directory.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  db/namei.c               |  380 ++++++++++++++++++++++++++++++++++++++++++++++
> >  libxfs/libxfs_api_defs.h |    1 
> >  man/man8/xfs_db.8        |   14 ++
> >  3 files changed, 395 insertions(+)
> > 
> > 
> > diff --git a/db/namei.c b/db/namei.c
> > index 3c9889d62338..b2c036e6777a 100644
> > --- a/db/namei.c
> > +++ b/db/namei.c
> > @@ -221,8 +221,388 @@ static const cmdinfo_t path_cmd = {
> >  	.help		= path_help,
> >  };
> >  
> > +/* List a directory's entries. */
> > +
> > +static const char *filetype_strings[XFS_DIR3_FT_MAX] = {
> > +	[XFS_DIR3_FT_UNKNOWN]	= N_("unknown"),
> > +	[XFS_DIR3_FT_REG_FILE]	= N_("regular"),
> > +	[XFS_DIR3_FT_DIR]	= N_("directory"),
> > +	[XFS_DIR3_FT_CHRDEV]	= N_("chardev"),
> > +	[XFS_DIR3_FT_BLKDEV]	= N_("blkdev"),
> > +	[XFS_DIR3_FT_FIFO]	= N_("fifo"),
> > +	[XFS_DIR3_FT_SOCK]	= N_("socket"),
> > +	[XFS_DIR3_FT_SYMLINK]	= N_("symlink"),
> > +	[XFS_DIR3_FT_WHT]	= N_("whiteout"),
> > +};
> 
> What does N_() do that is different to _()?

LOL, it doesn't do anything at all!

Sigh... WTF was the point of commit 97294b227aefd?

> > +static const char *
> > +get_dstr(
> > +	struct xfs_mount	*mp,
> > +	uint8_t			filetype)
> > +{
> > +	if (!xfs_sb_version_hasftype(&mp->m_sb))
> > +		return filetype_strings[XFS_DIR3_FT_UNKNOWN];
> > +
> > +	if (filetype >= XFS_DIR3_FT_MAX)
> > +		return filetype_strings[XFS_DIR3_FT_UNKNOWN];
> > +
> > +	return filetype_strings[filetype];
> > +}
> > +
> > +static void
> > +dir_emit(
> > +	struct xfs_mount	*mp,
> > +	char			*name,
> > +	ssize_t			namelen,
> > +	xfs_ino_t		ino,
> > +	uint8_t			dtype)
> > +{
> > +	char			*display_name;
> > +	struct xfs_name		xname = { .name = name };
> > +	const char		*dstr = get_dstr(mp, dtype);
> > +	xfs_dahash_t		hash;
> > +	bool			good;
> > +
> > +	if (namelen < 0) {
> > +		/* Negative length means that name is null-terminated. */
> > +		display_name = name;
> > +		xname.len = strlen(name);
> > +		good = true;
> > +	} else {
> > +		/*
> > +		 * Otherwise, name came from a directory entry, so we have to
> > +		 * copy the string to a buffer so that we can add the null
> > +		 * terminator.
> > +		 */
> > +		display_name = malloc(namelen + 1);
> > +		memcpy(display_name, name, namelen);
> > +		display_name[namelen] = 0;
> > +		xname.len = namelen;
> > +		good = libxfs_dir2_namecheck(name, namelen);
> > +	}
> > +	hash = libxfs_dir2_hashname(mp, &xname);
> > +
> > +	dbprintf("%-18llu %-14s 0x%08llx %3d %s", ino, dstr, hash, xname.len,
> > +			display_name);
> > +	if (!good)
> > +		dbprintf(_(" (corrupt)"));
> > +	dbprintf("\n");
> 
> Can we get this to emit the directory offset of the entry as well?

Er... I think so.  Do you want to report the u32 value that gets loaded
in ctx->pos?  Or the actual byte offset within the directory?

> Also, can this be done as a single dbprintf call like this?
> 
> 	dbprintf(%-18llu %-14s 0x%08llx %3d %s %s\n",
> 		ino, dstr, hash, xname.len, display_name,
> 		good ? _("(good)") : _("(corrupt)"));
> 
> (there will be lots of output on big directories....)

Ok.

> > +static int
> > +list_sfdir(
> > +	struct xfs_da_args		*args)
> > +{
> > +	struct xfs_inode		*dp = args->dp;
> > +	struct xfs_mount		*mp = dp->i_mount;
> > +	struct xfs_dir2_sf_entry	*sfep;
> > +	struct xfs_dir2_sf_hdr		*sfp;
> > +	xfs_ino_t			ino;
> > +	unsigned int			i;
> > +	uint8_t				filetype;
> > +
> > +	sfp = (struct xfs_dir2_sf_hdr *)dp->i_df.if_u1.if_data;
> > +
> > +	/* . and .. entries */
> > +	dir_emit(args->dp->i_mount, ".", -1, dp->i_ino, XFS_DIR3_FT_DIR);
> > +
> > +	ino = libxfs_dir2_sf_get_parent_ino(sfp);
> > +	dir_emit(args->dp->i_mount, "..", -1, ino, XFS_DIR3_FT_DIR);
> > +
> > +	/* Walk everything else. */
> > +	sfep = xfs_dir2_sf_firstentry(sfp);
> > +	for (i = 0; i < sfp->count; i++) {
> > +		ino = libxfs_dir2_sf_get_ino(mp, sfp, sfep);
> > +		filetype = libxfs_dir2_sf_get_ftype(mp, sfep);
> > +
> > +		dir_emit(args->dp->i_mount, (char *)sfep->name, sfep->namelen,
> > +				ino, filetype);
> > +		sfep = libxfs_dir2_sf_nextentry(mp, sfp, sfep);
> > +	}
> > +
> > +	return 0;
> > +}
> 
> Hmmm - how much of the xfs_readdir() implementation from the kernel
> does this duplicate? It doesn't contain the seek cookie stuff, but
> otherwise it's almost identical, right?

Yep.  I think it also omits a fair amount of error handling since we'd
rather just keep going for as long as we can.

> [....]
> 
> > +/* If the io cursor points to a directory, list its contents. */
> > +static int
> > +ls_cur(
> > +	char			*tag,
> > +	bool			direct)
> 
> I find the name "direct" rather confusing here. according to
> the help below, it will be true when we want to "list the directory
> itself, not it's contents"....
> 
> 
> > +{
> > +	struct xfs_inode	*dp;
> > +	int			ret = 0;
> > +
> > +	if (iocur_top->typ != &typtab[TYP_INODE]) {
> > +		dbprintf(_("current object is not an inode.\n"));
> > +		return -1;
> > +	}
> > +
> > +	ret = -libxfs_iget(mp, NULL, iocur_top->ino, 0, &dp);
> > +	if (ret) {
> > +		dbprintf(_("failed to iget directory %llu, error %d\n"),
> > +				(unsigned long long)iocur_top->ino, ret);
> > +		return -1;
> > +	}
> > +
> > +	if (S_ISDIR(VFS_I(dp)->i_mode) && !direct) {
> > +		/* List the contents of a directory. */
> > +		if (tag)
> > +			dbprintf(_("%s:\n"), tag);
> > +
> > +		ret = listdir(dp);
> > +		if (ret) {
> > +			dbprintf(_("failed to list directory %llu: %s\n"),
> > +					(unsigned long long)iocur_top->ino,
> > +					strerror(ret));
> > +			ret = -1;
> > +			goto rele;
> > +		}
> > +	} else if (direct || !S_ISDIR(VFS_I(dp)->i_mode)) {
> > +		/* List the directory entry associated with a single file. */
> > +		char		inum[32];
> > +
> > +		if (!tag) {
> > +			snprintf(inum, sizeof(inum), "<%llu>",
> > +					(unsigned long long)iocur_top->ino);
> > +			tag = inum;
> > +		} else {
> > +			char	*p = strrchr(tag, '/');
> > +
> > +			if (p)
> > +				tag = p + 1;
> > +		}
> > +
> > +		dir_emit(mp, tag, -1, iocur_top->ino,
> > +				libxfs_mode_to_ftype(VFS_I(dp)->i_mode));
> 
> I'm not sure what this is supposed to do - we turn the current inode
> if it's not a directory into a -directory entry- without actually
> know it's name? And we can pass in an inode that isn't a directory
> and do the same? This doesn't make a huge amount of sense to me - it
> tries to display the inode number as a dirent?

I added this (somewhat confusing) ability so that fstests could resolve
a path to an inode number without having to dig any farther into the
disk format.

IOWs, you can do:

ino=$(_scratch_xfs_db -c 'ls -d /usr/bin/bash')

to get the inode number directly.  Without this, you'd have to do
something horrible like this...

ino=$(_scratch_xfs_db -c 'path /usr/bin/bash' -c 'print' -c 'stack' /dev/sda | \
	tr ',' ' ' | \
	awk '{if ($1 ~ /inumber/) {print $3; exit(0); } else if ($1 == "inode") {print $2; exit(0);}}')

To map a path to an inode number.  I thought it made a lot more sense to
do that in C (even if it makes the xfs_db CLI a little weird) than
implement a bunch of string parsing after the fact.

Maybe I should just simplify it to "display the inode number of whatever
the path resolves to" instead of constructing an artificial directory
entry.

> > +	} else {
> > +		dbprintf(_("current inode %llu is not a directory.\n"),
> > +				(unsigned long long)iocur_top->ino);
> > +		ret = -1;
> > +		goto rele;
> > +	}
> 
> I don't think we can get to this else branch. If we don't take the
> first branch (dir && !direct), the either we are not a dir or direct
> is set. The second branch will then be taken if we are not a dir or
> direct is set....

Yes, I /will/ do that.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
