Received: from pannekake.samfundet.no (pannekake.samfundet.no [193.35.52.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E7C2E3386
	for <linux-xfs@vger.kernel.org>; Thu,  6 Mar 2025 08:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.35.52.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741249034; cv=none; b=kpnpOMgIwTVI3yy2YS/FM8uVSjzvcCFCxA/vDem8Q9BPtWW530cy7tXD1NYOiuZJ0MSkjt1z1pM6YA8OAQoRAgGNLNGXv/wRaGduWx6zam6hgvw68b/dCEIdXA/vK35TqVbSJkXhx/g6gRqN5VxlkQ8vDR3FqoO0P7Mo8sRuLTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741249034; c=relaxed/simple;
	bh=0oWDnGB41VikyNX4pDo1uqtGj1NFZOsxrI9d6yaX/+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=inwDu3Q9lhEI5opar1jRbDPUYVC4TLnnlMu/4YLPH+2uzGdNaQmHWospY7Z28uMw4fxloUpv1RFjwx/e3ak7b/i+0TmrH6nGJK2ONPeGvd+zgm1uFsfXgs1qcmbmSN2jjZsrwkQoQFzxfVCuzT0kjt8LWI9T0F4aniHCoLbeP7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gunderson.no; spf=pass smtp.mailfrom=gunderson.no; dkim=pass (2048-bit key) header.d=gunderson.no header.i=@gunderson.no header.b=Q6aBDFUA; arc=none smtp.client-ip=193.35.52.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gunderson.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gunderson.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gunderson.no header.i=@gunderson.no header.b="Q6aBDFUA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gunderson.no; s=legacy; h=In-Reply-To:Content-Type:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=fINc5Ov7cYJnQUq2lU4Qo8fw0D7no6oKXEdysoaNeCM=; b=Q6aBDFUAayi1tUaQixE9/OsznG
	ipjrjjAB8SIYJpwMoXGkxu8gShmOQ62SsthRIxtEiWZToSQ1I7eNIVTh36c7IikzsPugU0uPPyonp
	urgMQLklasgZ/FC6rA9VO41PvJ7iPe2hiMghAap0LV/5K/tAQ+WILrwPq3RsrgKUhNiluGRfDRcvd
	qE7b4MaJfoA3QYhi39wL6R24XnWb+VmsXAUj+PmpzdN9ZtxldD68UgH1M2jwXqAEd2Ri982dVC4zI
	evEMJUITdb/g1QPWMC9id9atO2UFVwGJOjeE390Csaxdbm8ODiJCLqbcsnpi8rON14eEnzY+EtJp1
	TI8FS0dg==;
Received: from sesse by pannekake.samfundet.no with local (Exim 4.96)
	(envelope-from <steinar+bounces@gunderson.no>)
	id 1tq6Pi-006Rsl-13;
	Thu, 06 Mar 2025 09:17:06 +0100
Date: Thu, 6 Mar 2025 09:17:06 +0100
From: "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: Slow deduplication
Message-ID: <20250306081706.5uomf6dkvas73bj7@sesse.net>
X-Operating-System: Linux 6.13.0-rc4 on a x86_64
References: <20250302084710.3g5ipnj46xxhd33r@sesse.net>
 <Z8TPPX3g9rA5XND_@dread.disaster.area>
 <20250302214933.dkp743wxlo624aj7@sesse.net>
 <Z8W2m8U9uniM8AAc@infradead.org>
 <Z8jt1jokQtZNUcVm@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z8jt1jokQtZNUcVm@infradead.org>

On Wed, Mar 05, 2025 at 04:35:34PM -0800, Christoph Hellwig wrote:
> I gave it a quick try yesterday, but it turns out XFS hold the
> invalidate_lock over dedup, and the readahead code also wants to
> take it.  So the simple use of the readahead code doesn't work.
> But as dedup only needs a tiny subset of the readahead algorithm
> it might be possible to simply open code it.  I'll see what I can
> do when I find a little more time for it.

Thanks for looking into this. I figured I had to always do read()
first to support older kernels anyway, but I guess it would be good
to get this fixed for the point where today's kernels have become
older kernels :-) (Perhaps this hasn't been noticed before since
most deduplication software does its own read() and comparison
before calling the ioctl? Just a guess.)

/* Steinar */
-- 
Homepage: https://www.sesse.net/
