Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q99Dci8Q046142 for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 08:38:44 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FzgwqMTrt0IWaANv for
	<xfs@oss.sgi.com>; Tue, 09 Oct 2012 06:40:14 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q99De2aC020083
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 09:40:14 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-88.phx2.redhat.com
	[10.3.113.88])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q99DdwiU029414
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 09:40:02 -0400
Date: Tue, 9 Oct 2012 10:39:58 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] 260: Add another corner case where length is zero
Message-ID: <20121009133958.GA22834@andromeda.usersys.redhat.com>
References: <1349785012-28588-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1349785012-28588-1-git-send-email-lczerner@redhat.com>
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

On Tue, Oct 09, 2012 at 02:16:52PM +0200, Lukas Czerner wrote:
> This commit adds another corner case to test FITRIM argument handling.
> In this case we set length to zero and we expect the number of discarded
> bytes to be obviously zero, however we've had bug in both ext4 and xfs
> where the internal variable would underflow. This test case will be able
> to catch that in future.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  260 |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/260 b/260
> index b005cd3..2ade9b3 100755
> --- a/260
> +++ b/260
> @@ -98,6 +98,19 @@ _scratch_unmount
>  _scratch_mkfs >/dev/null 2>&1
>  _scratch_mount
>  
> +# This should return zero
> +out=$("$FSTRIM" -v -s0 -l0 $SCRATCH_MNT)
> +bytes=${out%% *}
> +if [ $bytes -ne 0 ]; then
> +	status=1
> +	echo "We requested zero bytes to be discarded, however $bytes bytes"\
> +	     "were discarded instead. Length handling probably underflowed."
> +fi
> +
> +_scratch_unmount
> +_scratch_mkfs >/dev/null 2>&1
> +_scratch_mount
> +
>  # This is a bit fuzzy, but since the file system is fresh
>  # there should be at least (fssize/2) free space to trim.
>  # This is supposed to catch wrong FITRIM argument handling
> -- 
> 1.7.7.6
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

Looks good,

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
