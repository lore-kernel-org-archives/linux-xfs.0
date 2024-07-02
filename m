Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6F12C861
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897119; cv=none; b=oJ4RprkMXFzDJWJXk6cn15hobwbTg5/6HxnveihbEAm3pzPyJ/+QdvOniM6Q0DklLsJ4CT1zVpccS/m4DfURl99ZDYUehZW1rggk8M0r782OhfY0KOvZV46MlZOoL2uPgWUxUnN6/M48mQb9qDuwzasi5Rknulocido9dQnoA90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897119; c=relaxed/simple;
	bh=OUcI9CLNrcCbpidNnd5mR8fIvbV6NIOu3o0QMUNFeOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AHUFjJ8heXX9OJUdEiXGAwxAKPguaIcwXSPRHI3s6Nt0GHTRir8XNEjtGg2OTGiEVIebYkMzIgXo6SwH+KtDlVD4QAfA4u5Io4sAPHsAd566wvOwqVvkYJWHKCtevviPwJ50V90jUi7kMnkUn1R9qF08Gy4PLBWttmuVGsZ5kEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E88F968B05; Tue,  2 Jul 2024 07:11:54 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:11:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 06/12] xfs_logprint: support dumping exchmaps log items
Message-ID: <20240702051154.GF22284@lst.de>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs> <171988116801.2006519.17657789199852782439.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988116801.2006519.17657789199852782439.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +extern int xlog_print_trans_xmi(char **ptr, uint src_len, int continued);
> +extern void xlog_recover_print_xmi(struct xlog_recover_item *item);
> +extern int xlog_print_trans_xmd(char **ptr, uint len);
> +extern void xlog_recover_print_xmd(struct xlog_recover_item *item);

Drop the pointless externs here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

