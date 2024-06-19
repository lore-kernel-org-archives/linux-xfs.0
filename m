Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86B44405;
	Wed, 19 Jun 2024 06:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777743; cv=none; b=Pd9iBdNkZxB9tKLhbCGYAhgvGM5yb8C7SwJ/2DGc+6Q2O/I5XWaldVu2bpttK2LeLY52tn0LZaTTsTQHn7HjVKAi28EY69AR/kNKM5LTbZgI6INP3Ne9gWj3PyEal1qBQvPiHmCafHaQwm1Z8+AQyeJYTl9tKuJaBQMTtLuxEFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777743; c=relaxed/simple;
	bh=IPgwTa0RdpANsYuz+L0Cb/I9OeivYvv1lvbbgBOOP80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DOS2iTWTQFUCtaDRim3fI87oeY6ihBGRD3JmLNgfW/irvBaYYNsMD1cpKVncYZWFbX66rKNqhbjw1qClXAUtCb3v3SIj2j6i3i9YhF3X1Xaw1ekSKJWMYXs0dI1zME+VF42kMdZiFxHAIVLdWBxJ5OoPN6/9F9iRH7mTOTBBsjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=G7v3syQw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G7v3syQw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vIUlOauAw1l0LsvqpYHhdYAMeMrlczmIiF9SMcjQ+sM=; b=G7v3syQwLd+Xsx7vAIFJnI9b7o
	S4qj/NHcprYZZQEn9phQ6m96WzFocOg3p7RKhohP82ieuXZ0MMl6wEBhi4ocI0xvo81ESRUFGt+6J
	o5Sc6SSoThi05HKGUmJB7qQcA4+QCCZgKnD1yPBEV4hnDTp5Hl7QTW3WNnUTC1QuDQ0AgVLmVfoQE
	1yMYFvF0f6jpRRYB2Plz2T4gF9ZtvfLVDZQW6zzJlvwMxPapmd/GxjsSBDVd22dipm9z1K9YCB3Z2
	6F+wUDMeWXb4I9xXaQEKWlUkw3qll0ww5h44XNlD7pm0gAypZvozvvCKH1F41vGy6yv7q2AzIcFb8
	S2biv7Rg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJobe-000000001ku-19p1;
	Wed, 19 Jun 2024 06:15:42 +0000
Date: Tue, 18 Jun 2024 23:15:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
	catherine.hoang@oracle.com
Subject: Re: [PATCH 06/11] xfs/{018,191,288}: disable parent pointers for
 this test
Message-ID: <ZnJ3jnD3E--H4sJ3@infradead.org>
References: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
 <171867145899.793846.9319639235704732288.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867145899.793846.9319639235704732288.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

s/this test/these tests/ ?

> +	if echo "$MKFS_OPTIONS" | grep -q 'parent='; then
> +		MKFS_OPTIONS="$(echo "$MKFS_OPTIONS" | sed -e 's/parent=[01]/parent=0/g')"

Split the line?  I also wonder if a generic helper to remove mkfs
options might be useful.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
