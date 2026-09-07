Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CA5382F1C
	for <linux-xfs@vger.kernel.org>; Mon,  7 Sep 2026 07:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788766474; cv=none; b=OnrNr38VQyV+q1hAVcaqqZjORWpzKQkOVSMRVm4VO4m4/JXuhVZt3uyC0s8lZRu5cxgts27lIGkWD/ILbaOR53iLbxhlPflsBx89I/zgs7Q8q82pqYC2Vxpyjl3izeJZqWnbJSG13VgQG+dBip6xX+2VKIsoVpSOy3jOdAGfQSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788766474; c=relaxed/simple;
	bh=9s8yQLQ/Um8LjmUcqISQxvRo4aqsw7CJJ6Wdr0euhFg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kcNM/vyfBbcdh3amqYN208RAT9iRv/1PaQz10aX/yxxnR9nZaYFPhch4Q4xaL38LJYFzfaBvSqE1xmFH5qY3B77QfnBVhuP2VU4wWq5kxAPrWEHxxX2W1OcqaAT+j9cL/YHW60af40qyvHhDJSW0l8JVk2TqubxsHZJl7twUBio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pXEANCSn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pXEANCSn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=LFY2+/tWhBl2SYPnes+FoxsdoOo/7Enje4lSy6SQTzA=; b=pXEANCSneyNucPA38kc2gLUsnU
	ARK2hFs6CfU6R+I05oxt/i89jN8uyhp/rGiXjadL+A+Ri/xA6kKGoUR49SNgGu3a40PEv8XJsXtkq
	na+3N317RTPbieOEqRfXdSyT9Br7SW18EpqqHmkdKXZ/8XqA+h9VVj3ZFLLVjvgFTve+MwB5TZgfT
	G+1JhwnqJPqAmB5lWY8O+OGaZ8F/ihnYderWd4eCtiZEuQEciLFdTjiZ0r6IZAMSjvpG9YhMyL5LL
	7c/P3fkz1fSc7xli9Ku49CbgNef8d8WMsrIKF1JMLOmyZN6M0IOSaot/laTicMG/K0Bsdmf3BkSEU
	niNR0PEw==;
Received: from [91.92.197.219] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x3Ts5-00000006AVJ-47i9;
	Mon, 07 Sep 2026 07:34:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: fix cache flushes for the RT device
Date: Mon,  7 Sep 2026 10:33:06 +0300
Message-ID: <20260907073427.719935-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

when tracing workloads, I realized that currently the volatile write
cache on RT devices is only flushed by fsync, but never at all for
workloads that do not use fsync.

Changes since v1:
 - drop the patches that are pure optimizations for a minimal fix
   series
 - improve a commit log

Diffstat:
 xfs_file.c    |   47 ++++++++++++++---------------------------------
 xfs_log.c     |   45 +++++++++++++++++++++++++++++++--------------
 xfs_log_cil.c |    7 ++++---
 3 files changed, 49 insertions(+), 50 deletions(-)
