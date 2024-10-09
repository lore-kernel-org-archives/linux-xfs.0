Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C5B13A409;
	Wed,  9 Oct 2024 08:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728461308; cv=none; b=slr5j6ADDgvw7rlZK8Yiz7vXEguGyjyh9tevHPbz6XfRABRRKlg3LMO6mbtHKFHRBACkmaJrVSYB7bHkS2UmheoPC5u5TUb23MemNDV1WkBmAZph3HoBcCoTC63BR3coZd6x5KpyiavBrZtJvBt8Th6uiBxm7OnpNnMb6aK5Vck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728461308; c=relaxed/simple;
	bh=ML6e2fA5rJV5Uq3y3Qus9PWMu9J+hGyVJlUhyJ+qB5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mx6ZLwPQmEbmfFllbk88lL0VVbQeA2W1oPzde4K8BeWLaajxciz12FT0u9TyI2aLGcNkKLLKSb5AdsqCIfO7S4GzT6AMRbEBltFBK8/fhg8qSBdyc1aRtEc61BpmRqkwbVnMrb8oKN6Ie0+LMPv9a/mwQDFdJTeXHE7OZ61o3FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bFzpqu7M; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bFzpqu7M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ML6e2fA5rJV5Uq3y3Qus9PWMu9J+hGyVJlUhyJ+qB5s=; b=bFzpqu7MQeX7gS5YFKRW6OBHdJ
	W/f7e9r3dQmuZ2lki3/QdnGB1MpG0rF0dmrRgzbOq8eixP57TshQfKvVgzwF6SXv9Jl3ky0mDjB0R
	MgjoruotiVs6wBIYEFSAWyh0+dpzuMOVBt+ppTHgz5ZIwEZYAonC2Qqk4QVfmnXLVlVQD7IvnC7eW
	OA+PPpLgbSw1RIJ24SgzmfafyUocvwYMeHWEWcZfoZD9J9pwpamO/Mfy204oTVKzl33AxA1HVYHMv
	StxUqJ8ZLfSDxfC+4BhmKgPKntSlL3Im+fCy6aRex/4vD0TQmFqOnhBj0fkalxIPj0syNc+jg3h6v
	50q6Ji+w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1syRkA-00000008NRS-3skF;
	Wed, 09 Oct 2024 08:08:26 +0000
Date: Wed, 9 Oct 2024 01:08:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: syzbot <syzbot+3d96bb110d05e208ae9e@syzkaller.appspotmail.com>
Cc: chandan.babu@oracle.com, djwong@kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_buffered_write_iomap_end
Message-ID: <ZwY5-lv5L-X_TlL-@infradead.org>
References: <670610b7.050a0220.22840d.000e.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <670610b7.050a0220.22840d.000e.GAE@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This should be fixed by my

"fix stale delalloc punching for COW I/O v5" series.

