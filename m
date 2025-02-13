Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9A32063F7
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739419809; cv=none; b=qJNMhu8sKStuhjmWhNDk2CR27ircqzRdNdneT+oajs1P+S6oOsTPCYoQ05IfjRHVo0EftVjM/9XxOMvXKGvnpbqDOKJecehuL0Dy4vO6P+4TD41TXX9+0DNYvLMftku9kJenhkPI3lT5q3Gbl6PN2FIuqA77GKoAuGwU8bldz4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739419809; c=relaxed/simple;
	bh=eqHP2bbPqo0yO+1608WZnZGgf3sxtJxvl8DGiXoa7D4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hBU+FtNXfoC0JJT+74SDKFoklitVVvWfr6Yd/xvbx25Il3wEHUurGEqa94ZfT1vjGaQUhlywnYXJSw6wjoBh2nn1vBVRMu54GJWxvpEOYYwyueK+1agjPzuCClRpA2A9OSoglqkAirIFSfutz4CDk8uSoRQs1u0t1XOze+l6wgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Lc5NTNAY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Lc5NTNAY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uNAb0yngkcJXnUir7fCiaik2vrziwizQfog84tONl18=; b=Lc5NTNAYyT9IVAYlCm1iqxIZKz
	Czn5wrDT/gdohHOh+V02Grn4pHidnsxjYgsg0ysNRp++AhiJRT06MrmubYTfT5Bz1OFoMbbPdrGwi
	+c7UxUvsw4/PC+cGk9hXrPpP28Mr7kIjPh4ctz5RyEp+CBsJTiUHJsvuFSz3JFjN3YrgzEwZBXzOQ
	5fSH6R8+C/4RFipTtFcwm8/SnrB+v5TA7Am2F+QwDtLc3tdghusxub5uMQCY9kFPylEPzNnIGft23
	r7ffqUCrzuV07bhuVB0Oxa4qihvHrTYqCZpXelIkM+FUQVK4f5ri3z0AOwJZ9Ia0GYIGnAyeXizj2
	HMB/1OCg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQY8-00000009g7k-4AMg;
	Thu, 13 Feb 2025 04:10:04 +0000
Date: Wed, 12 Feb 2025 20:10:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Gomez <da.gomez@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>, gost.dev@samsung.com
Subject: Re: [PATCH] mkfs: use stx_blksize for dev block size by default
Message-ID: <Z61wnFLUGz6d_WSh@infradead.org>
References: <20250206-min-io-default-blocksize-v1-1-2312e0bb8809@samsung.com>
 <Z6WMXlJrgIIbgNV7@infradead.org>
 <323gt6bngrysa3i6nzgih6golhs3wovawnn5chjcrkegajinw7@fxdjlji5xbxb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <323gt6bngrysa3i6nzgih6golhs3wovawnn5chjcrkegajinw7@fxdjlji5xbxb>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Feb 07, 2025 at 11:04:06AM +0100, Daniel Gomez wrote:
> > > performance in the stx_blksize field of the statx data structure. This
> > > change updates the current default 4 KiB block size for all devices
> > > reporting a minimum I/O larger than 4 KiB, opting instead to query for
> > > its advertised minimum I/O value in the statx data struct.
> > 
> > UUuh, no.  Larger block sizes have their use cases, but this will
> > regress performance for a lot (most?) common setups.  A lot of
> > device report fairly high values there, but say increasing the
> 
> Are these devices reporting the correct value?

Who defines what "correct" means to start with?

> As I mentioned in my
> discussion with Darrick, matching the minimum_io_size with the "fs
> fundamental blocksize" actually allows to avoid RMW operations (when
> using the default path in mkfs.xfs and the value reported is within
> boundaries).

At least for buffered I/O it does not remove RMW operations at all,
it just moves them up.

And for plenty devices the min_io size might be set to larger than
LBA size, but the device is still reasonably efficient at handling
smaller I/O (e.g. because it has power loss protection and stages
writes in powerfail protected memory).
