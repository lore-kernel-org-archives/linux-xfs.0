Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA991DE3CB
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 18:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733940352; cv=none; b=CUDUUY6YS0s5hpJiDkdXKbZOzQT0/8/c2IVD9nRSLJSTbPIupQ8e+Bl8UPWviHqyQ7NoHuiIYSxxMAVg8lyOCZi2irr/mbqkPQK8cGRFxkEeu+1GpbxRfRwRF06FkE4f1Hfs/oqW/3Fmg452a97yEOfol9LjZghYOMMUKtGOyUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733940352; c=relaxed/simple;
	bh=y1cifI9wY7Mp1w1jkqKUENC+FgwCuPgJs6OnxCKy+XU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=edqA/GuANclHq7qmPkkLX1t0LEzVoHG9bLOw3B+duGYSJ5aej0keZpya/MnFUUwoMvEQJH03/+THOiPd/1SCIVhIhLKGw+6J4oKumiRd9zfkIBgJpY5YXH2g3WN9yvWOFZPTyqrbZx07u4hdOwGs3OuSU9QP794nxvd5QocK1G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lOH8dxeU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lOH8dxeU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=y1cifI9wY7Mp1w1jkqKUENC+FgwCuPgJs6OnxCKy+XU=; b=lOH8dxeULrm8u/zK6M6s2FlsBS
	oqHFYPetIlo0864E3klEa36zU7a+nhWsKn+o0PkVO/ri84URuVLhm3cx8UhdcBqcwJUSIZVqfV8as
	tZ2QLDaA7FnQYN58eWBcQk5RZLuwFXsIOI+9eMvKc2O5axAFJk3Bc1LeODFeLo5wZJt1LzAQQ6OvG
	LYeDDAsD50r0GX6tOWxFptooTcowtTFscFZ7Up/U7VyRwjYYOCbZPhHw56q0TxsXPZLvQxAgzz4gk
	GtVS0GipinELSPVTDbFIR5XuqbtG0TWPjUcdTV18H/h6Y8+oli291KMxoquBFkOYztkgTGHo+GpSq
	+NllYhcw==;
Received: from 2a02-8389-2341-5b80-99ee-4ff3-1961-a1ec.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:99ee:4ff3:1961:a1ec] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLR5l-0000000Fhfu-3X0f;
	Wed, 11 Dec 2024 18:05:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: aalbersh@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: xfsprogs metadir/rtgroup man page fixups
Date: Wed, 11 Dec 2024 19:05:35 +0100
Message-ID: <20241211180542.1411428-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series has two little fixes for the metadir/rtgroup xfsprogs
just sent out by Darrick.

