Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E074137748
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2024 16:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721753772; cv=none; b=At5cns+HiBEhcPJnQCZtn+SlQzFIyJRS2rMBZlBBeJ+tgcUn6sNDWC9t9+Wcbwf8JYfxJYJeKmLf2o1amQGH+AO+BuntYG305dlsDn8FXhxsmw/mwheRGc19k5AcuviycnIJpq0KeMVtuR22kqN7hE3gaIrQ8BPsfmwTawUrjnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721753772; c=relaxed/simple;
	bh=sC5EGHAM6peF+FoHVz+iRFy8r9Kb1nNYUTgsglPurjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bRHVlpg3y5ow+9CL8KziliMMz2GyEuhrVva5L5bzgS6ID7AGSSp7ekoVEjHWIyCcdUL1av02pK+mvgCsDFLtKP/tAedLB7PZr3zN3XQobwe+MP3RmRk/aPwq+WGeASu+8v+/yxFotxMW+jreh4Hh67epYGwsewSjx8LKGALvA/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=h4GN26II; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="h4GN26II"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JXpt8QiNWbJHd9olEqIsuGMM2VTiiyYRRhUNMZZvhTU=; b=h4GN26IIj+U6n/J+FGv/ci4Zjc
	fjUtwg8vH7Zb2kBEZ8CAAcwb0OFrYEP76Fhff35BcVm0Igq568YQiTwyVqqxsw7uSXJl1PYwD00gq
	ey7l3VrPlcWYjAwFVrry/xcZHRVcefAfHG/imio9hwEsq+8s3234a/jgExDyimUqcwc9YVPIMGpS5
	mrfIxCR8u6ZOC494BYAmwGVbN8ceYR6fFeP+AnamRFUhO62qx9wLZ465+P24K4f/QnwbqTXzrmsso
	f5c6qQjrn0ZHKTQOpZNZBjBfU1quGJ3QvyFDM5PrbpU2VRZ4fT4SJHQoiMTekBe6pTrA1B+IbZ4qh
	IDzfoDLQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sWIo6-0000000D3yn-27RT;
	Tue, 23 Jul 2024 16:56:10 +0000
Date: Tue, 23 Jul 2024 09:56:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH V3] xfs: allow SECURE namespace xattrs to use reserved
 block pool
Message-ID: <Zp_gqoQ7y7SPUXhz@infradead.org>
References: <fa801180-0229-4ea7-b8eb-eb162935d348@redhat.com>
 <7c666cfc-0478-42d0-b179-575ace474db0@redhat.com>
 <7ecf75c9-4727-4cde-ba5a-0736ea4128e9@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ecf75c9-4727-4cde-ba5a-0736ea4128e9@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	/*
> +	 * Some xattrs must be resistent to allocation failure at
> +	 * ENOSPC. e.g. creating an inode with ACLs or security
> +	 * attributes requires the allocation of the xattr holding
> +	 * that information to succeed. Hence we allow xattrs in the

If you repin this anyway because of the spelling nit maybe use up all
80 characters to make the comment a bit easier to read.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

