Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37328 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751984AbdHCLxv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Aug 2017 07:53:51 -0400
Date: Thu, 3 Aug 2017 07:53:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] generic/224: filter out expected XFS warnings for
 mixed direct/buffer I/O
Message-ID: <20170803115349.GD62447@bfoster.bfoster>
References: <20170731042825.6250-1-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170731042825.6250-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Jul 31, 2017 at 12:28:24PM +0800, Eryu Guan wrote:
> generic/224 is doing concurrent direct and buffered I/O to the same
> set of files, and this triggers some expected warnings on XFS. So
> filter out these warnings just like what we did in generic/095 and
> generic/247.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  tests/generic/224 | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/generic/224 b/tests/generic/224
> index 2c30a75258f3..29b1c05d06df 100755
> --- a/tests/generic/224
> +++ b/tests/generic/224
> @@ -82,5 +82,14 @@ for i in `seq 0 1 $FILES`; do
>  done
>  wait
>  echo "*** Silence is golden ***"
> -status=0
> +
> +# unmount and check dmesg, filtering out expected XFS warnings about mixed
> +# direct and buffered I/O
> +_scratch_unmount
> +if [ "$FSTYP" == "xfs" ]; then
> +	_check_dmesg _filter_xfs_dmesg
> +else
> +	_check_dmesg
> +fi
> +status=$?
>  exit
> -- 
> 2.13.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
