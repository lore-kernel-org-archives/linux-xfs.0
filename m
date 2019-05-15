Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:39173 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725857AbfEOGHw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 02:07:52 -0400
Date: Wed, 15 May 2019 16:07:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/11] libxfs: create new file trans_buf.c
Message-ID: <20190515060750.GY29573@dread.disaster.area>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
 <1557519510-10602-7-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557519510-10602-7-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, May 10, 2019 at 03:18:25PM -0500, Eric Sandeen wrote:
> Pull functions out of libxfs/*.c into trans_buf.c, if they roughly match
> the kernel's xfs_trans_buf.c file.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

So I have no problems with this, but I'm not sure what the eventual
goal is? Just sharing code, or is there some functionality that
requires a more complete transaction subsystem in userspace?

I'm asking because if the goal is eventual unification with the
kernel code, then we probably should name the files the same as the
kernel code so we don't have to rename them again when we do the
unification. That will make history searching a bit easier - less
file names to follow across and git blame works a whole lot better...

> +int
> +xfs_trans_read_buf_map(
> +	xfs_mount_t		*mp,
> +	xfs_trans_t		*tp,
> +	struct xfs_buftarg	*btp,
> +	struct xfs_buf_map	*map,
> +	int			nmaps,
> +	uint			flags,
> +	xfs_buf_t		**bpp,
> +	const struct xfs_buf_ops *ops)

Hmmmm. Will there be any follow-up to de-typedef these new files?

/me would love to just have a flag day that de-typedefs all of the
userspace code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
