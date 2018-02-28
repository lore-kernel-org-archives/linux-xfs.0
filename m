Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36598 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751791AbeB1D5e (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Feb 2018 22:57:34 -0500
Subject: Re: [PATCH v2] xfs_repair: Add missing braces
References: <b311ddb9-e996-9e4b-f7f1-d0d45b8f782a@sandeen.net>
 <1519789313-4037-1-git-send-email-yangx.jy@cn.fujitsu.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e5b3cd69-4e4b-f5b4-6867-8ce1cad8e4e1@sandeen.net>
Date: Tue, 27 Feb 2018 21:57:32 -0600
MIME-Version: 1.0
In-Reply-To: <1519789313-4037-1-git-send-email-yangx.jy@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org

On 2/27/18 9:41 PM, Xiao Yang wrote:
> When xlog_find_tail() fails to find the head or the tail, the missing
> braces leads that an unparseable log always exits with status 2, even
> if we've asked for -n or -L which should proceed.  We can expose this
> issue by xfstests case xfs/098.
> 
> Fixes:'commit b04647edea32 ("xfs_repair: exit with status 2 if log dirtiness is unknown")'
> 
> Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>

Thanks. I may make the subject more descriptive of the resulting
bug, but this is much better.

And thanks again for spotting it!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---


>  repair/phase2.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/repair/phase2.c b/repair/phase2.c
> index 992e997..c124882 100644
> --- a/repair/phase2.c
> +++ b/repair/phase2.c
> @@ -78,12 +78,13 @@ zero_log(
>  		do_warn(
>  		_("zero_log: cannot find log head/tail (xlog_find_tail=%d)\n"),
>  			error);
> -		if (!no_modify && !zap_log)
> +		if (!no_modify && !zap_log) {
>  			do_warn(_(
>  "ERROR: The log head and/or tail cannot be discovered. Attempt to mount the\n"
>  "filesystem to replay the log or use the -L option to destroy the log and\n"
>  "attempt a repair.\n"));
>  			exit(2);
> +		}
>  	} else {
>  		if (verbose) {
>  			do_log(
> 
