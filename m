Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F6ABC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jun 2023 14:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbjFIOsW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jun 2023 10:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbjFIOsV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jun 2023 10:48:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC3CE4A
        for <linux-xfs@vger.kernel.org>; Fri,  9 Jun 2023 07:48:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A7F960F66
        for <linux-xfs@vger.kernel.org>; Fri,  9 Jun 2023 14:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA74C433D2;
        Fri,  9 Jun 2023 14:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686322099;
        bh=42i9vQyCUG6JUFkCTQBTvHrs1h22yqQ7/0oY9Mpy0ew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e3o0zhd7E0vzIY9LtYkaEdly5nrVy6X7FNCbWaKDda02eokT0/k3MJChCWZn12pDY
         qkzaz7PnqTR1t1xWSHLFCsR8N+EFgkMPGS5/yxSIirg0wy5U/ZUgc50PaTlFBA5iLP
         a4Q3IItfne/pQo6SU+u5deZqph0IllFDjkuusPaehcv6zL5/wBcqLJvpjHfmPx9yfg
         8bz6LCw6C/LclR8H/j4OjK8Db6tZGVpFRuH1IRGAINwTqQrKqSyhLHLHyYSG2Cxbgp
         VDdCt4M2S+SAVOEP3iOfQ2Zeh+R7/4Mb/aDTCL99MDRxp+vSFGNAO3MT3PknTad+qb
         L8HagcEHLSPzQ==
Date:   Fri, 9 Jun 2023 07:48:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_repair: always print an estimate when reporting
 progress
Message-ID: <20230609144819.GX1325469@frogsfrogsfrogs>
References: <20230531064024.1737213-1-ddouwsma@redhat.com>
 <20230531064143.1737591-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230531064143.1737591-1-ddouwsma@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 31, 2023 at 04:41:43PM +1000, Donald Douwsma wrote:
> If xfs_repair completes the work for a given phase while allocation
> groups are still being processed the estimated time may be zero, when
> this occures xfs_repair prints an incomplete string.
> 
>  # xfs_repair -o ag_stride=4 -t 1 /dev/sdc
>  Phase 1 - find and verify superblock...
>          - reporting progress in intervals of 1 second
>  Phase 2 - using internal log
>          - zero log...
>          - 20:52:11: zeroing log - 0 of 2560 blocks done
>          - 20:52:12: zeroing log - 2560 of 2560 blocks done
>          - scan filesystem freespace and inode maps...
>          - 20:52:12: scanning filesystem freespace - 3 of 4 allocation groups done
>          - 20:52:13: scanning filesystem freespace - 4 of 4 allocation groups done
>          - found root inode chunk
>  Phase 3 - for each AG...
>          - scan and clear agi unlinked lists...
>          - 20:52:13: scanning agi unlinked lists - 4 of 4 allocation groups done
>          - process known inodes and perform inode discovery...
>          - agno = 0
>          - 20:52:13: process known inodes and inode discovery - 3456 of 40448 inodes done
>          - 20:52:14: process known inodes and inode discovery - 3456 of 40448 inodes done
>          - 20:52:14: Phase 3: elapsed time 1 second - processed 207360 inodes per minute
>          - 20:52:14: Phase 3: 8% done - estimated remaining time 10 seconds
>          - 20:52:15: process known inodes and inode discovery - 3456 of 40448 inodes done
>          - 20:52:15: Phase 3: elapsed time 2 seconds - processed 103680 inodes per minute
>          - 20:52:15: Phase 3: 8% done - estimated remaining time 21 seconds
>          - 20:52:16: process known inodes and inode discovery - 33088 of 40448 inodes done
>          - 20:52:16: Phase 3: elapsed time 3 seconds - processed 661760 inodes per minute
>          - 20:52:16: Phase 3: 81% done - estimated remaining time
>          - agno = 1
>  	...
> 
> Make this more consistent by printing 'estimated remaining time 0
> seconds' if there is a 0 estimate.
> 
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  repair/progress.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/repair/progress.c b/repair/progress.c
> index f6c4d988..9fb6e3eb 100644
> --- a/repair/progress.c
> +++ b/repair/progress.c
> @@ -501,6 +501,8 @@ duration(int length, char *buf)
>  			strcat(buf, _(", "));
>  		strcat(buf, temp);
>  	}
> +	if (!(weeks|days|hours|minutes|seconds))
> +		sprintf(buf, _("0 seconds"));
>  
>  	return(buf);
>  }
> -- 
> 2.39.3
> 
