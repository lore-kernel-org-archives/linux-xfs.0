Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D035F10E3
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 06:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765346436; cv=none; b=NL8Jo+9m+BjzMcKMuO47X2ycQb040jRaedUDB+KK47CRoUJi27vPUWO6cxzSYcMSuL/pzoKr8iBt6YlEh9rXA5HnX0K4QyQGF80RCheVUuOcw6XzZ408NpNgT4gOtpS9rCbWDWWrvn4n/L7qDhfQkAipJsCK/VIl1DHNA+la+D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765346436; c=relaxed/simple;
	bh=x3Va1FN7afjb0PeIo/t8a3xQK8NeEL/y1OT8qG2E4UY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sM+XYKm/1VNs/+f7khb8i49IrZavnyB9dDYyX5gYUMgT7xPUNK4vwEPOnOwqn+3KUDSQp5dAiTW6KicLcbc9eMBV98zoo1IhOx+yaeMIF6fobv3av4In5EKSMOm8TqvkWuQdxBF9LapzlSJqYxw/uAOXlih1Vz1vu2PP/2JAh2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yWMWBvf0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yWMWBvf0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vJOmm4m/tpS3NMNAGKCxV85jnqjBkdmoLwPHv/jo8yE=; b=yWMWBvf0dpeNloZKhv6etvULMu
	yHOmwwP5DqijEGCDaRW8OCQmCszRq6S32FdRWUYw1qua5aMqP1/v0ppEGhRg/rmruhYfbKH905gk7
	Pm5HWEUy7tQqyahpeCtwrCHj1zbuizPO77Rt3dFpDL04fEfYhvrRBjNvFV+jFykmR/1LoES0Ui7AP
	0c5J27/xm4kjhBDLo+LJPxJiXht5rL1GOwzg+qtOFGqrvvKKbT5Q9Ne2PdMUPWINdQv86TB7nWcqf
	kCaFiGZX3BE/h3y8iK+WR6hS6aiEjdNpkDIyx+5k9WGm1r0g5c5ZewGzpA5Lt+9T9jsoKgJiZZYQb
	PPVGZdoQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTDFY-0000000F9aa-1nkz;
	Wed, 10 Dec 2025 06:00:32 +0000
Date: Tue, 9 Dec 2025 22:00:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org,
	chandanbabu@kernel.org, sandeen@redhat.com, zlang@redhat.com,
	aalbersh@redhat.com
Subject: Re: [PATCH 1/1] mdrestore: fix restore_v2() superblock length check
Message-ID: <aTkMgBUQcp-AmkaC@infradead.org>
References: <20251209202700.1507550-1-preichl@redhat.com>
 <20251209202700.1507550-2-preichl@redhat.com>
 <20251209205017.GX89472@frogsfrogsfrogs>
 <aTkFC2EWf5UX5y9w@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTkFC2EWf5UX5y9w@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 09, 2025 at 09:28:43PM -0800, Christoph Hellwig wrote:
> On Tue, Dec 09, 2025 at 12:50:17PM -0800, Darrick J. Wong wrote:
> > > -	if (xme.xme_addr != 0 || xme.xme_len == 1 ||
> > > +	if (xme.xme_addr != 0 || cpu_to_be32(xme.xme_len) != 1 ||
> > 
> > xme.xme_len is the ondisk value, so that should be be32_to_cpu().
> > 
> > Otherwise the patch looks ok.
> 
> We really need to bring back regular sparse runs on the userspace
> code.  Let's see if I can get it back working..

I just gave it a try, and make CC=cgcc still works in theory.
But between the urcu headers making it throw up, issues in the
Linux UAPI headers and our own redefinition of the __be32/__be16
types it generates so much noise that it stops reporting before
any real issues including this one.  Sigh.  I'll see if there
is a way to clean some of this up and get useful results.

