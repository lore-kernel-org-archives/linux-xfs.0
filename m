Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 096C77F37
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 16:46:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E872B8F804B
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 14:46:37 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	XHRxmM3N56MHDvkQ for <xfs@oss.sgi.com>;
	Mon, 14 Oct 2013 14:46:36 -0700 (PDT)
Date: Tue, 15 Oct 2013 08:46:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: fix resouce leak in longform_dir2_rebuild()
Message-ID: <20131014214601.GJ5663@dastard>
References: <1381560174.3064.4.camel@ThinkPad-T5421>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1381560174.3064.4.camel@ThinkPad-T5421>
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
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, xfsprogs <xfs@oss.sgi.com>

On Sat, Oct 12, 2013 at 02:42:54PM +0800, Li Zhong wrote:
> coverity scan 997010 reported following leak in repair/phase6.c
> 
> 1309                if (error) {
> 1310                        do_warn(
> 1311        _("space reservation failed (%d), filesystem may be out of space\n"),
> 1312                                error);
>     	25. Breaking from loop
> 1313                        break;
> 1314                }
> 
> ......
> 
> 1342                libxfs_trans_commit(tp,
> 1343                                XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
> 1344        }
> 
> CID 997010 (#1 of 1): Resource leak (RESOURCE_LEAK)
> 26. leaked_storage: Variable "tp" going out of scope leaks the storage it points to.
> 1345}
> 
> Though not reported by coverity, it seems that there might be some entries in
> flist which needs to be freed in the failure case below libxfs_dir_createname(),
> so I also added a bmap cancel there.
> 
> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> ---
>  repair/phase6.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index a4ad7a3..0d88ad2 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -1310,6 +1310,8 @@ longform_dir2_rebuild(
>  			do_warn(
>  	_("space reservation failed (%d), filesystem may be out of space\n"),
>  				error);
> +			libxfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
> +						XFS_TRANS_ABORT);

As per the rest of the code in phase 6, the error handling here
should call "res_failed()" as we can't sanely recover from an ENOSPC
error during phase6.

>  			break;
>  		}
>  
> @@ -1323,6 +1325,7 @@ longform_dir2_rebuild(
>  			do_warn(
>  _("name create failed in ino %" PRIu64 " (%d), filesystem may be out of space\n"),
>  				ino, error);
> +			libxfs_bmap_cancel(&flist);
>  			libxfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
>  						XFS_TRANS_ABORT);
>  			break;

There's another case exactly the same in that function you missed.
What you should probably do is stack the error handling cases at the
end of the function like:

....
	return;

out_bmap_cancel:
	libxfs_bmap_cancel(&flist);
out_trans_cancel:
	libxfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
	return;
}

And convert all the error handling cases to jump to the appropriate
error handler.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
