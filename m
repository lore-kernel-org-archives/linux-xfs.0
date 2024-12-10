Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6264D8CB
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733806840; cv=none; b=GelPQxYRquUfpvHXWyEzMtU8PdjosB9e2ztsuaP68mUgJI3W71+rVUOXypZNH0Vw0P1a2UVnMRXX/BqHfWAqi7P7CbCwxaRaBjjwOyoVoRAy10ouIBvkuF7Tlxks8HTgx6OgnDuLjbKoum6BA9cPzA4vwA6OGWjkBc8Raw09FHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733806840; c=relaxed/simple;
	bh=OVuLwDawpCpZ8O+7dU+qJKFXHU2CeCxxwcRSKfpovJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IeP2vR2BJBzkA+b4Hfh9fT3WcZWO1KjWvS8Vp/gLSKRlIlD2haWJlvgIHMYaiwXprB6HrDxlwwxouVbaK0uRojLfGVxkfSrP5QArGYG3prg36xxqX7hhRu7ZMaEmtVQ3bCcogh+emF7tmhQNEL2WQfNsLLV7doyrkSNiS7TQ/bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rhtZnsMx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rhtZnsMx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gkvjbjpus9nS8gePHQDfn/e15BtbcEwxma8eYSt9D/8=; b=rhtZnsMxmQ313Nkk1NbwyjXndM
	o6WsfhG1GqobUBL+Rh+F9A7HYuInjvdjWhZN144v/QNst5LzJMsvjkGNQv0yych/NtRbhNibuWh4x
	vcp7bsmR3drXSyyUnltulURs8r1h22iBF6aExh/4NPwGRYtOJVq024iVimY9I1ooLIAqiFO1VEV4M
	1EOTezOFN22gRuOIr3DQ5KcHunDHg88Mt0OoxP6e1xpQZXkLtlGXR6DyT+S/kVQRQtXScKSzOj99a
	qnaOP+pmNs6fcVgAow0LZrVedXoN3R2SI+LOKy5XdWHqs/CMHL5Rhfger9Y9yBCswAQQuToMGq1/y
	GQHHesVQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsMQ-0000000AEv2-3dG2;
	Tue, 10 Dec 2024 05:00:38 +0000
Date: Mon, 9 Dec 2024 21:00:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/41] xfs_db: display di_metatype
Message-ID: <Z1fK9ul-gWSabENb@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748452.122992.5424837513822834189.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748452.122992.5424837513822834189.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Dec 06, 2024 at 03:43:17PM -0800, Darrick J. Wong wrote:
> +extern int	fp_metatype(void *obj, int bit, int count, char *fmtstr,
> +			      int size, int arg, int base, int array);

No need for the extern here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

