Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECB91B87C0;
	Mon, 16 Jun 2025 05:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750051810; cv=none; b=T/C2ZNbyYeJYUdabEVFtY3HxckMcbC9J2sO2PwvNBb9xhuWmd+UYFT1ifEVLStQ8ymwn07FsQAqGHGqnDtG1ftAMT3zP/oGjKZ/OP5+JRXUiAWHw8ye+IU7ZURH5Aj+uDEsboJNM/RhA05eZZxsWppTiqZVNKqBoLIY5T1aXg9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750051810; c=relaxed/simple;
	bh=dgNJF5a6/wPXGhWypY2dBM0Ak3JVyRat9hitpTVk7J4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ncTXKO8fduTB9OFrsB9Tkw+UogaYVB+kIAKXQ+r5vLzXyJlNFYnux6dZ6ZrOstERNp1ZDiFX2bAsZPez/hcFw7RN7dR9ZUiRIy9VDIwRfwcPLfl9+2jHyVWQQpl8Eyg3h4+s1Jemm0pshFNq9nGTG2IplSLMX6hirynYtjGA/AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7C34F68BFE; Mon, 16 Jun 2025 07:30:02 +0200 (CEST)
Date: Mon, 16 Jun 2025 07:30:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 00/14] xfs: Remove unused trace events
Message-ID: <20250616053001.GC1148@lst.de>
References: <20250612212405.877692069@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612212405.877692069@goodmis.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

I just went over them, and modulo the nitpicks this looks fine.

