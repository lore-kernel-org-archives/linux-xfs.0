Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A052430B50B;
	Fri, 20 Feb 2026 17:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771607250; cv=none; b=uAkfskN+k80O/zuw1B2Js9/wevFiiaA0mFlQF5Yk4/tcnJJ8Ap4vXKoFaFy0tSc8IzxzuL84Gs0yS79ZNy3MbQCwfSg+CFqMuysaNYMdA4F0ehiu5SoS2zo6pZf19WEj3H4TggzYIsizijiSJ+VDKtxXv11HH4ScNljJoKEi4Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771607250; c=relaxed/simple;
	bh=0rGB/DIVkDQrHLYzlF3il4R1KLZPxa9w9+kBsZbqQ2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B69G6bgy+S4grg27M41CYsQaODOWqvPeE1CR9BRpBdrwMtRy9WZJ/VmVA4vQV36NueZPv5b5pSUD4AitpiJKFV46ZN4RyY7V/cvgnQ5Bkj8HLGNRY/BbwTuQtIJMUoLdUBk6tEG8zudlgcFN87uNeBzlH9ISfzHMeNhICU4lrGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iidUEAV4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iidUEAV4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6oXYTXO2cyod2sPy6aZkf+YSvbVNgWjfMU7BkwinaG0=; b=iidUEAV4I41vX3aHmqfuj7XTu6
	AD8U1ZInEDcyH97VkLWQ6xZ7ihFleX7fbugY8qT8mFCq/xc+ZLc7glKVfVg1Uu3iZ8m7li6AK0Mvu
	l5aVkAbNorPdsJZnIzaRwN20+Hkbwue5LECZtYAifkzfNgB4bU4QztY5Zy/sd2HXEvvyzttj/dc2a
	0Ej9/djDa0nxo1Q7gn6TTgHtOuMoER4TA6wuIlCEOpRX//XSUN4l8UQ4gFa1y+tgt9jekzhSkSOxz
	Fr5UweVM6fg4QJSxuNdQt9yShDfrVVIej4a31YNlcacsdQd4MeAiomO2/KQd+Cf2BURapC8KtnG6O
	yQJbVxWg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vtTyR-0000000FLiM-1L5e;
	Fri, 20 Feb 2026 17:07:27 +0000
Date: Fri, 20 Feb 2026 09:07:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: syzbot <syzbot+d3a62bea0e61f9d121da@syzkaller.appspotmail.com>,
	brauner@kernel.org, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [iomap?] WARNING in ifs_free
Message-ID: <aZiUz-yBUWHOhejZ@infradead.org>
References: <6968a164.050a0220.58bed.0011.GAE@google.com>
 <699777ce.050a0220.b01bb.0031.GAE@google.com>
 <CAJnrk1bk7jN8SfHny9nVWZZS6tP8bnQbMZHTCuFma6-YuMugAg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJnrk1bk7jN8SfHny9nVWZZS6tP8bnQbMZHTCuFma6-YuMugAg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 19, 2026 at 04:46:58PM -0800, Joanne Koong wrote:
> The folio is uptodate but the ifs uptodate bitmap is not reflected as
> fully uptodate. I think this is because ntfs3 handles writes for
> compressed files through its own interface that doesn't go through
> iomap where it calls folio_mark_uptodate() but the ifs bitmap doesn't
> get updated. fuse-blk servers that operate in writethrough mode run
> into something like this as well [2].
> 
> This doesn't lead to any data corruption issues. Should we get rid of
> the  WARN_ON_ONCE(ifs_is_fully_uptodate(folio, ifs) !=
> folio_test_uptodate(folio))? The alternative is to make a modified
> version of the functionality in "iomap_set_range_uptodate()" a public
> api callable by subsystems.

I'd honestly rather have ntfs3 come along and explain what their
doing.  They've copy and pasted large chunks of the buffered
read code for now reason, which already annoys me and I'd rather
not paper over random misuses.

