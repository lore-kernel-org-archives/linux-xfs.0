Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED625336D
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 21:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710366057; cv=none; b=qKIX7JLclp7n6JqwpP3TRnCQWfHrMWulos9/ebxoH92d1jWSiUplVpoXKYPo6c4/AArVcXeiCJ2Kee1bmILbrEzQdEFWwdwMk5JQrgMcvFlr8uldSTZEaqER2X2hrmpinGyTTZ4Zw5wJUFeVJd/iWevTGCiGyPUyVvrbwe4Sgd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710366057; c=relaxed/simple;
	bh=kIpSu7LX8Ap86bONg/9+1FYdv4BbdIvkLYqNYOu6jLY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=b4yBor52+/ptboy0Om5tiRFcwjwGUOdMkD6+KkS8QW2RxgQ4eo0uRrofR1bMkeJN+/IKQISIRkt6zfgbHiTQ/oWIExcAlRI8XunApMG7TnI9Xm0qkEAD8uL2Q39e2zy7dr+e+D07alzUgUF+z+ipWc41ew/SvpZe1kOSSl7B7wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=o0ZOwykA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o0ZOwykA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=noirwPQ6aSYNeeUXqbqsI6rzN9ySZGa0iTWY9wb+XaE=; b=o0ZOwykAvfIBy8F/BjuHARHJcK
	CS2uRecl1EhAoiNL4TCv+tCEEspsYrxY0OHWfDZ2afFAHMkSc2mKBkdnDAaGpzhKlJNlCu4GaFiNX
	Gy4nDPxn43jJwf8zXSmq0zug1KS4ii0PerVH6T1uHuN8Bl60TABN2rWbmEpfok4EESgGSSLLjEep7
	eGH8PoNRp/zB9P/O+EcdIr08voJRmBCirgYWXlCZMsco8c8BMn23cDLCbXSU4NzK5yArWyy7VkLVS
	yWVVYf+jvUjq66VMN7IqTeFfT9zyZ/DZ69wuF76WgvCbQ6FWvIxqXWqyVsGk5CwMYjIK35mrib8p1
	F9T4aCxA==;
Received: from [206.0.71.29] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkWLG-0000000Bxon-0xcO;
	Wed, 13 Mar 2024 21:40:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: fix log sector size detection v3
Date: Wed, 13 Mar 2024 14:40:46 -0700
Message-Id: <20240313214051.1718117-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series cleans up the libxfs toplogy code and then fixes detection
of the log sector size in mkfs.xfs, so that it doesn't create smaller
than possible log sectors by default on > 512 byte sector size devices.

Note that this doesn't cleanup the types of the topology members, as
that creeps all the way into platform_findsize.  Which has a lot more
cruft that should be dealth with and is worth it's own series.

Changes since v2:
 - rebased to the lastest for-next branch

Changes since v1:
 - fix a spelling mistake
 - add a few more cleanups
