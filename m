Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 May 2008 11:22:32 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4KIMRjS015165
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 11:22:30 -0700
Date: Tue, 20 May 2008 14:23:15 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] XFS: Return case-insensitive match for dentry cache
Message-ID: <20080520182315.GA8456@infradead.org>
References: <20080513075749.477238845@chook.melbourne.sgi.com> <20080513080152.911303131@chook.melbourne.sgi.com> <20080513085724.GC21919@infradead.org> <op.ua4wa7t03jf8g2@pc-bnaujok.melbourne.sgi.com> <20080515045700.GA4328@infradead.org> <op.ua6ji4r93jf8g2@pc-bnaujok.melbourne.sgi.com> <DCB15FFF-F942-47BD-B8FB-38AADC24B9D6@cam.ac.uk> <op.ubfkzvjx3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ubfkzvjx3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Anton Altaparmakov <aia21@cam.ac.uk>, Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, May 20, 2008 at 12:24:57PM +1000, Barry Naujok wrote:
> +/**
> + * d_drop_neg_children - drop negative child dentries
> + * @parent: parent dentry
> + *
> + * Searches the children of the @parent dentry for negative dentries and
> + * drops them as they are found.
> + *
> + * This is primarily useful for case-insensitive filesystems to drop these
> + * entries when a new entry is created in the parent. The new entry must
> + * be instantiated before calling this function.
> + */
> +
> +void d_drop_neg_children(struct dentry *parent)

please spell out the negative :)  also no empty line between the
kerneldoc sand the actual function please.

> +{
> +	struct dentry *dentry;
> +
> +	spin_lock(&dcache_lock);
> +	list_for_each_entry(dentry, &parent->d_subdirs, d_u.d_child) {
> +		if (!dentry->d_inode) {
> +			spin_lock(&dentry->d_lock);
> +			__d_drop(dentry);
> +			spin_unlock(&dentry->d_lock);
> +			cond_resched_lock(&dcache_lock);

The cond_resched_lock here is not safe here, because the pointer you
are going to dereference in list_for_each_entry might not be valid
anymore.  This should look more like:

void d_drop_negative_children(struct dentry *parent)
{
	struct dentry *dentry;

 again:
	spin_lock(&dcache_lock);
	list_for_each_entry(dentry, &parent->d_subdirs, d_u.d_child) {
		if !dentry->d_inode)
			continue;

		spin_lock(&dentry->d_lock);
		__d_drop(dentry);
		spin_unlock(&dentry->d_lock);

		if (need_resched()) {
			spin_unlock(&dcache_lock);
			cond_resched();
			goto again;
		}
	}
	spin_unlock(&dcache_lock);
}


Btw, any reason you haven't commited patches 1 and 2 yet?  Also maybe
splitting 3 and 4 differently with one patch for the two new functions
in dcache.c and one for the full XFS ascii CI support might be best.
