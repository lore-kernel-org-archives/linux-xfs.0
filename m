Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:34255 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936884AbdKRVvn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Nov 2017 16:51:43 -0500
Date: Sun, 19 Nov 2017 08:51:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Illegal value 0 for -l sunit option ?
Message-ID: <20171118215140.GL5858@dastard>
References: <alpine.DEB.2.10.1711181547110.14549@gozora.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.10.1711181547110.14549@gozora.sk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vladimir Gozora <c@gozora.sk>
Cc: linux-xfs@vger.kernel.org

On Sat, Nov 18, 2017 at 04:00:08PM +0100, Vladimir Gozora wrote:
> Hello XFS team,
> 
> I'm working on ReaR project (https://github.com/rear/rear) which
> aims for bare-metal disaster recovery.
> Lately I’ve run across behavior of mkfs.xfs which I don’t really
> know if is correct or not.
> The thing is that when I try to create XFS file system with
> xfsprogs-4.5.0 following commands runs just fine:
> mkfs.xfs -f -i size=512 -d agcount=4 -s size=512 -i attr=2 -i
> projid32bit=1 -m crc=1 -m finobt=1 -b size=4096 -i maxpct=25 -d
> sunit=0 -d swidth=0 -l version=2 -l sunit=0 -l lazy-count=1 -n
> size=4096 -n version=2 -r extsize=4096 <destination>
> when I try same command with xfsprogs-4.10.0, I get following error:
> Illegal value 0 for -l sunit option. value is too small

Yup, old mkfs would accept values that were illegal and could do
completly unpredictable things with them. We tightened up the input
parsing to only accept valid values xfsprogs in 4.7.0, and in
particular this commit is relevant:

commit 2942ff49bdb6df08fb56674215b31c07cfc7c1fd
Author: Jan Tulak <jtulak@redhat.com>
Date:   Tue Jun 21 12:52:22 2016 +1000

    mkfs: fix -l su minval
    
    -l su should be in range BBTOB(1) <= L_SU <= XLOG_MAX_RECORD_BSIZE,
    because the upper limit is imposed by kernel on iclogbuf: stripe
    unit can't be bigger than the log buffer, but the log buffer can
    span multiple stripe units. L_SUNIT is changed in the same way.
    
    Signed-off-by: Jan Tulak <jtulak@redhat.com>
    Reviewed-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 1593ee893f92..ce1ade25780e 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -452,7 +452,7 @@ struct opt_params lopts = {
                { .index = L_SUNIT,
                  .conflicts = { L_SU,
                                 LAST_CONFLICT },
-                 .minval = BTOBB(XLOG_MIN_RECORD_BSIZE),
+                 .minval = 1,
                  .maxval = BTOBB(XLOG_MAX_RECORD_BSIZE),
                  .defaultval = SUBOPT_NEEDS_VAL,
                },
@@ -460,7 +460,7 @@ struct opt_params lopts = {
                  .conflicts = { L_SUNIT,
                                 LAST_CONFLICT },
                  .convert = true,
-                 .minval = XLOG_MIN_RECORD_BSIZE,
+                 .minval = BBTOB(1),
                  .maxval = XLOG_MAX_RECORD_BSIZE,
                  .defaultval = SUBOPT_NEEDS_VAL,
                },

> In ReaR we are trying to backup whole OS and recreate it closest to
> original as possible, so I was collecting data obtained from
> xfs_info and used them during recovery phase. This approach would
> unfortunately not work any more, since I can't use (at least) log
> sections "sunit=0 blks"
> and pass it back to mkfs.xfs ...
> Is there some (correct) way how I could save options that were used
> during XFS file system creation and use them later, during recovery
> phase?

Why not just use xfs_copy? I mean, if all you're trying to do is
make a space efficient block-level clone of an XFS filesytem, then
we've already got a tool to do that...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
