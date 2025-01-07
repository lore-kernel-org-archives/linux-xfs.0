Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1909E647
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 06:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736231604; cv=none; b=XODbDx44FWMOJDzbqQrfI2nvBiswVS4nuC5w1f1QFKkGXJmp5RS89P5MqmyDaodYF7ohMTGNGLoZpzqDHKGufaWCbaHnXPrG2RjHqu3pJO5JfES6vMumdo9Q89WGINKBkqPcaddkn9PCqVSIjY80a0OUgl2lNlO3pWcSqYGuYw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736231604; c=relaxed/simple;
	bh=F9vTfIXAe46vrLrHl6/Zt139I4ge8n95mn+XfgjCPVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CKYYPrWp5q7T+9H2VK2tx9tRsb9ZMXOXMsTsqQ8RRqO5MsOSxvIT+jw1x96v1whEPcWTJmjh2Jr2s5CfTh2kq2IRrbdMYUbCl7jM/Nzspxi0XIBoY9kdism45SCh3rMKY/xMlxRa0Lw0iylAYAeQwyj70Z5krRiODWwkq4QGr1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C0DCB67373; Tue,  7 Jan 2025 07:33:16 +0100 (CET)
Date: Tue, 7 Jan 2025 07:33:16 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/15] xfs: remove xfs_buf_delwri_submit_buffers
Message-ID: <20250107063316.GA14283@lst.de>
References: <20250106095613.847700-1-hch@lst.de> <20250106095613.847700-7-hch@lst.de> <20250107063148.GX6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250107063148.GX6174@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 06, 2025 at 10:31:48PM -0800, Darrick J. Wong wrote:
> On Mon, Jan 06, 2025 at 10:54:43AM +0100, Christoph Hellwig wrote:
> > xfs_buf_delwri_submit_buffers has two callers for synchronous and
> > asynchronous writes that share very little logic.  Split out a helper for
> > the shared per-buffer loop and otherwise open code the submission in the
> > two callers.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_buf.c | 121 +++++++++++++++++++++--------------------------
> >  1 file changed, 55 insertions(+), 66 deletions(-)
> 
> Sheesh, splitting a function into two reduces line count by 11??

Well, most of that is the comment in the low-level function say it
does either the thing the one callers wants which is already documented
in that caller, or the thing the other caller wants already documented
in that caller..

