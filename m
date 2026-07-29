Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CFC488776
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 13:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330207; cv=none; b=eyK1URxYwbQO7pb7X1r6Hbno2b760azG2DFpAsEoXBlQex/FuulvVX7LQPHipV8A7vWIHMTNMxJ6EGGUXR7EZ1Q+I1rauftUX1hjN8OaI98QUe8s3Lv41LNn4tA1jXomSZI0IUYAaXm0OGHeiAqQMBKWrg2Ij+pT32ZOcLWllLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330207; c=relaxed/simple;
	bh=UbqZi+N4uWwWLwnirGoJnakTEAxPNX7KnSlFR2R9jJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eanRxRd3jXZCkq2lMNK7rqiUJjlpgQZdYh+IYwdXuIGf9tTpFFB3MrK3wXkCtUPDZJ9ioF4QtpO3xZT5I3mVY2UdFQgYvbCeUVmgfX/qvn43OY4kpsD7M1CPJmQDmXWaUu/z12tom2Sh7g8wzkIY+lyqwWXmf3K76a/RiWqm92A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vQpcUAL4; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vQpcUAL4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=H9YT2WCFsFK2z+2yVuh8mu8h2yjV9HMVtAoXa/R7VTk=; b=vQpcUAL4u42ZkrbdaGcvkPSfjD
	gALsl6EOc6+4e8q0BmJB+KajKmBtnWNucWTWG3bAVicDpnwFOzD7yPK4HA5fothmhWAs4AFE4wwPL
	3UnXs4qxD1sLpayQAOJm4MqPwb+2OEotWoiUxO3Z/Kmzg0kzN3Irf9wW35Wzke1E+Gf2U2RIRZOdd
	2AS9U1HKuva92kpAuKbmrFCXhJ1ow/KpjL6ABqrFoc3o73LiIsA+n3wFDkvWya+OL5BeUjyHTTkX8
	hX7wyRJXe4LxJB86YWZx6wdLYcSnxc8kNZYQEEezQJN8v7TGEhfIyU6DFDxIoix9TFNzpc6wj6r+Z
	xKgqSYTg==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3wO-00000004WjL-491w;
	Wed, 29 Jul 2026 13:03:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: xfs ioctl handler cleanups
Date: Wed, 29 Jul 2026 15:02:59 +0200
Message-ID: <20260729130320.2282183-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

I've been annoyed at the KASAN stack usage warnings in xfs_file_ioctl
again recently, so let's sort this out properly by splitting each
ioctl handler into a separate, well-named helper.  We already do that
for most, but this series completes it.
