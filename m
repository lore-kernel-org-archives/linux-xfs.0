Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33473 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbfCWLok (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 Mar 2019 07:44:40 -0400
Date: Sat, 23 Mar 2019 19:44:32 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] _require_prjquota: Disable tests only when using
 realtime fs
Message-ID: <20190323114432.GV2824@desktop>
References: <20190320142112.31239-1-chandan@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320142112.31239-1-chandan@linux.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.ibm.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Mar 20, 2019 at 07:51:12PM +0530, Chandan Rajendra wrote:
> $USE_EXTERNAL needs to be set when using external log devices. In such a
> setup, tests which have "_require_prjquota
> $SCRATCH_DEV" (e.g. generic/383)  incorrectly end up being marked as
> "not run" since the test "[ "$USE_EXTERNAL" = yes -a ! -z "$_dev" ]"
> evaluates to true.
> 
> This commit fixes the bug by marking the test as "not run" only when
> $USE_EXTERNAL is set and one of $TEST_RTDEV or $SCRATCH_RTDEV is set.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.ibm.com>
> ---
>  common/quota | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/common/quota b/common/quota
> index 9309e786..cb627f19 100644
> --- a/common/quota
> +++ b/common/quota
> @@ -86,8 +86,9 @@ _require_prjquota()
>      fi
>      src/feature -P $_dev
>      [ $? -ne 0 ] && _notrun "Installed kernel does not support project quotas"
> -    if [ "$USE_EXTERNAL" = yes -a ! -z "$_dev" ]; then
> -	_notrun "Project quotas not supported on realtime filesystem"
> +    if [ "$USE_EXTERNAL" = yes -a \
> +		 \( ! -z "$TEST_RTDEV" \-o ! -z "$SCRATCH_RTDEV" \) ]; then
> +        _notrun "Project quotas not supported on realtime filesystem"

I changed this to

    if [ "$USE_EXTERNAL" = yes ]; then
        if [ -n "$TEST_RTDEV" -o -n "$SCRATCH_RTDEV" ]; then
            _notrun "Project quotas not supported on realtime filesystem"
        fi
    fi

which seems easier to read.

Thanks,
Eryu

>      fi
>  }
>  
> -- 
> 2.19.1
> 
