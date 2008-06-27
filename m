Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jun 2008 06:02:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5RD2A7t004330
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 06:02:10 -0700
Date: Fri, 27 Jun 2008 09:03:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Move xfs_attr_rolltrans to xfs_trans_roll
Message-ID: <20080627130310.GA4659@infradead.org>
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com> <1214196150-5427-2-git-send-email-xaiki@sgi.com> <1214196150-5427-3-git-send-email-xaiki@sgi.com> <20080626082827.GC23954@infradead.org> <ncctzff1o7e.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ncctzff1o7e.fsf@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Looks good except for a tiny nitpick:

> +/*
> + * Calculate how many blocks we need for the new attribute,
> + */
> +int
> +xfs_attr_calc_size(
> +	struct xfs_inode *ip,
> +	int		namelen,
> +	int		valuelen,
> +	int		*local)
> +{
> +	struct xfs_mount *mp = ip->i_mount;

Add another tab before the variable names so that it aligns nicely.
