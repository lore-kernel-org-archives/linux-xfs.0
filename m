Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52376 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbeI0F3b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Sep 2018 01:29:31 -0400
Date: Wed, 26 Sep 2018 16:13:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfsprogs: document environment variables
Message-ID: <20180926231341.GY20086@magnolia>
References: <05122b65-0a26-c36f-1efb-78591497ed90@sandeen.net>
 <959fd8f0-b03d-decd-3048-e1c7d88051fa@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <959fd8f0-b03d-decd-3048-e1c7d88051fa@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Sep 26, 2018 at 04:27:27PM -0500, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> Document the various environment variables used in the code,
> almost all are for debugging.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/doc/README-env-vars.txt b/doc/README-env-vars.txt
> new file mode 100644
> index 0000000..eec59a8
> --- /dev/null
> +++ b/doc/README-env-vars.txt
> @@ -0,0 +1,26 @@
> +Several environment variables are used within the code, primarily for
> +for debugging purposes; they are documented here.  In most cases simply
> +setting the environment variable enables the behavior, but in some
> +cases the value assigned influences behavior as well, as noted below.
> +
> +General
> +-------
> +LIBXFS_LEAK_CHECK            -- warn and exit(1) if zone-allocated memory
> +                                is leaked at exit.
> +xfs_fsr
> +-------
> +FSRXFSTEST                   -- enable -C nfrag in theory coalesces into
> +                                nfrag extents.  Doesn't work.

<eyeroll> Maybe someone should fix/remove that?

Anyway, for the documentation,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +xfs_scrub
> +---------
> +Known debug tweaks (pass -d and set the environment variable):
> +XFS_SCRUB_FORCE_ERROR        -- pretend all metadata is corrupt
> +XFS_SCRUB_FORCE_REPAIR       -- repair all metadata even if it's ok
> +XFS_SCRUB_NO_KERNEL          -- pretend there is no kernel ioctl
> +XFS_SCRUB_NO_SCSI_VERIFY     -- disable SCSI VERIFY (if present)
> +XFS_SCRUB_PHASE              -- run only this scrub phase
> +XFS_SCRUB_THREADS            -- start exactly this number of threads
> +
> +Available even in non-debug mode:
> +SERVICE_MODE                 -- compress all error codes to 1 for LSB
> +                                service action compliance
> 
