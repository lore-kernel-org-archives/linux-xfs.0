Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE03938B14D
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 12:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773147244; cv=none; b=ESj9nyzoBg6qp+WS37ZYTMebPkx/Z4rTgE4FYMtHtuY/7VplSOhUhMVa28QhYD5iPn9IhDjdkwcVhQo1r/6pDKQF27lvFR2S7JKu/FPsIqzE0gGrYIo6Sl0uwL5N/63/ViqtdksKYCeTbePwhkEpcRbxS1l6QilhV4cvyHikdgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773147244; c=relaxed/simple;
	bh=7ssFFT8xLLF+n4AY8h+ZZn7lNL372GCnZ7vuzDNHbZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YaN6Fa/HcwB/5GTlg+NxM4UDb+eaiHLqTkznjaTUXtNJxXtzYJ13uN4z7gVnyrGouWt1W2hkbd2JVpbup/enKikyMvCSRStY/dhA5JvnTp9kBazu7mCpoMdok3rpHSc94ItJC+N0/kTMoPdRPFHXLoVOrUEVkJ7iNYgwK/0m2Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5456D68C4E; Tue, 10 Mar 2026 13:54:01 +0100 (CET)
Date: Tue, 10 Mar 2026 13:54:00 +0100
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, dlemoal@kernel.org
Subject: Re: [PATCH 3/4] xfs: factor out xfs_zone_inc_written
Message-ID: <20260310125400.GC3323@lst.de>
References: <20260310115555.114197-1-cem@kernel.org> <20260310115555.114197-4-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310115555.114197-4-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 10, 2026 at 12:55:06PM +0100, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Move the written blocks increment and full zone check into a new helper.
> Also add an assert to ensure rmap lock is held here.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

