Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FEF377EBA;
	Fri, 17 Apr 2026 08:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776413978; cv=none; b=fJvdhc4COYubSXo/9z+kkHq7XjTSbmEyZCi0YRrGsf8enn2uJgJTXNCtiY83x+vo7kMMT9pG+1MWidJy/QdYZOndL8eLPOX2J+iTp3+8zOdKCgzNa7NNu77U8eWQaiZcAv3n31K6Hbw8h9JGrnMtVaGK76qw/ME14j8QKWag8AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776413978; c=relaxed/simple;
	bh=OMowBWsRkwolFos5RGrczxO4E4/8D5JHVx/VENOZJX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mrgFEdO9QVToJOWnyHDUwbtuue4fICWhsKHExKoaKAZs1EQW2N+7D6FJfAfW21SBKnNug0yXEwJKve+ufe9d9QekrgrgrHr0Y0c+/811XMdJMnupDp+SguT+541Z7U+9C+ZJCwxOrP8emnK3kefCUy99/NksNgfGs1YTSeCwiKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=p4ZWnW8Z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p4ZWnW8Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JPbuW35N5LsuICIGCAN9rFd/yCJrhFqkmc0YHSxmpCA=; b=p4ZWnW8Z8LMvrA9M9zW9fXqXkb
	6ghVuwbsr76K98ih3hVKCXgwbf83tZX2rymDMcPu65kNtMeYuWpZ1tguUSxEjMbSsDFZ+WF7omQ1h
	NWjfSZDw/tj50fUVamG86gMbaIwCSJIPRQ8nEZ39KyUPmTt5xcSSE6VaViKIJK/0cD+BXE7RA3I3R
	VuXJTK+AsQ/re9skFra34qBQ5zv+m+VgrZxE+a2924/r8wRdmFWR/KaxtyQ01s39bW1AO9J4dMfBM
	yG40nS1lnsZe1XFDtfKfzSZKM8TgEhoJaqa0NRRUr2q+5sjsb8WDsb1ymOyL3KVdq1TGRZkFr9JIE
	KCQZ1oHA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wDdbu-00000003aLm-3Gxa;
	Fri, 17 Apr 2026 07:27:30 +0000
Date: Fri, 17 Apr 2026 00:27:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Fengnan Chang <fengnanchang@gmail.com>, brauner@kernel.org,
	djwong@kernel.org, hch@infradead.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	lidiangang@bytedance.com,
	Fengnan Chang <changfengnan@bytedance.com>
Subject: Re: [PATCH] iomap: avoid memset iomap when iter is done
Message-ID: <aeHg4hUsVTxzm66I@infradead.org>
References: <20260416030642.26744-1-changfengnan@bytedance.com>
 <aeDjui2LGSidEHcJ@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeDjui2LGSidEHcJ@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Apr 16, 2026 at 09:27:22AM -0400, Brian Foster wrote:
> This seems reasonable to me in principle, but it feels a little odd to
> leave a reset helper that doesn't really do a "reset."

Agreed.

> I wonder if this
> should be refactored into an iomap_iter_complete() (i.e. "complete an
> iteration") helper that includes the ret assignment logic just above the
> reset call and returns it, and then maybe leave a oneline comment above
> the memset so somebody doesn't blindly fold it back in the future. So
> for example:

What about just killing iomap_iter_reset_iomap in it's current form
instead?  Move the batch reset logic into a little helper if we care,
and just inline the rest into the only claler to side-step the issue.

