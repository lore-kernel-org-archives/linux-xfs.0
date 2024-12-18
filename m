Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35241514F6
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 06:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734504881; cv=none; b=c8tp1SW6P9MpdElbsw6kFTTeImY/VD7scMqN8ZHDPp1w5lEyol8vQkpuO4IBoqWEJLOPNCV9udhw4w5dtOP3lit5TsOf+U6X8Ahu+MKB/SXFbz7puhS6Z4fCK214KmKAcjTpKK3YNYSi9ppprIPB/+LQLiKQ5Meo7l6sDrf4oLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734504881; c=relaxed/simple;
	bh=47ZpUaaXTDwuw7o9/2bYJ2HE4zcWymEKtHawN0LFxUw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FLMpbpnkb9Zq48QE4Rvh0YTw25xCuUC40RHgVu9xWAV3JM+TMlJZ0E6cYRp1UQVf9gPU6n0AFG0wfuJAlxkluDNqQOccOII+LmEboGxpWIgYJDfzS5YCAjr03tZtZTkcvLYsLqlbqtg5NEBfg7u1zvZsawKrd5EFIBsi7Go6Z/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=erRLHvp7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="erRLHvp7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nD6IPWy1R1kLLwyonoImWmAuOrqDXUAd72HAQLwyJi0=; b=erRLHvp7j2yqd51vfewf7Tfm++
	A5M9NIN83ZtkFKk6yTedJt2JANq2X4WjkBG8OLP+ish/m+NLnKf1yZYJTZkYnPvtSjBp3RkmnoxgF
	Ebocnnlp4YVJsfgD8hWusiiYs/M3n7wrasfU0MwDvaFy3xmXoXCdpy6ZOgo3vQJ4Y4Zki+ioT4GxZ
	DfhzJ69QFOC82qf5LWQ2WZ8QuS+R5fEQ4ry39khD6x7/qKG14orh4cEm9yWev6r2zVk8VjMpTX6v1
	XNx1DhgcKD/+6nRVAIkDyEAJEI/qq2p3W2qztBmdKnjCZxtDmXZgUIzqfigqV+O8b040A6V9p+O1o
	wkNV58/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tNnx9-0000000Flbb-254e;
	Wed, 18 Dec 2024 06:54:39 +0000
Date: Tue, 17 Dec 2024 22:54:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/37] xfs: online repair of realtime file bmaps
Message-ID: <Z2Jxr64g8c0KQcaN@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123778.1181370.13816707119197050202.stgit@frogsfrogsfrogs>
 <Z1vf6PiDFJBekXYU@infradead.org>
 <20241217202520.GS6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217202520.GS6174@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 17, 2024 at 12:25:20PM -0800, Darrick J. Wong wrote:
> "Now that we have a reverse-mapping index of the realtime device, we can
> rebuild the data fork forward-mappings of any realtime file.  Enhance
> the existing bmbt repair code to walk the rtrmap btrees to gather this
> information."

Sounds good.

