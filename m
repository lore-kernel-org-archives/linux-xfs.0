Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C622F432306;
	Tue, 22 Sep 2026 05:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790055264; cv=none; b=sUJObvXkG+QtTNr667nCWuUr50WU3eqRJmIqRo4cdV2+rtSMjl3/mlKskfoyDjnID3La2S+fW8aOBUrJbWP0JSgy/IrLgINJgfHC1ELhyaxfj6ksliG+opDy33sdayJm8uLgbummYhWZociOVypmXt7gOVhb6Q2dypZ+9acPVuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790055264; c=relaxed/simple;
	bh=Q0XhJdpgm33Gw4prQpgCoBBkbAdwC6AIX/OqmkLThA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WAwn1njEBo1uypDJEQFTS5DBbHgSeuVNdEMeXM27fSe0MtMe8MZM5nMCM+qnlqiFpoa10d5bcIPaw/K/dZb3CdGdrw4xrpL1wy8ptl3aWDA5qYPwtpVQNDxgr2t4JqMCx86CfGHmLmkGTHY5L1WI2h+4+dRcvNgFRjiKg3TlY3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=25SQCC/Y; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="25SQCC/Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Aa88rA2eZs0mP8Zfad7TGSmmevr029N5R2DM/dywu/E=; b=25SQCC/YPcjBv/JNUlV2GOnRsp
	JOOreYhEjecIoU1qFVp4gP1RkRPaSO0Y1Qqp/cMGh7zhSMJdcTrjHo4WNEdoBw3uol6OJpx+y8ox9
	TrOAEwXtLskUzxQh2fxfObP7CMogyGGbFhnkPmYsQ3giOXz68sqgNvPSQdnIMuS45lCsSR+bIHRNU
	5oF73xr5WnGo4ywLGYxo2xtRZNo7PHvhNzVPjcmutn2jBpUftmdftoTOZ9trRE91WCU8cRZBh+1/V
	jhCavt57URweGzEvFaADCxGIHOKq/4mmJFLFfFf1HqU+LXvKRgylM7GKm4aWNKKDNZi8hKJyYZ+pl
	XLkxoadw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8t93-00000004Fmb-0922;
	Tue, 22 Sep 2026 05:34:21 +0000
Date: Mon, 21 Sep 2026 22:34:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrea Parri <parri.andrea@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/3] iomap: don't resubmit an ioend after
 ->writeback_submit() failed
Message-ID: <arITXTsUhrA0N-qr@infradead.org>
References: <20260921083133.2960-1-parri.andrea@gmail.com>
 <20260921083133.2960-2-parri.andrea@gmail.com>
 <20260921222953.GM6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921222953.GM6283@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Sep 21, 2026 at 03:29:53PM -0700, Darrick J. Wong wrote:
> > +				 */
> > +				wpc->wb_ctx = NULL;
> 
> Do you need to do the same thing for the ->writeback_submit call in
> iomap_writepages?

No, after that the wpc is not reused.

