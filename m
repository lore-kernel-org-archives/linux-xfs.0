Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E254780045
	for <linux-xfs@vger.kernel.org>; Thu,  2 May 2024 12:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714654126; cv=none; b=RVQeN6FQ15TtTPm14cMAmoX+7LY1o4MIuRsAEfr4ILQ8qu5qZGa7TEtoSaGkw2eEmFNr7V38oFJZWfniFr7Mx6+JpG5mCbjh/3CfTJirLrHSPwTAclXFPXpf2bumYtRlF+FK4aFCND4ngwCduP35MwJfqc4Ql9ao2lIcFNJ+2wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714654126; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T+Uy1QpILShvxP+YxAdURSXtfS/ugVUqCFDsQ11J9N6EDhMHBPOFr6YoFK/LEOlwJsa8yvdI6/E+6O+ES2XBF8HoC049uOA4uJLlETLWVyDnRtikqVcbOA8fk46R2zLGzbQkY9GAJzDwp+mvbEDKti59EM7dE7r74X7xTL7urDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9E633227A87; Thu,  2 May 2024 14:48:41 +0200 (CEST)
Date: Thu, 2 May 2024 14:48:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, djwong@kernel.org,
	hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] xfs: Stop using __maybe_unused in xfs_alloc.c
Message-ID: <20240502124841.GB20481@lst.de>
References: <20240502100826.3033916-1-john.g.garry@oracle.com> <20240502100826.3033916-3-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240502100826.3033916-3-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
