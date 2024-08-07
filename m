Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3AB78B60;
	Wed,  7 Aug 2024 14:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723041321; cv=none; b=YgDHOMzs2XZRC4Z6ZN7EOSX346xxlXubPHbMy0KBaCN9tAfzSs1AXLTPoXgXmBL8kzTnOwoKK3ihNzOTmXv8UG6s4nfA0ufkWG1dtl+ob0rFVh4wHFcykTryRlIaSQ1vbaATcGEXWtavIQmkucagrw647xmgWqvfdY6VLWjoIBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723041321; c=relaxed/simple;
	bh=fbbGgS9xM7uuQJMlksGNHAtMhMJM+F39QM1REgLM26o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VXHevyNK6dA2U1q4ELA2MWBmrs1a131ew7TJAfhSAQf+VoYUg2Hi06bn9kKhVXJSUC66Ws2XSgshBsjktDEe21steFsSBfv4H59gvYxdFyA4kxgLK4rN4HcyX/uW8SaixqNYAk+SG05eeOpvOxSMN07VdHAWO1Qaa2iZzSKKIgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OrPykyBE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OrPykyBE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=+Td0JJP15wZF6blaiamgD6Og2znv/T1xmqfEvvNeJds=; b=OrPykyBEMXD7z2EDv1Y3tcYQV3
	wQNbmR6BJb0JKSoRWcd/sJaa62uyCCrEtuepTARPPjwtaZJdXZ92rGMpDJzPNWg2qfvm+ZDXb4c2A
	IQ14sUgpViySeh3sn9a7JDfIRmnXaYaaMaUO6R14SjFlO5K/Ze6GwOy9nbmq4d86k01bbwzlcIMAq
	wvK14VhgbbXJNhXZlQed8fkpMudIep0rGnvv14X7p67XpBYFpurTjJcsSZ25OlOQoYae3uhyiqXF0
	V0mmAIkmfSuMQM74bwHN98KEAp0LtVilzlM01yZ3SlEUP2elzVJ+SD0nntC+1dF34FTQSIqRLsG39
	JqDLgqfg==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sbhl1-00000005M03-1pgP;
	Wed, 07 Aug 2024 14:35:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: don't fail tests when mkfs options collide
Date: Wed,  7 Aug 2024 07:35:06 -0700
Message-ID: <20240807143519.2900711-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

I've been running some tests with forced large log sizes, and forced
sector sizes, and get a fair amount of failures because these options
collide with options forced by the tests themselves.  The series here was
my attempt to fix this by not failing the tests in this case but _notrun
them and print the options that caused them to fail.

Changes since RFC:
 - rebased to the patches-in-queue branch
