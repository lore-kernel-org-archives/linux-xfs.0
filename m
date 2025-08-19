Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA942EB851
	for <linux-xfs@vger.kernel.org>; Tue, 19 Aug 2025 15:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755616985; cv=none; b=X1423O81nLHMO84ojzDQcdzfOzdmZQBToU8SuCZOU9wy2kG1EIMRdVs9RrFS38RhtQw99CtHjF9TUqXiiZKJ/W5fmomncifb45Gtzu3+ygUNovwXciVertfJbZHCia4mQR6QjqhVLdZlqQM/392EY15EpatFUEv/kF3vaxYVX/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755616985; c=relaxed/simple;
	bh=ly0T1SVpWVgljTpLMV3SEbGXbBgeE7oZGARMfk5+RqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QMgbRRsAb+v54g/agdGxaTOatMQgA++vNVHqF7rGSyBuzLpmv5sM76I3WE8XSOD4fuIM7I77vt489ms+oanhxBwEmdJ1oJ9uboyu0Bfb4MWNUe5iwmA7SkC7IxY2fM8Qh0nmoYLZjwW1ZkiVtPHZIPLpBmdDasSEBzdErl467Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=a0egYQum; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a0egYQum"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8sXxMdConQDpJlhW6sLoTM6T1kEMvEcj62BD8oJlUCc=; b=a0egYQumcyUGSGF3OHcaSvS6w1
	NszofV6Ky3A7mH6pzmBG1Rxc48AdnmWlp+1NKOTuFwyoROzrDv2duFfA7UfPk2rbbjTAKEv1JMGrA
	S18wfCIdx8pFnqZ5sZU5IrnTn2PR0856hBHSEX4a0FuHN3l3XcsRwS31nXyE//RrfCpsNKs/zAisK
	EtOftoPGDcZ3XYFsPWY+tEucYLlWqygsqLDQM1RsHsl7H/kcbNKQbujAriGLQwvuFJEXcwyjLPCDS
	NOM7Qgiqg1Qr6f7QuuTHVlUjmcBkyQQm4Q1O4tr1pUS4gCFZL2Lr5otCCVfxyzmbXndpzbE66y7xY
	t2aPZe6Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uoOAx-0000000Asoj-1e7f;
	Tue, 19 Aug 2025 15:23:03 +0000
Date: Tue, 19 Aug 2025 08:23:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Donald Douwsma <ddouwsma@redhat.com>
Subject: Re: [PATCH RFC] xfs: remap block layer ENODATA read errors to EIO
Message-ID: <aKSW1yC3yyR6anIM@infradead.org>
References: <1bd13475-3154-4ab4-8930-2c8cdc295829@redhat.com>
 <aKQxD_txX68w4Tb-@infradead.org>
 <573177fd-202d-4853-b0d1-c7b7d9bbf2f2@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <573177fd-202d-4853-b0d1-c7b7d9bbf2f2@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Aug 19, 2025 at 10:14:01AM -0500, Eric Sandeen wrote:
> Though you and Dave seem to have different visions here,

We've already clashed on a slightly different twist of this a few weeks
ago :)

> I do think that
> for XFS's purposes, a failed IO is -EIO unless we explicitly need something
> different. Anything finer grained or distributed to higher layers sounds
> like a bit of a maintenance and correctness nightmare, to me.

Mostly, but not entirely yes.  In general I/O errors that bubble up
to the file system are just that: I/O errors that are not retryable
at this point, as otherwise the drivers / midlayers would have already
delt with it.

But there are a few exceptions to that:

The one thing we had a discussion about was ENOSPC, which can happen
with some thing provisioning solutions (and apparently redhat cares
about dm-thin there).  For this we do want retry metadata writes
based on that design, and special casing it would be good, because
an escaping ENOSPC would do the entirely wrong thing in all layers
about the buffer cache.

Another one is EAGAIN for non-blocking I/O.  That's mostly a data
path thing, and we can't really deal with it, but if we make full
use of it, it needs to be special cased.

And then EOPNOTSUP if we want to try optional operations that we
can't query ahead of time.  SCSI WRITE_SAME is one of them, but
we fortunately hide that behind block layer helpers.

For file system directly dealing with persistent reservations
BLK_STS_RESV_CONFLICT might be another one, but I hope we don't
get there :)

If the file system ever directly makes use of Command duration
limits, BLK_STS_DURATION_LIMIT might be another one.

As you see very little of that is actually relevant for XFS,
and even less for the buffer cache.
