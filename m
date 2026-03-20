Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A301F1932
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 07:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773991055; cv=none; b=acpkSUmyESvYVuOONDZ4+LbkGjKYJi84s7gByQVlWH6bL0z4HQ6/7388SHOGgHK+MAbz5MfmP7DUBrVeql1AmU7l3q9XQVTFh3Xyz4S/i++DQo+xloCS+kYUA29e5VodUxyngXlsSQdlNMHk02RNyRevECJ38unB2cYXhR+iJ6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773991055; c=relaxed/simple;
	bh=bZ5i0oFRKkaJOF+XFKVAN7pwY64UOYAzzCM4DUFSORQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sesUgYVdddP+uvtCC6Hz1bU2GyU6QhhDlrI/c3e3msNFyU/JP227U4r3X4THYak/+lyiTPNGQNKQuzksCHW2KKJWiuowf8tkHma6MQFAKqXyq1XCoQ7U8RM9mta4UtZjlaXSVOfYzzXb2+NR4kl1yfyrVyh5v6j3XMPMoUOAAWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3XxZN1bu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3XxZN1bu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wGpUf3N62uekwGUsgingKebf+VbbbiuptTx8A6Uto+k=; b=3XxZN1buRnWwJjzhJ4wZw0+nkZ
	W054YOeoz0zUCFAubXa8Y0MnA0Z2rSJ667f8/o9Mldb/30l3hBri3rmybhzk8u65/Jm83KqFqBnY4
	m1HWRj/U89ghbs9FWT7WdPQ5P6oUk/5kMwU/9bj1XDhBUYX7A1HontO/cuF4ugNLORmI06oOCESRv
	KMK512e1vHVaZa1A+/ahYYWzp7d41RwSyB+pPCWHc4Hejlub1bBgwe3hkLzcbN9Bq3XX/7aQQBlku
	xUrGt2wE2sBoDC+wm7lfNnNxIMRsLhaHNkZUWWLRevaCqY7v28MTkJ1CV7PdCacvsxoFn97JtbDZC
	2RlVA11Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3U6w-0000000CE3B-19XL;
	Fri, 20 Mar 2026 07:17:34 +0000
Date: Fri, 20 Mar 2026 00:17:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/22] xfs_scrub: allow overrides of the media
 verification IO limits
Message-ID: <abz0jpxjiVBe0hEQ@infradead.org>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
 <177389507344.3681140.4424251568194204096.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177389507344.3681140.4424251568194204096.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 18, 2026 at 09:51:16PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Allow power users to override the media verification IO size limits via
> magic environment variables.  For the background service, this can be
> done via:
> 
> [Service]
> Environment=XFS_SCRUB_VERIFY_MAX_SIZE=128M

So you'll need to hack the systemd unit files?  How could we set this
on a per-file system basis?

Not really arguing against this, but we might end up needing more
flexbility in the end.

