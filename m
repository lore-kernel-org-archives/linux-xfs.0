Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C9E3502A7;
	Tue,  3 Mar 2026 14:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772549482; cv=none; b=lLBiRJiiOMjoObykRKfVA5nIaRmON6GUcKebS0tM0wqT2wmkKc3q9IVLinn3m0ljFz+TK4R+HYHDuglDhFaxDVT7AdNMvQUY/qkFV7OLmCVUXACBFvbZ5MX+B0BJntr5B5iRG/KWUwNB7jcvzaGgYtQNpvd10wq83NwUpmvR0Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772549482; c=relaxed/simple;
	bh=rgNL1inaPJ7m8XSklo6WqH97eI0lqnqRQLRDL64gSJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mabaHp4vhYrklL1RvJnw/zFrjECrKNYbsJ9zMTsPB599qwH54KAw93hGKkFX2sGQGpxCSNucPlXQgWU1zgCAGHeAQ7sx6jTDdm0xRKuCST1GXRELSsxw5UDz4ftB0ZDQjQOHbhek5MQtUza3MYVgo2j0HFTlDMzv2m2Y3Vy4WpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WKsHdlMn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WKsHdlMn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=0azL9xrP6RjsDUWM8INKgKlOF2jsHNXZZ1YqkDP2LyI=; b=WKsHdlMnkEgxG2jMJsdzyNnAM1
	gzZbuFiJ1/V8ZzmO1LPj9LSCIMe92E/4TSnW/2LEozoRgcNnS/Tmbzbr8VwBZDUFyk8lf0YdHHnyU
	OGhRH3DqO6vlgf9RzInWHL+4//md+jo7+ligTbO8SkPQDtCnWo5/DUFJ4ZYs78L6/sU9nk4KUmiqx
	lDtXODNXhuW0El8IYf93I7qB6NtkM1O8sU+jSizp4ICfE7FCNb7Sax8iLmqjCXOUJIUmoekLGbVye
	Pk/yEElZPvkvgoAjmyAyyLAwpkPjueWPB8YvMszj2/ekXOBJvRcI4CtmoO6asn/FGfmM09IXAmY5L
	bd+8O/kw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxR5j-0000000FMKT-3PDm;
	Tue, 03 Mar 2026 14:51:19 +0000
Date: Tue, 3 Mar 2026 06:51:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, zlang@redhat.com,
	linux-fsdevel@vger.kernel.org, hch@lst.de, gabriel@krisman.be,
	jack@suse.cz, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] generic: test fsnotify filesystem error reporting
Message-ID: <aab1Z7J-m97VfFvS@infradead.org>
References: <177249785452.483405.17984642662799629787.stgit@frogsfrogsfrogs>
 <177249785472.483405.1160086113668716052.stgit@frogsfrogsfrogs>
 <CAOQ4uxgmYNWCs18+WU9-7QDkhp0f_xX6nvKiyDhS8gZzfUXXXA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxgmYNWCs18+WU9-7QDkhp0f_xX6nvKiyDhS8gZzfUXXXA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 03, 2026 at 10:21:04AM +0100, Amir Goldstein wrote:
> On Tue, Mar 3, 2026 at 1:40 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > Test the fsnotify filesystem error reporting.
> 
> For the record, I feel that I need to say to all the people whom we pushed back
> on fanotify tests in fstests until there was a good enough reason to do so,
> that this seems like a good reason to do so ;)

Who pushed backed on that?  Because IMHO hiding stuff in ltp is a sure
way it doesn't get exercisesd regularly?

