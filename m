Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9805142E7C
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 05:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731995142; cv=none; b=fvJPcBbzS4v/qSRAz0kSXcePZDzDQlrLX+A1Q6plmcmsFEqQUcMf/khnGJiyv6Qz00O4VdepVzGkiw6oB+vs44fNKRw+hZD4sIVWf9tZ6S/FzwVpd9lK8OF+Kp73tgxIRZChOtgKmcBWkiurlQ2aVIe4PROS3ZINjzBPpUlQWYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731995142; c=relaxed/simple;
	bh=EHqU852PRZ1LcCKpK53KZGP1go1ferglbQDTfbHP6SQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cVXEroem3b94j5adH6j2a+DgpUypqWSNpFP1sBgaY++z2wVKNC1yhnuLnLq2zoiQsyj873DHgNXhmSn5tsq3HrWCREabaPDjcN4QUcMm+Cu/8KSZINp6ixq+cJwKzij9aoD5cy4p16pRdRgf6dsykgTolh5mgGKDEwltm0PgSuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tBcp/VEq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tBcp/VEq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CpMErFNruwR1DJRlMvajGIkSIrXxmqIP1nRqUQcDGLk=; b=tBcp/VEqexUTWAYxZFgjw+JLTi
	N9VUztQd1+shCRG10aKhekq0h2wEWUj86IkJljKQi0NlvGhOg+QZP5p4kX1eBm+50O6DIS1GqrZJQ
	Fq9up6uLnJ1GErT1b8DwGHvpWNzFQs1yRQrwgLVtw7vAs4x8rq/+gcYNIMZu/qjravn2fNB5SI7yM
	rZu4yHg1bR0dl4VL9dDjrRM2IvJsE7u+Ma+0wYOE7C7R/riM2L7ggUTMYxjpRhSQUYaCyVd/gBrk3
	VL3VTbRoYSE7VNYEfR3pXAuZ0kpfOKKneW+68hjtQCyICm/NxDe6jc8P2CLPA6QD5WmVOkishZppu
	XjqOhY0g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tDH3R-0000000BRvu-2Bmg;
	Tue, 19 Nov 2024 05:45:37 +0000
Date: Mon, 18 Nov 2024 21:45:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/10] xfs: keep quota directory inode loaded
Message-ID: <ZzwmAevNy-Tcl9R0@infradead.org>
References: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
 <173197084464.911325.18182055244953182778.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173197084464.911325.18182055244953182778.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 18, 2024 at 03:05:17PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In the same vein as the previous patch, there's no point in the metapath
> scrub setup function doing a lookup on the quota metadir just so it can
> validate that lookups work correctly.  Instead, retain the quota
> directory inode in memory so that we can check this.

The commit log here feels a bit sloppy - it keeps the quotadir inode
in memory for the entire life time of the file system, and not just
the scrub as the above implicitly would imply to me.  Maybe clarify
this a bit?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

