Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43648 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933066AbdKRDvC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Nov 2017 22:51:02 -0500
Date: Sat, 18 Nov 2017 11:51:00 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [fstests PATCH v4 2/4] dm-log-writes: only replay log to marks
 that exist
Message-ID: <20171118035100.GC2749@eguan.usersys.redhat.com>
References: <20171117202828.25472-1-ross.zwisler@linux.intel.com>
 <20171117202828.25472-3-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171117202828.25472-3-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>, Amir Goldstein <amir73il@gmail.com>

On Fri, Nov 17, 2017 at 01:28:26PM -0700, Ross Zwisler wrote:
> The 'replay-log' executable will replay the dm-log-writes log until the
> given mark, or until the end of the log if the mark isn't found.
> 
> This means that if the mark you're looking for was never inserted in the
> log or if you give garbage to _log_writes_replay_log() the entire log will
> be replayed.  This can cause unexpected test results.
> 
> Fix this by making sure that the mark we're given actually exists in the
> log before we allow the replay.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  common/dmlogwrites | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/common/dmlogwrites b/common/dmlogwrites
> index 247c744..80ed4fc 100644
> --- a/common/dmlogwrites
> +++ b/common/dmlogwrites
> @@ -72,6 +72,10 @@ _log_writes_replay_log()
>  {
>  	_mark=$1
>  
> +	$here/src/log-writes/replay-log --log $LOGWRITES_DEV --find \
> +		--end-mark $_mark >> $seqres.full 2>&1
> +	[ $? -ne 0 ] && _fail "mark does not exist"

Print out $_mark too?

Thanks,
Eryu

> +
>  	$here/src/log-writes/replay-log --log $LOGWRITES_DEV --replay $SCRATCH_DEV \
>  		--end-mark $_mark >> $seqres.full 2>&1
>  	[ $? -ne 0 ] && _fail "replay failed"
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
