Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C449F4F1
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 14:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789137966; cv=none; b=lRb8FPPiEdYq4/3CfafwpQGSZivLdk6SVtjLbWGkXRAjPZ41yjabzBifG/Cmc908ri+6ckH3IMgaWLplnwwgA5P842LIp/QaZ8eNS0Wsf3l7cyyvZzQuGkA/N8Roo9Cta6khvdu+iZNr3v5Cyx0g9VW6JS/S57NgW2cpvZ0K4PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789137966; c=relaxed/simple;
	bh=11zLUS9sLcu2j4V+8Q1kz8eDbIBw09HCgJm31vXKsi4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IelMNMGta/ZGxltx7C9VzLtB4qwyYT+CMuOPlmnL1oYK6LGPIjdQ/M28OU2DiIMmEh/tkm6NcNG8+93y8nxKgpZw/JPzTCIBKOV2m+6Pn6DklX/pvUqRWu4kR6aSciqY1IMlrF70BaJQnJyYnLUzVhpswHUD92yvAMTycW0cNM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VBvaDtwK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VBvaDtwK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=11zLUS9sLcu2j4V+8Q1kz8eDbIBw09HCgJm31vXKsi4=; b=VBvaDtwKsPGTwrWq7+Qa89uATu
	0g7Vd5JRuqclycSpowtAcFmY8z4EAbOXfIp2mZColuMFSnkR3aodLvIZhMh7oi4DdbMrnoYfgsyBe
	oHjxHIg6Y1OI5kdXEs+JfjuUmbZjLgn6GLh7xLAnvW0BoBB2JjHNM+ou8ifTnKtwDlYxtKVwQiVRM
	auclSfl5k0XIl+fX/spPp6KYh84ATOr5A+jKvmNbhyE0nC+o2id0vPSRCGNUG6/7d/42rKY3l16xm
	RBrV4lM8j488rjThvWk8OcebCDoSTiGBDdoL/m08rj2/uoxy7K0pbuGufDTXzKIX0Wl8u5dZzYjar
	gTot9U5w==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x52Vu-0000000Gx2E-0mjA;
	Fri, 11 Sep 2026 14:46:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: fix missing RT detection in libxfs
Date: Fri, 11 Sep 2026 16:45:41 +0200
Message-ID: <20260911144559.1959740-1-hch@lst.de>
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

the first patch in this series fixes the detection of a missing rtdev
specification in libxfs, and the other two clean up lose ends in this
area that I stumbled upon while debugging the original issue.
