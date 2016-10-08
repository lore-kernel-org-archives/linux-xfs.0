Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29376 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbcJHRpV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Oct 2016 13:45:21 -0400
Date: Sat, 8 Oct 2016 10:45:14 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs/122: remove dead code
Message-ID: <20161008174514.GB5619@birch.djwong.org>
References: <1475916836-30439-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1475916836-30439-1-git-send-email-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Sat, Oct 08, 2016 at 04:53:56PM +0800, Eryu Guan wrote:
> Seems this hunk of dead code is used for debug purpose to inspect
> what the output looks like after _attribute_filter. Just remove it.

Heh.  Barf.  Ooops. :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  tests/xfs/122 | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/tests/xfs/122 b/tests/xfs/122
> index 330d3ac..f39ceba 100755
> --- a/tests/xfs/122
> +++ b/tests/xfs/122
> @@ -196,10 +196,6 @@ echo 'int main(int argc, char *argv[]) {' >>$cprog
>  #
>  cat /usr/include/xfs/xfs*.h | indent |\
>  _attribute_filter |\
> -egrep '(} *xfs_.*_t|^struct xfs_[a-z0-9_]*$)' > /tmp/barf
> -
> -cat /usr/include/xfs/xfs*.h | indent |\
> -_attribute_filter |\
>  egrep '(} *xfs_.*_t|^struct xfs_[a-z0-9_]*$)' |\
>  egrep -v -f $tmp.ignore |\
>  sed -e 's/^.*}[[:space:]]*//g' -e 's/;.*$//g' -e 's/_t, /_t\n/g' |\
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
