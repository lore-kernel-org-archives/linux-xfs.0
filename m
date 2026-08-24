Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A268B2F7F07;
	Mon, 24 Aug 2026 19:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787598500; cv=none; b=L6JmgM76oYCb6CG1vh9XaQLYGPCSQE4Dpr9oQEa1zqjgx7Ht4OtN5tk8bx5TezAOy+Dqbg2XkZ7aAxhOIP16Z46jVbD2Ma0eWqvP+rNuGz5uNh3UudsKKv8pL8vYW+VcGs+vnbf0+PMmfX4KvyTGlh2V052WB2Msg6xm954T1VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787598500; c=relaxed/simple;
	bh=UoTHI0wl9uwRYi4bXDCHTnXbLx3actvehgDjeCO3YcI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=t1XCP+sFL7BfkQ6ypZJY4D9cmlxmwvXfLfuNQjp209sIXHA78fKnshbHBIr9bj3wWfQmHOAfLZaDh/x8e5yMFC93gPVbTzLVb9nOrR0hxAcjyYWaZwPpian/ICr74AjIQHptG0A6rKLZQBPQP99bLrvM37XLGLtBbgNclKVvIo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fVJ5WxBy; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fVJ5WxBy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=rXZ7ZE15rvwerUJ9OHaFUdA7osUeOjHjAwPp1v8D3Z8=; b=fVJ5WxBy21PuBmR1rP+fz/pIl2
	5Iuy6MNrN7UowmFAKk8XIDnE7WC9ITFHIuJe/0qyEScfD8Aq3HNb5e1Kiri2u+3H6fiY8aSK9fyu2
	XQevVKRrCMTmBlMNadaWX+V+rVqPbAv62qHyPJkOraieP/ZkEWspLWVMewUYnHGMh8BJIZEINI0kQ
	WqcLUXDbgQn6v4HUweUI71vOv6UCWcA57cnwYfI19WbBrRGpDLMBANTfSay7oE9/4QNvDmF113AH/
	LcERCZFuIfNDm5T712CokJ4O0JmENbSA+FD66cAVZV7EUpVaHpnhFOd3m7dcWbozPDNtmMWL2CyMn
	A7Laf5Zg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wya1e-00000007gW8-3U3q;
	Mon, 24 Aug 2026 19:08:06 +0000
Date: Mon, 24 Aug 2026 20:08:06 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
	Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Removing ->dirty_folio
Message-ID: <aoyWln-Gt-yvZQkE@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I think it's time to remove folio_mark_dirty(), ->dirty_folio() and so on.

This is not how filesystems want to be informed of folio dirtying.
It was fine for ext2, but anything that's journalled or COW has work
to do before the folio is made dirty, and it's hard to do that work
under the page table spinlock (not all callers hold that lock, but the
filesystem has to be able to handle the cases where it is.

Filesystems want the page_mkwrite() entry point to be how they find out
about a folio being dirtied -- and that works great!  Except that we
can writeback the folio for a number of reasons.  If it's been dirtied
due to a shared writable mmap, that's fine; we map the folio read-only
and any subsequent writes will re-enter the page_mkwrite path.

The problem is GUP.  We have no way to force the GUP caller to go
through page_mkwrite again.  So instead we make the GUP caller call
folio_mark_dirty_lock() which many just don't, and generally we get away
with it.  But it's a bug, and a bad interface.

There's also the problem that GUP users bypass the folio_wait_stable()
mechanism.  If a page is written to while somebody is creating a
checksum over that page, the checksum will be corrupted.  If we want
to fix this, we have to bounce-buffer the page.  There's no way to
prevent or delay a GUP user from writing to the page.  Enjoy your RAID.

My proposal is this:

 - Fileystems take note of folio_maybe_dma_pinned() during writeback.
   If it's true, do the writeback, but retain/recreate whatever data
   structures you need in order to write the folio again; behave as if
   ->page_mkdirty() had been called again for each page in the folio is
   marked as dirty.
 - The MM behaves similarly; we do not clear the writeback flag for
   folio_maybe_dma_pinned().

This will have the effect of writing pinned folios back every time the
inode is scheduled for writeback.  But since we have no idea whether
the folio is actually dirty (because the GUP user won't tell us),
this is the correct behaviour.

I'm probably missing some stuff here.  Let me know.
