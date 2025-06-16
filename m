Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EAF1C6FFD;
	Mon, 16 Jun 2025 05:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750051612; cv=none; b=of+d2iYpi+AvHapvde6+QI1aGQUwL6dP8GxpidhUFr2WN9AWtJTNR5lrIV4dnga5upBuVuSDsvOyo18SmAVOdvL/aqphPpsq0dydJBFZGKNxW+rXSptjb7Wsx8WbASDiBJX39zyY8+JiHKkerlPXd//9SnGe+EXzNHXNRMN3Q5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750051612; c=relaxed/simple;
	bh=lphKOmOLjR2hhPC/cgmfQ2jfqnJ3CNusH5G/WB25BVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Iz0BAeiMfNyywjzeCcIFCQmVsHoLMi/hg7yJt24BfoD1PxVvd7SMxHcTOI9ElYgzhh5/M54XlMyshsqsn5aYrXbVaTmVG2B+1HP/3Lp4Pt1HB7SOS/cgauwkYLVhHPTjY+Aj7gGou4nmDfWuXtqtWbHRgf06FroFJwiJwKOlogU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 21D0668BFE; Mon, 16 Jun 2025 07:26:46 +0200 (CEST)
Date: Mon, 16 Jun 2025 07:26:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 02/14] xfs: Remove unused trace event
 xfs_attr_remove_iter_return
Message-ID: <20250616052645.GA1148@lst.de>
References: <20250612212405.877692069@goodmis.org> <20250612212634.914730119@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612212634.914730119@goodmis.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Please lover case the start of the commit message after the subsystem
prefix like other xfs commits.  The Subject line / one line summary
is not a sentence.  Same for all the other pathes.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

