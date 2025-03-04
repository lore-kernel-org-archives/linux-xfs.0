Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C74D204876
	for <linux-xfs@vger.kernel.org>; Tue,  4 Mar 2025 13:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741096704; cv=none; b=QzJaNSjVNzaTvbFwOsu0ogX3xBzIN2rIhqVYa5sJ8NB5JJSugFybi0W5aDdfYSZcBEvAg7PU8/s3odnaUJ0yi6LtgmN9nU9YZ1iHzVWm/sERkoXmod01HzY7FlDc7RKfxRbV2i+EfdVR/mHCe8H6O/FPGa+8jueCKM/JvYNSrXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741096704; c=relaxed/simple;
	bh=lb3eo6/GFUOljp+k/tX6SPRPkXWx2tF1jGlzoLrJThA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eHuN1B6/KrfFrOOttoJ/zDsFG1P3cyEIBOkLJVYsFIR0RMExO5wisuWy1Qn8BDLPD26wLKFUeoliD4zLUWYpcGO+a6Ms8ZEqOSwgQijv/nmlGOjp5R29rFP5xWhSQuP6svzVAOGV5YTxoIz1eQvlEBoBiups0t2foSaVzR0Geas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LBikmbVm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LBikmbVm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lb3eo6/GFUOljp+k/tX6SPRPkXWx2tF1jGlzoLrJThA=; b=LBikmbVmLKRP+SLbpEeA0aNhJE
	b2ElqnM3xKpjLRQBGmKIqgw8TMNKoiBMZbcX76wRHPIU7dLjQuTpFGeZvW7uterxVAIb7oUwyTU05
	3Okdhh+ISMCea+LBEtQem6D5pCl6rO9OtJWaPph2HypaVpFKSb/XOQ74zNT0KQrOOPlNGK61o6gI+
	X4NKvvOYtcvQu1H4PN+UVvSR3ggUh1nfIpOwe8Ip7jFQ+UHm0UOAyXue2W6HQ2hda/Mcluc63kO61
	f2AbKlqv+2NwQI/U1OXyZ6gKCq2oIjll28LQexOFl8lLseFOoJDJ/y9KXcQBNEQkoEUFJu74J+kCy
	Fm4/drTA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tpSmt-00000004sU8-1AX5;
	Tue, 04 Mar 2025 13:58:23 +0000
Date: Tue, 4 Mar 2025 05:58:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Julian Sun <sunjunchao2870@gmail.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, djwong@kernel.org
Subject: Re: [PATCH 2/2] xfs: refactor out xfs_buf_get_maps()
Message-ID: <Z8cG_2lKpav_Cpy3@infradead.org>
References: <20250228082622.2638686-1-sunjunchao2870@gmail.com>
 <20250228082622.2638686-3-sunjunchao2870@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250228082622.2638686-3-sunjunchao2870@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Feb 28, 2025 at 04:26:22PM +0800, Julian Sun wrote:
> Since xfs_buf_get_maps() now always returns 0, we can change
> its return type to void, so callers no longer need to check for errors.

If we touch this anyway I'd just rather kill xfs_buf_get_maps
entirely.

