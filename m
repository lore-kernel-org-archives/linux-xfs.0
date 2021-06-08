Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 621E5C47082
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 04:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A93D61249
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 04:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbhFHEQU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Jun 2021 00:16:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhFHEQU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Jun 2021 00:16:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F61160FE3;
        Tue,  8 Jun 2021 04:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623125668;
        bh=Z4r9UEXoq6V3dO6wdkLKuKxWrXBL6v55Ue6kff7TFBQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p985Yb8AxEtEdnHdEuimSezGhmhW95XZq22z2y3BLT4/YjIE/anrrSXCUe5CcgyWh
         1/oD4rbtuwVNJo4+OyLiItrofD8GJ9p4ykI0JBmgwFj3yLkQltplSCq9l3mvhhPwTK
         /EYDjXGbH49tyfLIoFdxwz80I/MlhUZGhzPKy3f9qr6j5k2lSTV6kNUZ2oTDp4otq+
         jfyP9JD/90nV3NHc81t5hJJcr/HIoVgDVALnCqoCE/1nCPFyVr2AMusOwwwGzDWTU0
         V6zxvJ4awaaFDg0DY9gH3wckvls2U6h3/eTHpDHbbMtFLfA4AgTxI66ht690nptmGU
         ffUE1P5ZtrpEg==
Date:   Mon, 7 Jun 2021 21:14:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: introduce CPU hotplug infrastructure
Message-ID: <20210608041427.GQ2945738@locust>
References: <20210604032928.GU664593@dread.disaster.area>
 <20210605020354.GG26380@locust>
 <20210605021533.GH26380@locust>
 <20210606221119.GW664593@dread.disaster.area>
 <20210607000040.GX664593@dread.disaster.area>
 <20210607001714.GY664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607001714.GY664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 07, 2021 at 10:17:14AM +1000, Dave Chinner wrote:
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> We need to move to per-cpu state for CIL tracking, but to do that we
> need to handle CPUs being removed from the system by the hot-plug
> code. Introduce generic XFS infrastructure to handle CPU hotplug
> events that is set up at module init time and torn down at module
> exit time.
> 
> Initially, the CIL only needs CPU dead notifications, so we only set
> up a callback for these notifications. The infrastructure can be
> updated in future for CPU add notifications easily if every needed.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_super.c         | 38 +++++++++++++++++++++++++++++++++++++-
>  include/linux/cpuhotplug.h |  1 +
>  2 files changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 017ba9c24c2d..0146d3c89da9 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -2123,6 +2123,35 @@ xfs_destroy_workqueues(void)
>  	destroy_workqueue(xfs_alloc_wq);
>  }
>  
> +static int
> +xfs_cpu_dead(
> +	unsigned int		cpu)
> +{
> +	return 0;
> +}
> +
> +static int __init
> +xfs_cpu_hotplug_init(void)
> +{
> +	int	error;
> +
> +	error = cpuhp_setup_state_nocalls(CPUHP_XFS_DEAD,
> +					"xfs:dead", NULL,
> +					xfs_cpu_dead);
> +	if (error < 0) {
> +		xfs_alert(NULL,
> +"Failed to initialise CPU hotplug, error %d. XFS is non-functional.",
> +			error);
> +	}
> +	return error;
> +}
> +
> +static void
> +xfs_cpu_hotplug_destroy(void)
> +{
> +	cpuhp_remove_state_nocalls(CPUHP_XFS_DEAD);
> +}
> +
>  STATIC int __init
>  init_xfs_fs(void)
>  {
> @@ -2135,10 +2164,14 @@ init_xfs_fs(void)
>  
>  	xfs_dir_startup();
>  
> -	error = xfs_init_zones();
> +	error = xfs_cpu_hotplug_init();
>  	if (error)
>  		goto out;
>  
> +	error = xfs_init_zones();
> +	if (error)
> +		goto out_destroy_hp;
> +
>  	error = xfs_init_workqueues();
>  	if (error)
>  		goto out_destroy_zones;
> @@ -2218,6 +2251,8 @@ init_xfs_fs(void)
>  	xfs_destroy_workqueues();
>   out_destroy_zones:
>  	xfs_destroy_zones();
> + out_destroy_hp:
> +	xfs_cpu_hotplug_destroy();
>   out:
>  	return error;
>  }
> @@ -2240,6 +2275,7 @@ exit_xfs_fs(void)
>  	xfs_destroy_workqueues();
>  	xfs_destroy_zones();
>  	xfs_uuid_table_free();
> +	xfs_cpu_hotplug_destroy();
>  }
>  
>  module_init(init_xfs_fs);
> diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
> index 4a62b3980642..bf8f29ad9bf8 100644
> --- a/include/linux/cpuhotplug.h
> +++ b/include/linux/cpuhotplug.h
> @@ -52,6 +52,7 @@ enum cpuhp_state {
>  	CPUHP_FS_BUFF_DEAD,
>  	CPUHP_PRINTK_DEAD,
>  	CPUHP_MM_MEMCQ_DEAD,
> +	CPUHP_XFS_DEAD,
>  	CPUHP_PERCPU_CNT_DEAD,
>  	CPUHP_RADIX_DEAD,
>  	CPUHP_PAGE_ALLOC_DEAD,
