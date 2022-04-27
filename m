Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13DC8C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 00:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356430AbiD0Alw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356400AbiD0Alf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 20:41:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E2D38D83
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 17:38:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F4ADB823FC
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 00:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3FCC385A4;
        Wed, 27 Apr 2022 00:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651019903;
        bh=m4bBQ8jXwTqPvFx8H5n8BZro7adwDSBTXL4/RZ7KuPQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QdauqNCZrg2sOXuUF9E+2bOsmwmuKxpQKsi4SbxEyvCxBo7OjFfQLttwGU1WpCsQL
         RWyMighmStSm/HBFK+8/cbS5AMOTmmXEe/GPjUSCadEzSsd9gMVEv33napvwuRR+tc
         WU6OwODwjSFsEUFh8QDKpQ14PJU1w5HIPz278WUoPo/NOQsGr7933PRg5ON3gFX9sn
         hBRL3swVwQaPn8MD5P6OeHx4MdeEx40UKEDB/i2PaZIYXh+Ir9RMDrAUn7FCPiDHZB
         +dxpoMbW7x+yOGUYrP19deNPUq8fwQnzVJ6ju2RU3kK+EuIT3kFGMjZPEStEeAki2e
         v+HpHN/PfF8ww==
Date:   Tue, 26 Apr 2022 17:38:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_io: add a quiet option to bulkstat
Message-ID: <20220427003822.GW17025@magnolia>
References: <20220426234453.682296-1-david@fromorbit.com>
 <20220426234453.682296-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426234453.682296-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 27, 2022 at 09:44:52AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This is purely for driving the kernel bulkstat operations as hard
> as userspace can drive them - we don't care about the actual output,
> just want to drive maximum IO rates through the inode cache.
> 
> Bulkstat at 3.4 million inodes a second via xfs_io currently burns
> about 30% of CPU time just formatting and outputting the stat
> information to stdout and dumping it to /dev/null.
> 
> 		wall time	rate	IOPS	bandwidth
> unpatched	17.823s		3.4M/s	70k	1.9GB/s
> with -q		15.682		6.1M/s  150k	3.5GB/s
> 
> The disks are at about 30% of max bandwidth and only at 70kiops, so
> this CPU can be used to drive the kernel and IO subsystem harder.
> 
> Wall time doesn't really go down on this specific test because the
> increase in inode cache turn-over (about 10GB/s of cached metadata
> (in-core inodes and buffers) is being cycled through memory on a
> machine with 16GB of RAM) and that hammers memory reclaim into a
> utter mess that often takes seconds for it to recover from...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Heh, moar bulkstat.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  io/bulkstat.c     | 9 ++++++++-
>  man/man8/xfs_io.8 | 6 +++++-
>  2 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/io/bulkstat.c b/io/bulkstat.c
> index 201470b29223..411942006591 100644
> --- a/io/bulkstat.c
> +++ b/io/bulkstat.c
> @@ -67,6 +67,7 @@ bulkstat_help(void)
>  "\n"
>  "   -a <agno>  Only iterate this AG.\n"
>  "   -d         Print debugging output.\n"
> +"   -q         Be quiet, no output.\n"
>  "   -e <ino>   Stop after this inode.\n"
>  "   -n <nr>    Ask for this many results at once.\n"
>  "   -s <ino>   Inode to start with.\n"
> @@ -104,11 +105,12 @@ bulkstat_f(
>  	uint32_t		ver = 0;
>  	bool			has_agno = false;
>  	bool			debug = false;
> +	bool			quiet = false;
>  	unsigned int		i;
>  	int			c;
>  	int			ret;
>  
> -	while ((c = getopt(argc, argv, "a:de:n:s:v:")) != -1) {
> +	while ((c = getopt(argc, argv, "a:de:n:qs:v:")) != -1) {
>  		switch (c) {
>  		case 'a':
>  			agno = cvt_u32(optarg, 10);
> @@ -135,6 +137,9 @@ bulkstat_f(
>  				return 1;
>  			}
>  			break;
> +		case 'q':
> +			quiet = true;
> +			break;
>  		case 's':
>  			startino = cvt_u64(optarg, 10);
>  			if (errno) {
> @@ -198,6 +203,8 @@ _("bulkstat: startino=%lld flags=0x%x agno=%u ret=%d icount=%u ocount=%u\n"),
>  		for (i = 0; i < breq->hdr.ocount; i++) {
>  			if (breq->bulkstat[i].bs_ino > endino)
>  				break;
> +			if (quiet)
> +				continue;
>  			dump_bulkstat(&breq->bulkstat[i]);
>  		}
>  	}
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index e3c5d3ea99dd..d876490bf65d 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -1143,7 +1143,7 @@ for the current memory mapping.
>  
>  .SH FILESYSTEM COMMANDS
>  .TP
> -.BI "bulkstat [ \-a " agno " ] [ \-d ] [ \-e " endino " ] [ \-n " batchsize " ] [ \-s " startino " ] [ \-v " version" ]
> +.BI "bulkstat [ \-a " agno " ] [ \-d ] [ \-e " endino " ] [ \-n " batchsize " ] [ \-q ] [ \-s " startino " ] [ \-v " version" ]
>  Display raw stat information about a bunch of inodes in an XFS filesystem.
>  Options are as follows:
>  .RS 1.0i
> @@ -1164,6 +1164,10 @@ Defaults to stopping when the system call stops returning results.
>  Retrieve at most this many records per call.
>  Defaults to 4,096.
>  .TP
> +.BI \-q
> +Run quietly.
> +Does not parse or output retrieved bulkstat information.
> +.TP
>  .BI \-s " startino"
>  Display inode allocation records starting with this inode.
>  Defaults to the first inode in the filesystem.
> -- 
> 2.35.1
> 
