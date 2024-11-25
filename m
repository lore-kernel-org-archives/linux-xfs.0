Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B8A2AE8B;
	Mon, 25 Nov 2024 05:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732511548; cv=none; b=V0QZxGKLdZBc/HNjsZoWdxIYAn+GNIHYSSFNQjwjn3eTtbECjJwtFARuZCkCEdqVVH7bcjrIHvLk5EkJR0MWMHSkiaI162Jqs2j3MIOfTuc/Xol9irS2cExc36X0GXK67KQgd/Yr28IZeSl9nTD869fgSPsysQQmNH1UhdL4p6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732511548; c=relaxed/simple;
	bh=0s2lUWMQKR0hoLosHCt0cYkCQuad1nAysL6sRmMAGMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GGyl+rImDMch9XhQc96XmBPM1lrlUzNAxhQ763Py84AlqrxmEwChBfCxspfc0VZdAa1dHvkyzlg/vqrxn7WqNrKSDjR8PmXvAYU63Mib7kmMj4JUETGp/6MqRy713oMxRxRvLn7FnQambH0wYEZp3bYvvZEa8njFFnTc17R2x6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hyIXy+/A; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hyIXy+/A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5+Be6KR913s2ZUa3ZM64I5ErQ55KrBwpt/vz1jRbqOc=; b=hyIXy+/AZZxQsBOV7WuDQ5pbvb
	mKSMaf6UvL5kSwQwNxN6kFthYNtel/qSyUsKepvPxvb+9V9IGxS0ynjdf5RLlsXIvs6c360liXN3R
	xjl8/pk72kheQZuUOG4oM6JmUb094BE5dfRPK9/o8U4bprIZRP6N6trfuaAHo6Yxj5OjKDguCGJaJ
	kCSAaLyYTECPhJ699B4Asz2rqG1qhJZNGFXGQF7VgFGEg1MIhWbljY0UYSMEh2a3Kpp1M6aCVy/aP
	I64AgrVNC/Mh+qkJvpC/zCki4q00O/mzemSKZp2xcR8e0nDRQFoihiFHVFFHbcZSMDCVxxNINwN92
	+WDtLO9A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFROc-000000074bZ-0N4H;
	Mon, 25 Nov 2024 05:12:26 +0000
Date: Sun, 24 Nov 2024 21:12:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/17] logwrites: warn if we don't think read after
 discard returns zeroes
Message-ID: <Z0QHOjqagg5VuhFf@infradead.org>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
 <173229420060.358248.11054238752146807489.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173229420060.358248.11054238752146807489.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This feels like it's heading in the wrong direction, as it just adds
more hacks.

IMHO the right thing is to:

 a) document current assumptions and tell users very clearly to use
    dm-thin to get the expected semantics
 b) if we have a use for it, provide an option to use write zeroes
    instead that can be used on any device

I'm happy to do that work, but until then I'd suggest to skip this and
the next two patches.

