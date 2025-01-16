Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC59813D279;
	Thu, 16 Jan 2025 04:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737002213; cv=none; b=d/xZgsh7HCYrBy0ZlEtUVcj7lbPsqkeGfIlWt9pYm9IPb6n6k8LtWOXU4HxZFkNGd1wuPZaT2PsFf/+GcAh3lUw8FRLguONQ5pdkkWciQdaGnBxGhrEIX4nXYpqW/DZhP9Ga8EuNjCdfqBYCkEGpzVF4qU1lu7+3IETiaVn96Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737002213; c=relaxed/simple;
	bh=BUsnXrC0OwahI/SAZiU/B4GBZPTH+PURZNofczUcauc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KeQqWUwyZLWh8G3v+dyEDHqhoH9+zbsFlac4Wknks1Ae2abRcGeJGZdzW/Ynw0h53GpW87yHj6erFb3utbnd9hVax30scrlPNhDrdrwJ/3Vw0UxDCIZpdPMix95oJ0zTDCb10CDueooE4lC1Usswvy/2Yv34Q8FLjfTb4ewANSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cgc3Dwfb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cgc3Dwfb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Uw+7f+/8nKbSWyT7Kufr7lW5iijsltyiMajTInwHBTc=; b=cgc3DwfbQMUVQ5rKp9BlXZWc+b
	piXLgCWeNMpfmn0GwJoXVlqv2QpZaeO+mK+gPxvUhRjDL+ibt5+g1GMXJsBiB1o0ZX25UrrvkL5k4
	maXohC1K4uYEE8g+9+zhIc70egxIiK7lEj3aqadx5d1iLM0OKDKlkkmAWLt5rNs8oOjEWObrYjKSX
	sAfUFyex3+uzeZz8jOZ8WWPulpa9xBrxpdXus0QjgkZsanNhJzT8M2Z7RvV90dZEJym874gxi8BXq
	AH+8aby5ttPRoxdQTIdbVB5iGjJAVgWxu9WdWdT4wfC4orGYuvRf1tDit9VpDMmR6nLtpPM973L/j
	dkcAzTsw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tYHce-0000000Do8R-10jG;
	Thu, 16 Jan 2025 04:36:48 +0000
Date: Wed, 15 Jan 2025 20:36:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chi Zhiling <chizhiling@163.com>,
	Amir Goldstein <amir73il@gmail.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Message-ID: <Z4iM4IJj53g-mbGV@infradead.org>
References: <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
 <953b0499-5832-49dc-8580-436cf625db8c@163.com>
 <20250108173547.GI1306365@frogsfrogsfrogs>
 <Z4BbmpgWn9lWUkp3@dread.disaster.area>
 <CAOQ4uxjTXjSmP6usT0Pd=NYz8b0piSB5RdKPm6+FAwmKcK4_1w@mail.gmail.com>
 <d99bb38f-8021-4851-a7ba-0480a61660e4@163.com>
 <20250113024401.GU1306365@frogsfrogsfrogs>
 <Z4UX4zyc8n8lGM16@bfoster>
 <Z4dNyZi8YyP3Uc_C@infradead.org>
 <Z4grgXw2iw0lgKqD@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4grgXw2iw0lgKqD@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jan 16, 2025 at 08:41:21AM +1100, Dave Chinner wrote:
> > to finish, or by simply forcing buffered I/O when direct I/O would
> > conflict. 
> 
> Right. We really don't want to downgrade to buffered IO if we can
> help it, though.

Of course we never want it.  But if we do have invalidation failures
and thus still folios in the page cache it might the least bad of
all the bad options.

> It's much harder to sanely serialise DIO against buffered writes
> this way, because i_dio_count only forms a submission barrier in
> conjunction with the i_rwsem being held exclusively. e.g. ongoing
> DIO would result in the buffered write being indefinitely delayed.

Or any other exclusive lock taken by all submitters, yes.

> I think the model and method that bcachefs uses is probably the best
> way to move forward - the "two-state exclusive shared" lock which it
> uses to do buffered vs direct exclusion is a simple, easy way to
> handle this problem. The same-state shared locking fast path is a
> single atomic cmpxchg operation, so it has neglible extra overhead
> compared to using a rwsem in the shared DIO fast path.

NFS and ocfs2 have been doing this for about two decades as well.

> This only leaves DIO coherency issues with mmap() based IO as an
> issue, but that's a problem for a different day...

I think it's a generally unsolveable problem that we can just whack
enough to make it good enough in practice for the few workloads that
matter.

> 
> > I don't really have time to turn this hand waving into, but maybe we 
> > should think if it's worthwhile or if I'm missing something important.
> 
> If people are OK with XFS moving to exclusive buffered or DIO
> submission model, then I can find some time to work on the
> converting the IO path locking to use a two-state shared lock in
> preparation for the batched folio stuff that will allow concurrent
> buffered writes...

This does sound fine to me, but it's hard to judge without seeing
a prototype and results based on it.

