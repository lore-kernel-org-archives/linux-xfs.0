Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60366 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935852AbeFGPDY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jun 2018 11:03:24 -0400
Date: Thu, 7 Jun 2018 08:03:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/6] xfs: abstract xfs_info into $XFS_INFO_PROG
Message-ID: <20180607150316.GG25007@magnolia>
References: <152821697018.24976.12939094615403004592.stgit@magnolia>
 <152821700731.24976.1667061625518547754.stgit@magnolia>
 <20180607113713.GA1103@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180607113713.GA1103@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Jun 07, 2018 at 07:37:13PM +0800, Eryu Guan wrote:
> On Tue, Jun 05, 2018 at 09:43:27AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Abstract calls to xfs_info into $XFS_INFO_PROG like we do for all other
> > xfs utilities.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  common/attr      |    2 +-
> >  common/config    |    1 +
> >  common/populate  |   18 +++++++++---------
> >  common/rc        |    2 +-
> 
> Better to make xfs_info mandatory too when testing xfs, so I did the
> below diff on commit

Ok, thank you for making the change on the way in. :)

--D

> diff --git a/common/rc b/common/rc
> index f04c9ea2fd89..9d6665b6c4d7 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -136,6 +136,7 @@ case "$FSTYP" in
>          [ "$XFS_REPAIR_PROG" = "" ] && _fatal "xfs_repair not found"
>          [ "$XFS_DB_PROG" = "" ] && _fatal "xfs_db not found"
>          [ "$MKFS_XFS_PROG" = "" ] && _fatal "mkfs_xfs not found"
> +        [ "$XFS_INFO_PROG" = "" ] && _fatal "xfs_info not found"
> 
>          . ./common/xfs
>          ;;
> 
> Thanks,
> Eryu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
