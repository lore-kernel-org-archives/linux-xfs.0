Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 25 Oct 2008 13:27:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9PKRicK030988
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:27:44 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 216C6147F6CD
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:27:44 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id eB0qpenFAPX2RGTo for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:27:44 -0700 (PDT)
Date: Sat, 25 Oct 2008 16:27:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2 v2] convert xfs_getbmap to take formatter functions
Message-ID: <20081025202743.GH28002@infradead.org>
References: <49031E81.7040807@sandeen.net> <49032017.6070408@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49032017.6070408@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

> +int xfs_getbmapx_format(void __user **ap, struct getbmapx *bmv, int *filled)
> +{
> +	*filled = 0;
> +	if (copy_to_user(*ap, bmv, sizeof(struct getbmapx)))
> +		return XFS_ERROR(EFAULT);
> +
> +	*ap += sizeof(struct getbmapx);
> +	*filled = 1;
> +	return 0;
> +}
> +
> +int xfs_getbmap_format(void __user **ap, struct getbmapx *bmv, int *filled)
> +{
> +	*filled = 0;
> +	/* copy only getbmap portion (not getbmapx) */
> +	if (copy_to_user(*ap, bmv, sizeof(struct getbmap)))
> +		return XFS_ERROR(EFAULT);
> +
> +	*ap += sizeof(struct getbmap);
> +	*filled = 1;
> +	return 0;
> +}

Probably makes sense to have these two helpers in xfs_ioctl.c, where
they are used, similar to how fiemap is implemented.
