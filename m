Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59628 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750760AbdALTlU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Jan 2017 14:41:20 -0500
Subject: Re: [PATCH 7/5] xfs_repair.8: document dirty log conditions
References: <148419038856.32674.6479634718673149751.stgit@birch.djwong.org>
 <20170112193444.GY14038@birch.djwong.org>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <89e49f41-86fe-2af1-df7b-1e40af22c5b1@redhat.com>
Date: Thu, 12 Jan 2017 13:41:18 -0600
MIME-Version: 1.0
In-Reply-To: <20170112193444.GY14038@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 1/12/17 1:34 PM, Darrick J. Wong wrote:
> Add a section describing what is a dirty log, why xfs_repair won't touch
> such things, and what one can do to clear the condition and check the
> filesystem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, this seems fine.

<resists urge to nitpick> ;)
<reserves right to last-minute commit mods>  :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  man/man8/xfs_repair.8 |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/man/man8/xfs_repair.8 b/man/man8/xfs_repair.8
> index 1b4d9e3..e4ca88e 100644
> --- a/man/man8/xfs_repair.8
> +++ b/man/man8/xfs_repair.8
> @@ -510,6 +510,25 @@ will return a status of 1 if filesystem corruption was detected and
>  0 if no filesystem corruption was detected.
>  .B xfs_repair
>  run without the \-n option will always return a status code of 0.
> +.SH DIRTY LOGS
> +Due to the design of the XFS log, a dirty log can only be replayed on a
> +machine having the same CPU architecture as the machine which was
> +writing to the log.
> +xfs_repair cannot replay a dirty log and will return a status code of 2
> +when it detects a dirty log.
> +.PP
> +In this situation, the log can be replayed by mounting and immediately
> +unmounting the filesystem on the same class of machine that crashed.
> +Please make sure that the machine's hardware is reliable before
> +replaying to avoid compounding the problems.
> +.PP
> +If mounting fails, the log can be erased by running xfs_repair with the
> +-L option.
> +All metadata updates in progress at the time of the crash will be lost,
> +which may cause significant filesystem damage.
> +This should
> +.B only
> +be used as a last resort.
>  .SH BUGS
>  The filesystem to be checked and repaired must have been
>  unmounted cleanly using normal system administration procedures
> 

