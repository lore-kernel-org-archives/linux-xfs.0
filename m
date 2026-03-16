Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C70B3B95FB
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 15:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773676727; cv=none; b=rgOPNRhXA6LSgCC95Buw8jYKjpAOhQ4FpFGsMMK9G3qIp8ySIurKJ4f2SjUIwyhlkrTCP12swfqBt9IfmM2oLPRoa3NufuutPvATmE35Jyex4TC+CZSIZK5TcQ0PjwdQjhdxMiUHIwfknRNQWQa+TtNZbg4/ErRpct/FPpfTMpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773676727; c=relaxed/simple;
	bh=0h409omNgpgY3sDXYZMKzf57/xvS9xVoiIn5kN1wo8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YcXQWhF8Omk4576vi2PlOoS/0NRDr8NbET6rCcMSRhawf8VnVdbgholbJkRiIyAuDXioQGJzVOY6IzP1np2mW7VFl1F5m5FBJ6hczLHpDaDTL98LiudxsPTtf1F6IgMoHvnrMK39wW6qVug5+MK429yp6UBfxlet6gQ3kEQi4E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 12E2068BEB; Mon, 16 Mar 2026 16:58:44 +0100 (CET)
Date: Mon, 16 Mar 2026 16:58:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: Re: [PATCH v2 4/4] xfs: avoid unnecessary calculations in
 xfs_zoned_need_gc()
Message-ID: <20260316155843.GA19837@lst.de>
References: <20260316114020.753228-1-dlemoal@kernel.org> <20260316114020.753228-5-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316114020.753228-5-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 16, 2026 at 08:40:20PM +0900, Damien Le Moal wrote:
> If zonegc_low_space is set to zero (which is the default), the second
> condition in xfs_zoned_need_gc() that triggers GC never evaluates to
> true because the calculated threshold will always be 0. So there is no
> need to calculate the threshold and to evaluate that condition. Return
> early when zonegc_low_space is zero.
> 
> While at it, add comments to document the intent of each of the 3 tests
> used to determine the return value to control the execution of garbage
> collection.


Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
