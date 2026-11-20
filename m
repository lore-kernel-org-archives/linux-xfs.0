Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795192642;
	b=BsLkpW6eRT2UL9/HX0n3SFI2ITAsZZv21jk3PyjxEzx9vgmNZtOsYUgG2j9o96xF6Yps
	 J5Y1RMmNkgO9zQOc0Eq9/iRmS1rOc218tjjm+fiPHzFhmb8Nf/RiYOnJidXZt1OWN6IQe
	 GZ9IEgTc/nXT+TYSyh1F+Ez5aurwykHKeKB66s8+xaAM89lms+5cgqpA6aDTh+7oxAGD+
	 /fjzB9tco+RwjIq+aPyZfF1C3SY0RB5d3Y0XAxivHsVv7kZJydWbhXRsPqMTHl1gqDuQd
	 PTeahPGmV5JZYc7iOD1PkfijsPJ4FYEf7w+rc3EmYrDkSVFA+b/3uA3tnq0B0f05B3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795192642;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=a5NPDgjqS8ag5BoV6cQUwDUcNZlUOPNK1UJULxFOgx8=;
	b=ZHjHXOumBjyyEphLfH/WMX+PL5d5t/KLck+TJkCyqNYsHuuLzRHA9jPW3yPGxOk17gwd
	 UhltSvn7hTIFx7c7nQQuYL8+GyNXX90F/7A582/7Wc4FUqcsNd2mZAR+ZcmIubU9sgGr5
	 5l6DrAgGRMm/pWpPRsHcKzjN48VC1FWyNnVjY/UbuGXJrMcCeoc+gWhZ6Sbr6gn7mMAd3
	 TzttB1Slmo9q/psULSdTrUUWcHjv05Zb2UbkoQwfoMfbkEPyujjPKGPi1Y2Onnlt5CWdS
	 QWF7s9kySM5FmZB91F3GdtK7m7RumX9H0wfuXYoDGjclCthZ3rVjHSCBT7bJIpgrNPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=OkLqyK0Z;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34527606A336
	for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2026 16:37:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34527606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=OkLqyK0Z
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=a5NPDgjqS8ag5BoV6cQUwDUcNZlUOPNK1UJULxFOgx8=; b=OkLqyK0Z4LnFFysHQRk7b8QlSF
	SpLv5wW/2JvKI23ISn5bKFRZnt0foUv9EDIVIe9UUSv30piT0RnJlFf82wyG8hmlRLcdM4w+9Chht
	4LzCWLjgVes5DhT8b9zjFqkYCA4iH4nY5LMvT9Ht8MyubSF9sIKIEeak9DXmJmT+xhPTuBOCITl86
	nROJANqNEbJuosLJ1BzizHw5D6iXcsDfXVdILXEaesnNdWJGQgnsmswpqDM/5Nbt34WBrBqD3I7ot
	a7vJQqJVRcNR34TM6Lau8bn+4cpczgvnUDmD8kDPovTn8PCfcO9YwPwJXxA7mPOxKurnPpHkPvwpG
	Z+xEGvxA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xURc1-0000000FZW5-342T;
	Fri, 20 Nov 2026 16:37:21 +0000
Date: Fri, 20 Nov 2026 08:37:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 09/59] xfs: apply mount superblock updates after log
 recovery
Message-ID: <awB3QS0ttoWAs8bb@infradead.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
 <20261116231707.3625263-10-dgc@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116231707.3625263-10-dgc@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Similar to the previous one.  I really worry about issues with this
if we don't exercise it.  And sashiko seems to worry as well.

