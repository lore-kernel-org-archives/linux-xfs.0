Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:42236 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934407AbdKBVPo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2017 17:15:44 -0400
Date: Fri, 3 Nov 2017 08:12:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] common: Check for fiemap range argument support
Message-ID: <20171102211259.GE4094@dastard>
References: <20171102031622.GV17339@eguan.usersys.redhat.com>
 <1509610421-16716-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1509610421-16716-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Nov 02, 2017 at 10:13:41AM +0200, Nikolay Borisov wrote:
> From: Nikolay Borsiov <nborisov@suse.com>
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> v3:
>  * Changed the way we detect ranged args. Now use a regexp which checks 
>  explicitly for the ranged args
>  common/rc | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index e2a8229..f7a5fe9 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2053,8 +2053,15 @@ _require_xfs_io_command()
>  			-c "$command 4k 8k" $testfile 2>&1`
>  		;;
>  	"fiemap")
> +		if echo "$param" | egrep -q "[[:digit:]]+[bskmgtpe]? [[:digit:]]+[bskmgtpe]?$"

What is that for?

If you're going to dump crazy complex regexes to match something,
you need comments to explain it in both the commit message and the
code.

And, really, if we need to add complex or tricky code to check a
command exists, we've done somethign wrong. Don't make the "fiemap
range" command by triggered/detected by an optional parameter, add a
specific option instead e.g. "-r" for "range query":

$ xfs_io -c "fiemap -r 0 10k" /mnt/foo

Then you can test it like the falloc command tests it's different
parameters....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
