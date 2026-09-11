Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8DC35F8C5
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 15:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789139671; cv=none; b=OriBwYB+Jeipx7r4rDNQdmiP13vrLcG6zVSxiyPpD9TopiY0KZ+pLMy1+TY6GO3C+XpWO/hEtMj0azx4k7LmRz7lWaLabJuIK/QGn+ueGwfktVKQh0JsR1jYLAppD5SuiNu/RscS2G27+wrwLji7g5E9qL04kT9Yy+8oldC+rY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789139671; c=relaxed/simple;
	bh=idXhniJ3IxfHHXpa8+s+laDffbu36UKYAmQY0tZ6sY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qYr+FBdFDqKxyHXLvEfyAhK4tHebOuT4pfYOIF5J4a4x3fD9vLA3PxPzkGiyFEEuodjlYsO7thORlVXEMHILrCHtevBnDO2hX4LsId6Kjw7HHPyfWCP4TNULAwcfDkVi+jny0hVNBKXvr3GabCzRHztJsaqCFfRd80CkPAmImMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gm/ZC9Nn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gm/ZC9Nn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=SMSi4bGEXO1zRyQ+6EyUiGS4KpzvicJA7OYeEGMijDA=; b=gm/ZC9Nn3pQvUgqUjBL/P2q+a+
	SaYVFZT/rdlI4bbyxVGDPsGEd54XslmWp/+d+84kdPe/vzRWk/+yOFY6WPmKbXDKEjGdSiTjSL4IJ
	A6XxDGc43Y4jiIBt/6S5VxidqqrGJFa2uPqkSjuWDmMrenRXWO9EeuleFurIMhTO92O6wukPWkI4j
	tDNgJmiBkzLjyJGid5kkI4AzzORCyBA9DBAT6bX+XtjEf/0F//pnAjlAT0a27SiBfPIVGn1NnUU7U
	9jw2WvuWBv8FyEDBU+izqzEqeaWcwEFu5axM2DLgFQv3CYuLFIxlD5rUEpWU2sideIQkOM4aqUErB
	IrjAlQlg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x52xR-0000000H193-0ojz;
	Fri, 11 Sep 2026 15:14:29 +0000
Date: Fri, 11 Sep 2026 08:14:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] mkfs: print config file for a given mkfs
 configuration
Message-ID: <aqQa1cuREZufaWnT@infradead.org>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
 <178892910566.4047311.11716167302378334931.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <178892910566.4047311.11716167302378334931.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 08, 2026 at 11:00:46PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a -c makecfg= switch to mkfs to emit a mkfs.xfs configuration file
> documenting the user-visible filesystem featuresets of the configured

featuresets sounds German :)  Wouldn't english spelling split this
into two words?

> filesystem.  This can be used to emit default configuration files as we
> do once a year for each LTS.
> 
> Note that geometry information is not written to the configuration file.

I guess this is implied by "This file will contain only user-visible
features" but maybe the man page could state this just as explіctly?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
