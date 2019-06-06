Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57174 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbfFFVXx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Jun 2019 17:23:53 -0400
Subject: Re: [PATCH v2] xfs_restore: detect rtinherit on destination
References: <e6968aa2-a5ad-4964-2966-589486e4a251@sandeen.net>
 <20190606195724.2975689-1-sheenobu@fb.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f89a09b5-8a91-51e0-d869-039dbe9a7349@sandeen.net>
Date: Thu, 6 Jun 2019 16:23:51 -0500
MIME-Version: 1.0
In-Reply-To: <20190606195724.2975689-1-sheenobu@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sheena Artrip <sheenobu@fb.com>
Cc: sheena.artrip@gmail.com, linux-xfs@vger.kernel.org

On 6/6/19 2:57 PM, Sheena Artrip wrote:
> When running xfs_restore with a non-rtdev dump,
> it will ignore any rtinherit flags on the destination
> and send I/O to the metadata region.
> 
> Instead, detect rtinherit on the destination XFS fileystem root inode
> and use that to override the incoming inode flags.
> 
> Original version of this patch missed some branches so multiple
> invocations of xfsrestore onto the same fs caused
> the rtinherit bit to get re-removed. There could be some
> additional edge cases in non-realtime to realtime workflows so
> the outstanding question would be: is it worth supporting?
> 
> Changes in v2:
> * Changed root inode bulkstat to just ioctl to the destdir inode

Thanks for that fixup (though comment still says "root" FWIW)

Thinking about this some more, I'm really kind of wondering how this
should all be expected to work.  There are several scenarios here,
and "is this file rt?" is prescribed in different ways - either in
the dump itself, or on the target fs via inheritance flags...

(NB: rt is not the only inheritable flag, so would we need to handle
the others?)

non-rt fs dump, restored onto non-rt fs
	- obviously this is fine

rt fs dump, restored onto rt fs
	- obviously this is fine as well

rt fs dump, restored onto non-rt fs
	- this works, with errors - all rt files become non-rt
	- nothing else to do here other than fail outright

non-rt fs dump, restored into rt fs dir/fs with "rtinherit" set
	- this one is your case
	- today it's ignored, files stay non-rt
	- you're suggesting it be honored and files turned into rt

the one case that's not handled here is "what if I want to have my
realtime dump with realtime files restored onto an rt-capable fs, but
turned into regular files?" 

So your patch gives us one mechanism (restore non-rt files as
rt files) but not the converse (restore rt files as non-rt files) -
I'm not sure if that matters, but the symmetry bugs me a little.

I'm trying to decide if dump/restore is truly the right way to
migrate files from non-rt to rt or vice versa, TBH.  Maybe dchinner
or djwong will have thoughts as well...

I'll worry more about the details of the patch after we decide if this
is the right behavior in the first place...

-Eric

> Signed-off-by: Sheena Artrip <sheenobu@fb.com>
> ---
>  restore/content.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
> 
> diff --git a/restore/content.c b/restore/content.c
> index 6b22965..4822d1c 100644
> --- a/restore/content.c
> +++ b/restore/content.c
> @@ -670,6 +670,9 @@ struct tran {
>  		/* to establish critical regions while updating pers
>  		 * inventory
>  		 */
> +	bool_t t_dstisrealtime;
> +		/* to force the realtime flag on incoming inodes
> +		 */
>  };
>  
>  typedef struct tran tran_t;
> @@ -1803,6 +1806,37 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  		free_handle(fshanp, fshlen);
>  	}
>  
> +	/* determine if destination root inode has rtinherit.
> +	 * If so, we should force XFS_REALTIME on the incoming inodes.
> +	 */
> +	if (persp->a.dstdirisxfspr) {
> +		struct fsxattr dstxattr;
> +
> +		int dstfd = open(persp->a.dstdir, O_RDONLY);
> +		if (dstfd < 0) {
> +			mlog(MLOG_NORMAL | MLOG_WARNING,
> +					_("open of %s failed: %s\n"),
> +					persp->a.dstdir,
> +					strerror(errno));
> +			return BOOL_FALSE;
> +		}
> +
> +		/* Get the xattr details for the destination folder */
> +		if (ioctl(dstfd, XFS_IOC_FSGETXATTR, &dstxattr) < 0) {
> +			(void)close(dstfd);
> +			mlog(MLOG_ERROR,
> +			      _("failed to get xattr information for dst inode\n"));
> +			return BOOL_FALSE;
> +		}
> +
> +		(void)close(dstfd);
> +
> +		/* test against rtinherit */
> +		if((dstxattr.fsx_xflags & XFS_XFLAG_RTINHERIT) != 0) {
> +			tranp->t_dstisrealtime = true;
> +		}
> +	}
> +
>  	/* map in pers. inv. descriptors, if any. NOTE: this ptr is to be
>  	 * referenced ONLY via the macros provided; the descriptors will be
>  	 * occasionally remapped, causing the ptr to change.
> @@ -7270,6 +7304,10 @@ restore_file_cb(void *cp, bool_t linkpr, char *path1, char *path2)
>  	bool_t ahcs = contextp->cb_ahcs;
>  	stream_context_t *strctxp = (stream_context_t *)drivep->d_strmcontextp;
>  
> +	if (tranp->t_dstisrealtime) {
> +		bstatp->bs_xflags |= XFS_XFLAG_REALTIME;
> +	}
> +
>  	int rval;
>  	bool_t ok;
>  
> @@ -7480,6 +7518,10 @@ restore_reg(drive_t *drivep,
>  	if (tranp->t_toconlypr)
>  		return BOOL_TRUE;
>  
> +	if (tranp->t_dstisrealtime) {
> +	      bstatp->bs_xflags |= XFS_XFLAG_REALTIME;
> +	}
> +
>  	oflags = O_CREAT | O_RDWR;
>  	if (persp->a.dstdirisxfspr && bstatp->bs_xflags & XFS_XFLAG_REALTIME)
>  		oflags |= O_DIRECT;
> @@ -8470,6 +8512,11 @@ restore_extent(filehdr_t *fhdrp,
>  		}
>  		assert(new_off == off);
>  	}
> +
> +	if (tranp->t_dstisrealtime) {
> +	      bstatp->bs_xflags |= XFS_XFLAG_REALTIME;
> +	}
> +
>  	if ((fd != -1) && (bstatp->bs_xflags & XFS_XFLAG_REALTIME)) {
>  		if ((ioctl(fd, XFS_IOC_DIOINFO, &da) < 0)) {
>  			mlog(MLOG_NORMAL | MLOG_WARNING, _(
> @@ -8729,6 +8776,10 @@ restore_extattr(drive_t *drivep,
>  
>  	assert(extattrbufp);
>  
> +	if (tranp->t_dstisrealtime) {
> +		bstatp->bs_xflags |= XFS_XFLAG_REALTIME;
> +	}
> +
>  	if (!isdirpr)
>  		isfilerestored = partial_check(bstatp->bs_ino,  bstatp->bs_size);
>  
> 
