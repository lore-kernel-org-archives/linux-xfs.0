Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E8133D4E4;
	Tue, 10 Feb 2026 16:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770740210; cv=none; b=dek31EKiIlzSP5Va0w34Kgd1PKWD5x58jP7KkLyYCQkoZ9+8PMIRg2qzucfOnmW0lztW5kGoyFNSOpD6GH66fKfdsDmAOya2ZSYKUkzl1Grtx+/r41pEcdPvk/CJdixhVXKM4qGCrySq5RrWzT3bU5nShe061J/sBt742QtkVZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770740210; c=relaxed/simple;
	bh=R9HCcfu4GxdKCJdbhjp6yg+9igYySaQyt1VmiE4EuXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MtuxCa2Y4nGysII7UcYYl/TMytU0p1OTmR8Mz8M0Qs0QrSD9R1CEU4hgeC04ahzhAtfTr/Q8eLWZQUoJW0iRtQ4KZ+C1JUIjyg+w2EYV4iBANeIsccwveZ680PMbK16KSrYh6+TY8qK2GVWLanRK+WRrvMINBF/bXF9pJQ+FRSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=g+aydpiO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g+aydpiO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Dtpx+1X9hkXRbmLL8K1jfjaUi4jNk+eZLihNKbsCpJ8=; b=g+aydpiOIETHJJL67oQw8+D7sM
	SYgMa9goevg/Wbq8NwB6nSB5RXEj+gM+fyvYCSfSK7f3gQ6XAkdMsQ4ik4gYniVMezftL360RFps1
	bioVwtFddecsaAFpD4I1P0Q70UewAthpVCC93jMVgMXRqJsZnMzjogIhU8S2SE4mmsnm2Liq7hXjb
	5CIJp5eNTjZiTTLxEqAEtpqarcU4sG91kFklaNzoMGfbD5PCmdsZk0IOK3+HiW1foaWO0wBnlNvzj
	LE424XSRjLHZKmit+EcYohjCJaXcAJ4fqndrJ+MGd+s4ruh+LGd/57XOSXF7vSuMeOYmwjnJYW72x
	fsstDaIQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vpqPw-0000000HD2O-3Rm9;
	Tue, 10 Feb 2026 16:16:48 +0000
Date: Tue, 10 Feb 2026 08:16:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/5] xfs: flush eof folio before insert range size
 update
Message-ID: <aYtZ8OSBCU2EtRQU@infradead.org>
References: <20260129155028.141110-1-bfoster@redhat.com>
 <20260129155028.141110-3-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129155028.141110-3-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jan 29, 2026 at 10:50:25AM -0500, Brian Foster wrote:
> The flush in xfs_buffered_write_iomap_begin() for zero range over a
> data fork hole fronted by COW fork prealloc is primarily designed to
> provide correct zeroing behavior in particular pagecache conditions.
> As it turns out, this also partially masks some odd behavior in
> insert range (via zero range via setattr).
> 
> Insert range bumps i_size the length of the new range, flushes,
> unmaps pagecache and cancels COW prealloc, and then right shifts
> extents from the end of the file back to the target offset of the
> insert. Since the i_size update occurs before the pagecache flush,
> this creates a transient situation where writeback around EOF can
> behave differently.

Eww.

> To avoid this quirk, flush the EOF folio before the i_size update
> during insert range. The entire range will be flushed, unmapped and
> invalidated anyways, so this should be relatively unnoticeable.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

