Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE8E1B94C;
	Fri, 26 Jan 2024 13:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706276006; cv=none; b=ntLmXNC1OgyIzJDJjaLNlzXJCKN2VqP6x8nosXbh/awDYfvXZbRHwnAjnYJZxhALPCPzRJKi7LF8GPjCDG+pawyTCOMZE9fwhpCjOhLxcaGnKooV3rON7s40idvDGespo6ug2TkYxvAqU86xYts7OJwZ+6T6Oofw/FcmuoEPYgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706276006; c=relaxed/simple;
	bh=F1ocbJnwrW5mubg93CSR1kPEBiGRSfHh2Ph6Phuj3js=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WGm9sh/c+GzPNUeob/0Emn/K3wE8j2MaTtKWHv+Bjy2ARp3+lAmgA7FUKKHjMywabEW5mcsw3h87CXyhoMWEzxTYHqVzRbAonEEYg25FYCpvjEAPZrakob1YzxCH9SpL+i8q86J8TnlkiMLZ3N9mt5nOLMJhOxqFkogG/LQ7nmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NJxcrEEm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NJxcrEEm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sg5kbikyGWUHtIUEq1sHd8PCcRX89beGoMXkX+9D5TQ=; b=NJxcrEEmwCWIaiOftdmCR9d+pk
	gM8SKIytdKVWZHaTsHZ3A6bdI+sC9okXbtdonBMUAdKOFB5WHrBEhyDBMuYeApQjqMun1dbJp7L1N
	FKRG7fffy1VG6L4nCUl0EJ9j4BH6JeXNxYHgv7X63jL1YWKpyyr4c8uJJ9YhmqbZhDDP1/E1f4Txk
	apTHJKrxddNl93jT7ZiT2zFQhC4wvmmQy/l6cT1j/OJjZXoHX5jVpHpha3X2VzAEXN1MlI3nYkuvE
	5IFxFKC/urISaDDTEVgHa9I0GefiBRZm40V/qjXISTM1ZEtsJWF9cG3vPiLIiBWpHaV6k75XmgnOV
	grJRh7UQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMKi-00000004DWi-2fA3;
	Fri, 26 Jan 2024 13:33:24 +0000
Date: Fri, 26 Jan 2024 05:33:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, guan@eryu.me, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs/336: fix omitted -a and -o in metadump call
Message-ID: <ZbO0pHSrCmwKTqDn@infradead.org>
References: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
 <170620924420.3283496.6869276450141660418.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170620924420.3283496.6869276450141660418.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jan 25, 2024 at 11:05:01AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Commit e443cadcea reworked _xfs_metadump to require that all callers
> always pass the arguments they want -- no more defaulting to "-a -o".
> Unfortunately, a few got missed.  Fix some of them now; the rest will
> get cleaned up in the next patch.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
