Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF87A8C1F;
	Mon, 23 Mar 2026 06:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774246540; cv=none; b=DJl7B/hEoS6D8UHvgeJV5Ojv0B8eKII2WiUY4CTlZZgLFHd5KNnSt0Ax37B31q+X1Q8keXNocO5QFQPGRg1C3KX0dSPOBVBC1yEa7mbnfZvI3qgCxcnTYZrl7ACdE9pVRLySnjEGtI8VHoFqceEI4YpSWaCZjtHk3KkgO/m3xu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774246540; c=relaxed/simple;
	bh=V65Y83fClJLyUDb+npUUvIvczYHLk6Wei2gLXw+2Hew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EklF8wC5LfF6yfCrjV5lF4ugNDVUPVH3vJpZ6ofwEwexwGSeFZUPLb9LMm1fVQnpTViXEue31DPB+as/1JcZz2Kd4BZnisYikhQdNSPzrdcqz9Tpi985BFCb8+S2zye+ZRo4M55sP0RF0A9ty3aPeSc90rh8yVAKyMN5jAWT87k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rbR5jV5i; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rbR5jV5i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=V65Y83fClJLyUDb+npUUvIvczYHLk6Wei2gLXw+2Hew=; b=rbR5jV5irZk1amvrcARy3jPbQ2
	43+WGjmrJ1IsGHztdzUJOa70AJaPnpNGdFHra/J+UbO9Yopx0tqHY0pIf/11JxXNnl5jr9xjNHMce
	jSxMqGklOxl/GQGSA7V4iL4fJQJXfhGygvaDMGk35LtW1Bpk6djocCMxr/HEMx71C4khCLTH3th4H
	5wRJ27Cut+LbxN26wRK9Q3MxZ0g4LNLlVY9BQ0OYRhAMZYIpCohi2bHPkn0AxhRZ9jHVbZg5ZRrY+
	vP5qPvKppoaj/fOYeQWOpHfl/JzJn6zyb7TP5coSD7DTrlLN5E6gxZqvte1Zjpgnrn3SD0K7yYcp5
	LsxP1YIA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4YZe-0000000G7NZ-3vKV;
	Mon, 23 Mar 2026 06:15:38 +0000
Date: Sun, 22 Mar 2026 23:15:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Zorro Lang <zlang@redhat.com>,
	linux-xfs@vger.kernel.org, brauner@kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [Bug][xfstests xfs/556] inconsistent {HARDIRQ-ON-W} ->
 {IN-HARDIRQ-W} usage
Message-ID: <acDailQqSRGBX9D3@infradead.org>
References: <20260319194303.efw4wcu7c4idhthz@doltdoltdolt>
 <abz2C1a-KIGMZCGe@infradead.org>
 <20260320142728.GA6254@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320142728.GA6254@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 20, 2026 at 07:27:28AM -0700, Darrick J. Wong wrote:
> That was only for writeback ioends[1], which went upstream a couple of
> weeks ago.

Ah, right.

