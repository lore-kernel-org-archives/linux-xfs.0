Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47986 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751223AbeAYH6r (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Jan 2018 02:58:47 -0500
Date: Thu, 25 Jan 2018 15:58:45 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 3/5] generic/403: don't spew '$GETFATTR_PROG: Killed'
 messages
Message-ID: <20180125075845.GG18267@eguan.usersys.redhat.com>
References: <151683799705.17051.9987269343206294671.stgit@magnolia>
 <151683801556.17051.2037237512407215800.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151683801556.17051.2037237512407215800.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Jan 24, 2018 at 03:53:35PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use a runfile presence check to control the background getfattr loop
> instead of using kill -9.  This helps us to avoid the problem that
> the controlling bash will print a process killed message, which wrecks
> the golden output.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I saw this failure in automatic fstests runs occasionally, but could
never reproduce it manually. Thanks for fixing it!

> ---
>  tests/generic/403 |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/tests/generic/403 b/tests/generic/403
> index 17897ff..18fd1e5 100755
> --- a/tests/generic/403
> +++ b/tests/generic/403
> @@ -61,7 +61,9 @@ touch $SCRATCH_MNT/file
>  $SETFATTR_PROG -n trusted.small -v a $SCRATCH_MNT/file
>  
>  # start a background getxattr loop for the existing xattr
> -while [ true ]; do
> +runfile="$tmp.getfattr"
> +touch $runfile
> +while [ -e $runfile ]; do
>  	$GETFATTR_PROG --absolute-names -n trusted.small $SCRATCH_MNT/file \
>  		> /dev/null || break
>  done &
> @@ -75,7 +77,7 @@ for i in $(seq 0 99); do
>  	$SETFATTR_PROG -x trusted.big $SCRATCH_MNT/file
>  done
>  
> -kill -9 $getfattr_pid > /dev/null 2>&1
> +rm -rf $runfile

I changed it to 'rm -f $runfile', dropped '-r'.

Thanks,
Eryu

>  wait > /dev/null 2>&1
>  
>  echo Silence is golden
> 
