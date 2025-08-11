Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857BB261593
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 10:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754909301; cv=none; b=kT8RARAkGhRTuCrbDbNAyBZClnUHDJFu70NivE/ZwoPJpnKJ4XkGRoHTilHtIVahLZ1Xl7zFgWG/zrUvq+3g6JCACncalAP5jeU5TUBqTkUMMIzDDjH9QadAI6uTqtLCiQi5m7GX3UnjVRvXJbuVWQUVTswQBYIabOV11gJvkSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754909301; c=relaxed/simple;
	bh=CQgX+40GhXe+YnUGPM3rnjJMHUa9NTGFy26+aldJpl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VuL1Rw81nxYQ4s0WQtxVNIHGN+VlnkJ6Kn/hiLfWL730eYpQzM5TNbAcQOU7igYmmQRBVHWWVKqrzy18HnYSMm4/LVEm78mE7Dv/enbsE7NspBaFkn7RxN0fhhgKfgIsAQHLlbpd2IMBNHY+fm78OQWSEOJsuwpdHQRmkuJaJCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=W9HdBUtt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W9HdBUtt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3xjW8b/kM4yT456AyiC69zUpTATy9CQeobAbehpAx30=; b=W9HdBUttni5MVpv2FS/S5ITckE
	YRV6s513+uvbDGI4C6uEKfzHKqpY45GLAh9U58WRYZfHE9hX/4FeJs7g6kftWwNLPdYwsiOymAZKQ
	PBzo9UeW1IPUDvRgBHUOtmf4KLLoQEa3kQmz5az7/RLPTaE2Hjdpe4S0lkP4Vsc7FTvP9Zu7Y9ZS4
	AWBahZ1WYhL+3DwfmavJ1FRZcET65bMpPnaiQlTKNHUzOddCRSKxqZLUWqo44vSfxai/byvfpuz4B
	GETAYp6TyyQeIICvH9upXFaZ89ez69QTWpqcdvta36B5q/dgOn2On6fLzQl4KVaPK8g9ZdtFo0jur
	lDGI5ZUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ulQ4g-00000007OhB-3HyO;
	Mon, 11 Aug 2025 10:48:18 +0000
Date: Mon, 11 Aug 2025 03:48:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, linux-xfs@vger.kernel.org
Subject: Re: Shrinking XFS - is that happening?
Message-ID: <aJnKcktFW6jPBETP@infradead.org>
References: <B96A5598-3A5F-4166-8566-2792E5AADB3E@karlsbakk.net>
 <8a9071104eec47d91ab44c86465d08d76e0cf808.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a9071104eec47d91ab44c86465d08d76e0cf808.camel@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Aug 05, 2025 at 10:20:15AM +0530, Nirjhar Roy (IBM) wrote:
> On Mon, 2025-08-04 at 17:13 +0200, Roy Sigurd Karlsbakk wrote:
> > Hi all!
> > 
> > I beleive I heard something from someone some time back about work in progress on shrinking xfs filesystems. Is this something that's been worked with or have I been lied to or just had a nice dream?
> > 
> > roy
> I have recently posted an RFC[1]. The work is based/inspired from an old RFC[2] by Gao and ideas
> given by Dave Chinner.

Like the previous attempts it doesn't seem to include an attempt to
address the elephant in the room:  moving inodes out of the to be
removed AGs or tail blocks of an AG.
