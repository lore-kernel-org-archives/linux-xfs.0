Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F0915B98B
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 15:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709135992; cv=none; b=UArtrQyjVnaMN4R2J+Tm1FNDMhwPsgzMeMW1+/shrk6w0279jvOLr9G/HcBOB7mnldQmymmQMHAKlAt6VPPoq331uvXUqxZU1lk5p3A8Xg2BXhsqkxAycE3F4OnbXFBFHZ/vzC/Tw3fHPpx0rUbU38p4PjUP6rf/3qdQYs4dQ4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709135992; c=relaxed/simple;
	bh=n549ns73JMTIwlrexX57kNXzbNjR6WBVdAjrpx/8YXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gi9gSaBFREaYhKAZ4zykiU5LUXybzrik2NRszwzmli3PAjWc87EFGaBBBJqE/ZM/s/XkkA7iqMDyX+xOTxyxp8Kv9VrgPSD6QYN5qyIk/OO6J7QbSo9RkDub4WVXrDADbCEuUaLN2zZ+3xC7Z+3iZheKqP36uO8EUQXnLsp5Y4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Yv2yiPKh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Yv2yiPKh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=n549ns73JMTIwlrexX57kNXzbNjR6WBVdAjrpx/8YXo=; b=Yv2yiPKhWbM6HSHE2zQk9qtzQG
	Z+a1kxF157+ptCh/3bqyls3ZHeyaz3+YsLCUNxmkDJJewSjPQoy3cSUXhWsNJuwS7IhYKLvGzlflZ
	Z21Xdi1c1c8U9EWM8AYIw5DNZaayIIKTDv56n2f3ECXtIEz6odtrtQ+5tKDYhCdW2DDpI5wOYurT0
	LK0ff+5qcWfcZvNdrCyBNsn+vTaOzIxWFKEysn8VzBtPJpqGby9VSkfD7ChbIY391gIRHlhMgs/l0
	cVWEpmuoBzJR8/a0l/6oCMTvH+xPJsbKlbnljJbRN0q0qlFJemhJrzzyG7pWEbiSL8iD+x67OgQ8J
	Qstt/94g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfMLX-0000000A0Uz-10oo;
	Wed, 28 Feb 2024 15:59:51 +0000
Date: Wed, 28 Feb 2024 07:59:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 9/9] xfs: validate explicit directory free block owners
Message-ID: <Zd9Yd50w5vskYZrA@infradead.org>
References: <170900013068.938940.1740993823820687963.stgit@frogsfrogsfrogs>
 <170900013243.938940.4243130142867918052.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900013243.938940.4243130142867918052.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Same comment about the extern as for the last one.

Otherwise:

Reviewed-by: Christoph Hellwig <hch@lst.de>
