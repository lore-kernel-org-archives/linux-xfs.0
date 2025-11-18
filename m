Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EC02D94A5;
	Tue, 18 Nov 2025 05:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763445575; cv=none; b=VmcFbAz69imQ1wwBMfgQY35J6pwjKYULPQaTRKZqxBzBSjCsoBxVu56iKX/yFI2BVz+PiL4X6kYzDhHOwHKuXbd+MeOxJr4BOR6rQTPzCmLvJEFoQSIvHoJ+Wfuuzqdxvp+1WXp02Ry2GWmT5jOvd2EJGJQ+vKg1HKaP6MpXJ4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763445575; c=relaxed/simple;
	bh=aPu5Yy9SwFcuCcSF+lmjVGFh1GF0dElEC0VsC2TBfbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QHTP4TVUMefwVAsBdIh1cuBbtBOtD1MiNW1AHHimkudPbNuIll/PiSAXj1oNE/ztfJ5L26XrQm6PuEYtDh4DSR50mF6VfShDB7UfyPG2G9oL/GDuccuzobJ7JjG0myzqz9lc8RVp+5QTyHpO1SrsCk58UJfTXizsUdxDRQBhUoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D03E2227A88; Tue, 18 Nov 2025 06:59:29 +0100 (CET)
Date: Tue, 18 Nov 2025 06:59:29 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>, linux-sparse@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: move some code out of xfs_iget_recycle
Message-ID: <20251118055929.GC22733@lst.de>
References: <20251114055249.1517520-1-hch@lst.de> <20251114055249.1517520-3-hch@lst.de> <20251114170402.GJ196370@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114170402.GJ196370@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 14, 2025 at 09:04:02AM -0800, Darrick J. Wong wrote:
> I wonder, does sparse get confused by rcu_read_lock having been taken by
> the caller but unlocked here?

Probably.  Plus the conditional trylock.  Note that the more complex
clang context tracking also didn't like it.

