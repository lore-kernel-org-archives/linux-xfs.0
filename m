Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33894 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751326AbdFWHtF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Jun 2017 03:49:05 -0400
Date: Fri, 23 Jun 2017 15:49:02 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 9/8] common/populate: remember multi-device configurations
Message-ID: <20170623074902.GK23360@eguan.usersys.redhat.com>
References: <149808222258.8924.1682057078986741098.stgit@birch.djwong.org>
 <20170622062653.GF3787@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170622062653.GF3787@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Jun 21, 2017 at 11:26:53PM -0700, Darrick J. Wong wrote:
> Record the external log and realtime device configurations when we
> create a sample filesystem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/populate |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/common/populate b/common/populate
> index e99ce68..b59ed02 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -713,7 +713,15 @@ _scratch_populate_cached() {
>  	rm -rf "$(find "${POPULATE_METADUMP}" -mtime +2 2>/dev/null)"
>  
>  	# Throw away cached image if it doesn't match our spec.
> -	meta_descr="FSTYP ${FSTYP} MKFS_OPTIONS ${MKFS_OPTIONS} SIZE $(blockdev --getsz "${SCRATCH_DEV}") ARGS $@"
> +	case "${FSTYP}" in
> +	"ext4")
> +		extra_descr="LOGDEV ${SCRATCH_LOGDEV} USE_EXTERNAL ${USE_EXTERNAL}";;
> +	"xfs")
> +		extra_descr="LOGDEV ${SCRATCH_LOGDEV} USE_EXTERNAL ${USE_EXTERNAL} RTDEV ${SCRATCH_RTDEV}";;
> +	*)
> +		extra_descr="";;
> +	esac
> +	meta_descr="FSTYP ${FSTYP} MKFS_OPTIONS ${MKFS_OPTIONS} SIZE $(blockdev --getsz "${SCRATCH_DEV}") ${extra_descr} ARGS $@"

This works fine if "test without external log" then "test with external
log" or vise-versa. But I just found that a second run with external log
still cause scratch dev fail to mount. Seems it's because e2image
doesn't take the external log dev into account when save/restore fs
image, then mounting scratch dev failed with

[184952.642892] EXT4-fs (sdc2): journal UUID does not match

Thanks,
Eryu

>  	cmp -s "${POPULATE_METADUMP_DESCR}" <(echo "${meta_descr}") || rm -rf "${POPULATE_METADUMP}"
>  
>  	# Do we have a cached image?
