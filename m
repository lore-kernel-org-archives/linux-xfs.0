Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F112336C592
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 13:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781615329; cv=none; b=Mfg77+1M/pKKD7twL3gIyVJ1RzhRNiAQavVge3sGnHTEwBT7qD++sbQud7BRFQTOmIFx/qjodtgCvj9dKMPtNtiAyAvusICgR/b726cNQ6OWU95re1aA+ttVId0lOFGxH1jAvjP2LtKoR/xUM+eoBygRYwAEjhsBpOBJgRyllfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781615329; c=relaxed/simple;
	bh=ysbktjwlRvkb8eNsFVnJr77qDP8T3N0lnoivtp+CGgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g/HuLShZLOJZ8rgE4myIy5acNREM75CSuNOmaJ3ss295hyfGTlDm10HDTZ2STjWbsso5Gq2bUVfTISd2124BpkxQSSBDr00jg6ixtk0WCLdk+XOF3Aa2ufr+aeDW8NlKBeCcbs0h1RYPIEY5WTzqWGDceKxtG3MIsyzZQqkrtHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=elR4j4wM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="elR4j4wM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OZx+4lxvYRZMYNtJJIxTgeFxRtMRyP0aOxMA4f0Sr9Q=; b=elR4j4wMa7qFW5ytHDZ1fRiFNZ
	g2jRU6ie81fBQy0I3FZWlB/OtCMK2nYHeQqvaOfB8XiyX+dZjSaPwxv/XHVTkk0C/H4UL4g4sn+hA
	L3RcmVlEeLywzQiRrmY4qGzkCqF7V9WcRzFAu0eq2yhOI9gLc9+aT2vW/Iu/OZ5e2MD4Oc9DvhRdc
	8/Ln+IxXK3Ai0NFRYGD//DK2zpXE4OBa7vtsm1ifvFSwUVrkgl9OxGzgnlbDOspx4OkhQL5sZ0HSu
	JkrQqiZFrU6UR7GuYXgICw47fbw2cCACsSLxDt7SM8mv+PvuLtb6D0Guyx4S1w5xxyQrFWCOxMIVH
	yCnyLbrA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZTX5-0000000Foee-0M4L;
	Tue, 16 Jun 2026 13:08:47 +0000
Date: Tue, 16 Jun 2026 06:08:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: caina <caina@uniontech.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: clean up spelling and grammar errors in comments
Message-ID: <ajFK3-Z7CpIx4Wh8@infradead.org>
References: <20260616020912.11409-1-caina@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616020912.11409-1-caina@uniontech.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jun 16, 2026 at 10:09:12AM +0800, caina wrote:
/*
> -	 * If we need to re-sort the free extents by length, do so so that we
> +	 * If we need to re-sort the free extents by length, do so that we
>  	 * can put the records into the cntbt in the correct order.

This looks incorrect to me, but I'm not a native speaker.

> @@ -342,7 +342,7 @@ xchk_btree_block_check_siblings(
>  	/*
>  	 * Does the left & right sibling pointers match the adjacent
>  	 * parent level pointers?

Should the does here be a do?

