Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464C14594A
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 07:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764661128; cv=none; b=UeNNeG6Vri5Jhdb4qBLNuFquCAYcax9ihxg9CoELuJZXfPg4Gxz4iErWAKJbsdgMu+WCW8wPMp3WroAWH5ALI7F0KvmudHj7dy0Ch1xFbTgKEu5F4QgToq7t+oUdWWjZnxCc/DpwlgBRWld24PXeKsvgqja+WziwGwapCLUvyeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764661128; c=relaxed/simple;
	bh=Jq29UyC1YwZMttx9ZS/AX5toN/jTZuZKQiCqgS/4mD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LGB0k+qBRfQj5FJyfaRAWdqaaBlh+w+k1r3Lonf3DjjmH9BA8sccvLCBWftecIMaNVM7DpwmytnGHPsp14p52qcmjpmu+DUxsg7Mbyx0dW9rkZcmDW7gkvWhFY6YOHaUdqP333YQPV1rYr77efEAiS3m0n+forkguPpBpxjkkvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YvTHuqKU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YvTHuqKU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7Z+EpnbrdnH/9zuNKXII0c7YqwPXp2RQPhy7eJzzh08=; b=YvTHuqKUhbzZVSJAJqNgcMvduw
	SbUOj4vONtOdrMLo1CT7BqUBEOdG2+JE2eHipPjBjpvpZBdc+IqNyqhcAbCBszeYYZvAsDplPmlIu
	vC34LBjFWLS8IOav447nxQARnyl1yL8apE/lTWw8hnHJ2D2E9MVFF+RpCRR96aO1xuBaloZzs09Ag
	KKOpfXX8tRoEKpC+uDGEMqAiZa5YWGH2Esd38xWKfofq9QM9T7L+h0j/lfZ7sGXt4kIR93axTISuB
	v5gKM/jh+8VedBl8CqPpb6wS9jWwsEs00FFMGZzxj5uouqJir3r/AvY+UWD6N0ebCOnYHz7wAToat
	ptgt2JXw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQKyE-00000004xqR-3HnS;
	Tue, 02 Dec 2025 07:38:46 +0000
Date: Mon, 1 Dec 2025 23:38:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mkfs: enable new features by default
Message-ID: <aS6Xhh4iZHwJHA3m@infradead.org>
References: <176463876373.839908.10273510618759502417.stgit@frogsfrogsfrogs>
 <176463876397.839908.4080899024281714980.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176463876397.839908.4080899024281714980.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Dec 01, 2025 at 05:28:16PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Since the LTS is coming up, enable parent pointers and exchange-range by
> default for all users.  Also fix up an out of date comment.

Do you have any numbers that show the overhead or non-overhead of
enabling rmap?  It will increase the amount of metadata written quite
a bit.

