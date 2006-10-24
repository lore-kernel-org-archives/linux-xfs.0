Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Oct 2006 14:39:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9OLdTaG003414
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 14:39:30 -0700
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C2B63D1AA4FC
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 14:38:45 -0700 (PDT)
Date: Tue, 24 Oct 2006 22:38:22 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REVIEW 1 of 4] Clean up i_flags handling
Message-ID: <20061024213822.GA23909@infradead.org>
References: <20061024071723.GR11034@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061024071723.GR11034@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, t-nagano@ah.jp.nec.com, xfs-dev@sgi.com

> +/*
> + * i_flags helper functions
> + */
> +static inline void
> +__xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
> +{
> +	ip->i_flags |= flags;
> +}
> +
> +static inline void
> +xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
> +{
> +	spin_lock(&ip->i_flags_lock);
> +	__xfs_iflags_set(ip, flags);
> +	spin_unlock(&ip->i_flags_lock);
> +}

This is not actually 

> +
> +static inline void
> +xfs_iflags_clear(xfs_inode_t *ip, unsigned short flags)
> +{
> +	spin_lock(&ip->i_flags_lock);
> +	ip->i_flags &= ~flags;
> +	spin_unlock(&ip->i_flags_lock);
> +}
> +
> +static inline int
> +__xfs_iflags_test(xfs_inode_t *ip, unsigned short flags)
> +{
> +	return (ip->i_flags & flags);
> +}
> +
> +static inline int
> +xfs_iflags_test(xfs_inode_t *ip, unsigned short flags)
> +{
> +	int ret;
> +	spin_lock(&ip->i_flags_lock);
> +	ret = __xfs_iflags_test(ip, flags);
> +	spin_unlock(&ip->i_flags_lock);
> +	return ret;

This is not actually guaranteed to work on machiens with very weak
memory ordering.  Please use the *_bit routines from bitops.h instead.
