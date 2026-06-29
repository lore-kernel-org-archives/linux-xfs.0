Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E35340A6C;
	Mon, 29 Jun 2026 12:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782736244; cv=none; b=D1KVZSsFXp3i1MyIKrLT7PkLJirAM7WHo/qpiU+SoYgVjT7iyAvSEWC8qKMjT6CDoWwWfIpsSZl7nagAY3a0ue3/Cwouh9NDpB/4lYQ7YMFaOcKhqy6t6cNMSV0P3W+U8z8iXNfFhESlDDDzXT6uWbqgJTO+QW1tNxR1a2Rzvks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782736244; c=relaxed/simple;
	bh=ojR7k8vKLgbofZ3cC5Gx2KGNbY0Wdj9E6ztE7TInfCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LyHcBD+Lq4euQ6VQFN0cqng6oojIb3hPPUnplGRzawENH7fqNY+Ib7M5Y/tn1euePlLPAKt5qDikgDhImlHPF2Bz5Mgg2HhjmCtNUrbmdX2xxOVWPmnTYTWy5Xi98yTNZwM5ITo/JukoEL/77W+c0QLhx/YHgd0jKJqElIHMPhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0451668B05; Mon, 29 Jun 2026 14:30:41 +0200 (CEST)
Date: Mon, 29 Jun 2026 14:30:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-fsdevel@vger.kernel.org, jack@suze.cz, djwong@kernel.org,
	hch@lst.de, serge@hallyn.com, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 3/4] xfs: replace ns_capable_noaudit()
Message-ID: <20260629123040.GC21958@lst.de>
References: <20260626114533.102138-1-cem@kernel.org> <20260626114533.102138-4-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626114533.102138-4-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jun 26, 2026 at 01:45:22PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> We don't need to use ns_capable_noaudit() as all we care is the initial
> user namespace, use capable_noaudit() instead.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

