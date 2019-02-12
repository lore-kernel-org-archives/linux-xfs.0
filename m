Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56478 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729923AbfBLODo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Feb 2019 09:03:44 -0500
Date: Tue, 12 Feb 2019 09:03:42 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] inject: skip tests when knob dir exists but knob
 doesn't
Message-ID: <20190212140341.GD35803@bfoster>
References: <154993786231.2062.8490515215533507881.stgit@magnolia>
 <154993786856.2062.15965021741779968907.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154993786856.2062.15965021741779968907.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: guaneryu@gmail.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Mon, Feb 11, 2019 at 06:17:48PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If the XFS error injection knob directory exists but the knob itself
> doesn't, then we know that this kernel doesn't support the knob and
> can skip the test.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  common/inject |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> 
> diff --git a/common/inject b/common/inject
> index 903fb379..984ec209 100644
> --- a/common/inject
> +++ b/common/inject
> @@ -62,6 +62,13 @@ _require_xfs_io_error_injection()
>  	knob="$(_find_xfs_mountdev_errortag_knob "${TEST_DEV}" "${type}")"
>  	test -w "${knob}" && return
>  
> +	# If the directory containing the sysfs error injection knob exists
> +	# but the knob itself isn't usable, this kernel doesn't know about
> +	# the knob.  Skip the test.
> +	if [ -d "$(dirname "${knob}")" ]; then
> +		_notrun "XFS error injection $type unknown on this kernel."
> +	fi
> +
>  	# NOTE: We can't actually test error injection here because xfs
>  	# hasn't always range checked the argument to xfs_errortag_add.
>  	# We also don't want to trip an error before we're ready to deal
> 
