Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D924156D0;
	Fri, 14 Aug 2026 07:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786692505; cv=none; b=IDy1WlMxSAKkzsWexaaOcyE3NaN2rh157Beo8DRITma+ep7fu8QrNebZb9NMBWpSDIUcX6lQzBhlT9QPh/lM6Pw7ChaBrS3DHBkBQmdofnMsgtUv2INjgaO+b0guwFa9ilk3uIy/8cmU5SrUYljKxyppusjjlXqNj/KJzeCMF1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786692505; c=relaxed/simple;
	bh=5Ibx0tsomdtfNGZpd6mWiCRdn1qQ7X5A0iP0MgXBz58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gfX2siZtY2saSV2/hcSeYsTZMjEYt31OEBCvTz/tbd5Ar6ZwueY+LZykbq/kinVb4qY/ddFrcDu3sxXGOCdlUgUOFKHkEYYycIt5PVbR9kIY3lxaTCXoho3vXWdjtt3VTz0ebEz/knhugRbqi8sB8C2DlEBAX1gOjW5mxW9VFRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dUflBAyq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dUflBAyq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lPFxvP6ARci2OYMB/8eBSp5Qk4jL41d4FUk6GPedCbI=; b=dUflBAyqY3SXc80uBDOkB7HAw8
	KJcNvqx6FBFt2uGignowAnBeh0RKk5i48ZZd3Mm79mODVTXJWL+A98nGrsSIF/HudBxlaXzblbw8U
	llLugN3RyCQP35oRxaYm85ZZOKnSQUmLsujN0yhEK6sbzBUJb3JZFz5wD/htO5ai0BIg/JJ+aaG/4
	gKW4eSzsxmlbFbEHkt9oeRT3dOYzJl46Z+9Y/8aIug2qHQ//ahzH1gGbEF7rAeBTQIo3Wi6OJSEQ1
	l2TdRmYgh4s+/AFtp3Yc52OXUzaEdl3oo7CQC7L0u8eJPL2e6/UzzRCwPpSr2BjCosLlhQUexgec/
	thOWQdFw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wumKx-000000029Md-0U38;
	Fri, 14 Aug 2026 07:28:19 +0000
Date: Fri, 14 Aug 2026 00:28:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] xfs: prevent close() from hanging on frozen
 filesystems
Message-ID: <an7Dk2Tn1ibCRsv2@infradead.org>
References: <20260616053850.2188-1-aditya.ansh182@gmail.com>
 <20260616053850.2188-3-aditya.ansh182@gmail.com>
 <20260624173531.GQ6078@frogsfrogsfrogs>
 <CAK5ssPP6FL+6i8z+0QdE-9DSp0rC_U2S20qdxY7Kmdp7RS0xRw@mail.gmail.com>
 <CAK5ssPMyJhvnEQSRoAwVNnZS-A837OOMewEAvp+ZiuWKD=vUdg@mail.gmail.com>
 <CAK5ssPPC4Ov0KBbRphC_wZBZGu1Rr4-d2At4V+ZECFcuHxbEfg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5ssPPC4Ov0KBbRphC_wZBZGu1Rr4-d2At4V+ZECFcuHxbEfg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 13, 2026 at 09:43:44PM +0530, Aditya Prakash Srivastava wrote:
> 
> Are there any remaining concerns or feedback that need
> to be addressed with this patch?

Still looks good to me, but I think it just go lost.  It's a bit close
for the 7.3 merge window now, but I'd suggest you resend it in a week
or two to get it onto the agenda for 7.4 early.

> 
