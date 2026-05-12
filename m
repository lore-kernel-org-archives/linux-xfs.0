Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2BC3D411A;
	Tue, 12 May 2026 05:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778564405; cv=none; b=hLOsk88tEQlxg7KDxx9rbOYsWfHdVNe0zDiikj4ni85LQL6BzVKm/+dANlTr7n3VnERU7hDe90itiHEsyCEWYZrO4yWF4s5nkVxHGVp/eLNh8mZskAQbhgiuMAhG7iGuGbuawTSQZmUqZcHBwF7WP9FdWK3XhMSAX1GV6yio/c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778564405; c=relaxed/simple;
	bh=9UmhZouBRx0Zm3NwCIeu1OtlXu9KMetIX7TR2AcblcA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hVFOQ2fx8JG0x4sy7p2tJFXWYO6FcpJ4ZxBIKg1TbuQ/GBDUQW6soFKv4rnOZuUwW6Kt800WT/w4Bsv8jbi3dzfEELEb/lnUUvvF1mD1IrGr4R27Wm/hab6JWm5Pp6np/MRPLLRVh9XssQPKM15r7Mn36iHaUBpYeU3GT3Emn/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WKEH/ihx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WKEH/ihx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9UmhZouBRx0Zm3NwCIeu1OtlXu9KMetIX7TR2AcblcA=; b=WKEH/ihxP5/p7NmZ4tHe0opMeT
	6K61i7tkEdh+IvQG3qUtcSDjb25DrSP75DbkP824cmi5V45kD8q05+a6y4d+JPH1EnkWjuSGSONuA
	NHdOocSgIOj82vBS98nZ8XOkSFbdjz3zi8T/tt1T8w6lHTyX/jA6UsZIejYts36xoAXEN9svgwuin
	vc1It8Xo+KIoPVl6IkoDCdQCRFy4bspp2yGWErluMEvVu7lS/xnj+9/ys19zwt1JV+XUz4m4jRbR5
	dgmeGxFQI6+XJKZ/VOxBhO1pOj8fhZO//HxZRtNNOsO4b/5JPcw7VJoXuiPwzJcy+zBTINus5LfQv
	O7fO+Q/Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMfqa-0000000FfoO-3VnY;
	Tue, 12 May 2026 05:40:00 +0000
Date: Mon, 11 May 2026 22:40:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org, amir73il@gmail.com, zlang@redhat.com,
	djwong@kernel.org
Subject: Re: [PATCH v4 9/9] fstests: btrfs: test UUID consistency for clones
 with metadata_uuid
Message-ID: <agK9MC0ufkTJj-zu@infradead.org>
References: <cover.1777357320.git.asj@kernel.org>
 <d079b3f7cce446b0c5bc0762226957b960c7a3ac.1777357321.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d079b3f7cce446b0c5bc0762226957b960c7a3ac.1777357321.git.asj@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 28, 2026 at 02:42:59PM +0800, Anand Jain wrote:
> Btrfs uses the metadata_uuid superblock feature to change the on-disk UUID
> without rewriting every block header. This patch adds a sanity check to
> ensure UUID consistency when a filesystem with metadata_uuid enabled is
> cloned.

xfs does the same.

Can we abstract out the uuid change and generalize the test?

