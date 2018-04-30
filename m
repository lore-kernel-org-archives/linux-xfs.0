Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43764 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751569AbeD3FbV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 01:31:21 -0400
Date: Sun, 29 Apr 2018 22:30:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] fsck.xfs: do not use 'function' keyword
Message-ID: <20180430053059.GA21688@magnolia>
References: <20a302b8-a5c8-7cf2-94d4-3cc41560976c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20a302b8-a5c8-7cf2-94d4-3cc41560976c@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Jan Tulak <jtulak@redhat.com>

On Sun, Apr 29, 2018 at 08:15:28PM -0500, Eric Sandeen wrote:
> It was pointed out on irc that fsck.xfs uses the 'function' keyword
> although it invokes /bin/sh - 'function' is a bashism.  It's not needed
> here, so just remove it.
> 
> Fixes: 04a2d5d ("fsck.xfs: allow forced repairs using xfs_repair")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Does RHEL have 'checkbashisms'?

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> This might be a 4.16.1 item, if strict-sh initscripts fail to run fsck.xfs at
> boot time ...?
> 
> diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
> index c9fc3eb..1916c07 100755
> --- a/fsck/xfs_fsck.sh
> +++ b/fsck/xfs_fsck.sh
> @@ -6,7 +6,7 @@
>  NAME=$0
>  
>  # get the right return code for fsck
> -function repair2fsck_code() {
> +repair2fsck_code() {
>  	case $1 in
>  	0)  return 0 # everything is ok
>  		;;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
