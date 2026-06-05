Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E0947F2E6;
	Fri,  5 Jun 2026 07:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780646131; cv=none; b=fh5sOd41Nxi5aJ6Fywcbz95tSywC4rvZlORkGyWCuL0O84ySLC9rykptroFr5uYZw6uNgwurD6/s09DaWJDY3QYtRURtJ6U68AVQ4Po6qjRA8nTcDlwI6DuBueJXTuhpbGpTqNztCUWSf2z3sAyHsvM1b1olibVz6Qmn+r7iLe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780646131; c=relaxed/simple;
	bh=JtWYcKaru1X60vr/sQHSeNk8PBS6aRDqxNy4gL4waKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WG5OrDTLo9Ng84uuRL0SCejRVFtwAcN2FultQFKrxiMlj3PGKNCIOWC7+e1pGxvLzihSbdh3mAipkrMEUSUbXSo8tWAwZHhfkVz+GlLACigBBL1QT0FSaU5pN8VwYgVOdPtxPs5PPSXhf5JKPrEsiZIfh1PMUcU0sb/bAHJ26xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lU1cV6tL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lU1cV6tL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=6qwO9hfKW2pKTamiHyow/+mQH+vUWj9LhckadVNAwAA=; b=lU1cV6tLQm4g8knzti+jCzf/+D
	6y0P1uZ/RtcONdyw/P6KXFGMxwMvs5nFRZtNLNnlVtuKf7L76v/37LN2if+2Ct7ajYwHgHP6dAREq
	IhoD67pD/GM4KZW0ZAkXiOyqUfxb+1EpEoM353k44vzbOY5SEYWHVoaXg+ai8KkGKizz6HePyCvrh
	51rlNfo8XwD3PwlFFoWGm6Nwd99F5tqvNIhPiRE7+DKNTTgS9sTPeVg7ZWvV3lKiTNMnvqJOrVJC2
	/uT9TnBHt49wDs0tFXbvYJFsmDGIq8q1qBaTozxcGcpbGxvpvJQ6aeQQpEqDcp+DIc26Y2Lh+9ezM
	C2Ls2nEA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wVPOo-00000000GNZ-1j20;
	Fri, 05 Jun 2026 07:55:26 +0000
Date: Fri, 5 Jun 2026 00:55:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mikhail Lobanov <m.lobanov@rosa.ru>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org,
	Christoph Hellwig <hch@infradead.org>,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: Re: [PATCH v2] xfs: do not inactivate inodes on a failed mount
Message-ID: <aiKA7vVQ_RxT_YOr@infradead.org>
References: <20260602143717.21976-1-m.lobanov@rosa.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260602143717.21976-1-m.lobanov@rosa.ru>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jun 02, 2026 at 05:37:17PM +0300, Mikhail Lobanov wrote:
> XFS already encodes this rule: xfs_inode_needs_inactive() returns false
> when the mount is shut down ("If the log isn't running, push inodes
> straight to reclaim"), so an inode destroyed on a shut down mount is
> never queued for inactivation.  The gap is that this is only evaluated at
> queue time; an inode queued while the mount was still live is then
> inactivated by the worker even after the mount has been torn down.  Honour
> the same invariant at gc time: in xfs_inodegc_inactivate(), skip
> xfs_inactive() when the mount is shut down and just make the inode
> reclaimable (xfs_inodegc_set_reclaimable() already handles the shutdown
> case).  This is not a new policy, just consistency with the existing one.
> 
> Then, in the xfs_mountfs() failure path, shut the mount down before
> flushing the inodegc queue, so the queued inodes are dropped to reclaim
> instead of inactivated.

Doing a shutdown on failed mount is actually a really nice idea!  I
hadn't though of that before, but it makes a lot of sense.

> Note that shutting down alone is not enough to stop the crash:
> xfs_inactive() calls xfs_qm_dqattach() before any shutdown-sensitive
> transaction, and neither xfs_qm_need_dqattach() nor xfs_qm_dqattach()
> tests for shutdown - so the worker change is what actually closes it.

The Sashiko review points out a that skipping the entire inactive can
leak the dquot references when we get here due to a normal shutdown,
and I think it is right so we migþt still need to call into the quota
code in an else branch that checks if quotas actually were attached
and drop the reference very carefully.  It probably makes sense to
split all these shutdown in inactive handling into a separate prep
patch from shutting down in the mount failure path as well.

> Open question: in the failure path I used xfs_force_shutdown(mp,
> SHUTDOWN_FORCE_UMOUNT) to mark the fs down.  It logs "User initiated
> shutdown received", which is a bit misleading for a mount failure (the tag
> actually shown is "Metadata I/O Error (0x4)").  Would a different flag, or
> just quietly setting the shutdown state, be preferable here?

I think a different state makes sense.  It could be quite as we usually
have other messages for mount failures, but I dont think a message
really hurts either, so in doubt avoid the special casing.

> +	 * If the filesystem has been shut down - for example a mount that failed

Overly long line here.

> +	 * to reclaim instead of being inactivated: a failed mount must not write

.. and here

