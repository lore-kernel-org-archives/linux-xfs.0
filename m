Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F4F2BD030;
	Fri, 19 Jun 2026 05:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781845787; cv=none; b=kdgQiqLla9AHuXb5PUP0V8Kxz8YGY7NAZlkNDEPvlF7PBj8nQFvQ0gDIteF8q+wJqXM6ZAJJlLysJfYJahu6Hi5+p10VB7AESOs3mOcWTuG769nx1kNNVOisDE32HDmyqpJppta6XOZa3BOyb0gtYbq99ys5KfZi2IWKfs6aup8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781845787; c=relaxed/simple;
	bh=DHC1ETU3WJiSH7w1IsW6nVSsOc/8em551R+nkeN30i0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KrqROg3DaxG43oMBjFbkqoERSu5fkCvF7Hnx4xUd2PMbNMdH88uXqpblLhLdkdtgfUBLX6viOa40b3/l37BVoC7ANJbe+y/u/vfJ72HA5uOYc+TGdf2vaKUqrsM/jd3RMkJYVQCscK2SJ41KegoTvRxTRE2i4pA9PJm/tM61O6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wwmcFbeP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wwmcFbeP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=DHC1ETU3WJiSH7w1IsW6nVSsOc/8em551R+nkeN30i0=; b=wwmcFbePDoI4AvEbRMvvugBZry
	PcbvYV+bjeuzB3uQomQ86IZ/urQ32uoX5eo5VmPuYMYTJk+oCn61FJTVVJi6BWkkqm6X7J8IRwElC
	CUMU/g3VGkXOuOtZmEp84uM2dBjm8n4uZ7hisstPOGPXkILqvpMjpM7HaFjtljsArA/zCN/hXs36c
	TZfI3C23t06tDwfZ0vlT+e+unWNAXscQTHjwixJnFtksVxvtqtdI2w81aHt+KoYtBePo5x9TS2y1u
	uHRf/Z26zntXD5b8q0ua8T92CXjNqKSFBa4tGUETRVu+G6ZP5axJb5l8JsLQUotnzu7ZqiC3sCAQd
	TuMdBwwQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1waRU4-00000001zqC-412U;
	Fri, 19 Jun 2026 05:09:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Lukas Herbolt <lukas@herbolt.com>,
	Eric Sandeen <sandeen@sandeen.net>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: cpu scaling fixes v2
Date: Fri, 19 Jun 2026 07:09:27 +0200
Message-ID: <20260619050937.444488-1-hch@lst.de>
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

this series fully disables the mkfs automatic CPU count scaling for two
tests, where that would lead to differences in the gold output.

Changes since v1:
 - only disabling scaling in xfs/078 when it is supported
