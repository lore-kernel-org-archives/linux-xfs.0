Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q76FmAWq164106 for <xfs@oss.sgi.com>; Mon, 6 Aug 2012 10:48:11 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TnMrlANpAAlSnKRE for
	<xfs@oss.sgi.com>; Mon, 06 Aug 2012 08:48:10 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q76Fm8up022586
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 6 Aug 2012 11:48:09 -0400
Received: from orion.usersys.redhat.com (vpn1-5-205.gru2.redhat.com
	[10.97.5.205])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q76Fm5rU017326
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 6 Aug 2012 11:48:07 -0400
Date: Mon, 6 Aug 2012 12:48:04 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: fix race while discarding buffers
Message-ID: <20120806154804.GA8670@orion.usersys.redhat.com>
References: <1344266797-7749-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1344266797-7749-1-git-send-email-cmaiolino@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Please, ignore this patch. 

I've made a mistake on this patch, and I'm sending a V2 patch to fix the
error signed below:

>  fs/xfs/xfs_buf.c | 7 ++++++-
>  fs/xfs/xfs_buf.h | 7 ++++++-
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index d7a9dd7..52b27c4 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -96,6 +96,8 @@ xfs_buf_lru_add(
>  		atomic_inc(&bp->b_hold);
>  		list_add_tail(&bp->b_lru, &btp->bt_lru);
>  		btp->bt_lru_nr++;
> +		if (bp->b_lru_flags & XBF_LRU_DISPOSE)
		^^^^^^

		This should be if (!(b_lru_flags & XBF_LRU_DISPOSE))


I'm sending the V2 patch. Sorry about that.

-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
