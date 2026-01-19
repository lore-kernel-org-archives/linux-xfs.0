Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88DE29BD95;
	Mon, 19 Jan 2026 09:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768813405; cv=none; b=s1u/cSXJVcsg8wdiKevLePIh3B3IkHvg2ccUoDC7S2j0Amtn7/NdY1PZ6XV7RFvfBuCehVUQcEg2WKT5iy9fZMp+TVVj56a41RbYryATeXGJe7ODeieBk8o1kWr0Ncw1CGQOieHrd/6wXDMm4c5K/OnFY+IhOa7C+uREgYmq8WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768813405; c=relaxed/simple;
	bh=IOAdp2mvo3xJ64KuYq6nPuZwyvznxy49ypaVdGZETYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mz6GNzBoaiHQcKmjYKLBNdOWIN3a7z2NtwuMV4DI4WmbTz21W04LrDuEGqRkynvidxZHGOcQ0od5OmSq+XgTZUgIQc6TbuLGH0msa10p8w9vomdpxR+eLiy64qX+K94uUC8yb+L+Ayq0VbBp134lh4WM6ten8TdDp29nHZxufow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NlCbga6g; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NlCbga6g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=VVF9Vwa2+xdjizaQLVvAuXkqoIAbS9mFpprw0iio9P8=; b=NlCbga6gKWsJh5pOcNpQ0oNZOy
	AXjMIrGo7IT6Epnb3nS/kaJnr5Db/bYTNV9xfpkJB/4rsSj6fkCzWO7dLtTxitngNd3QAeKCJrDkd
	zej/EyHbazj5LKUREibnBsfAxaIekA25id/UzNnpg5sVptQ4LWEz6GMGFU5o4XzqmZ+5S3kFCvrPa
	QrE2HXbkOZUbhQHeQRAi/IYJkaZvnpfR2GaIFKidkGgjwLYccWOgpAXMQIMoUKoTIcbnRIVs55uYB
	p4S7b9bH91/d7UtfDbLXE1kQNnVg8pRlLKgN5GSkO6Y6jiD70q7PwqWuBFfrxPh+BK5T2o1CAPGf2
	orWUWBdA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vhlAO-00000001bDv-36GG;
	Mon, 19 Jan 2026 09:03:20 +0000
Date: Mon, 19 Jan 2026 01:03:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Aleksandr Nogikh <nogikh@google.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	syzbot <syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com>,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com, Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [syzbot] [xfs?] KASAN: slab-use-after-free Read in xfs_buf_rele
 (4)
Message-ID: <aW3zWKJ4-ThpwT7Y@infradead.org>
References: <aW3g7G_dWk4cbx0_@infradead.org>
 <696dec7b.a70a0220.34546f.043a.GAE@google.com>
 <aW3tX6aAAONC6zyr@infradead.org>
 <CANp29Y6PLo-Lr81SWp4qK9avLKpTGhXMAUDrZe3OYYgfWuaKVw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANp29Y6PLo-Lr81SWp4qK9avLKpTGhXMAUDrZe3OYYgfWuaKVw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jan 19, 2026 at 09:53:18AM +0100, Aleksandr Nogikh wrote:
> On Mon, Jan 19, 2026 at 9:37 AM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > So I'm not sure what this test does that it always triggers the lockdep
> > keys, but that makes it impossible to validate the original xfs report.
> >
> > Is there a way to force running syzbot reproducers without lockdep?
> 
> Not directly, but you could explicitly modify lockdep's Kconfig in
> your test patch to disable lockdep entirely.

Already, I'll give it a try.

