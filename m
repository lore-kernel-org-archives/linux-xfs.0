Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F87718E1F
	for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 05:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731303925; cv=none; b=NwiXyxR6c7Cwrl20AGb39q36414UJdIbkeJFRpb/GQuZI5jMJ8AxcZflIt22zGI4gb6bOMelfMV3kiqV0AoltYVmqxSp60HL1O9MrVgTSfFNBdlh+Wjf3pNf6jFAbvXh+hhydBgFRxw4sCepE5uO1KkAUI66m3TXhbiJQnp5Er0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731303925; c=relaxed/simple;
	bh=ABvcLSvUsznlB9q2JnzrMgWRq0R7QBqJDoRrCctewfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qFGo/TKG3gmkYaS5AR+1yVzzWA4WmpgZUsh2S5hsqahhbjZDZFV709rQxvqHobJxjOv8dTII69EWnELDloIUGAnWsFpWkLw13fg3KmXCH94FiH0rjdKRHUO2ovcMcRYnR4M9ecPSlSDtufy2VBjVFTTEAvL5TGoBZvlYIiKUIJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sm65iAc7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sm65iAc7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZgwJAAwDN2m/WVr4TzWEo4/v7goxWkVljK9zhm5160c=; b=sm65iAc7RjKLwoEN8aT8deYPfM
	ewutxDKHK8auPgTjTiV4FrY5FtMlnFqaleNIzgdZeK4PfXOTeMzCspjBgWjky5tG7acSPUGzCFEQt
	fMfG045c9fMfeHvLAA4+TzwepJ/1cT/ebhJZdInM5JCP7x+cS3DRUeQfdhWGfb2F44IOysPPQC3tl
	w8Nr257tfnMTesguzfSR66pOIIp4aA97PXTsdmgE6fKb+Pc2wSYMvoGk65JM3mY5cVkQ095RthwVs
	PyrAwnTPIBen8MT7qSMuvb7ndKvoZzT8+/AuZQuZt/8idWiJdp4ZbwavG9/ZKmmgFUc3rQS1GBeNW
	8kJWsQDA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tANEl-0000000GPte-3b9d;
	Mon, 11 Nov 2024 05:45:20 +0000
Date: Sun, 10 Nov 2024 21:45:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Long Li <leo.lilong@huawei.com>
Cc: Christoph Hellwig <hch@infradead.org>, djwong@kernel.org,
	cem@kernel.org, brauner@kernel.org, linux-xfs@vger.kernel.org,
	david@fromorbit.com, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com, lonuxli.64@gmail.com
Subject: Re: [PATCH] iomap: fix zero padding data issue in concurrent append
 writes
Message-ID: <ZzGZ76Qy7mCZo8a3@infradead.org>
References: <20241108122738.2617669-1-leo.lilong@huawei.com>
 <Zy4mW6r3rjMEsNir@infradead.org>
 <Zy8Lsee7EDodz5Xk@localhost.localdomain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zy8Lsee7EDodz5Xk@localhost.localdomain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Nov 09, 2024 at 03:13:53PM +0800, Long Li wrote:
> > Oh, interesting one.  Do you have a reproducer we could wire up
> > to xfstests?
> > 
> 
> Yes, I have a simple reproducer, but it would require significant
> work to incorporate it into xfstestis.

Can you at least shared it?  We might be able to help turning it into
a test.

> If we only use one size record, we can remove io_size and keep only
> io_end to record the tail end of valid file data in ioend. Meanwhile,
> we can add a wrapper function iomep_ioend_iosize() to get the extent
> size of ioend, replacing the existing ioend->io_size. Would this work?

I'd probably still use offset + size to avoid churn because it feels
more natural and causes less churn, but otherwise this sounds good to
me.

