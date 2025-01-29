Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547F97FD;
	Wed, 29 Jan 2025 05:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738128025; cv=none; b=PfYRhBS4ok4m1YirJAnOFY7rEsxt3BKv44JYqT1vuLevA0SbFns0rkymKfxmkJVZS6is37O1Qd0fs0/kfZ/nQ7c+KHQPwOLQttCxEilZxSIvQqq+ra4+/ccDOK5faYsHZ6Rk4YG8XMMiJmKFc7Pnvcuj8+Yh7AW+bXOZET7Zl20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738128025; c=relaxed/simple;
	bh=39z95OPRIENXf5VgwRqZYyEr3zgdt9bbB/B8oAJq8k0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JLSxe6c5/3wUQnUapLtw02sx4XE9Ld0wO5ADTCEavd7qNvAyipIxAlR3Fxq5nWa0Zennac0vSLW9T3pJW0uwLxtpt/JcgU7rGOc0m/a60hjeiHR8j6I5zVU32cItSGyTmds0n01HtVdfHD51vgRJxZ+XnyZcuJ3pj7fjSFC7CBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AdqwePKH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AdqwePKH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=C1DEMUgMUBIHIyTKPUNGpnalEfSYZ49CqTbR7nmTSzg=; b=AdqwePKHBbInO0AyMqMrCRTSeC
	l5uGeYHDyXIz8uNKOnIaL46tVFv4Zkm8TShUMoWrS2G6A4qw2hDMxfgJSz8CKchM+YiH3fJjFNOT9
	frwTjgY0e6jSPPIMbcffp0ZW82VlORTqXxBbRIjaGgNLu9lVZBMvrmqtHL5qhl71qhj4hzoCQOdei
	dcFxpbo6+VtHyT+VMXSBiMqhYLdEvZpMpS4LsotRJXswcdSXic7/GKmaMrt/MSneYNVOGIIrI+XSE
	+lihZVckwKWpLqNGL1QrwR+r9cwgwCSLJQxAm0XXeWtO1EoAQrCwUOzVhrstC7GmQhbLXvgEIgldg
	0w67mr5g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1td0Us-00000006LLr-3Pg0;
	Wed, 29 Jan 2025 05:20:18 +0000
Date: Tue, 28 Jan 2025 21:20:18 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Chi Zhiling <chizhiling@163.com>,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Message-ID: <Z5m6kqmdUcLVNa9m@infradead.org>
References: <CAOQ4uxjTXjSmP6usT0Pd=NYz8b0piSB5RdKPm6+FAwmKcK4_1w@mail.gmail.com>
 <d99bb38f-8021-4851-a7ba-0480a61660e4@163.com>
 <20250113024401.GU1306365@frogsfrogsfrogs>
 <Z4UX4zyc8n8lGM16@bfoster>
 <Z4dNyZi8YyP3Uc_C@infradead.org>
 <Z4grgXw2iw0lgKqD@dread.disaster.area>
 <3d657be2-3cca-49b5-b967-5f5740d86c6e@163.com>
 <Z5fxTdXq3PtwEY7G@dread.disaster.area>
 <Z5hn_cRb_cLzHX4Z@infradead.org>
 <Z5l9ieD8zkCQYHFV@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5l9ieD8zkCQYHFV@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 29, 2025 at 11:59:53AM +1100, Dave Chinner wrote:
> Sure, but we don't think we need full file offset-scope IO exclusion
> to solve that problem.  We can still safely do concurrent writes
> within EOF to occur whilst another buffered append write is doing
> file extension work.

Sure.  The previous mail just sounded like you'd want to do away
with exclusion for assigning the offset.

> IOWs, where we really need to get to is a model that allows
> concurrent buffered IO at all times, except for the case where IO
> operations that change the inode size need to serialise against
> other similar operations (e.g. other EOF extending IOs, truncate,
> etc).
> 
> Hence I think we can largely ignore O_APPEND for the
> purposes of prototyping shared buffered IO and getting rid of the
> IOLOCK from the XFS IO path. I may end up re-using the i_rwsem as
> a "EOF modification" serialisation mechanism for O_APPEND and
> extending writes in general, but I don't think we need a general
> write IO exclusion mechanism for this...

That might be a chance to also fix O_DIRECT while we're at it..

