Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7A94A3F0D
	for <linux-xfs@vger.kernel.org>; Tue, 15 Sep 2026 12:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789475202; cv=none; b=n5AGpkn1rbJUMsGS/ejgrhcz/q7/9YPbRcR4LTsmwvMj+SPwEvimKBYDfWFwaq5mg803xIV0paydf2mL7wpGd91UnqWt6A+l4ZQLUCSEqb9UCW35zjTBTpXisao8HCN4zPQxpBcyfWtOsFKZiYjnUFUvGpgwmW6fpv2MNo7uR8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789475202; c=relaxed/simple;
	bh=aDWz0MRuwycF5hYz8DNbm4EDjFTcBZGrr7nfoyN2JK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YLk0M73MXHU+foZNDBluL2MafcUJ2kqQWXc0g2BvI7/AfjBF+KtKHOF8J1nUhNfE3W4GugUSt7AMGVGyiDBDNSLow53nn5Fvt7j1V4rrFVfMDJP9qBWNe4s2fg7O9GQjI026SxIS7wN3txY9/ytkrfHMb14veqw6AIHogbvEorU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n99hkBX0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n99hkBX0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WIJ3tellVSO3Hp7vbgYg+83v1cX3d9eBky19OkOqRzQ=; b=n99hkBX0aQ9hIMYSBLUIp01AWX
	UOcgstZUzVX83uV9AMYZhSmjs8lYvofuDTo96A+Ruw6PfioEw5ubR3lXVY8AXjdwI4+HJp+r7gm2s
	/ctx5JjchBdiBHIg6aQLH5fr09Af/LlvNBOUaWKoPtDsfxHECjzGCW6VWPFLcSsWswiN9Id1jMBkt
	XoLd6gQk9uvjxRtDqH318P6yENHY/kHLliXoejv6jd3dI6EjzObwDu/OpWys+Dm6OmE4Bv6iQCT/y
	zNq/vySp5qgw4QxuRJNcMuWQVnEne43sXqT13xjCjJHKBKzvQjpVCbbacDzQBZJVF487bX1X77cDh
	gL+EMURg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6SFE-00000006USZ-23zW;
	Tue, 15 Sep 2026 12:26:40 +0000
Date: Tue, 15 Sep 2026 05:26:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] libfrog: try to pass struct fs_path objects to
 quotactl wrapper
Message-ID: <aqk5gM82hhqq-Upd@infradead.org>
References: <178936484773.2108717.13238892511050788442.stgit@frogsfrogsfrogs>
 <178936484880.2108717.3928521689854404034.stgit@frogsfrogsfrogs>
 <aqkeeAgNLMFFqgcl@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqkeeAgNLMFFqgcl@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 15, 2026 at 12:34:33PM +0200, Andrey Albershteyn wrote:
> > +	const struct fs_path	*mount,
> > +	enum xfs_quota_cmd	xcommand,
> > +	uint			xtype,
> > +	uint			id,
> > +	void			*addr)
> > +{
> > +	return xfsquotactl(xcommand, mount->fs_name, xtype, id, addr);
> 
> The xfsquotactl() can be unfolded here and calls may be replaced
> with xfrog_quotactl(), no?

Yeah, looks like we should be able to kill it.  But maybe do that
as a follow on cleanup?

