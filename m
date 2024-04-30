Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F10128386
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 09:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714469757; cv=none; b=dr/ExKROdlHU3fBseYTS7Z8+GE85y0vm3y109UApNhRPh6X+KTUtLr/QMKY4JAGvJBQsK3p3ZWSL2WgtzsDhL8Pl2+KBpB5YFTFvM+9Lz65Jzj6/NsJZSkJHFlODBKASocNCuVTcq+TgWGCxMEoJVG0lKhApiZrFFd5myzDn3Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714469757; c=relaxed/simple;
	bh=VzGjjRV7GtmPu3uwvuJqKhk4HHKhHtt+hP84408+HIA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uYYbHXuKpvRuLmbZNurC7pliaDwN52QlN5rzc3H803KAfOllCrHzsHn1Jd8xWn342rW2uF27sbxFHwYqU7S2xNrPU9Sh6yfvsGDgb3IPR0ZbitB+/J63qaGHJspJOE1YRVfcC3DEuML1Evlii032bK2TwfAO6DSn5Lu9tnKcS/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 38F5B68AFE; Tue, 30 Apr 2024 11:35:44 +0200 (CEST)
Date: Tue, 30 Apr 2024 11:35:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	akpm@linux-foundation.org, hch@lst.de, osalvador@suse.de,
	elver@google.com, vbabka@suse.cz, andreyknvl@gmail.com
Subject: Re: [PATCH 0/3] mm: fix nested allocation context filtering
Message-ID: <20240430093543.GA19310@lst.de>
References: <20240430054604.4169568-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430054604.4169568-1-david@fromorbit.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

The changes looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Btw, I wonder why NOLOCKDEP isn't a context flag to start with,
but maybe this isn't the right time to start that discussion..

