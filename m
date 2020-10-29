Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C08C4363A
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 18:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B73C020732
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 18:38:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BlVVfffW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgJ2Siz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 14:38:55 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:40196 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgJ2Siy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 14:38:54 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TITWrI143337;
        Thu, 29 Oct 2020 18:38:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=qqp5zQPE3tiXZlG3ekhPTJeQv7bIogE37g4WGbQXDqw=;
 b=BlVVfffW3kZ7mb8h5dMWlvxs4NLTksJ0WMppxj41XAGeOA1xbZ03G6cAHgHtgmEpdb7t
 DddckQHCoE+/xFfmJldhKl7ntABwkNgzpmu64xc8q0WYHRw9C6L+P1B615MD9mCkRErI
 mYuHa7ZdYuDH0jyMuFOz/9wa1yrVxycoxZ0nrn8t9/DfG+Ky5GO812s1yN8x0SoYkjfu
 oku0uOJBEkVVvYVR8s2JRtN37tMAM/XO9TlhKjRsH/mDxkOxzMhDuMC3iHre/0WYEACr
 y13VqxsbIVAE8rn2vL+H2oHvSe9QurSs5ybMfIk03EUshuqsLQy73yrRVCJdwpSVKZop 8w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34c9sb6jwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 18:38:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TIUVWK135600;
        Thu, 29 Oct 2020 18:38:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34cx1tj5fx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 18:38:50 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09TIcnJZ024065;
        Thu, 29 Oct 2020 18:38:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 11:38:49 -0700
Date:   Thu, 29 Oct 2020 11:38:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_db: add a directory path lookup command
Message-ID: <20201029183848.GX1061252@magnolia>
References: <160375514873.880118.10145241423813965771.stgit@magnolia>
 <160375515483.880118.8069916247570952970.stgit@magnolia>
 <20201028003551.GZ7391@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028003551.GZ7391@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=1 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290128
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 28, 2020 at 11:35:51AM +1100, Dave Chinner wrote:
> On Mon, Oct 26, 2020 at 04:32:34PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a command to xfs_db so that we can navigate to inodes by path.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ....
> > +/* Given a directory and a structured path, walk the path and set the cursor. */
> > +static int
> > +path_navigate(
> > +	struct xfs_mount	*mp,
> > +	xfs_ino_t		rootino,
> > +	struct dirpath		*dirpath)
> > +{
> > +	struct xfs_inode	*dp;
> > +	xfs_ino_t		ino = rootino;
> > +	unsigned int		i;
> > +	int			error;
> > +
> > +	error = -libxfs_iget(mp, NULL, ino, 0, &dp);
> > +	if (error)
> > +		return error;
> > +
> > +	for (i = 0; i < dirpath->depth; i++) {
> > +		struct xfs_name	xname = {
> > +			.name	= dirpath->path[i],
> > +			.len	= strlen(dirpath->path[i]),
> > +		};
> > +
> > +		if (!S_ISDIR(VFS_I(dp)->i_mode)) {
> > +			error = ENOTDIR;
> > +			goto rele;
> > +		}
> > +
> > +		error = -libxfs_dir_lookup(NULL, dp, &xname, &ino, NULL);
> > +		if (error)
> > +			goto rele;
> > +		if (!xfs_verify_ino(mp, ino)) {
> > +			error = EFSCORRUPTED;
> > +			goto rele;
> > +		}
> > +
> > +		libxfs_irele(dp);
> > +		dp = NULL;
> > +
> > +		error = -libxfs_iget(mp, NULL, ino, 0, &dp);
> > +		switch (error) {
> > +		case EFSCORRUPTED:
> > +		case EFSBADCRC:
> > +		case 0:
> > +			break;
> > +		default:
> > +			return error;
> > +		}
> > +	}
> > +
> > +	set_cur_inode(ino);
> > +rele:
> > +	if (dp)
> > +		libxfs_irele(dp);
> > +	return error;
> > +}
> 
> This could return negative errors....
> 
> > +/* Walk a directory path to an inode and set the io cursor to that inode. */
> > +static int
> > +path_walk(
> > +	char		*path)
> > +{
> > +	struct dirpath	*dirpath;
> > +	char		*p = path;
> > +	xfs_ino_t	rootino = mp->m_sb.sb_rootino;
> > +	int		ret = 0;
> > +
> > +	if (*p == '/') {
> > +		/* Absolute path, start from the root inode. */
> > +		p++;
> > +	} else {
> > +		/* Relative path, start from current dir. */
> > +		if (iocur_top->typ != &typtab[TYP_INODE]) {
> > +			dbprintf(_("current object is not an inode.\n"));
> > +			return -1;
> > +		}
> > +
> > +		if (!S_ISDIR(iocur_top->mode)) {
> > +			dbprintf(_("current inode %llu is not a directory.\n"),
> > +					(unsigned long long)iocur_top->ino);
> > +			return -1;
> > +		}
> > +		rootino = iocur_top->ino;
> > +	}
> > +
> > +	dirpath = path_parse(p);
> > +	if (!dirpath) {
> > +		dbprintf(_("%s: not enough memory to parse.\n"), path);
> > +		return -1;
> > +	}
> 
> and this could return -ENOMEM here with no error message....
> 
> > +
> > +	ret = path_navigate(mp, rootino, dirpath);
> > +	if (ret) {
> > +		dbprintf(_("%s: %s\n"), path, strerror(ret));
> > +		ret = -1;
> > +	}
> 
> ... don't overwrite ret here, move the dbprintf() to the caller and
> the one error message captures all possible errors.
> 
> Also, no need for _() for a format string that contains no
> translatable text....

Ok, will fix.  Thanks!

--D

> Otherwise, looks fine.
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
