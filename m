Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34341C4363A
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 02:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC26A208C3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 02:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgJ2CFn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 22:05:43 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55685 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727072AbgJ1ViK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:38:10 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0E4E13AA2F3;
        Wed, 28 Oct 2020 11:35:52 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kXZRP-0053JR-7S; Wed, 28 Oct 2020 11:35:51 +1100
Date:   Wed, 28 Oct 2020 11:35:51 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_db: add a directory path lookup command
Message-ID: <20201028003551.GZ7391@dread.disaster.area>
References: <160375514873.880118.10145241423813965771.stgit@magnolia>
 <160375515483.880118.8069916247570952970.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375515483.880118.8069916247570952970.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=afefHYAZSVUA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=GW4bklfYMzz692-khpAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 26, 2020 at 04:32:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a command to xfs_db so that we can navigate to inodes by path.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
....
> +/* Given a directory and a structured path, walk the path and set the cursor. */
> +static int
> +path_navigate(
> +	struct xfs_mount	*mp,
> +	xfs_ino_t		rootino,
> +	struct dirpath		*dirpath)
> +{
> +	struct xfs_inode	*dp;
> +	xfs_ino_t		ino = rootino;
> +	unsigned int		i;
> +	int			error;
> +
> +	error = -libxfs_iget(mp, NULL, ino, 0, &dp);
> +	if (error)
> +		return error;
> +
> +	for (i = 0; i < dirpath->depth; i++) {
> +		struct xfs_name	xname = {
> +			.name	= dirpath->path[i],
> +			.len	= strlen(dirpath->path[i]),
> +		};
> +
> +		if (!S_ISDIR(VFS_I(dp)->i_mode)) {
> +			error = ENOTDIR;
> +			goto rele;
> +		}
> +
> +		error = -libxfs_dir_lookup(NULL, dp, &xname, &ino, NULL);
> +		if (error)
> +			goto rele;
> +		if (!xfs_verify_ino(mp, ino)) {
> +			error = EFSCORRUPTED;
> +			goto rele;
> +		}
> +
> +		libxfs_irele(dp);
> +		dp = NULL;
> +
> +		error = -libxfs_iget(mp, NULL, ino, 0, &dp);
> +		switch (error) {
> +		case EFSCORRUPTED:
> +		case EFSBADCRC:
> +		case 0:
> +			break;
> +		default:
> +			return error;
> +		}
> +	}
> +
> +	set_cur_inode(ino);
> +rele:
> +	if (dp)
> +		libxfs_irele(dp);
> +	return error;
> +}

This could return negative errors....

> +/* Walk a directory path to an inode and set the io cursor to that inode. */
> +static int
> +path_walk(
> +	char		*path)
> +{
> +	struct dirpath	*dirpath;
> +	char		*p = path;
> +	xfs_ino_t	rootino = mp->m_sb.sb_rootino;
> +	int		ret = 0;
> +
> +	if (*p == '/') {
> +		/* Absolute path, start from the root inode. */
> +		p++;
> +	} else {
> +		/* Relative path, start from current dir. */
> +		if (iocur_top->typ != &typtab[TYP_INODE]) {
> +			dbprintf(_("current object is not an inode.\n"));
> +			return -1;
> +		}
> +
> +		if (!S_ISDIR(iocur_top->mode)) {
> +			dbprintf(_("current inode %llu is not a directory.\n"),
> +					(unsigned long long)iocur_top->ino);
> +			return -1;
> +		}
> +		rootino = iocur_top->ino;
> +	}
> +
> +	dirpath = path_parse(p);
> +	if (!dirpath) {
> +		dbprintf(_("%s: not enough memory to parse.\n"), path);
> +		return -1;
> +	}

and this could return -ENOMEM here with no error message....

> +
> +	ret = path_navigate(mp, rootino, dirpath);
> +	if (ret) {
> +		dbprintf(_("%s: %s\n"), path, strerror(ret));
> +		ret = -1;
> +	}

... don't overwrite ret here, move the dbprintf() to the caller and
the one error message captures all possible errors.

Also, no need for _() for a format string that contains no
translatable text....

Otherwise, looks fine.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
